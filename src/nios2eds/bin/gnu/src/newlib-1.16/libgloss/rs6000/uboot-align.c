/*
 * uboot-align.c -- fix up unaligned floating point instructions
 *
 * Copyright (c) 2007 CodeSourcery
 *
 * The authors hereby grant permission to use, copy, modify, distribute,
 * and license this software and its documentation for any purpose, provided
 * that existing copyright notices are retained in all copies and that this
 * notice is included verbatim in any distributions. No written agreement,
 * license, or royalty fee is required for any of the authorized uses.
 * Modifications to this software may be copyrighted by their authors
 * and need not follow the licensing terms described here, provided that
 * the new terms are clearly indicated on the first page of each file where
 * they apply.
 */

#include <unistd.h>
#include <stdio.h>

struct regs
{
  unsigned int ccr;
  unsigned int xer;
  unsigned int ctr;
  unsigned int lr;
  unsigned int *dar;
  unsigned int dsisr;
  unsigned int srr0;
  unsigned int srr1;
  unsigned int gprs[32];
  double fprs[32];
  unsigned long long fscr;
};

/* Dump out some information about a trap.  Note: nothing has saved or
   restored the upper halves of 64-bit Book E GPRs; but we are not
   going to return anyway.  */
void
_trap_handler (struct regs *regs, int trap)
{
  int i;

  printf ("***\nUnexpected trap: 0x%X\n", trap);

  printf ("NIP: %08X XER %08X CCR: %08X CTR: %08x LR: %08X\n",
	  regs->srr0, regs->xer, regs->ccr, regs->ctr, regs->lr);
  printf ("MSR: %08X DAR %08X DSISR: %08X\n",
	  regs->srr1, regs->dar, regs->dsisr);

  for (i = 0; i < 32; i++)
    {
      if ((i % 8) == 0)
	printf ("R%02d:", i);
      printf (" %08X", regs->gprs[i]);
      if ((i % 8) == 7)
	printf ("\n");
    }

  fflush (stdout);
  _exit(trap);
}

#ifndef __NO_FPRS__
/* Bit patterns in DSISR[47:53].  For the instructions we are interested
   in only - floating point load and store.  */

#define MASK 0x6c
#define INDEXED 0x68
#define UNINDEXED 0x08

#define DOUBLE 0x01
#define STORE 0x02
#define UPDATE 0x10

unsigned long
_cs_alignment_c (unsigned long *dar, unsigned long dsisr,
		 double *fprs, unsigned long *gprs,
		 unsigned long nip)
{
  int bits = (dsisr >> 10) & 0x7f;
  int rst = (dsisr >> 5) & 0x1f;
  int ra = dsisr & 0x1f;

  if ((bits & MASK) == UNINDEXED || (bits & MASK) == INDEXED)
    {
      /* Handle misaligned FP loads and stores by explicit integer
	 stores (which do not raise alignment interrupts).  */
      if (bits & DOUBLE)
	{
	  union {
	    double d;
	    long l[2];
	  } u;

	  if (bits & STORE)
	    {
	      u.d = fprs[rst];
	      asm ("stw %1, %0" : "=m" (dar[0]) : "r" (u.l[0]));
	      asm ("stw %1, %0" : "=m" (dar[1]) : "r" (u.l[1]));
	    }
	  else
	    {
	      asm ("lwz %0, %1" : "=r" (u.l[0]) : "m" (dar[0]));
	      asm ("lwz %0, %1" : "=r" (u.l[1]) : "m" (dar[1]));
	      fprs[rst] = u.d;
	    }
	}
      else
	{
	  union {
	    float f;
	    long l;
	  } u;

	  if (bits & STORE)
	    {
	      u.f = fprs[rst];
	      asm ("stw %1, %0" : "=m" (dar[0]) : "r" (u.l));
	    }
	  else
	    {
	      asm ("lwz %0, %1" : "=r" (u.l) : "m" (dar[0]));
	      fprs[rst] = u.f;
	    }
	}

      if (bits & UPDATE)
	gprs[ra] = (unsigned long) dar;
    }
  else
    _exit(1);

  return nip + 4;
}
#endif
