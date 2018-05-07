/*
 * uboot-crt0.S -- startup file for uboot PowerPC systems.
 *
 * Copyright (c) 1995 Cygnus Support
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

/* uboot expects r29 to be preserved, so we have to save it somewhere
	and restore it on exit.  We also preserve the stack pointer,
	so we can return nicely to uboot.  In other respects we are
	the same as a regular crt0. */
#include "ppc-asm.h"

	.file	"uboot-crt0.S"
	.section ".got2","aw"
	.align	2

.LCTOC1 = .+32768

	.section ".got2","aw"
.Ltable = .-.LCTOC1
	.long	.LCTOC1			/* address we think .LCTOC1 is loaded at */

.Lsbss_start = .-.LCTOC1
	.long	__sbss_start

.Lsbss_end = .-.LCTOC1
	.long	__sbss_end

.Lbss_start = .-.LCTOC1
	.long	__bss_start

.Lend = .-.LCTOC1
	.long	_end

.Lstack = .-.LCTOC1			/* stack address if set by user */
	.long	__stack

.Luboot = .-.LCTOC1
	.long  __uboot

.Lalign_saved = .-.LCTOC1
	.long  __align_saved

.Lhandler = .-.LCTOC1
	.long _handler

.Ltrap_handler = .-.LCTOC1
	.long _trap_handler

#ifndef __NO_FPRS__
.Lcs_alignment = .-.LCTOC1
	.long  _cs_alignment

.Lcs_alignment_helper = .-.LCTOC1
	.long  _cs_alignment_helper
#endif

	.data
	.p2align 2
__uboot:	
	.long 0
__align_saved:
	.space 0x0f00
	
	.text
	.globl	_start
	.type	_start,@function
_start:
	mflr    r10 /* Preserve link register */
	bl	. + 8		/* get current address */
	.long	.LCTOC1 - .
	mflr	r4			/* real address of .Laddr */
	lwz	r5,0(r4)		/* linker generated address of .LCTOC1 */
	add	r5,r5,r4		/* correct to real pointer */
	lwz	r4,.Ltable(r5)		/* get linker's idea of where .Laddr is */
	subf	r4,r4,r5		/* calculate difference between where linked and current */

	/* clear bss and sbss */
	lwz	r6,.Lbss_start(r5)	/* calculate beginning of the BSS */
	lwz	r7,.Lend(r5)		/* calculate end of the BSS */
	add	r6,r6,r4		/* adjust pointers */
	add	r7,r7,r4

	cmplw	1,r6,r7
	bc	4,4,.Ldone1

	subf	r8,r6,r7		/* number of bytes to zero */
	srwi	r9,r8,2			/* number of words to zero */
	mtctr	r9
	li	r0,0			/* zero to clear memory */
	addi	r6,r6,-4		/* adjust so we can use stwu */
.Lloop:
	stwu	r0,4(r6)		/* zero bss */
	bdnz	.Lloop

.Ldone1:

	lwz	r6,.Lsbss_start(r5)	/* calculate beginning of the SBSS */
	lwz	r7,.Lsbss_end(r5)	/* calculate end of the SBSS */
	add	r6,r6,r4		/* adjust pointers */
	add	r7,r7,r4

	cmplw	1,r6,r7
	bc	4,4,.Ldone

	subf	r8,r6,r7		/* number of bytes to zero */
	srwi	r9,r8,2			/* number of words to zero */
	mtctr	r9
	li	r0,0			/* zero to clear memory */
	addi	r6,r6,-4		/* adjust so we can use stwu */
.Lloop2:
	stwu	r0,4(r6)		/* zero bss */
	bdnz	.Lloop2

.Ldone:

	lwz	r0,.Lstack(r5)		/* stack address or 0 */
	cmplwi	1,r0,0			/* equal to 0? */
	bc	12,6,.Lnostack		/* use default stack if == 0 */
	mr	sp,r0			/* use user defined stack */

.Lnostack:
	/* set up initial stack frame */
	stwu	sp,-100(sp)
	stw	r10,104(sp)
	/* space */
	mfmsr	r10
	stw	r10,100(sp)
	/* Spill all callee save integer regs */
	stw	r31,80(sp)
	stw	r30,76(sp)
	stw	r29,72(sp)
	stw	r28,68(sp)
	stw	r27,64(sp)
	stw	r26,60(sp)
	stw	r25,56(sp)
	stw	r24,52(sp)
	stw	r23,48(sp)
	stw	r22,44(sp)
	stw	r21,40(sp)
	stw	r20,36(sp)
	stw	r19,32(sp)
	stw	r18,28(sp)
	stw	r17,24(sp)
	stw	r16,20(sp)
	stw	r15,16(sp)
	stw	r14,12(sp)
	stw	r13,8(sp)

	mr	r31,sp

	/* Save sp somewhere static */
	lwz	r8,.Luboot(r5)
	add	r8,r8,r4
	stw	sp,0(r8)

	/* Align stack */
	li	r3,-16
	and	sp,sp,r3

	/* U-Boot's global registers (on e500, r2 and r14 and r29) are
	   not available while we are running so make sure we don't enter
	   its interrupt handlers unless we crash.  */
	li	r3,0
	ori	r3,r3,0x8000
	andc	r10,r10,r3

	/* Enable coprocessors.  */
#ifdef __SPE__
	oris	r10,r10,0x0200
#endif

	mtmsr	r10
	isync


	/* Save the U-Boot exception handlers, so that we can
	   temporarily use our own.  */
	li	r3, 0xf00/4
	mtctr	r3
	li	r3, 0xfc
	lwz	r4, .Lalign_saved(r5)
	subi	r4, r4, 4
1:
	lwzu	r7, 4(r3)
	stwu	r7, 4(r4)
	bdnz	1b

	.macro handler addr
	li	r3, 0x100/4
	mtctr	r3
	li	r3, \addr-4
	lwz	r6, .Lhandler(r5)
	subi	r6, r6, 4
1:
	lwzu	r7, 4(r6)
	stwu	r7, 4(r3)
	bdnz	1b

	li	r4, \addr + .Lhandler_ptr - _handler
	lwz	r6, .Ltrap_handler(r5)
	stw	r6, 0(r4)
	.endm

	handler 0x100
	handler 0x200
	handler 0x300
	handler 0x400
	handler 0x500
	handler 0x600
	handler 0x700
	handler 0x800
	handler 0x900
	handler 0xa00
	handler 0xb00
	handler 0xc00
	handler 0xd00
	handler 0xe00
	handler 0xf00

#ifndef __NO_FPRS__
	/* Install our own alignment handler.  */
	li	r3, 0x100/4
	mtctr	r3
	li	r3, 0x5fc
	lwz	r6, .Lcs_alignment(r5)
	subi	r6, r6, 4
1:
	lwzu	r7, 4(r6)
	stwu	r7, 4(r3)
	bdnz	1b

	li	r4, 0x600 + .Lcs_helper_ptr - _cs_alignment
	lwz	r6, .Lcs_alignment_helper(r5)
	stw	r6, 0(r4)
#endif

	/* Clean up any cache revenants.  */
	li	r3, 0xf00/16
	mtctr	r3
	li	r3, 0x100
1:
	dcbst	0,r3
	addi	r3,r3,16
	bdnz	1b
	li	r3, 0xf00/16
	mtctr	r3
	li	r3, 0x100
1:
	icbi	0,r3
	addi	r3,r3,16
	bdnz	1b
	sync
	isync

	/* Let her rip */
	li r3,0
	li r4,0
	li r5,0
	bl	FUNC_NAME(main)

	/* return value from main is argument to exit */
	bl	FUNC_NAME(exit)
	trap
	.size	_start,.-_start

	.globl	_exit
	.type	_exit,@function
_exit:
	/* r3 is exit code.  */

	/* Restore stack */
	bl	. + 8		/* get current address */
	.long	.LCTOC1 - .
	mflr	r4		/* real address of .Laddr */
	lwz	r5,0(r4)	/* linker generated address of .LCTOC1 */
	add	r5,r5,r4	/* correct to real pointer */
	lwz	r4,.Ltable(r5)	/* get linker's idea of where .Laddr is */
	subf	r4,r4,r5	/* calculate difference between where linked and current */
	lwz	r8,.Luboot(r5)
	add	r8,r8,r4
	lwz	sp,0(r8)

	/* Restore saved exception handlers.  */
	li	r4, 0xf00/4
	mtctr	r4
	li	r4, 0xfc
	lwz	r5, .Lalign_saved(r5)
	subi	r5, r5, 4
1:
	lwzu	r6, 4(r5)
	stwu	r6, 4(r4)
	bdnz	1b

	/* Clean up any cache revenants.  */
	li	r4, 0xf00/16
	mtctr	r4
	li	r4, 0x100
1:
	dcbst	0,r4
	addi	r4,r4,16
	bdnz	1b
	li	r4, 0xf00/16
	mtctr	r4
	li	r4, 0x100
1:
	icbi	0,r4
	addi	r4,r4,16
	bdnz	1b
	sync
	isync

	/* Restore callee save registers. */
	lwz	r13,8(sp)
	lwz	r14,12(sp)
	lwz	r15,16(sp)
	lwz	r16,20(sp)
	lwz	r17,24(sp)
	lwz	r18,28(sp)
	lwz	r19,32(sp)
	lwz	r20,36(sp)
	lwz	r21,40(sp)
	lwz	r22,44(sp)
	lwz	r23,48(sp)
	lwz	r24,52(sp)
	lwz	r25,56(sp)
	lwz	r26,60(sp)
	lwz	r27,64(sp)
	lwz	r28,68(sp)
	lwz	r29,72(sp)
	lwz	r30,76(sp)
	lwz	r31,80(sp)
	lwz	r0,100(sp)
	mtmsr	r0
	isync
	lwz	r0,104(sp)
	mtlr	r0
	addi	sp,sp,100
	blr
	.size	_exit,.-_exit

/* Exception handler layout.  Book E GPRs are not saved.  FPRs are usually
   not saved.  */

/* Leave some space on the stack in case anything writes below it.  */
#define STACK_SKIP 128
#define _CCR 8
#define _XER 12
#define _CTR 16
#define _LR 20
#define _DAR 24
#define _DSISR 28
#define _SRR0 32
#define _SRR1 36
#define _R0 40
#define _FPR0 (_R0 + 32 * 4)
#define _FSCR (_FPR0 + (32 * 8))
#define STACK_SIZE (_FSCR + 8 + STACK_SKIP)
#define r2 2

	.type _handler,@function
_handler:
	mtsprg	0, r0		/* Save two registers for scratch.  */
	mtsprg	1, sp
	subi	sp, sp, STACK_SIZE
	mfcr	r0
	stw	r0, _CCR(sp)
	mfxer	r0
	stw	r0, _XER(sp)
	mfctr	r0
	stw	r0, _CTR(sp)
	mflr	r0
	stw	r0, _LR(sp)
	stmw	r2, _R0+8(sp)
	mfsprg	r3, 0
	stw	r3, _R0(sp)
	mfsprg	r3, 1
	stw	r3, _R0+4(sp)
	mfdar	r3
	stw	r3, _DAR(sp)
	mfdsisr	r3
	stw	r3, _DSISR(sp)
	mfsrr0	r3
	stw	r3, _SRR0(sp)
	mfsrr1	r3
	stw	r3, _SRR1(sp)

	bl	. + 8
.Lhandler_ptr:
	.long	0
	mflr	r4
	lwz	r5,0(r4)
	mtsrr0	r5

	addi	r3, sp, 8
	addi	r4, r4, _handler - .Lhandler_ptr
	sync
	isync
	rfi
	.size _handler,.-_handler
	. = _handler + 0x100

#ifndef __NO_FPRS__
	.type _save_fp,@function
_save_fp:
#define STFD(n) stfdu n, 8(r3)
	subi	r3, r3, 8
	STFD(0)
	STFD(1)
	STFD(2)
	STFD(3)
	STFD(4)
	STFD(5)
	STFD(6)
	STFD(7)
	STFD(8)
	STFD(9)
	STFD(10)
	STFD(11)
	STFD(12)
	STFD(13)
	STFD(14)
	STFD(15)
	STFD(16)
	STFD(17)
	STFD(18)
	STFD(19)
	STFD(20)
	STFD(21)
	STFD(22)
	STFD(23)
	STFD(24)
	STFD(25)
	STFD(26)
	STFD(27)
	STFD(28)
	STFD(29)
	STFD(30)
	STFD(31)
	mffs	f0
	stfdu	f0, 8(r3)
	blr
	.size _save_fp,.-_save_fp

	.type _rest_fp,@function
_rest_fp:
#define LFD(n) lfdu n, 8(r3)
	lfd	f0, 32*8(r3)
	mtfsf	0xff, f0
	subi	r3, r3, 8
	LFD(0)
	LFD(1)
	LFD(2)
	LFD(3)
	LFD(4)
	LFD(5)
	LFD(6)
	LFD(7)
	LFD(8)
	LFD(9)
	LFD(10)
	LFD(11)
	LFD(12)
	LFD(13)
	LFD(14)
	LFD(15)
	LFD(16)
	LFD(17)
	LFD(18)
	LFD(19)
	LFD(20)
	LFD(21)
	LFD(22)
	LFD(23)
	LFD(24)
	LFD(25)
	LFD(26)
	LFD(27)
	LFD(28)
	LFD(29)
	LFD(30)
	LFD(31)
	blr
	.size _rest_fp,.-_rest_fp

	.type	_cs_alignment, @function
_cs_alignment:
	mtsprg	0, r0		/* Save two registers for scratch.  */
	mtsprg	1, sp
	subi	sp, sp, STACK_SIZE
	mfcr	r0
	stw	r0, _CCR(sp)
	mfxer	r0
	stw	r0, _XER(sp)
	mfctr	r0
	stw	r0, _CTR(sp)
	mflr	r0
	stw	r0, _LR(sp)
	stmw	r2, _R0+8(sp)
	mfsprg	r3, 0
	stw	r3, _R0(sp)
	mfsprg	r3, 1
	stw	r3, _R0+4(sp)

	bl	. + 8
.Lcs_helper_ptr:
	.long	0
	mflr	r4
	lwz	r5,0(r4)
	mtlr	r5
	blr
	.size	_cs_alignment,.-_cs_alignment
	. = _cs_alignment + 0x100

	.type	_cs_alignment_helper, @function
_cs_alignment_helper:
	/* Re-enable FP.  */
	mfmsr	r3
	ori	r3, r3, 0x2000
	mtmsr	r3
	isync

	la	r3, _FPR0(sp)
	bl	_save_fp

	/* We rely on the implementation setting DSISR.  Some affected
	   processors (e.g. 440FP) do not - to support those we would have
	   to look up the instruction.  */
	mfdar	r3
	mfdsisr	r4
	la	r5, _FPR0(sp)
	la	r6, _R0(sp)
	mfsrr0	r7
	bl	_cs_alignment_c
	mtsrr0	r3

	/* Restore.  */
	la	r3, _FPR0(sp)
	bl	_rest_fp
	lmw	r28, _CCR(sp)
	mtcr	r28
	mtxer	r29
	mtctr	r30
	mtlr	r31
	lmw	r2, _R0+8(sp)
	lwz	r0, _R0(sp)
	lwz	sp, _R0+4(sp)
	rfi
	.size	_cs_alignment_helper,.-_cs_alignment_helper
#endif
