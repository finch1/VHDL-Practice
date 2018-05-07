/* Linux-specific atomic operations for Nios II Linux.
   Copyright (C) 2008 Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free
Software Foundation; either version 2, or (at your option) any later
version.

In addition to the permissions in the GNU General Public License, the
Free Software Foundation gives you unlimited permission to link the
compiled version of this file into combinations with other programs,
and to distribute those combinations without any restriction coming
from the use of this file.  (The General Public License restrictions
do apply in other respects; for example, they cover modification of
the file, and distribution when not linked into a combine
executable.)

GCC is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

You should have received a copy of the GNU General Public License
along with GCC; see the file COPYING.  If not, write to the Free
Software Foundation, 51 Franklin Street, Fifth Floor, Boston, MA
02110-1301, USA.  */

#include <asm/unistd.h>
#define EFAULT  14
#define EBUSY   16
#define ENOSYS  38

/* We implement byte, short and int versions of each atomic operation
   using the kernel helper defined below.  There is no support for
   64-bit operations yet.  */

/* Crash a userspace program with SIGSEV.  */
#define ABORT_INSTRUCTION asm ("stw zero, 0(zero)")

/* Kernel helper for compare-and-exchange a 32-bit value.  */
static inline long
__kernel_cmpxchg (int oldval, int newval, int *mem)
{
  register int r2 asm ("r2") = __NR_nios2cmpxchg;
  register unsigned long lws_mem asm("r4") = (unsigned long) (mem);
  register int lws_old asm("r5") = oldval;
  register int lws_new asm("r6") = newval;
  register int err asm ("r7");
  asm volatile ("trap"
		: "=r" (r2), "=r" (err)
		: "r" (r2), "r" (lws_mem), "r" (lws_old), "r" (lws_new)
		: "r1", "r3", "r8", "r9", "r10", "r11", "r12", "r13", "r14",
		  "r15", "r29", "memory");

  /* If the kernel LWS call succeeded (err == 0), r2 contains the old value
     from memory.  If this value is equal to OLDVAL, the new value was written
     to memory.  If not, return EBUSY.  */
  if (__builtin_expect (err, 0))
    {
      if(__builtin_expect (r2 == EFAULT || r2 == ENOSYS,0))
	ABORT_INSTRUCTION;
    }
  else
    {
      if (__builtin_expect (r2 != oldval, 0))
	r2 = EBUSY;
      else
	r2 = 0;
    }

  return r2;
}

#define HIDDEN __attribute__ ((visibility ("hidden")))

/* Big endian masks  */
#define INVERT_MASK_1 24
#define INVERT_MASK_2 16

#define MASK_1 0xffu
#define MASK_2 0xffffu

#define FETCH_AND_OP_WORD(OP, PFX_OP, INF_OP)				\
  int HIDDEN								\
  __sync_fetch_and_##OP##_4 (int *ptr, int val)				\
  {									\
    int failure, tmp;							\
									\
    do {								\
      tmp = *ptr;							\
      failure = __kernel_cmpxchg (tmp, PFX_OP tmp INF_OP val, ptr);	\
    } while (failure != 0);						\
									\
    return tmp;								\
  }

FETCH_AND_OP_WORD (add,   , +)
FETCH_AND_OP_WORD (sub,   , -)
FETCH_AND_OP_WORD (or,    , |)
FETCH_AND_OP_WORD (and,   , &)
FETCH_AND_OP_WORD (xor,   , ^)
FETCH_AND_OP_WORD (nand, ~, &)

#define NAME_oldval(OP, WIDTH) __sync_fetch_and_##OP##_##WIDTH
#define NAME_newval(OP, WIDTH) __sync_##OP##_and_fetch_##WIDTH

/* Implement both __sync_<op>_and_fetch and __sync_fetch_and_<op> for
   subword-sized quantities.  */

#define SUBWORD_SYNC_OP(OP, PFX_OP, INF_OP, TYPE, WIDTH, RETURN)	\
  TYPE HIDDEN								\
  NAME##_##RETURN (OP, WIDTH) (TYPE *ptr, TYPE val)			\
  {									\
    int *wordptr = (int *) ((unsigned long) ptr & ~3);			\
    unsigned int mask, shift, oldval, newval;				\
    int failure;							\
									\
    shift = (((unsigned long) ptr & 3) << 3) ^ INVERT_MASK_##WIDTH;	\
    mask = MASK_##WIDTH << shift;					\
									\
    do {								\
      oldval = *wordptr;						\
      newval = ((PFX_OP ((oldval & mask) >> shift)			\
                 INF_OP (unsigned int) val) << shift) & mask;		\
      newval |= oldval & ~mask;						\
      failure = __kernel_cmpxchg (oldval, newval, wordptr);		\
    } while (failure != 0);						\
									\
    return (RETURN & mask) >> shift;					\
  }

SUBWORD_SYNC_OP (add,   , +, short, 2, oldval)
SUBWORD_SYNC_OP (sub,   , -, short, 2, oldval)
SUBWORD_SYNC_OP (or,    , |, short, 2, oldval)
SUBWORD_SYNC_OP (and,   , &, short, 2, oldval)
SUBWORD_SYNC_OP (xor,   , ^, short, 2, oldval)
SUBWORD_SYNC_OP (nand, ~, &, short, 2, oldval)

SUBWORD_SYNC_OP (add,   , +, char, 1, oldval)
SUBWORD_SYNC_OP (sub,   , -, char, 1, oldval)
SUBWORD_SYNC_OP (or,    , |, char, 1, oldval)
SUBWORD_SYNC_OP (and,   , &, char, 1, oldval)
SUBWORD_SYNC_OP (xor,   , ^, char, 1, oldval)
SUBWORD_SYNC_OP (nand, ~, &, char, 1, oldval)

#define OP_AND_FETCH_WORD(OP, PFX_OP, INF_OP)				\
  int HIDDEN								\
  __sync_##OP##_and_fetch_4 (int *ptr, int val)				\
  {									\
    int tmp, failure;							\
									\
    do {								\
      tmp = *ptr;							\
      failure = __kernel_cmpxchg (tmp, PFX_OP tmp INF_OP val, ptr);	\
    } while (failure != 0);						\
									\
    return PFX_OP tmp INF_OP val;					\
  }

OP_AND_FETCH_WORD (add,   , +)
OP_AND_FETCH_WORD (sub,   , -)
OP_AND_FETCH_WORD (or,    , |)
OP_AND_FETCH_WORD (and,   , &)
OP_AND_FETCH_WORD (xor,   , ^)
OP_AND_FETCH_WORD (nand, ~, &)

SUBWORD_SYNC_OP (add,   , +, short, 2, newval)
SUBWORD_SYNC_OP (sub,   , -, short, 2, newval)
SUBWORD_SYNC_OP (or,    , |, short, 2, newval)
SUBWORD_SYNC_OP (and,   , &, short, 2, newval)
SUBWORD_SYNC_OP (xor,   , ^, short, 2, newval)
SUBWORD_SYNC_OP (nand, ~, &, short, 2, newval)

SUBWORD_SYNC_OP (add,   , +, char, 1, newval)
SUBWORD_SYNC_OP (sub,   , -, char, 1, newval)
SUBWORD_SYNC_OP (or,    , |, char, 1, newval)
SUBWORD_SYNC_OP (and,   , &, char, 1, newval)
SUBWORD_SYNC_OP (xor,   , ^, char, 1, newval)
SUBWORD_SYNC_OP (nand, ~, &, char, 1, newval)

int HIDDEN
__sync_val_compare_and_swap_4 (int *ptr, int oldval, int newval)
{
  int actual_oldval, fail;
    
  while (1)
    {
      actual_oldval = *ptr;

      if (oldval != actual_oldval)
	return actual_oldval;

      fail = __kernel_cmpxchg (actual_oldval, newval, ptr);
  
      if (!fail)
	return oldval;
    }
}

#define SUBWORD_VAL_CAS(TYPE, WIDTH)					\
  TYPE HIDDEN								\
  __sync_val_compare_and_swap_##WIDTH (TYPE *ptr, TYPE oldval,		\
				       TYPE newval)			\
  {									\
    int *wordptr = (int *)((unsigned long) ptr & ~3), fail;		\
    unsigned int mask, shift, actual_oldval, actual_newval;		\
									\
    shift = (((unsigned long) ptr & 3) << 3) ^ INVERT_MASK_##WIDTH;	\
    mask = MASK_##WIDTH << shift;					\
									\
    while (1)								\
      {									\
	actual_oldval = *wordptr;					\
									\
	if (((actual_oldval & mask) >> shift) != (unsigned int) oldval)	\
          return (actual_oldval & mask) >> shift;			\
									\
	actual_newval = (actual_oldval & ~mask)				\
			| (((unsigned int) newval << shift) & mask);	\
									\
	fail = __kernel_cmpxchg (actual_oldval, actual_newval,		\
				 wordptr);				\
									\
	if (!fail)							\
	  return oldval;						\
      }									\
  }

SUBWORD_VAL_CAS (short, 2)
SUBWORD_VAL_CAS (char,  1)

typedef unsigned char bool;

bool HIDDEN
__sync_bool_compare_and_swap_4 (int *ptr, int oldval, int newval)
{
  int failure = __kernel_cmpxchg (oldval, newval, ptr);
  return (failure == 0);
}

#define SUBWORD_BOOL_CAS(TYPE, WIDTH)					\
  bool HIDDEN								\
  __sync_bool_compare_and_swap_##WIDTH (TYPE *ptr, TYPE oldval,		\
					TYPE newval)			\
  {									\
    TYPE actual_oldval							\
      = __sync_val_compare_and_swap_##WIDTH (ptr, oldval, newval);	\
    return (oldval == actual_oldval);					\
  }

SUBWORD_BOOL_CAS (short, 2)
SUBWORD_BOOL_CAS (char,  1)

int HIDDEN
__sync_lock_test_and_set_4 (int *ptr, int val)
{
  int failure, oldval;

  do {
    oldval = *ptr;
    failure = __kernel_cmpxchg (oldval, val, ptr);
  } while (failure != 0);

  return oldval;
}

#define SUBWORD_TEST_AND_SET(TYPE, WIDTH)				\
  TYPE HIDDEN								\
  __sync_lock_test_and_set_##WIDTH (TYPE *ptr, TYPE val)		\
  {									\
    int failure;							\
    unsigned int oldval, newval, shift, mask;				\
    int *wordptr = (int *) ((unsigned long) ptr & ~3);			\
									\
    shift = (((unsigned long) ptr & 3) << 3) ^ INVERT_MASK_##WIDTH;	\
    mask = MASK_##WIDTH << shift;					\
									\
    do {								\
      oldval = *wordptr;						\
      newval = (oldval & ~mask)						\
	       | (((unsigned int) val << shift) & mask);		\
      failure = __kernel_cmpxchg (oldval, newval, wordptr);		\
    } while (failure != 0);						\
									\
    return (oldval & mask) >> shift;					\
  }

SUBWORD_TEST_AND_SET (short, 2)
SUBWORD_TEST_AND_SET (char,  1)

#define SYNC_LOCK_RELEASE(TYPE, WIDTH)					\
  void HIDDEN								\
  __sync_lock_release_##WIDTH (TYPE *ptr)				\
  {									\
    *ptr = 0;								\
  }

SYNC_LOCK_RELEASE (int,   4)
SYNC_LOCK_RELEASE (short, 2)
SYNC_LOCK_RELEASE (char,  1)
