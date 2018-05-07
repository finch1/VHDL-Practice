/* DWARF2 EH unwinding support for NIOS2 Linux.
   Copyright (C) 2008 Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

In addition to the permissions in the GNU General Public License, the
Free Software Foundation gives you unlimited permission to link the
compiled version of this file with other programs, and to distribute
those programs without any restriction coming from the use of this
file.  (The General Public License restrictions do apply in other
respects; for example, they cover modification of the file, and
distribution when not linked into another program.)

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GCC; see the file COPYING.  If not, write to
the Free Software Foundation, 51 Franklin Street, Fifth Floor,
Boston, MA 02110-1301, USA.  */

#ifndef inhibit_libc

/* Do code reading to identify a signal frame, and set the frame
   state data appropriately.  See unwind-dw2.c for the structs.  */

#include <signal.h>
#include <asm/unistd.h>

/* Unfortunately the kernel headers define the wrong shape of the
   register file, so we define our own version here.  This problem has
   been reported.  */

struct nios2_mcontext
{
  int version; /* 2 */
  unsigned seq_regs[23];  /* regs 1..23 */
  unsigned ra; /* Return address, r31 */
  unsigned fp; /* Frame pointer, r28 */
  unsigned gp; /* Global pointer, r26 */
  unsigned pad1;
  unsigned ea; /* Exception return address (pc) */
  unsigned sp; /* Stack pointer, r27 */
  unsigned pad2;
  /* Note r24, r25, r29, r30 are reserved registers */
};

/* The kernel's definition of this structure also doesn't match
   reality.  Again, this has been reported. */

struct nios2_ucontext {
  unsigned long uc_flags;
  unsigned pad1;
  void	  *uc_link;
  stack_t       uc_stack;
  struct siginfo info;
  struct nios2_mcontext uc_mcontext;
};

#define MD_FALLBACK_FRAME_STATE_FOR nios2_fallback_frame_state

static _Unwind_Reason_Code
nios2_fallback_frame_state (struct _Unwind_Context *context,
			    _Unwind_FrameState *fs)
{
  u_int32_t *pc = (u_int32_t *) context->ra;
  _Unwind_Ptr new_cfa;
  int i;

  /* movi r2,(sigreturn/rt_sigreturn)
     trap  */
  if (pc[1] != 0x003b683a) /* trap */
    return _URC_END_OF_STACK;

#define NIOS2_REG(NUM,NAME)					\
      (fs->regs.reg[NUM].how = REG_SAVED_OFFSET,		\
       fs->regs.reg[NUM].loc.offset = (_Unwind_Ptr)&regs->NAME - new_cfa)
  
  if (pc[0] == (0x00800004 | (__NR_sigreturn << 6)))
    {
      struct sigframe {
	u_int32_t trampoline[2];
	u_int32_t pad1;
	u_int32_t pad2;
	struct sigcontext ctx;
      } *rt_ = context->ra;
      struct pt_regs *regs = &rt_->ctx.regs;

      /* The CFA is the user's incoming stack pointer value.  */
      new_cfa = (_Unwind_Ptr)regs->sp;
      fs->cfa_how = CFA_REG_OFFSET;
      fs->cfa_reg = STACK_POINTER_REGNUM;
      fs->cfa_offset = new_cfa - (_Unwind_Ptr) context->cfa;

      /* Regs 1..15 */
      NIOS2_REG (1, r1);
      NIOS2_REG (2, r2);
      NIOS2_REG (3, r3);
      NIOS2_REG (4, r4);
      NIOS2_REG (5, r5);
      NIOS2_REG (6, r6);
      NIOS2_REG (7, r7);
      NIOS2_REG (8, r8);
      NIOS2_REG (9, r9);
      NIOS2_REG (10, r10);
      NIOS2_REG (11, r11);
      NIOS2_REG (12, r12);
      NIOS2_REG (13, r13);
      NIOS2_REG (14, r14);
      NIOS2_REG (15, r15);

      /* Regs 16..23 are not saved here.  They are callee saved or
	 special.  */
      
      /* The random registers.  */
      NIOS2_REG (RA_REGNO, ra);
      NIOS2_REG (FP_REGNO, fp);
      NIOS2_REG (GP_REGNO, gp);
      NIOS2_REG (SIGNAL_UNWIND_RETURN_COLUMN, ea);
      
      fs->retaddr_column = SIGNAL_UNWIND_RETURN_COLUMN;
      
      return _URC_NO_REASON;
    }
  else if (pc[0] == (0x00800004 | (__NR_rt_sigreturn << 6)))
    {
      struct sigframe {
	u_int32_t trampoline[2];
	struct nios2_ucontext sigctx;
      } *rt_ = context->ra;
      struct nios2_mcontext *regs = &rt_->sigctx.uc_mcontext;
      
      if (regs->version != 2)
	return _URC_END_OF_STACK;

      /* The CFA is the user's incoming stack pointer value.  */
      new_cfa = (_Unwind_Ptr)regs->sp;
      fs->cfa_how = CFA_REG_OFFSET;
      fs->cfa_reg = STACK_POINTER_REGNUM;
      fs->cfa_offset = new_cfa - (_Unwind_Ptr) context->cfa;
      
      /* The sequential registers.  */
      for (i = 1; i != 24; i++)
	NIOS2_REG (i, seq_regs[i-1]);
      
      /* The random registers.  */
      NIOS2_REG (RA_REGNO, ra);
      NIOS2_REG (FP_REGNO, fp);
      NIOS2_REG (GP_REGNO, gp);
      NIOS2_REG (SIGNAL_UNWIND_RETURN_COLUMN, ea);
      
      fs->retaddr_column = SIGNAL_UNWIND_RETURN_COLUMN;
      
      return _URC_NO_REASON;
    }
#undef NIOS2_REG
  return _URC_END_OF_STACK;
}
#endif
