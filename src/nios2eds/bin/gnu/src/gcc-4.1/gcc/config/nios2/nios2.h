/* NOT ASSIGNED TO FSF.  COPYRIGHT ALTERA.  */
/* Definitions of target machine for Altera NIOS 2G NIOS2 version.
   Copyright (C) 2007 Altera
   Contributed by Jonah Graham (jgraham@altera.com), 
   Will Reece (wreece@altera.com), and Jeff DaSilva (jdasilva@altera.com).

This file is part of GNU CC.

GNU CC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

GNU CC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GNU CC; see the file COPYING.  If not, write to
the Free Software Foundation, 59 Temple Place - Suite 330,
Boston, MA 02111-1307, USA.  */

#if defined(TARGET_ARCH_NIOS2DPX) && (TARGET_ARCH_NIOS2DPX == 1)
#define NIOS2_XB_ENCODE_STD "nios2_6b"
#else
#define NIOS2_XB_ENCODE_STD "nios2_5b"
#endif

#define TARGET_CPU_CPP_BUILTINS()                   \
  do                                                \
    {                                               \
      builtin_define_std ("NIOS2");                 \
      builtin_define_std ("nios2");                 \
      builtin_define_std (NIOS2_XB_ENCODE_STD);     \
      if (TARGET_BIG_ENDIAN)                        \
        builtin_define_std ("nios2_big_endian");    \
      else                                          \
        builtin_define_std ("nios2_little_endian"); \
    }                                               \
  while (0)

#define TARGET_VERSION fprintf (stderr, " (Altera Nios II)")

/*********************************
 * Run-time Target Specification
 *********************************/

extern int target_flags;

#if !defined(TARGET_LINUX)
/*extern const char *nios2_sys_nosys_string; --> for -msys=nosys */
extern const char *nios2_sys_lib_string;    /* for -msys-lib= */
extern const char *nios2_sys_crt0_string;    /* for -msys-crt0= */
#endif

/*
 * There's a lot of error-prone tedium with all the different
 * custom floating point instructions.  Try to automate it a bit
 * to make it easier to deal with.
 */
#define NIOS2_STRINGIFY_INNER(x) #x
#define NIOS2_STRINGIFY(x) NIOS2_STRINGIFY_INNER(x)
#define NIOS2_CONCAT_INNER(x, y) x ## y
#define NIOS2_CONCAT(x, y) NIOS2_CONCAT_INNER (x, y)

#define NIOS2_FOR_ALL_FPU_INSNS \
  NIOS2_FPU_INSN (fwrx,     nios2_fwrx,    zdz) \
  NIOS2_FPU_INSN (fwry,     nios2_fwry,    zsz) \
  NIOS2_FPU_INSN (frdxlo,   nios2_frdxlo,  szz) \
  NIOS2_FPU_INSN (frdxhi,   nios2_frdxhi,  szz) \
  NIOS2_FPU_INSN (frdy,     nios2_frdy,    szz) \
\
  NIOS2_FPU_INSN (fadds,    addsf3,        sss) \
  NIOS2_FPU_INSN (fsubs,    subsf3,        sss) \
  NIOS2_FPU_INSN (fmuls,    mulsf3,        sss) \
  NIOS2_FPU_INSN (fdivs,    divsf3,        sss) \
  NIOS2_FPU_INSN (fmins,    minsf3,        sss) \
  NIOS2_FPU_INSN (fmaxs,    maxsf3,        sss) \
  NIOS2_FPU_INSN (fnegs,    negsf2,        ssz) \
  NIOS2_FPU_INSN (fabss,    abssf2,        ssz) \
  NIOS2_FPU_INSN (fsqrts,   sqrtsf2,       ssz) \
  NIOS2_FPU_INSN (fcoss,    cossf2,        ssz) \
  NIOS2_FPU_INSN (fsins,    sinsf2,        ssz) \
  NIOS2_FPU_INSN (ftans,    tansf2,        ssz) \
  NIOS2_FPU_INSN (fatans,   atansf2,       ssz) \
  NIOS2_FPU_INSN (fexps,    expsf2,        ssz) \
  NIOS2_FPU_INSN (flogs,    logsf2,        ssz) \
  NIOS2_FPU_INSN (fcmplts,  nios2_sltsf,   iss) \
  NIOS2_FPU_INSN (fcmples,  nios2_slesf,   iss) \
  NIOS2_FPU_INSN (fcmpgts,  nios2_sgtsf,   iss) \
  NIOS2_FPU_INSN (fcmpges,  nios2_sgesf,   iss) \
  NIOS2_FPU_INSN (fcmpeqs,  nios2_seqsf,   iss) \
  NIOS2_FPU_INSN (fcmpnes,  nios2_snesf,   iss) \
\
  NIOS2_FPU_INSN (faddd,    adddf3,        ddd) \
  NIOS2_FPU_INSN (fsubd,    subdf3,        ddd) \
  NIOS2_FPU_INSN (fmuld,    muldf3,        ddd) \
  NIOS2_FPU_INSN (fdivd,    divdf3,        ddd) \
  NIOS2_FPU_INSN (fmind,    mindf3,        ddd) \
  NIOS2_FPU_INSN (fmaxd,    maxdf3,        ddd) \
  NIOS2_FPU_INSN (fnegd,    negdf2,        ddz) \
  NIOS2_FPU_INSN (fabsd,    absdf2,        ddz) \
  NIOS2_FPU_INSN (fsqrtd,   sqrtdf2,       ddz) \
  NIOS2_FPU_INSN (fcosd,    cosdf2,        ddz) \
  NIOS2_FPU_INSN (fsind,    sindf2,        ddz) \
  NIOS2_FPU_INSN (ftand,    tandf2,        ddz) \
  NIOS2_FPU_INSN (fatand,   atandf2,       ddz) \
  NIOS2_FPU_INSN (fexpd,    expdf2,        ddz) \
  NIOS2_FPU_INSN (flogd,    logdf2,        ddz) \
  NIOS2_FPU_INSN (fcmpltd,  nios2_sltdf,   idd) \
  NIOS2_FPU_INSN (fcmpled,  nios2_sledf,   idd) \
  NIOS2_FPU_INSN (fcmpgtd,  nios2_sgtdf,   idd) \
  NIOS2_FPU_INSN (fcmpged,  nios2_sgedf,   idd) \
  NIOS2_FPU_INSN (fcmpeqd,  nios2_seqdf,   idd) \
  NIOS2_FPU_INSN (fcmpned,  nios2_snedf,   idd) \
\
  NIOS2_FPU_INSN (floatis,  floatsisf2,    siz) \
  NIOS2_FPU_INSN (floatus,  floatunssisf2, suz) \
  NIOS2_FPU_INSN (floatid,  floatsidf2,    diz) \
  NIOS2_FPU_INSN (floatud,  floatunssidf2, duz) \
  NIOS2_FPU_INSN (fixsi,    fixsfsi2,      isz) \
  NIOS2_FPU_INSN (fixsu,    fixunssfsi2,   usz) \
  NIOS2_FPU_INSN (fixdi,    fixdfsi2,      idz) \
  NIOS2_FPU_INSN (fixdu,    fixunsdfsi2,   udz) \
  NIOS2_FPU_INSN (fextsd,   extendsfdf2,   dsz) \
  NIOS2_FPU_INSN (ftruncds, truncdfsf2,    sdz)

enum
{
#define NIOS2_FPU_INSN(opt, insn, args) \
  NIOS2_CONCAT (nios2_fpu_, insn),
NIOS2_FOR_ALL_FPU_INSNS
  nios2_fpu_max_insn
};

struct cpp_reader;
typedef const char * (*nios2_outputfn) (rtx);
typedef void (*nios2_pragmafn) (struct cpp_reader *);

typedef struct
{
  const char *option;      /* name of switch, e.g. fadds */
  const char *insnnm;      /* name of gcc insn, e.g. addsf3 */
  const char *args;        /* args to gcc insn, e.g. sss */
  int N;                   /* value of switch as an integer, -1 = not used */
  nios2_outputfn output;   /* output function for use in .md file */
  const char *pname;       /* name of corresponding #pragma custom- */
  nios2_pragmafn pragma;   /* pragma function for register_target_pragmas */
  const char *nopname;     /* name of corresponding #pragma no-custom- */
  nios2_pragmafn nopragma; /* pragma function for register_target_pragmas */
  int is_double;           /* does this insn have any double operands */
  int needed_by_double;    /* is this insn needed if doubles are used? */
  int needs_unsafe;        /* does this insn require
                              -funsafe-math-optimizations to work? */
  int needs_finite;        /* does this insn require
                              -ffinite-math-only to work? */
  int pragma_seen;         /* have we seen the corresponding #pragma? */
  int* pN;                 /* pointer to the value as set by the option
			      parser.  */
} nios2_fpu_info;

extern nios2_fpu_info nios2_fpu_insns[nios2_fpu_max_insn];
extern const char *nios2_custom_fpu_cfg_string;

#undef NIOS2_FPU_INSN
#define NIOS2_FPU_INSN(opt, insn, args) \
  extern int NIOS2_CONCAT (nios2_custom_, opt);
NIOS2_FOR_ALL_FPU_INSNS

#ifndef TARGET_ENDIAN_DEFAULT
#if defined(TARGET_ARCH_NIOS2DPX) && (TARGET_ARCH_NIOS2DPX == 1)
/* nios2dpx is big endian, unless otherwise specified by defining BIG_ENDIAN_FLAG */
# define TARGET_ENDIAN_DEFAULT MASK_BIG_ENDIAN
#else /* !TARGET_ARCH_NIOS2DPX */
/* nios2 is little endian, unless otherwise specified by defining BIG_ENDIAN_FLAG */
# define TARGET_ENDIAN_DEFAULT 0
#endif
#endif /* TARGET_ENDIAN_DEFAULT */

/* Default target_flags if no switches specified.  */
#ifndef TARGET_DEFAULT
# define TARGET_DEFAULT (MASK_HAS_MUL | \
			 TARGET_ENDIAN_DEFAULT)
#endif

/* Switch  Recognition by gcc.c.  Add -G xx support */
#undef  SWITCH_TAKES_ARG
#define SWITCH_TAKES_ARG(CHAR)                                          \
  (DEFAULT_SWITCH_TAKES_ARG (CHAR) || (CHAR) == 'G')

#define OVERRIDE_OPTIONS override_options ()
#define OPTIMIZATION_OPTIONS(LEVEL, SIZE) optimization_options (LEVEL, SIZE)
#define CAN_DEBUG_WITHOUT_FP

#define CC1_SPEC "\
%{G*} %{EB:-meb} %{EL:-mel} %{EB:%{EL:%emay not use both -EB and -EL}}"

#if TARGET_ENDIAN_DEFAULT == 0
# define ASM_SPEC "\
%{!EB:%{!meb:-EL}} %{EB|meb:-EB}"
# define LINK_SPEC_ENDIAN "\
%{!EB:%{!meb:-EL}} %{EB|meb:-EB}"
# define MULTILIB_DEFAULTS { "EL" }
#else
# define ASM_SPEC "\
%{!EL:%{!mel:-EB}} %{EL|mel:-EL}"
# define LINK_SPEC_ENDIAN "\
%{!EL:%{!mel:-EB}} %{EL|mel:-EL}"
# define MULTILIB_DEFAULTS { "EB" }
#endif

#define LINK_SPEC LINK_SPEC_ENDIAN \
  " %{shared:-shared} \
    %{static:-Bstatic}"


#if defined(TARGET_LINUX)

#undef LIB_SPEC
#define LIB_SPEC \
"--start-group -lc -lgcc \
 -lnosys -lstack \
 --end-group \
"

#undef STARTFILE_SPEC
#define STARTFILE_SPEC  \
"crt0%O%s"

#undef ENDFILE_SPEC
#define ENDFILE_SPEC \
 ""

#else

#undef LIB_SPEC
#define LIB_SPEC \
"--start-group %{msmallc: -lsmallc} %{!msmallc: -lc} -lgcc \
 %{msys-lib=*: -l%*} \
 %{!msys-lib=*: -lnosys -lstack} \
 --end-group \
 %{msys-lib=: %eYou need a library name for -msys-lib=} \
"

#undef STARTFILE_SPEC
#define STARTFILE_SPEC  \
"%{msys-crt0=*: %*} %{!msys-crt0=*: crt0%O%s} \
 %{msys-crt0=: %eYou need a C startup file for -msys-crt0=} \
 %{mctors-in-init: crti%O%s crtbegin%O%s} \
"

#undef ENDFILE_SPEC
#define ENDFILE_SPEC \
 "%{mctors-in-init: crtend%O%s crtn%O%s}"

#endif



/***********************
 * Storage Layout
 ***********************/

#define DEFAULT_SIGNED_CHAR 1
#define BITS_BIG_ENDIAN 0

#define BYTES_BIG_ENDIAN (TARGET_BIG_ENDIAN != 0)
#define WORDS_BIG_ENDIAN (TARGET_BIG_ENDIAN != 0)

/* Define this to set the endianness to use in libgcc2.c, which can
   not depend on target_flags.  */
#if defined(__nios2_big_endian__)
#define LIBGCC2_WORDS_BIG_ENDIAN 1
#else
#define LIBGCC2_WORDS_BIG_ENDIAN 0
#endif
#define BITS_PER_UNIT 8
#define BITS_PER_WORD 32
#define UNITS_PER_WORD 4
#define POINTER_SIZE 32
#define BIGGEST_ALIGNMENT 32
#define STRICT_ALIGNMENT 1
#define FUNCTION_BOUNDARY 32
#define PARM_BOUNDARY 32
#define STACK_BOUNDARY 32
#define PREFERRED_STACK_BOUNDARY 32
#define MAX_FIXED_MODE_SIZE 64

#define CONSTANT_ALIGNMENT(EXP, ALIGN)                          \
  ((TREE_CODE (EXP) == STRING_CST)                              \
   && (ALIGN) < BITS_PER_WORD ? BITS_PER_WORD : (ALIGN))


/**********************
 * Layout of Source Language Data Types
 **********************/

#define INT_TYPE_SIZE 32
#define SHORT_TYPE_SIZE 16
#define LONG_TYPE_SIZE 32
#define LONG_LONG_TYPE_SIZE 64
#define FLOAT_TYPE_SIZE 32
#define DOUBLE_TYPE_SIZE 64
#define LONG_DOUBLE_TYPE_SIZE DOUBLE_TYPE_SIZE


/*************************
 * Condition Code Status
 ************************/

/* comparison type */
/* ??? Currently CMP_DI is unused.  CMP_SF and CMP_DF are only used if
   the corresponding -mcustom-<opcode> switches are present. */
enum cmp_type {
  CMP_SI,                               /* compare four byte integers */
  CMP_DI,                               /* compare eight byte integers */
  CMP_SF,                               /* compare single precision floats */
  CMP_DF,                               /* compare double precision floats */
  CMP_MAX                               /* max comparison type */
};

extern GTY(()) rtx branch_cmp[2];       /* operands for compare */
extern enum cmp_type branch_type;       /* what type of branch to use */

/**********************
 * Register Usage
 **********************/

/* ---------------------------------- *
 * Basic Characteristics of Registers
 * ---------------------------------- */

/*
Register Number
      Register Name
          Alternate Name
                Purpose
0     r0  zero  always zero
1     r1  at    Assembler Temporary
2-3   r2-r3     Return Location
4-7   r4-r7     Register Arguments
8-15  r8-r15    Caller Saved Registers
16-22 r16-r22   Callee Saved Registers
21    r21 sc    Callee Saved Register / (LINUX) Static Chain (Callee Saved)
                ??? Does $sc want to be caller or callee
                saved. If caller, 15, else 21.
22    r22       Callee Saved Register (BareMetal) / (LINUX) Global Offset Table pointer for linux
23    r23 sc    Static Chain (Callee Saved)/ (LINUX) Thread pointer for linux
24    r24 et    Exception Temporary
25    r25 bt    Breakpoint Temporary
26    r26 gp    Global Pointer
27    r27 sp    Stack Pointer
28    r28 fp    Frame Pointer
29    r29 ea    Exception Return Address
30    r30 ba    Breakpoint Return Address
31    r31 ra    Return Address

32    ctl0 status
33    ctl1 estatus STATUS saved by exception ?
34    ctl2 bstatus STATUS saved by break ?
35    ctl3 ipri    Interrupt Priority Mask ?
36    ctl4 ecause  Exception Cause ?

37    pc       Not an actual register

38    fake_fp  Fake Frame Pointer which will always be eliminated.
39    fake_ap  Fake Argument Pointer which will always be eliminated.

40             First Pseudo Register


The definitions for all the hard register numbers
are located in nios2.md.
*/

#define ET_REGNO (24)
#define GP_REGNO (26)
#define SP_REGNO (27)
#define FP_REGNO (28)
#define EA_REGNO (29)
#define RA_REGNO (31)
#define FIRST_RETVAL_REGNO (2)
#define LAST_RETVAL_REGNO (3)
#define FIRST_ARG_REGNO (4)
#define LAST_ARG_REGNO (7)

#if defined(TARGET_LINUX)
/* LINUX */
#define SC_REGNO (21)
#else
/* BARE-METAL */
#define SC_REGNO (23)
#endif

#define PC_REGNO (37)
#define FAKE_FP_REGNO (38)
#define FAKE_AP_REGNO (39)

#define FIRST_PSEUDO_REGISTER 40
#define NUM_ARG_REGS (LAST_ARG_REGNO - FIRST_ARG_REGNO + 1)


#if defined(TARGET_LINUX)
/* LINUX */
#define FIXED_REGISTERS                      \
    {                                        \
/*        +0  1  2  3  4  5  6  7  8  9 */   \
/*   0 */  1, 1, 0, 0, 0, 0, 0, 0, 0, 0,     \
/*  10 */  0, 0, 0, 0, 0, 0, 0, 0, 0, 0,     \
/*  20 */  0, 0, 1, 1, 1, 1, 1, 1, 0, 1,     \
/*  30 */  1, 0, 1, 1, 1, 1, 1, 1, 1, 1,     \
    }

/* call used is the same as caller saved
   + fixed regs + args + ret vals */
#define CALL_USED_REGISTERS                  \
    {                                        \
/*        +0  1  2  3  4  5  6  7  8  9 */   \
/*   0 */  1, 1, 1, 1, 1, 1, 1, 1, 1, 1,     \
/*  10 */  1, 1, 1, 1, 1, 1, 0, 0, 0, 0,     \
/*  20 */  0, 0, 1, 1, 1, 1, 1, 1, 0, 1,     \
/*  30 */  1, 0, 1, 1, 1, 1, 1, 1, 1, 1,     \
    }
#else
/* BARE-METAL */
#define FIXED_REGISTERS                      \
    {                                        \
/*        +0  1  2  3  4  5  6  7  8  9 */   \
/*   0 */  1, 1, 0, 0, 0, 0, 0, 0, 0, 0,     \
/*  10 */  0, 0, 0, 0, 0, 0, 0, 0, 0, 0,     \
/*  20 */  0, 0, 0, 0, 1, 1, 1, 1, 0, 1,     \
/*  30 */  1, 0, 1, 1, 1, 1, 1, 1, 1, 1,     \
    }

/* call used is the same as caller saved
   + fixed regs + args + ret vals */
#define CALL_USED_REGISTERS                  \
    {                                        \
/*        +0  1  2  3  4  5  6  7  8  9 */   \
/*   0 */  1, 1, 1, 1, 1, 1, 1, 1, 1, 1,     \
/*  10 */  1, 1, 1, 1, 1, 1, 0, 0, 0, 0,     \
/*  20 */  0, 0, 0, 0, 1, 1, 1, 1, 0, 1,     \
/*  30 */  1, 0, 1, 1, 1, 1, 1, 1, 1, 1,     \
    }

#endif

#define THREAD_POINTER_REGNUM 23

#define HARD_REGNO_NREGS(REGNO, MODE)            \
   ((GET_MODE_SIZE (MODE) + UNITS_PER_WORD - 1)  \
    / UNITS_PER_WORD)

/* --------------------------- *
 * How Values Fit in Registers
 * --------------------------- */

#define HARD_REGNO_MODE_OK(REGNO, MODE) 1

#define MODES_TIEABLE_P(MODE1, MODE2) 1


/*************************
 * Register Classes
 *************************/

enum reg_class
{
    NO_REGS,
    D00_REG,
    D01_REG,
    D02_REG,
    D03_REG,
    D04_REG,
    D05_REG,
    D06_REG,
    D07_REG,
    D08_REG,
    D09_REG,
    D10_REG,
    D11_REG,
    D12_REG,
    D13_REG,
    D14_REG,
    D15_REG,
    D16_REG,
    D17_REG,
    D18_REG,
    D19_REG,
    D20_REG,
    D21_REG,
    D22_REG,
    D23_REG,
    D24_REG,
    D25_REG,
    D26_REG,
    D27_REG,
    D28_REG,
    D29_REG,
    D30_REG,
    D31_REG,
    SIB_REGS,
    GP_REGS,
    ALL_REGS,
    LIM_REG_CLASSES
};

#define N_REG_CLASSES (int) LIM_REG_CLASSES

#define REG_CLASS_NAMES   \
    {"NO_REGS",           \
     "D00_REG",           \
     "D01_REG",           \
     "D02_REG",           \
     "D03_REG",           \
     "D04_REG",           \
     "D05_REG",           \
     "D06_REG",           \
     "D07_REG",           \
     "D08_REG",           \
     "D09_REG",           \
     "D10_REG",           \
     "D11_REG",           \
     "D12_REG",           \
     "D13_REG",           \
     "D14_REG",           \
     "D15_REG",           \
     "D16_REG",           \
     "D17_REG",           \
     "D18_REG",           \
     "D19_REG",           \
     "D20_REG",           \
     "D21_REG",           \
     "D22_REG",           \
     "D23_REG",           \
     "D24_REG",           \
     "D25_REG",           \
     "D26_REG",           \
     "D27_REG",           \
     "D28_REG",           \
     "D29_REG",           \
     "D30_REG",           \
     "D31_REG",           \
     "SIB_REGS",	  \
     "GP_REGS",           \
     "ALL_REGS"}

#define GENERAL_REGS ALL_REGS

#define REG_CLASS_CONTENTS   \
/* NO_REGS  */       {{ 0, 0},     \
/* D00_REG  */        { 1 << 0, 0},    \
/* D01_REG  */        { 1 << 1, 0},    \
/* D02_REG  */        { 1 << 2, 0},    \
/* D03_REG  */        { 1 << 3, 0},    \
/* D04_REG  */        { 1 << 4, 0},    \
/* D05_REG  */        { 1 << 5, 0},    \
/* D06_REG  */        { 1 << 6, 0},    \
/* D07_REG  */        { 1 << 7, 0},    \
/* D08_REG  */        { 1 << 8, 0},    \
/* D09_REG  */        { 1 << 9, 0},    \
/* D10_REG  */        { 1 << 10, 0},    \
/* D11_REG  */        { 1 << 11, 0},    \
/* D12_REG  */        { 1 << 12, 0},    \
/* D13_REG  */        { 1 << 13, 0},    \
/* D14_REG  */        { 1 << 14, 0},    \
/* D15_REG  */        { 1 << 15, 0},    \
/* D16_REG  */        { 1 << 16, 0},    \
/* D17_REG  */        { 1 << 17, 0},    \
/* D18_REG  */        { 1 << 18, 0},    \
/* D19_REG  */        { 1 << 19, 0},    \
/* D20_REG  */        { 1 << 20, 0},    \
/* D21_REG  */        { 1 << 21, 0},    \
/* D22_REG  */        { 1 << 22, 0},    \
/* D23_REG  */        { 1 << 23, 0},    \
/* D24_REG  */        { 1 << 24, 0},    \
/* D25_REG  */        { 1 << 25, 0},    \
/* D26_REG  */        { 1 << 26, 0},    \
/* D27_REG  */        { 1 << 27, 0},    \
/* D28_REG  */        { 1 << 28, 0},    \
/* D29_REG  */        { 1 << 29, 0},    \
/* D30_REG  */        { 1 << 30, 0},    \
/* D31_REG  */        { 1 << 31, 0},    \
/* SIB_REGS */	      { 0xfe0c, 0}, 	\
/* GP_REGS  */        {~0, 0},    \
/* ALL_REGS */        {~0,~0}}    \

#define GP_REGNO_P(REGNO) ((REGNO) < 32)
#define REGNO_REG_CLASS(REGNO) (GP_REGNO_P (REGNO) ? GP_REGS : ALL_REGS)

/* always returns true for nios2 */
#define REG_OK_FOR_WRITE(X) 1

/* always returns true for nios2 */
#define REG_OK_FOR_READ(X) 1


#define BASE_REG_CLASS ALL_REGS
#define INDEX_REG_CLASS ALL_REGS

/* 'r', is handled automatically */
#define REG_CLASS_FROM_LETTER(C) ((C) == 'j' ? SIB_REGS : NO_REGS)

#define  REG_CLASS_FROM_CONSTRAINT(CHAR, STR) \
  ((CHAR) == 'j' ? SIB_REGS : 			\
   reg_class_from_constraint ((CHAR), (STR)))


#define REGNO_OK_FOR_BASE_P2(REGNO, STRICT) \
    ((STRICT) \
     ? (REGNO) < FIRST_PSEUDO_REGISTER \
     : (REGNO) < FIRST_PSEUDO_REGISTER || \
		 (reg_renumber && reg_renumber[REGNO] < FIRST_PSEUDO_REGISTER))

#define REGNO_OK_FOR_INDEX_P2(REGNO, STRICT) \
    (REGNO_OK_FOR_BASE_P2 (REGNO, STRICT))

#define REGNO_OK_FOR_BASE_P(REGNO) \
    (REGNO_OK_FOR_BASE_P2 (REGNO, 1))

#define REGNO_OK_FOR_INDEX_P(REGNO) \
    (REGNO_OK_FOR_INDEX_P2 (REGNO, 1))

#define REG_OK_FOR_BASE_P2(X, STRICT)                                   \
    (STRICT                                                             \
     ? REGNO_OK_FOR_BASE_P2 (REGNO (X), 1)                              \
     : REGNO_OK_FOR_BASE_P2 (REGNO (X), 1) ||                           \
       REGNO(X) >= FIRST_PSEUDO_REGISTER)

#define REG_OK_FOR_INDEX_P2(X, STRICT)                                  \
    (STRICT                                                             \
     ? REGNO_OK_FOR_INDEX_P2 (REGNO (X), 1)                             \
     : REGNO_OK_FOR_INDEX_P2 (REGNO (X), 1) ||                          \
       REGNO(X) >= FIRST_PSEUDO_REGISTER)

#define CLASS_MAX_NREGS(CLASS, MODE)             \
   ((GET_MODE_SIZE (MODE) + UNITS_PER_WORD - 1)  \
    / UNITS_PER_WORD)

#define SMALL_INT(X) ((unsigned HOST_WIDE_INT) ((X) + 0x8000) < 0x10000)
#define SMALL_INT_UNSIGNED(X) ((unsigned HOST_WIDE_INT) (X) < 0x10000)
#define UPPER16_INT(X) (((X) & 0xffff) == 0)
#define SHIFT_INT(X) ((X) >= 0 && (X) <= 31)

#if defined(TARGET_ARCH_NIOS2DPX) && (TARGET_ARCH_NIOS2DPX == 1)
#define RDWRCTL_INT(X) ((X) >= 0 && (X) <= 63)
#else
#define RDWRCTL_INT(X) ((X) >= 0 && (X) <= 31)
#endif

#define CUSTOM_INSN_OPCODE(X) ((X) >= 0 && (X) <= 255)

/* for 6b encoding */
#define SMALL12_INT(X) ((unsigned HOST_WIDE_INT) ((X) + 0x800) < 0x1000)
#define SMALL12_INT_UNSIGNED(X) ((unsigned HOST_WIDE_INT) (X) < 0x1000)
#define UPPER20_INT(X) (((X) & 0xfff) == 0)


/* CONST_OK_FOR_LETTER_P is deprecated -- see gcc internals section 17.9 */
#define CONST_OK_FOR_LETTER_P(VALUE, C)                 \
 (                                                      \
  (C) == 'I' ? SMALL_INT (VALUE) :                      \
  (C) == 'J' ? SMALL_INT_UNSIGNED (VALUE) :             \
  (C) == 'K' ? UPPER16_INT (VALUE) :                    \
  (C) == 'L' ? SHIFT_INT (VALUE) :                      \
  (C) == 'M' ? (VALUE) == 0 :                           \
  (C) == 'N' ? CUSTOM_INSN_OPCODE (VALUE) :             \
  (C) == 'O' ? RDWRCTL_INT (VALUE) :                    \
  (C) == 'P' ? SMALL12_INT (VALUE) :                    \
  0)

#define CONST_DOUBLE_OK_FOR_LETTER_P(VALUE, C) 0

#define PREFERRED_RELOAD_CLASS(X, CLASS) \
    ((CLASS) == NO_REGS ? GENERAL_REGS : (CLASS))

#define CONSTRAINT_LEN(C, STR) \
 ((C) == 'D' ? 3 : DEFAULT_CONSTRAINT_LEN ((C), (STR)))


/* EXTRA_CONSTRAINT is deprecated -- see gcc internals section 17.9 */
#define EXTRA_CONSTRAINT(VALUE, C)                              \
  (                                                             \
   (GET_CODE (VALUE) == CONST_INT) ?                            \
   ((C) == 'Q' ? SMALL12_INT_UNSIGNED (INTVAL(VALUE)) :         \
    (C) == 'R' ? UPPER20_INT (INTVAL(VALUE)):                   \
    0) :                                                        \
   (GET_CODE (VALUE) == SYMBOL_REF) ?                           \
   ((C) == 'S' ? SYMBOL_REF_IN_NIOS2_SMALL_DATA_P (VALUE) :     \
    0) :                                                        \
   0)


/* Say that the epilogue uses the return address register.  Note that
   in the case of sibcalls, the values "used by the epilogue" are
   considered live at the start of the called function.  */
#define EPILOGUE_USES(REGNO) ((REGNO) == RA_REGNO)


/**********************************
 * Trampolines for Nested Functions
 ***********************************/

#define TRAMPOLINE_TEMPLATE(FILE) \
    error ("trampolines not yet implemented")
#define TRAMPOLINE_SIZE 20
#define INITIALIZE_TRAMPOLINE(TRAMP, FNADDR, CXT) \
    error ("trampolines not yet implemented")

/***************************
 * Stack Layout and Calling Conventions
 ***************************/

/* ------------------ *
 * Basic Stack Layout
 * ------------------ */

/* The downward variants are used by the compiler,
   the upward ones serve as documentation */
#define STACK_GROWS_DOWNWARD
#define FRAME_GROWS_UPWARD
#define ARGS_GROW_UPWARD

#define STARTING_FRAME_OFFSET 0
#define FIRST_PARM_OFFSET(FUNDECL) 0

/* Before the prologue, RA lives in r31.  */
#define INCOMING_RETURN_ADDR_RTX  gen_rtx_REG (VOIDmode, RA_REGNO)
#define RETURN_ADDR_RTX(C,F) nios2_get_return_address (C)

/* -------------------------------------- *
 * Registers That Address the Stack Frame
 * -------------------------------------- */

#define STACK_POINTER_REGNUM SP_REGNO
#define STATIC_CHAIN_REGNUM SC_REGNO
#define PC_REGNUM PC_REGNO
#define DWARF_FRAME_RETURN_COLUMN RA_REGNO

/* The DWARF 2 CFA column which tracks the return address from a
   signal handler context.  */
#define SIGNAL_UNWIND_RETURN_COLUMN EA_REGNO

/* Base register for access to local variables of the function.  We
   pretend that the frame pointer is a non-existent hard register, and
   then eliminate it to HARD_FRAME_POINTER_REGNUM. */
#define FRAME_POINTER_REGNUM FAKE_FP_REGNO

#define HARD_FRAME_POINTER_REGNUM FP_REGNO
/* the argumnet pointer needs to always be eliminated
   so it is set to a fake hard register. */
#define ARG_POINTER_REGNUM FAKE_AP_REGNO

/* The CFA includes the pretend args */
#define ARG_POINTER_CFA_OFFSET(FNDECL) \
  (gcc_assert ((FNDECL) == current_function_decl), \
   FIRST_PARM_OFFSET (FNDECL) + current_function_pretend_args_size)

/* ----------------------------------------- *
 * Eliminating Frame Pointer and Arg Pointer
 * ----------------------------------------- */

#define FRAME_POINTER_REQUIRED 0

#define ELIMINABLE_REGS                                                 \
{{ ARG_POINTER_REGNUM,   STACK_POINTER_REGNUM},                         \
 { ARG_POINTER_REGNUM,   HARD_FRAME_POINTER_REGNUM},                    \
 { FRAME_POINTER_REGNUM, STACK_POINTER_REGNUM},                         \
 { FRAME_POINTER_REGNUM, HARD_FRAME_POINTER_REGNUM}}

#define CAN_ELIMINATE(FROM, TO)  \
  ((TO) == STACK_POINTER_REGNUM ? ! frame_pointer_needed : 1)

#define INITIAL_ELIMINATION_OFFSET(FROM, TO, OFFSET) \
        (OFFSET) = nios2_initial_elimination_offset ((FROM), (TO))

/* Treat LOC as a byte offset from the stack pointer and round it up
   to the next fully-aligned offset.  */
#define STACK_ALIGN(LOC)                                                \
  (((LOC) + ((PREFERRED_STACK_BOUNDARY / 8) - 1)) &                     \
   ~((PREFERRED_STACK_BOUNDARY / 8) - 1))


/* ------------------------------ *
 * Passing Arguments in Registers
 * ------------------------------ */

/* see nios2.c */
#define FUNCTION_ARG(CUM, MODE, TYPE, NAMED) \
  (function_arg (&CUM, MODE, TYPE, NAMED))

#define FUNCTION_ARG_CALLEE_COPIES(CUM, MODE, TYPE, NAMED) 0

typedef struct nios2_args
{
    int regs_used;
} CUMULATIVE_ARGS;

/* This is to initialize the above unused CUM data type */
#define INIT_CUMULATIVE_ARGS(CUM, FNTYPE, LIBNAME, FNDECL, N_NAMED_ARGS) \
    (init_cumulative_args (&CUM, FNTYPE, LIBNAME, FNDECL, N_NAMED_ARGS))

#define FUNCTION_ARG_ADVANCE(CUM, MODE, TYPE, NAMED) \
    (function_arg_advance (&CUM, MODE, TYPE, NAMED))

#define FUNCTION_ARG_PADDING(MODE, TYPE) \
  (nios2_function_arg_padding_upward ((MODE), (TYPE)) ? upward : downward)

#define PAD_VARARGS_DOWN \
  (FUNCTION_ARG_PADDING (TYPE_MODE (type), type) == downward)

#define BLOCK_REG_PADDING(MODE, TYPE, FIRST) \
  (nios2_block_reg_padding_upward ((MODE), (TYPE), (FIRST)) ? upward : \
   downward)

#define FUNCTION_ARG_REGNO_P(REGNO) \
    ((REGNO) >= FIRST_ARG_REGNO && (REGNO) <= LAST_ARG_REGNO)

/* ----------------------------- *
 * Generating Code for Profiling
 * ----------------------------- */


#define PROFILE_BEFORE_PROLOGUE
#define NO_PROFILE_COUNTERS 1
#define FUNCTION_PROFILER(FILE, LABELNO) \
  function_profiler ((FILE), (LABELNO))

/* --------------------------------------- *
 * Passing Function Arguments on the Stack
 * --------------------------------------- */

#define PUSH_ARGS 0
#define ACCUMULATE_OUTGOING_ARGS 1

#define RETURN_POPS_ARGS(FUNDECL, FUNTYPE, STACKSIZE) 0

/* --------------------------------------- *
 * How Scalar Function Values Are Returned
 * --------------------------------------- */

#define FUNCTION_VALUE(VALTYPE, FUNC) \
    gen_rtx_REG(TYPE_MODE(VALTYPE), FIRST_RETVAL_REGNO)

#define LIBCALL_VALUE(MODE) \
    gen_rtx_REG(MODE, FIRST_RETVAL_REGNO)

#define FUNCTION_VALUE_REGNO_P(REGNO) ((REGNO) == FIRST_RETVAL_REGNO)

/* ----------------------------- *
 * How Large Values Are Returned
 * ----------------------------- */


#define RETURN_IN_MEMORY(TYPE)  \
  nios2_return_in_memory (TYPE)


#define STRUCT_VALUE 0

#define DEFAULT_PCC_STRUCT_RETURN 0

/* These bits describe the different types of function supported
   by the NIOS2 backend.  They are exclusive.  i.e. a function cannot be both a
   normal function and a naked function, for example.  Knowing the
   type of a function is important for determining its prologue and
   epilogue sequences.
   Note values 3-7 are currently unassigned.
   Note that 0 is deliberately chosen for NIOS2_FT_UNKNOWN so that when the
   machine_function structure is initialized (to zero) func_type will
   default to unknown.  This will force the first use of nios2_current_func_type
   to call nios2_compute_func_type.  */
#define NIOS2_FT_UNKNOWN	 0 /* Type has not yet been determined.  */
#define NIOS2_FT_NORMAL		 1 /* Your normal, straightforward function.  */
#define NIOS2_FT_TASK		 2 /* A task. */

#define NIOS2_FT_TYPE_MASK	((1 << 3) - 1)

/* In addition functions can have type modifiers,
   outlined by these bit masks:  */
#define NIOS2_FT_NAKED		(1 << 3) /* No prologue or epilogue.  */

/* Some macros to test these flags.  */
#define NIOS2_FUNC_TYPE(t)	(t & NIOS2_FT_TYPE_MASK)
#define IS_TASK(t)     	        (t & NIOS2_FT_TASK)
#define IS_NAKED(t)        	(t & NIOS2_FT_NAKED)


/*******************
 * Addressing Modes
 *******************/


#define LEGITIMIZE_ADDRESS(X, OLDX, MODE, WIN)      \
  do                                                \
    {                                               \
      X = nios2_legitimize_address (X, OLDX, MODE); \
      if (memory_address_p (MODE, X))               \
        goto WIN;                                   \
    }                                               \
  while (0)

#define CONSTANT_ADDRESS_P(X) \
  (CONSTANT_P (X) && nios2_legitimate_address (X, Pmode, 0))

#define MAX_REGS_PER_ADDRESS 1

/* Go to ADDR if X is a valid address.  */
#ifndef REG_OK_STRICT
#define GO_IF_LEGITIMATE_ADDRESS(MODE, X, ADDR)        \
    {                                                  \
        if (nios2_legitimate_address ((X), (MODE), 0))  \
            goto ADDR;                                 \
    }
#else
#define GO_IF_LEGITIMATE_ADDRESS(MODE, X, ADDR)        \
    {                                                  \
        if (nios2_legitimate_address ((X), (MODE), 1))  \
            goto ADDR;                                 \
    }
#endif

#ifndef REG_OK_STRICT
#define REG_OK_FOR_BASE_P(X)   REGNO_OK_FOR_BASE_P2 (REGNO (X), 0)
#define REG_OK_FOR_INDEX_P(X)  REGNO_OK_FOR_INDEX_P2 (REGNO (X), 0)
#else
#define REG_OK_FOR_BASE_P(X)   REGNO_OK_FOR_BASE_P2 (REGNO (X), 1)
#define REG_OK_FOR_INDEX_P(X)  REGNO_OK_FOR_INDEX_P2 (REGNO (X), 1)
#endif

#define LEGITIMATE_CONSTANT_P(X) nios2_legitimate_constant (X)

/* Nios II has no mode dependent addresses.  */
#define GO_IF_MODE_DEPENDENT_ADDRESS(ADDR, LABEL)

/* Set if this has a weak declaration  */
#define SYMBOL_FLAG_WEAK_DECL   (1 << SYMBOL_FLAG_MACH_DEP_SHIFT)
#define SYMBOL_REF_WEAK_DECL_P(RTX) \
  ((SYMBOL_REF_FLAGS (RTX) & SYMBOL_FLAG_WEAK_DECL) != 0)


/* true if a symbol is both small and not weak. In this case, gp
   relative access can be used.  gp relative access cannot be used in
   position independent code.  gp relative access cannot be used for externally
   defined symbols, because the compilation unit which defines the symbol may
   place it in a section that cannot be reached from gp.  */
#define SYMBOL_REF_IN_NIOS2_SMALL_DATA_P(RTX) \
   (!flag_pic && SYMBOL_REF_SMALL_P(RTX) && !SYMBOL_REF_WEAK_DECL_P(RTX) && \
    !SYMBOL_REF_EXTERNAL_P(RTX) && SYMBOL_REF_TLS_MODEL(RTX)==0)

/*****************
 * Describing Relative Costs of Operations
 *****************/

#define SLOW_BYTE_ACCESS 1

/* It is as good to call a constant function address as to call an address
   kept in a register.
   ??? Not true anymore really. Now that call cannot address full range
   of memory callr may need to be used */

#define NO_FUNCTION_CSE

/***************************
 * Position Independent Code
 ***************************/

#define PIC_OFFSET_TABLE_REGNUM 22

#define LEGITIMATE_PIC_OPERAND_P(X) nios2_legitimate_pic_operand_p (X)

/*****************************************
 * Defining the Output Assembler Language
 *****************************************/

/* ------------------------------------------ *
 * The Overall Framework of an Assembler File
 * ------------------------------------------ */

#define ASM_APP_ON "#APP\n"
#define ASM_APP_OFF "#NO_APP\n"

#define ASM_COMMENT_START "# "

/* ------------------------------- *
 * Output and Generation of Labels
 * ------------------------------- */

#define GLOBAL_ASM_OP "\t.global\t"


/* -------------- *
 * Output of Data
 * -------------- */

/* -------------------------------- *
 * Assembler Commands for Alignment
 * -------------------------------- */

#define ASM_OUTPUT_ALIGN(FILE, LOG) \
  do { \
    fprintf ((FILE), "%s%d\n", ALIGN_ASM_OP, (LOG)); \
  } while (0)


/* -------------------------------- *
 * Output of Assembler Instructions
 * -------------------------------- */

#define REGISTER_NAMES \
{ \
    "zero", \
    "at", \
    "r2", \
    "r3", \
    "r4", \
    "r5", \
    "r6", \
    "r7", \
    "r8", \
    "r9", \
    "r10", \
    "r11", \
    "r12", \
    "r13", \
    "r14", \
    "r15", \
    "r16", \
    "r17", \
    "r18", \
    "r19", \
    "r20", \
    "r21", \
    "r22", \
    "r23", \
    "et", \
    "bt", \
    "gp", \
    "sp", \
    "fp", \
    "ta", \
    "ba", \
    "ra", \
    "status", \
    "estatus", \
    "bstatus", \
    "ipri", \
    "ecause", \
    "pc", \
    "fake_fp", \
    "fake_ap", \
}

#define ADDITIONAL_REGISTER_NAMES       \
{                                       \
  {"r0", 0},                            \
  {"r1", 1},                            \
  {"r24", 24},                          \
  {"r25", 25},                          \
  {"r26", 26},                          \
  {"r27", 27},                          \
  {"r28", 28},                          \
  {"r29", 29},                          \
  {"r30", 30},                          \
  {"r31", 31}                           \
}


#define ASM_OUTPUT_OPCODE(STREAM, PTR)\
   (PTR) = asm_output_opcode (STREAM, PTR)

#define PRINT_OPERAND(STREAM, X, CODE) \
    nios2_print_operand (STREAM, X, CODE)

#define PRINT_OPERAND_ADDRESS(STREAM, X) \
    nios2_print_operand_address (STREAM, X)

#define ASM_OUTPUT_ADDR_VEC_ELT(FILE, VALUE)  \
do { fputs (integer_asm_op (POINTER_SIZE / BITS_PER_UNIT, TRUE), FILE); \
     fprintf (FILE, ".L%u\n", (unsigned) (VALUE));               \
   } while (0)

#define ASM_OUTPUT_ADDR_DIFF_ELT(STREAM, BODY, VALUE, REL)\
do { fputs (integer_asm_op (POINTER_SIZE / BITS_PER_UNIT, TRUE), STREAM); \
     fprintf (STREAM, ".L%u-.L%u\n", (unsigned) (VALUE), (unsigned) (REL)); \
   } while (0)


/* ------------ *
 * Label Output
 * ------------ */


/* ---------------------------------------------------- *
 * Dividing the Output into Sections (Texts, Data, ...)
 * ---------------------------------------------------- */

/* Output before read-only data.  */
#define TEXT_SECTION_ASM_OP "\t.section\t.text"

/* Output before writable data.  */
#define DATA_SECTION_ASM_OP "\t.section\t.data"


/* Default the definition of "small data" to 8 bytes. */
/* ??? How come I can't use HOST_WIDE_INT here? */
extern unsigned long nios2_section_threshold;
#define NIOS2_DEFAULT_GVALUE 8



/* This says how to output assembler code to declare an
   uninitialized external linkage data object.  Under SVR4,
   the linker seems to want the alignment of data objects
   to depend on their types.  We do exactly that here.  */

#undef COMMON_ASM_OP
#define COMMON_ASM_OP   "\t.comm\t"

#undef  ASM_OUTPUT_ALIGNED_COMMON
#define ASM_OUTPUT_ALIGNED_COMMON(FILE, NAME, SIZE, ALIGN)              \
do                                                                      \
{                                                                       \
  fprintf ((FILE), "%s", COMMON_ASM_OP);                                \
  assemble_name ((FILE), (NAME));                                       \
  fprintf ((FILE), ","HOST_WIDE_INT_PRINT_UNSIGNED",%u\n", (SIZE),      \
           (ALIGN) / BITS_PER_UNIT);                                    \
}                                                                       \
while (0)


/* This says how to output assembler code to declare an
   uninitialized internal linkage data object.  Under SVR4,
   the linker seems to want the alignment of data objects
   to depend on their types.  We do exactly that here.  */

#undef  ASM_OUTPUT_ALIGNED_LOCAL
#define ASM_OUTPUT_ALIGNED_LOCAL(FILE, NAME, SIZE, ALIGN)               \
do {                                                                    \
  if ((SIZE) <= nios2_section_threshold)                                \
    named_section (0, ".sbss", 0);                                      \
  else                                                                  \
    named_section (0, ".bss", 0);                                       \
  ASM_OUTPUT_TYPE_DIRECTIVE (FILE, NAME, "object");                     \
  if (!flag_inhibit_size_directive)                                     \
    ASM_OUTPUT_SIZE_DIRECTIVE (FILE, NAME, SIZE);                       \
  ASM_OUTPUT_ALIGN ((FILE), exact_log2((ALIGN) / BITS_PER_UNIT));       \
  ASM_OUTPUT_LABEL(FILE, NAME);                                         \
  ASM_OUTPUT_SKIP((FILE), (SIZE) ? (SIZE) : 1);                         \
} while (0)

/* Put the jump tables in .text because when using position independent code,
   Nios II elf has no relocation that can represent arbitrary differences
   between symbols in different sections.  */
#define JUMP_TABLES_IN_TEXT_SECTION 1


/* Exception Handling */

#define MUST_USE_SJLJ_EXCEPTIONS 1

/* Describe __builtin_eh_return */
#define EH_RETURN_STACKADJ_RTX gen_rtx_REG (Pmode, LAST_RETVAL_REGNO)
#define EH_RETURN_DATA_REGNO(N) ((N) <= (LAST_ARG_REGNO - FIRST_ARG_REGNO) \
				 ? (N) + FIRST_ARG_REGNO : INVALID_REGNUM)
#define ASM_PREFERRED_EH_DATA_FORMAT(CODE, GLOBAL)		\
  (!flag_pic ? DW_EH_PE_sdata4					\
   /* FIXME: These get expanded to dynamic relocs, which is  wrong  */ \
   /* : !(GLOBAL) ? DW_EH_PE_pcrel | DW_EH_PE_sdata4	*/	\
   : DW_EH_PE_aligned)

/***************************
 * Miscellaneous Parameters
 ***************************/

#define MOVE_MAX 4

#define STORE_FLAG_VALUE 1
#define Pmode SImode
#define FUNCTION_MODE QImode

#define REGISTER_TARGET_PRAGMAS() nios2_register_target_pragmas ()

#define CASE_VECTOR_MODE Pmode

#define TRULY_NOOP_TRUNCATION(OUTPREC, INPREC) 1

#define LOAD_EXTEND_OP(MODE) (ZERO_EXTEND)

#define WORD_REGISTER_OPERATIONS
