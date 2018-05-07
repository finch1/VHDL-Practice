/* NOT ASSIGNED TO FSF.  COPYRIGHT ALTERA.  */
/* Subroutines for assembler code output for Altera NIOS 2G NIOS2 version.
   Copyright (C) 2005 Altera
   Contributed by Jonah Graham (jgraham@altera.com), Will Reece (wreece@altera.com),
   and Jeff DaSilva (jdasilva@altera.com).

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


#include <stdio.h>
#include "config.h"
#include "system.h"
#include "coretypes.h"
#include "tm.h"
#include "rtl.h"
#include "tree.h"
#include "tm_p.h"
#include "regs.h"
#include "hard-reg-set.h"
#include "real.h"
#include "insn-config.h"
#include "conditions.h"
#include "output.h"
#include "insn-attr.h"
#include "flags.h"
#include "recog.h"
#include "expr.h"
#include "toplev.h"
#include "basic-block.h"
#include "function.h"
#include "integrate.h"
#include "ggc.h"
#include "reload.h"
#include "debug.h"
#include "optabs.h"
#include "target.h"
#include "target-def.h"
#include "c-pragma.h"           /* For c_register_pragma.  */
#include "cpplib.h"             /* For CPP_NUMBER.  */
#include "c-tree.h"             /* For builtin_function.  */


/* Forward definitions of types */
const struct attribute_spec nios2_attribute_table[];

/* Local prototypes.  */
static bool nios2_rtx_costs (rtx, int, int, int *);

static unsigned long nios2_compute_func_type (void);
static int nios2_current_task_id (void);
static const char *nios2_current_function_name (void);
static void nios2_asm_function_prologue (FILE *, HOST_WIDE_INT);
static int nios2_issue_rate (void);
static struct machine_function *nios2_init_machine_status (void);
static bool nios2_in_small_data_p (tree);
static void save_reg (int, unsigned);
static void restore_reg (int, unsigned);
static unsigned int nios2_section_type_flags (tree, const char *, int);

/* 0 --> no #pragma seen
   1 --> in scope of #pragma reverse_bitfields
   -1 --> in scope of #pragma no_reverse_bitfields.  */
static int nios2_pragma_reverse_bitfields_flag = 0;
static void nios2_pragma_reverse_bitfields (struct cpp_reader *);
static void nios2_pragma_no_reverse_bitfields (struct cpp_reader *);
static tree nios2_handle_fndecl_attribute (tree *, tree, tree, int, bool *);
static tree nios2_handle_task_attribute (tree *, tree, tree, int, bool *);
static tree nios2_handle_struct_attribute (tree *, tree, tree, int, bool *);
static void nios2_insert_attributes (tree, tree *);
static void nios2_load_pic_register (void);
static bool nios2_cannot_force_const_mem (rtx);
bool nios2_legitimate_pic_operand_p (rtx x);
static rtx nios2_legitimize_pic_address (rtx orig, enum machine_mode mode,
					 rtx reg);
rtx nios2_legitimize_address (rtx x, rtx orig_x, enum machine_mode mode);
static void nios2_init_builtins (void);
static rtx nios2_expand_builtin (tree, rtx, rtx, enum machine_mode, int);
static bool nios2_function_ok_for_sibcall (tree, tree);
static int nios2_arg_partial_bytes (CUMULATIVE_ARGS *cum,
				    enum machine_mode mode, tree type,
				    bool named ATTRIBUTE_UNUSED);
static bool nios2_pass_by_reference (CUMULATIVE_ARGS *cum ATTRIBUTE_UNUSED,
				     enum machine_mode mode ATTRIBUTE_UNUSED,
				     tree type, bool named ATTRIBUTE_UNUSED);
static void nios2_encode_section_info (tree, rtx, int);
int nios2_function_arg_padding_upward (enum machine_mode mode, tree type);
int nios2_block_reg_padding_upward (enum machine_mode mode, tree type,
                                    int first ATTRIBUTE_UNUSED);

static bool nios2_use_reg_for_func (void);
static void nios2_output_dwarf_dtprel (FILE *fuke, int size, rtx x);

/* Initialize the GCC target structure.  */
#undef TARGET_ATTRIBUTE_TABLE
#define TARGET_ATTRIBUTE_TABLE nios2_attribute_table

#undef TARGET_ASM_FUNCTION_PROLOGUE
#define TARGET_ASM_FUNCTION_PROLOGUE nios2_asm_function_prologue

#undef TARGET_DEFAULT_TARGET_FLAGS
#define TARGET_DEFAULT_TARGET_FLAGS TARGET_DEFAULT

#undef TARGET_SCHED_ISSUE_RATE
#define TARGET_SCHED_ISSUE_RATE nios2_issue_rate
#undef TARGET_IN_SMALL_DATA_P
#define TARGET_IN_SMALL_DATA_P nios2_in_small_data_p
#undef  TARGET_ENCODE_SECTION_INFO
#define TARGET_ENCODE_SECTION_INFO nios2_encode_section_info
#undef  TARGET_SECTION_TYPE_FLAGS
#define TARGET_SECTION_TYPE_FLAGS  nios2_section_type_flags

#undef TARGET_INIT_BUILTINS
#define TARGET_INIT_BUILTINS nios2_init_builtins
#undef TARGET_EXPAND_BUILTIN
#define TARGET_EXPAND_BUILTIN nios2_expand_builtin

#undef TARGET_FUNCTION_OK_FOR_SIBCALL
#define TARGET_FUNCTION_OK_FOR_SIBCALL nios2_function_ok_for_sibcall

#undef TARGET_PASS_BY_REFERENCE
#define TARGET_PASS_BY_REFERENCE nios2_pass_by_reference

#undef TARGET_ARG_PARTIAL_BYTES
#define TARGET_ARG_PARTIAL_BYTES nios2_arg_partial_bytes

#undef TARGET_PROMOTE_PROTOTYPES
#define TARGET_PROMOTE_PROTOTYPES hook_bool_tree_true

#undef TARGET_SETUP_INCOMING_VARARGS
#define TARGET_SETUP_INCOMING_VARARGS nios2_setup_incoming_varargs

#undef TARGET_USE_REG_FOR_FUNC
#define TARGET_USE_REG_FOR_FUNC nios2_use_reg_for_func

#undef TARGET_MUST_PASS_IN_STACK
#define TARGET_MUST_PASS_IN_STACK must_pass_in_stack_var_size

#undef TARGET_RTX_COSTS
#define TARGET_RTX_COSTS nios2_rtx_costs

#undef TARGET_ADDRESS_COST
#define TARGET_ADDRESS_COST hook_int_rtx_0

#undef TARGET_HAVE_TLS
#define TARGET_HAVE_TLS true

#undef TARGET_CANNOT_FORCE_CONST_MEM
#define TARGET_CANNOT_FORCE_CONST_MEM nios2_cannot_force_const_mem

#undef TARGET_ASM_OUTPUT_DWARF_DTPREL
#define TARGET_ASM_OUTPUT_DWARF_DTPREL nios2_output_dwarf_dtprel

const struct attribute_spec nios2_attribute_table[] =
{
  /* { name, min_len, max_len, decl_req, type_req, fn_type_req, handler } */
  { "reverse_bitfields",    0, 0, false, false,  false, nios2_handle_struct_attribute },
  { "no_reverse_bitfields", 0, 0, false, false,  false, nios2_handle_struct_attribute },
  { "naked",                0, 0, true,  false,  false, nios2_handle_fndecl_attribute },
  { "task",                 0, 1, false, false,  false, nios2_handle_task_attribute   },
  { NULL,                   0, 0, false, false,  false, NULL                          }
};

#undef TARGET_ATTRIBUTE_TABLE
#define TARGET_ATTRIBUTE_TABLE nios2_attribute_table

#undef  TARGET_INSERT_ATTRIBUTES
#define TARGET_INSERT_ATTRIBUTES nios2_insert_attributes

/* ??? Might want to redefine TARGET_RETURN_IN_MSB here to handle
   big-endian case; depends on what ABI we choose.  */

struct gcc_target targetm = TARGET_INITIALIZER;



/* Threshold for data being put into the small data/bss area, instead
   of the normal data area (references to the small data/bss area take
   1 instruction, and use the global pointer, references to the normal
   data area takes 2 instructions).  */
unsigned HOST_WIDE_INT nios2_section_threshold = NIOS2_DEFAULT_GVALUE;

/* Structure to be filled in by compute_frame_size with register
   save masks, and offsets for the current function.  */

struct nios2_frame_info
GTY (())
{
  unsigned HOST_WIDE_INT save_mask; /* Mask of registers to save */
  long total_size;       /* # bytes that the entire frame takes up.  */
  long var_size;         /* # bytes that variables take up.  */
  long args_size;        /* # bytes that outgoing arguments take up.  */
  int save_reg_size;     /* # bytes needed to store gp regs.  */
  long save_regs_offset; /* Offset from new sp to store gp registers.  */
  int initialized;       /* != 0 if frame size already calculated.  */
};

struct machine_function
GTY (())
{

  /* Current frame information, calculated by compute_frame_size.  */
  struct nios2_frame_info frame;
  /* Records the type of the current function */
  unsigned long func_type;
};

/* Supported TLS relocations.  */

enum tls_reloc {
  TLS_GD16,
  TLS_LDM16,
  TLS_LDO16,
  TLS_IE16,
  TLS_LE16
};

#define IS_UNSPEC_TLS(x) ((x)>=UNSPEC_TLS && (x)<=UNSPEC_ADD_TLS_LDO)



/***************************************
 * Register Classes
 ***************************************/

enum reg_class
reg_class_from_constraint (char chr, const char *str)
{
  if (chr == 'D' && ISDIGIT (str[1]) && ISDIGIT (str[2]))
    {
      int regno;
      int ones = str[2] - '0';
      int tens = str[1] - '0';

      regno = ones + (10 * tens);
      if (regno < 0 || regno > 31)
        return NO_REGS;

      return D00_REG + regno;
    }

  return NO_REGS;
}


/***************************************
 * Stack Layout and Calling Conventions
 ***************************************/

#if defined(TARGET_ARCH_NIOS2DPX) && (TARGET_ARCH_NIOS2DPX == 1)
#define TOO_BIG_OFFSET(X) ((X) > ((1 << 11) - 1))
#else
#define TOO_BIG_OFFSET(X) ((X) > ((1 << 15) - 1))
#endif
#define TEMP_REG_NUM 8


/* Returns the task_id for the current function, or 
   -1 if the task_id can not be determined.  */
static int
nios2_current_task_id (void)
{
  int task_id;
  tree attr_list, task_attr, task_attr_value;

  gcc_assert (TREE_CODE (current_function_decl) == FUNCTION_DECL);

  attr_list = DECL_ATTRIBUTES (current_function_decl);

  task_attr = lookup_attribute ("task", attr_list);

  /* No argument - return -1. */
  if ((task_attr == NULL_TREE) || (TREE_VALUE (task_attr) == NULL_TREE))
    return -1;

  /* Get the value of the argument. */
  task_attr_value = TREE_VALUE(task_attr);

  if ((TREE_VALUE (task_attr_value) == NULL_TREE) || (TREE_CODE (TREE_VALUE (task_attr_value)) != INTEGER_CST))
    return -1;

  /* task_id = ((TREE_INT_CST_HIGH (TREE_VALUE (task_attr_value)) << HOST_BITS_PER_WIDE_INT) + TREE_INT_CST_LOW (TREE_VALUE (task_attr_value))); */

  task_id = TREE_INT_CST_LOW (TREE_VALUE (task_attr_value));

  if (task_id >= 0)
    return task_id;
  else
    return -1;
}

/* Computes the type of the current function.  */
static const char *
nios2_current_function_name (void)
{
  rtx func_decl_rtx, func_decl_exp_rtx;
  const char *function_name;

  gcc_assert (TREE_CODE (current_function_decl) == FUNCTION_DECL);

  func_decl_rtx = DECL_RTL(current_function_decl);

  gcc_assert (GET_CODE(func_decl_rtx) == MEM);

  func_decl_exp_rtx = XEXP (func_decl_rtx, 0);

  gcc_assert (GET_CODE(func_decl_exp_rtx) == SYMBOL_REF);

  function_name = XSTR (func_decl_exp_rtx,0);

  gcc_assert (function_name != NULL);

  return function_name;

}

/* Computes the type of the current function.  */
static unsigned long
nios2_compute_func_type (void)
{
  unsigned long type = NIOS2_FT_UNKNOWN;
  tree a;
  tree attr;

  gcc_assert (TREE_CODE (current_function_decl) == FUNCTION_DECL);

  attr = DECL_ATTRIBUTES (current_function_decl);

  a = lookup_attribute ("naked", attr);
  if (a != NULL_TREE)
    type |= NIOS2_FT_NAKED;

  a = lookup_attribute ("task", attr);

  if (a == NULL_TREE)
    type |= NIOS2_FT_NORMAL;
  else 
    type |= NIOS2_FT_TASK;

  return type;
}

/* Returns the type of the current function.  */
unsigned long
nios2_current_func_type (void)
{
  if (NIOS2_FUNC_TYPE (cfun->machine->func_type) == NIOS2_FT_UNKNOWN)
    cfun->machine->func_type = nios2_compute_func_type ();

  return cfun->machine->func_type;
}

int
nios2_naked_function_p(void) 
{
  return IS_NAKED (nios2_current_func_type ());
}

bool
nios2_use_reg_for_func (void)
{
  /* Never spill function parameters to the stack if the function
     is naked.  */
  return IS_NAKED (nios2_current_func_type ());
}

static void
nios2_asm_function_prologue (FILE *file, HOST_WIDE_INT size ATTRIBUTE_UNUSED)
{
  unsigned long func_type;

  if (flag_verbose_asm || flag_debug_asm)
    {
      compute_frame_size ();
      dump_frame_size (file);
    }

  func_type = nios2_current_func_type ();

  if (IS_NAKED (func_type))
    asm_fprintf (file, "\t%s Naked Function: prologue and epilogue provided by programmer.\n", ASM_COMMENT_START);

  if (IS_TASK (func_type)) 
    {
      int task_id = nios2_current_task_id();
      asm_fprintf (file, "\t%s Task Function [task_id:%d]: task entry point terminated with exit instruction.\n", ASM_COMMENT_START, task_id);

      if (task_id != -1)
        {
#define TASK_PREFIX_SYM "__task_"
          asm_fprintf (file, "\t.global %s%d\n", TASK_PREFIX_SYM, task_id);
          asm_fprintf(file, "\t.set %s%d,%s\n", TASK_PREFIX_SYM, task_id, nios2_current_function_name());
        }
    }
}

static void
save_reg (int regno, unsigned offset)
{
  rtx reg = gen_rtx_REG (SImode, regno);
  rtx addr = gen_rtx_PLUS (Pmode, stack_pointer_rtx, GEN_INT (offset));

  rtx pattern = gen_rtx_SET (SImode, gen_frame_mem (Pmode, addr), reg);
  rtx insn = emit_insn (pattern);
  RTX_FRAME_RELATED_P (insn) = 1;
}

static void
restore_reg (int regno, unsigned offset)
{
  rtx reg = gen_rtx_REG (SImode, regno);
  rtx addr = gen_rtx_PLUS (Pmode, stack_pointer_rtx, GEN_INT (offset));

  rtx pattern = gen_rtx_SET (SImode, reg, gen_frame_mem (Pmode, addr));
  emit_insn (pattern);
}


void
expand_prologue (void)
{
  int ix;
  HOST_WIDE_INT total_frame_size;
  unsigned sp_offset; /* offset from base_reg to final stack value */
  unsigned fp_offset;    /* offset from base_reg to final fp value */
  unsigned long func_type;
  unsigned save_offset;
  rtx insn;
  unsigned HOST_WIDE_INT save_mask;
  
  total_frame_size = compute_frame_size ();

  func_type = nios2_current_func_type();
  
  /* Naked functions don't have prologues.  */
  if (IS_NAKED (func_type))
    return;

  /* Decrement the stack pointer */
  if (TOO_BIG_OFFSET (total_frame_size))
    {
      /* We need an intermediary point, this will point at the spill
	 block */
#if defined(TARGET_ARCH_NIOS2DPX) && (TARGET_ARCH_NIOS2DPX == 1)
      insn = emit_insn
        (gen_rtx_SET (Pmode, stack_pointer_rtx,
                      gen_rtx_PLUS (Pmode, stack_pointer_rtx,
                                    GEN_INT (cfun->machine->frame.save_regs_offset
                                             - total_frame_size))));
#else
      insn = emit_insn
	(gen_add3_insn (stack_pointer_rtx,
			stack_pointer_rtx,
			GEN_INT (cfun->machine->frame.save_regs_offset
				 - total_frame_size)));
#endif

      RTX_FRAME_RELATED_P (insn) = 1;

      fp_offset = 0;
      sp_offset = -cfun->machine->frame.save_regs_offset;
    }
  else if (total_frame_size)
    {
#if defined(TARGET_ARCH_NIOS2DPX) && (TARGET_ARCH_NIOS2DPX == 1)
      insn = emit_insn
        (gen_rtx_SET (Pmode, stack_pointer_rtx,
                      gen_rtx_PLUS (Pmode, stack_pointer_rtx,
                                    GEN_INT (-total_frame_size))));
#else
      insn = emit_insn (gen_add3_insn (stack_pointer_rtx,
				       stack_pointer_rtx,
				       GEN_INT (-total_frame_size)));
#endif

      RTX_FRAME_RELATED_P (insn) = 1;
      fp_offset = cfun->machine->frame.save_regs_offset;
      sp_offset = 0;
    }
  else
    fp_offset = sp_offset = 0;

  if (current_function_limit_stack)
    emit_insn (gen_stack_overflow_detect_and_trap ());

  save_offset = fp_offset + cfun->machine->frame.save_reg_size;
  save_mask = cfun->machine->frame.save_mask;
  
  for (ix = 32; ix--;)
    if (save_mask & ((unsigned HOST_WIDE_INT)1 << ix))
      {
	save_offset -= 4;
        save_reg (ix, save_offset);
      }

  if (frame_pointer_needed)
    {
#if defined(TARGET_ARCH_NIOS2DPX) && (TARGET_ARCH_NIOS2DPX == 1)
      insn = emit_insn
        (gen_rtx_SET (Pmode, hard_frame_pointer_rtx,
                      gen_rtx_PLUS (Pmode, stack_pointer_rtx,
                                    GEN_INT (fp_offset))));
#else
      insn = emit_insn (gen_add3_insn (hard_frame_pointer_rtx,
				       stack_pointer_rtx,
				       GEN_INT (fp_offset)));
#endif

      RTX_FRAME_RELATED_P (insn) = 1;
    }

  if (sp_offset)
    {
      rtx tmp = gen_rtx_REG (Pmode, TEMP_REG_NUM);
      emit_insn (gen_rtx_SET (Pmode, tmp, GEN_INT (sp_offset)));

      insn = emit_insn (gen_add3_insn (stack_pointer_rtx, stack_pointer_rtx,
				       tmp));
      if (!frame_pointer_needed)
	{
	  /* Attache a note indicating what just happened */
	  rtx note = gen_rtx_SET (Pmode, stack_pointer_rtx,
				  gen_rtx_PLUS (Pmode, stack_pointer_rtx,
						GEN_INT (sp_offset)));
	  REG_NOTES (insn) = alloc_EXPR_LIST (REG_FRAME_RELATED_EXPR,
					      note, REG_NOTES (insn));
	  RTX_FRAME_RELATED_P (insn) = 1;
	}
      if (current_function_limit_stack)
	emit_insn (gen_stack_overflow_detect_and_trap ());
    }

  /* Load the PIC register if needed.  */
  if (current_function_uses_pic_offset_table)
    nios2_load_pic_register ();

  /* If we are profiling, make sure no instructions are scheduled before
     the call to mcount.  */
  if (current_function_profile)
    emit_insn (gen_blockage ());
}

void
expand_epilogue (bool sibcall_p)
{
  rtx insn;
  int ix;
  HOST_WIDE_INT total_frame_size = compute_frame_size ();
  unsigned HOST_WIDE_INT save_mask;
  unsigned long func_type;
  int sp_adjust;
  int save_offset;
 
  if (!sibcall_p && nios2_can_use_return_insn ())
    {
      insn = emit_jump_insn (gen_return ());
      return;
    }

  func_type = nios2_current_func_type ();

  /* Naked functions don't have epilogues.  */
  if (IS_NAKED (func_type))
    {
      insn = emit_insn (gen_return_from_naked_epilogue ());
      return;
    }

  emit_insn (gen_blockage ());

  if (frame_pointer_needed)
    {
      /* Recover the stack pointer.  */
      emit_insn (gen_rtx_SET (Pmode, stack_pointer_rtx,
			      hard_frame_pointer_rtx));
      save_offset = 0;
      sp_adjust = total_frame_size - cfun->machine->frame.save_regs_offset;
    }
  else if (TOO_BIG_OFFSET (total_frame_size))
    {
      rtx tmp = gen_rtx_REG (Pmode, TEMP_REG_NUM);

      emit_insn
	(gen_rtx_SET
	 (Pmode, tmp, GEN_INT (cfun->machine->frame.save_regs_offset)));
      emit_insn (gen_add3_insn (stack_pointer_rtx, stack_pointer_rtx, tmp));
      save_offset = 0;
      sp_adjust = total_frame_size - cfun->machine->frame.save_regs_offset;
    }
  else
    {
      save_offset = cfun->machine->frame.save_regs_offset;
      sp_adjust = total_frame_size;
    }
  
  save_mask = cfun->machine->frame.save_mask;
  save_offset += cfun->machine->frame.save_reg_size;
  
  for (ix = 32; ix--;)
    if (save_mask & ((unsigned HOST_WIDE_INT)1 << ix))
      {
	save_offset -= 4;
	restore_reg (ix, save_offset);
      }

  if (sp_adjust)
    {
#if defined(TARGET_ARCH_NIOS2DPX) && (TARGET_ARCH_NIOS2DPX == 1)
      insn = emit_insn
        (gen_rtx_SET (Pmode, stack_pointer_rtx,
                      gen_rtx_PLUS (Pmode, stack_pointer_rtx,
                                    GEN_INT (sp_adjust))));
#else
      emit_insn (gen_add3_insn (stack_pointer_rtx, stack_pointer_rtx,
                                GEN_INT (sp_adjust)));
#endif
    }

  /* Add in the __builtin_eh_return stack adjustment.  */
  if (current_function_calls_eh_return)
    {
#if defined(TARGET_ARCH_NIOS2DPX) && (TARGET_ARCH_NIOS2DPX == 1)
      insn = emit_insn
        (gen_rtx_SET (Pmode, stack_pointer_rtx,
                      gen_rtx_PLUS (Pmode, stack_pointer_rtx,
                                    EH_RETURN_STACKADJ_RTX)));
#else
      emit_insn (gen_add3_insn (stack_pointer_rtx,
                                stack_pointer_rtx,
                                EH_RETURN_STACKADJ_RTX));
#endif

    }

  if (IS_TASK (func_type))    
        insn = emit_jump_insn
          (gen_return_from_task_epilogue ());  
  else if (!sibcall_p)
        insn = emit_jump_insn
          (gen_return_from_epilogue (gen_rtx_REG (Pmode, RA_REGNO)));
}

/* Implement RETURN_ADDR_RTX.  Note, we do not support moving
   back to a previous frame.  */
rtx
nios2_get_return_address (int count)
{
  if (count != 0)
    return const0_rtx;

  return get_hard_reg_initial_val (Pmode, RA_REGNO);
}

/* Emit code to change the current function's return address to
   ADDRESS.  SCRATCH is available as a scratch register, if needed.
   ADDRESS and SCRATCH are both word-mode GPRs.  */

void
nios2_set_return_address (rtx address, rtx scratch)
{
  compute_frame_size ();
  if ((cfun->machine->frame.save_mask >> RA_REGNO) & 1)
    {
      unsigned offset = cfun->machine->frame.save_reg_size - 4;
      rtx base;
      
      if (frame_pointer_needed)
	base = hard_frame_pointer_rtx;
      else
	{
	  base = stack_pointer_rtx;
	  offset += cfun->machine->frame.save_regs_offset;

	  if (TOO_BIG_OFFSET (offset))
	    {
	      emit_insn (gen_rtx_SET (Pmode, scratch, GEN_INT (offset)));
	      emit_insn (gen_add3_insn (scratch, scratch, base));
	      base = scratch;
	      offset = 0;
	    }
	}
      if (offset)
	base = gen_rtx_PLUS (Pmode, base, GEN_INT (offset));
      emit_insn (gen_rtx_SET (Pmode, gen_rtx_MEM (Pmode, base), address));
    }
  else
    emit_insn (gen_rtx_SET (Pmode, gen_rtx_REG (Pmode, RA_REGNO), address));
}

bool
nios2_function_ok_for_sibcall (tree a ATTRIBUTE_UNUSED, tree b ATTRIBUTE_UNUSED)
{
  unsigned int func_type;

  func_type = nios2_current_func_type();

  return !IS_NAKED (func_type) && !IS_TASK(func_type);
}





/* ----------------------- *
 * Profiling
 * ----------------------- */

void
function_profiler (FILE *file, int labelno ATTRIBUTE_UNUSED)
{
  fprintf (file, "\tmov\tr8, ra\n");
  if (flag_pic)
    {
      fprintf (file, "\tnextpc\tr2\n");
      fprintf (file, "\t1: movhi\tr3, %%hiadj(_GLOBAL_OFFSET_TABLE_ - 1b)\n");
      fprintf (file, "\taddi\tr3, r3, %%lo(_GLOBAL_OFFSET_TABLE_ - 1b)\n");
      fprintf (file, "\tadd\tr2, r2, r3\n");
      fprintf (file, "\tldw\tr2, %%call(_mcount)(r2)\n");
      fprintf (file, "\tcallr\tr2\n");
    }
  else
    fprintf (file, "\tcall\t_mcount\n");
  fprintf (file, "\tmov\tra, r8\n");
}


/***************************************
 * Stack Layout
 ***************************************/


void
dump_frame_size (FILE *file)
{
  fprintf (file, "\t%s Current Frame Info\n", ASM_COMMENT_START);

  fprintf (file, "\t%s total_size = %ld\n", ASM_COMMENT_START,
           cfun->machine->frame.total_size);
  fprintf (file, "\t%s var_size = %ld\n", ASM_COMMENT_START,
           cfun->machine->frame.var_size);
  fprintf (file, "\t%s args_size = %ld\n", ASM_COMMENT_START,
           cfun->machine->frame.args_size);
  fprintf (file, "\t%s save_reg_size = %d\n", ASM_COMMENT_START,
           cfun->machine->frame.save_reg_size);
  fprintf (file, "\t%s initialized = %d\n", ASM_COMMENT_START,
           cfun->machine->frame.initialized);
  fprintf (file, "\t%s save_regs_offset = %ld\n", ASM_COMMENT_START,
           cfun->machine->frame.save_regs_offset);
  fprintf (file, "\t%s current_function_is_leaf = %d\n", ASM_COMMENT_START,
           current_function_is_leaf);
  fprintf (file, "\t%s frame_pointer_needed = %d\n", ASM_COMMENT_START,
           frame_pointer_needed);
  fprintf (file, "\t%s pretend_args_size = %d\n", ASM_COMMENT_START,
           current_function_pretend_args_size);

}

/* Return true if RENOG should be saved in a prologue.  */

static bool
save_reg_p (unsigned regno)
{
  gcc_assert (GP_REGNO_P (regno));
  
  if (IS_TASK (nios2_current_func_type()))
    return false;

  if (regs_ever_live[regno] && !call_used_regs[regno])
    return true;

  if (regno == HARD_FRAME_POINTER_REGNUM && frame_pointer_needed)
    return true;

  if (regno == PIC_OFFSET_TABLE_REGNUM
      && current_function_uses_pic_offset_table)
    return true;

  if (regno == RA_REGNO && regs_ever_live[RA_REGNO])
    return true;

  return false;
}

/* Return the bytes needed to compute the frame pointer from the current
   stack pointer.  */

HOST_WIDE_INT
compute_frame_size (void)
{
  unsigned int regno;
  HOST_WIDE_INT var_size;       /* # of var. bytes allocated */
  HOST_WIDE_INT total_size;     /* # bytes that the entire frame takes up.  */
  HOST_WIDE_INT save_reg_size;  /* # bytes needed to store callee save regs.  */
  HOST_WIDE_INT out_args_size;  /* # bytes needed for outgoing args. */
  unsigned HOST_WIDE_INT save_mask = 0;

  if (cfun->machine->frame.initialized)
    return cfun->machine->frame.total_size;
  
  save_reg_size = 0;
  var_size = STACK_ALIGN (get_frame_size ());
  out_args_size = STACK_ALIGN (current_function_outgoing_args_size);

  total_size = var_size + out_args_size;

  /* Calculate space needed for gp registers.  */
  for (regno = 0; GP_REGNO_P (regno); regno++)
    if (save_reg_p (regno))
      {
	save_mask |= (unsigned HOST_WIDE_INT)1 << regno;
	save_reg_size += 4;
      }

  /* If we call eh_return, we need to save the EH data registers.  */
  if (current_function_calls_eh_return)
    {
      unsigned i;
      unsigned r;
      
      for (i = 0; (r = EH_RETURN_DATA_REGNO (i)) != INVALID_REGNUM; i++)
	if (!(save_mask & (1 << r)))
	  {
	    save_mask |= 1 << r;
	    save_reg_size += 4;
	  }
    }

  save_reg_size = STACK_ALIGN (save_reg_size);
  total_size += save_reg_size;

  total_size += STACK_ALIGN (current_function_pretend_args_size);

  /* Save other computed information.  */
  cfun->machine->frame.save_mask = save_mask;
  cfun->machine->frame.total_size = total_size;
  cfun->machine->frame.var_size = var_size;
  cfun->machine->frame.args_size = out_args_size;
  cfun->machine->frame.save_reg_size = save_reg_size;
  cfun->machine->frame.initialized = reload_completed;

  cfun->machine->frame.save_regs_offset = out_args_size + var_size;

  return total_size;
}


int
nios2_initial_elimination_offset (int from, int to)
{
  int offset;

  compute_frame_size ();

  /* Set OFFSET to the offset from the stack pointer.  */
  switch (from)
    {
    case FRAME_POINTER_REGNUM:
      offset = cfun->machine->frame.args_size;
      break;

    case ARG_POINTER_REGNUM:
      offset = cfun->machine->frame.total_size;
      offset -= current_function_pretend_args_size;
      break;

    default:
      gcc_unreachable ();
    }

    /* If we are asked for the frame pointer offset, then adjust OFFSET
       by the offset from the frame pointer to the stack pointer.  */
    if (to == HARD_FRAME_POINTER_REGNUM)
      offset -= cfun->machine->frame.save_regs_offset;

    return offset;
}

/* Return nonzero if this function is known to have a null epilogue.
   This allows the optimizer to omit jumps to jumps if no stack
   was created.  */
int
nios2_can_use_return_insn (void)
{
  unsigned int func_type;

  if (!reload_completed)
    return 0;

  func_type = nios2_current_func_type();

  if (IS_NAKED(func_type) || IS_TASK(func_type))
    return 0;

  if (regs_ever_live[RA_REGNO] || current_function_profile)
    return 0;

  if (cfun->machine->frame.initialized)
    return cfun->machine->frame.total_size == 0;

  return compute_frame_size () == 0;
}





/* Try to take a bit of tedium out of the __builtin_custom_<blah>
   builtin functions, too.  */

#define NIOS2_FOR_ALL_CUSTOM_BUILTINS \
  NIOS2_DO_BUILTIN (N,    n,    n    ) \
  NIOS2_DO_BUILTIN (NI,   ni,   nX   ) \
  NIOS2_DO_BUILTIN (NF,   nf,   nX   ) \
  NIOS2_DO_BUILTIN (NP,   np,   nX   ) \
  NIOS2_DO_BUILTIN (NII,  nii,  nXX  ) \
  NIOS2_DO_BUILTIN (NIF,  nif,  nXX  ) \
  NIOS2_DO_BUILTIN (NIP,  nip,  nXX  ) \
  NIOS2_DO_BUILTIN (NFI,  nfi,  nXX  ) \
  NIOS2_DO_BUILTIN (NFF,  nff,  nXX  ) \
  NIOS2_DO_BUILTIN (NFP,  nfp,  nXX  ) \
  NIOS2_DO_BUILTIN (NPI,  npi,  nXX  ) \
  NIOS2_DO_BUILTIN (NPF,  npf,  nXX  ) \
  NIOS2_DO_BUILTIN (NPP,  npp,  nXX  ) \
  NIOS2_DO_BUILTIN (IN,   in,   Xn   ) \
  NIOS2_DO_BUILTIN (INI,  ini,  XnX  ) \
  NIOS2_DO_BUILTIN (INF,  inf,  XnX  ) \
  NIOS2_DO_BUILTIN (INP,  inp,  XnX  ) \
  NIOS2_DO_BUILTIN (INII, inii, XnXX ) \
  NIOS2_DO_BUILTIN (INIF, inif, XnXX ) \
  NIOS2_DO_BUILTIN (INIP, inip, XnXX ) \
  NIOS2_DO_BUILTIN (INFI, infi, XnXX ) \
  NIOS2_DO_BUILTIN (INFF, inff, XnXX ) \
  NIOS2_DO_BUILTIN (INFP, infp, XnXX ) \
  NIOS2_DO_BUILTIN (INPI, inpi, XnXX ) \
  NIOS2_DO_BUILTIN (INPF, inpf, XnXX ) \
  NIOS2_DO_BUILTIN (INPP, inpp, XnXX ) \
  NIOS2_DO_BUILTIN (FN,   fn,   Xn   ) \
  NIOS2_DO_BUILTIN (FNI,  fni,  XnX  ) \
  NIOS2_DO_BUILTIN (FNF,  fnf,  XnX  ) \
  NIOS2_DO_BUILTIN (FNP,  fnp,  XnX  ) \
  NIOS2_DO_BUILTIN (FNII, fnii, XnXX ) \
  NIOS2_DO_BUILTIN (FNIF, fnif, XnXX ) \
  NIOS2_DO_BUILTIN (FNIP, fnip, XnXX ) \
  NIOS2_DO_BUILTIN (FNFI, fnfi, XnXX ) \
  NIOS2_DO_BUILTIN (FNFF, fnff, XnXX ) \
  NIOS2_DO_BUILTIN (FNFP, fnfp, XnXX ) \
  NIOS2_DO_BUILTIN (FNPI, fnpi, XnXX ) \
  NIOS2_DO_BUILTIN (FNPF, fnpf, XnXX ) \
  NIOS2_DO_BUILTIN (FNPP, fnpp, XnXX ) \
  NIOS2_DO_BUILTIN (PN,   pn,   Xn   ) \
  NIOS2_DO_BUILTIN (PNI,  pni,  XnX  ) \
  NIOS2_DO_BUILTIN (PNF,  pnf,  XnX  ) \
  NIOS2_DO_BUILTIN (PNP,  pnp,  XnX  ) \
  NIOS2_DO_BUILTIN (PNII, pnii, XnXX ) \
  NIOS2_DO_BUILTIN (PNIF, pnif, XnXX ) \
  NIOS2_DO_BUILTIN (PNIP, pnip, XnXX ) \
  NIOS2_DO_BUILTIN (PNFI, pnfi, XnXX ) \
  NIOS2_DO_BUILTIN (PNFF, pnff, XnXX ) \
  NIOS2_DO_BUILTIN (PNFP, pnfp, XnXX ) \
  NIOS2_DO_BUILTIN (PNPI, pnpi, XnXX ) \
  NIOS2_DO_BUILTIN (PNPF, pnpf, XnXX ) \
  NIOS2_DO_BUILTIN (PNPP, pnpp, XnXX )


/* const char *nios2_sys_nosys_string;    for -msys=nosys */
const char *nios2_sys_lib_string;    /* for -msys-lib= */
const char *nios2_sys_crt0_string;    /* for -msys-crt0= */


#undef NIOS2_FPU_INSN
#define NIOS2_FPU_INSN(opt, insn, args) \
static const char *NIOS2_CONCAT (nios2_output_fpu_insn_, insn) (rtx); \
static void NIOS2_CONCAT (nios2_pragma_, insn) (struct cpp_reader *); \
static void NIOS2_CONCAT (nios2_pragma_no_, insn) (struct cpp_reader *); \
int NIOS2_CONCAT (nios2_custom_, opt) = -1;
NIOS2_FOR_ALL_FPU_INSNS

nios2_fpu_info nios2_fpu_insns[nios2_fpu_max_insn] = {
#undef NIOS2_FPU_INSN
#define NIOS2_FPU_INSN(opt, insn, args) \
  { NIOS2_STRINGIFY (opt), \
    NIOS2_STRINGIFY (insn), \
    NIOS2_STRINGIFY (args), \
    -1, \
    NIOS2_CONCAT (nios2_output_fpu_insn_, insn), \
    "custom_" NIOS2_STRINGIFY (opt), \
    NIOS2_CONCAT (nios2_pragma_, insn), \
    "no_custom_" NIOS2_STRINGIFY (opt), \
    NIOS2_CONCAT (nios2_pragma_no_, insn), \
    0, \
    0, \
    0, \
    0, \
    0, \
    &NIOS2_CONCAT (nios2_custom_, opt) },
  NIOS2_FOR_ALL_FPU_INSNS
};

const char *nios2_custom_fpu_cfg_string;

static const char *builtin_custom_seen[256];

static void
nios2_custom_switch (int parameter, int *value, const char *opt)
{
  /* We only document values from 0-255, but we secretly allow -1 so
   * that the -mno-custom-<opt> switches work.  */
  if (parameter != -1)
    {
      if (parameter < -1 || parameter > 255)
        error ("switch `-mcustom-%s' value %d must be between 0 and 255",
               opt, parameter);
      *value = (int)parameter;
    }
}

static void
nios2_custom_check_insns (int is_pragma)
{
  int i;
  int has_double = 0;
  int errors = 0;
  const char *ns[256];
  int ps[256];

  for (i = 0; i < nios2_fpu_max_insn; i++)
    if (nios2_fpu_insns[i].is_double && nios2_fpu_insns[i].N >= 0)
      has_double = 1;

  if (has_double)
    {
      for (i = 0; i < nios2_fpu_max_insn; i++)
        {
          if (nios2_fpu_insns[i].needed_by_double
              && nios2_fpu_insns[i].N < 0)
            {
              if (is_pragma)
                error ("either switch `-mcustom-%s' or `#pragma custom_%s' is "
		       "required for double precision floating point",
                       nios2_fpu_insns[i].option,
                       nios2_fpu_insns[i].option);
              else
                error ("switch `-mcustom-%s' is required for double precision "
		       "floating point",
                       nios2_fpu_insns[i].option);
              errors = 1;
            }
        }
    }

  /* Warn if the user has certain exotic operations that won't get used
     without -funsafe-math-optimizations, See expand_builtin () in
     bulitins.c.  */
  if (!flag_unsafe_math_optimizations)
    {
      for (i = 0; i < nios2_fpu_max_insn; i++)
        {
          if (nios2_fpu_insns[i].needs_unsafe && nios2_fpu_insns[i].N >= 0)
            {
              warning (0, "%s%s' has no effect unless "
		       "-funsafe-math-optimizations is specified",
                       is_pragma ? "`#pragma custom_" : "switch `-mcustom-",
                       nios2_fpu_insns[i].option);
              /* Just one warning per function per compilation unit, please.  */
              nios2_fpu_insns[i].needs_unsafe = 0;
            }
        }
    }

  /* Warn if the user is trying to use -mcustom-fmins et. al, that won't
     get used without -ffinite-math-only.  See fold in fold () in
     fold-const.c.  */
  if (!flag_finite_math_only)
    {
      for (i = 0; i < nios2_fpu_max_insn; i++)
        {
          if (nios2_fpu_insns[i].needs_finite && nios2_fpu_insns[i].N >= 0)
            {
              warning (0, "%s%s' has no effect unless -ffinite-math-only "
		       "is specified",
                       is_pragma ? "`#pragma custom_" : "switch `-mcustom-",
                       nios2_fpu_insns[i].option);
              /* Just one warning per function per compilation unit, please.  */
              nios2_fpu_insns[i].needs_finite = 0;
            }
        }
    }

  /* Warn the user about double precision divide braindamage until we
     can fix it properly.  See the RDIV_EXPR case of expand_expr_real in
     expr.c.  */
  {
    static int warned = 0;
    if (flag_unsafe_math_optimizations
        && !optimize_size
        && nios2_fpu_insns[nios2_fpu_divdf3].N >= 0
        && !warned)
      {
        warning (0, "%s%s' behaves poorly without -Os",
                 is_pragma ? "`#pragma custom_" : "switch `-mcustom-",
                 nios2_fpu_insns[nios2_fpu_divdf3].option);
        warned = 1;
      }
  }

  /* The following bit of voodoo is lifted from the generated file
     insn-opinit.c: to allow #pragmas to work properly, we have to tweak
     the optab_table manually -- it only gets initialized once after the
     switches are handled and before any #pragmas are seen.  */
  if (is_pragma)
    {
      /* Only do this if the optabs have already been defined, not
         when we're handling command line switches.  */
      addv_optab->handlers[SFmode].insn_code =
      add_optab->handlers[SFmode].insn_code = CODE_FOR_nothing;
      addv_optab->handlers[DFmode].insn_code =
      add_optab->handlers[DFmode].insn_code = CODE_FOR_nothing;
      subv_optab->handlers[SFmode].insn_code =
      sub_optab->handlers[SFmode].insn_code = CODE_FOR_nothing;
      subv_optab->handlers[DFmode].insn_code =
      sub_optab->handlers[DFmode].insn_code = CODE_FOR_nothing;
      smulv_optab->handlers[SFmode].insn_code =
      smul_optab->handlers[SFmode].insn_code = CODE_FOR_nothing;
      smulv_optab->handlers[DFmode].insn_code =
      smul_optab->handlers[DFmode].insn_code = CODE_FOR_nothing;
      sdiv_optab->handlers[SFmode].insn_code = CODE_FOR_nothing;
      sdiv_optab->handlers[DFmode].insn_code = CODE_FOR_nothing;
      negv_optab->handlers[SFmode].insn_code =
      neg_optab->handlers[SFmode].insn_code = CODE_FOR_nothing;
      negv_optab->handlers[DFmode].insn_code =
      neg_optab->handlers[DFmode].insn_code = CODE_FOR_nothing;
      smin_optab->handlers[SFmode].insn_code = CODE_FOR_nothing;
      smin_optab->handlers[DFmode].insn_code = CODE_FOR_nothing;
      smax_optab->handlers[SFmode].insn_code = CODE_FOR_nothing;
      smax_optab->handlers[DFmode].insn_code = CODE_FOR_nothing;
      absv_optab->handlers[SFmode].insn_code =
      abs_optab->handlers[SFmode].insn_code = CODE_FOR_nothing;
      absv_optab->handlers[DFmode].insn_code =
      abs_optab->handlers[DFmode].insn_code = CODE_FOR_nothing;
      sqrt_optab->handlers[SFmode].insn_code = CODE_FOR_nothing;
      sqrt_optab->handlers[DFmode].insn_code = CODE_FOR_nothing;
      cos_optab->handlers[SFmode].insn_code = CODE_FOR_nothing;
      cos_optab->handlers[DFmode].insn_code = CODE_FOR_nothing;
      sin_optab->handlers[SFmode].insn_code = CODE_FOR_nothing;
      sin_optab->handlers[DFmode].insn_code = CODE_FOR_nothing;
      tan_optab->handlers[SFmode].insn_code = CODE_FOR_nothing;
      tan_optab->handlers[DFmode].insn_code = CODE_FOR_nothing;
      atan_optab->handlers[SFmode].insn_code = CODE_FOR_nothing;
      atan_optab->handlers[DFmode].insn_code = CODE_FOR_nothing;
      exp_optab->handlers[SFmode].insn_code = CODE_FOR_nothing;
      exp_optab->handlers[DFmode].insn_code = CODE_FOR_nothing;
      log_optab->handlers[SFmode].insn_code = CODE_FOR_nothing;
      log_optab->handlers[DFmode].insn_code = CODE_FOR_nothing;
      sfloat_optab->handlers[SFmode][SImode].insn_code = CODE_FOR_nothing;
      sfloat_optab->handlers[DFmode][SImode].insn_code = CODE_FOR_nothing;
      ufloat_optab->handlers[SFmode][SImode].insn_code = CODE_FOR_nothing;
      ufloat_optab->handlers[DFmode][SImode].insn_code = CODE_FOR_nothing;
      sfix_optab->handlers[SImode][SFmode].insn_code = CODE_FOR_nothing;
      sfix_optab->handlers[SImode][DFmode].insn_code = CODE_FOR_nothing;
      ufix_optab->handlers[SImode][SFmode].insn_code = CODE_FOR_nothing;
      ufix_optab->handlers[SImode][DFmode].insn_code = CODE_FOR_nothing;
      sext_optab->handlers[DFmode][SFmode].insn_code = CODE_FOR_nothing;
      trunc_optab->handlers[SFmode][DFmode].insn_code = CODE_FOR_nothing;
      cmp_optab->handlers[SFmode].insn_code = CODE_FOR_nothing;
      cmp_optab->handlers[DFmode].insn_code = CODE_FOR_nothing;

      if (HAVE_addsf3)
        addv_optab->handlers[SFmode].insn_code =
        add_optab->handlers[SFmode].insn_code = CODE_FOR_addsf3;
      if (HAVE_adddf3)
        addv_optab->handlers[DFmode].insn_code =
        add_optab->handlers[DFmode].insn_code = CODE_FOR_adddf3;
      if (HAVE_subsf3)
        subv_optab->handlers[SFmode].insn_code =
        sub_optab->handlers[SFmode].insn_code = CODE_FOR_subsf3;
      if (HAVE_subdf3)
        subv_optab->handlers[DFmode].insn_code =
        sub_optab->handlers[DFmode].insn_code = CODE_FOR_subdf3;
      if (HAVE_mulsf3)
        smulv_optab->handlers[SFmode].insn_code =
        smul_optab->handlers[SFmode].insn_code = CODE_FOR_mulsf3;
      if (HAVE_muldf3)
        smulv_optab->handlers[DFmode].insn_code =
        smul_optab->handlers[DFmode].insn_code = CODE_FOR_muldf3;
      if (HAVE_divsf3)
        sdiv_optab->handlers[SFmode].insn_code = CODE_FOR_divsf3;
      if (HAVE_divdf3)
        sdiv_optab->handlers[DFmode].insn_code = CODE_FOR_divdf3;
      if (HAVE_negsf2)
        negv_optab->handlers[SFmode].insn_code =
        neg_optab->handlers[SFmode].insn_code = CODE_FOR_negsf2;
      if (HAVE_negdf2)
        negv_optab->handlers[DFmode].insn_code =
        neg_optab->handlers[DFmode].insn_code = CODE_FOR_negdf2;
      if (HAVE_minsf3)
        smin_optab->handlers[SFmode].insn_code = CODE_FOR_minsf3;
      if (HAVE_mindf3)
        smin_optab->handlers[DFmode].insn_code = CODE_FOR_mindf3;
      if (HAVE_maxsf3)
        smax_optab->handlers[SFmode].insn_code = CODE_FOR_maxsf3;
      if (HAVE_maxdf3)
        smax_optab->handlers[DFmode].insn_code = CODE_FOR_maxdf3;
      if (HAVE_abssf2)
        absv_optab->handlers[SFmode].insn_code =
        abs_optab->handlers[SFmode].insn_code = CODE_FOR_abssf2;
      if (HAVE_absdf2)
        absv_optab->handlers[DFmode].insn_code =
        abs_optab->handlers[DFmode].insn_code = CODE_FOR_absdf2;
      if (HAVE_sqrtsf2)
        sqrt_optab->handlers[SFmode].insn_code = CODE_FOR_sqrtsf2;
      if (HAVE_sqrtdf2)
        sqrt_optab->handlers[DFmode].insn_code = CODE_FOR_sqrtdf2;
      if (HAVE_cossf2)
        cos_optab->handlers[SFmode].insn_code = CODE_FOR_cossf2;
      if (HAVE_cosdf2)
        cos_optab->handlers[DFmode].insn_code = CODE_FOR_cosdf2;
      if (HAVE_sinsf2)
        sin_optab->handlers[SFmode].insn_code = CODE_FOR_sinsf2;
      if (HAVE_sindf2)
        sin_optab->handlers[DFmode].insn_code = CODE_FOR_sindf2;
      if (HAVE_tansf2)
        tan_optab->handlers[SFmode].insn_code = CODE_FOR_tansf2;
      if (HAVE_tandf2)
        tan_optab->handlers[DFmode].insn_code = CODE_FOR_tandf2;
      if (HAVE_atansf2)
        atan_optab->handlers[SFmode].insn_code = CODE_FOR_atansf2;
      if (HAVE_atandf2)
        atan_optab->handlers[DFmode].insn_code = CODE_FOR_atandf2;
      if (HAVE_expsf2)
        exp_optab->handlers[SFmode].insn_code = CODE_FOR_expsf2;
      if (HAVE_expdf2)
        exp_optab->handlers[DFmode].insn_code = CODE_FOR_expdf2;
      if (HAVE_logsf2)
        log_optab->handlers[SFmode].insn_code = CODE_FOR_logsf2;
      if (HAVE_logdf2)
        log_optab->handlers[DFmode].insn_code = CODE_FOR_logdf2;
      if (HAVE_floatsisf2)
        sfloat_optab->handlers[SFmode][SImode].insn_code = CODE_FOR_floatsisf2;
      if (HAVE_floatsidf2)
        sfloat_optab->handlers[DFmode][SImode].insn_code = CODE_FOR_floatsidf2;
      if (HAVE_floatunssisf2)
        ufloat_optab->handlers[SFmode][SImode].insn_code = CODE_FOR_floatunssisf2;
      if (HAVE_floatunssidf2)
        ufloat_optab->handlers[DFmode][SImode].insn_code = CODE_FOR_floatunssidf2;
      if (HAVE_fixsfsi2)
        sfix_optab->handlers[SImode][SFmode].insn_code = CODE_FOR_fixsfsi2;
      if (HAVE_fixdfsi2)
        sfix_optab->handlers[SImode][DFmode].insn_code = CODE_FOR_fixdfsi2;
      if (HAVE_fixunssfsi2)
        ufix_optab->handlers[SImode][SFmode].insn_code = CODE_FOR_fixunssfsi2;
      if (HAVE_fixunsdfsi2)
        ufix_optab->handlers[SImode][DFmode].insn_code = CODE_FOR_fixunsdfsi2;
      if (HAVE_extendsfdf2)
        sext_optab->handlers[DFmode][SFmode].insn_code = CODE_FOR_extendsfdf2;
      if (HAVE_truncdfsf2)
        trunc_optab->handlers[SFmode][DFmode].insn_code = CODE_FOR_truncdfsf2;
      if (HAVE_cmpsf)
        cmp_optab->handlers[SFmode].insn_code = CODE_FOR_cmpsf;
      if (HAVE_cmpdf)
        cmp_optab->handlers[DFmode].insn_code = CODE_FOR_cmpdf;
    }

  /* Check for duplicate values of N.  */
  for (i = 0; i < 256; i++)
    {
      ns[i] = 0;
      ps[i] = 0;
    }

  for (i = 0; i < nios2_fpu_max_insn; i++)
    {
      int N = nios2_fpu_insns[i].N;
      if (N >= 0)
        {
          if (ns[N])
            {
              error ("%s%s' conflicts with %s%s'",
                     is_pragma ? "`#pragma custom_" : "switch `-mcustom-",
                     nios2_fpu_insns[i].option,
                     ps[N] ? "`#pragma custom_" : "switch `-mcustom-",
                     ns[N]);
              errors = 1;
            }
          else if (builtin_custom_seen[N])
            {
              error ("call to `%s' conflicts with %s%s'",
                     builtin_custom_seen[N],
                     (nios2_fpu_insns[i].pragma_seen
                      ? "`#pragma custom_" : "switch `-mcustom-"),
                     nios2_fpu_insns[i].option);
              errors = 1;
            }
          else
            {
              ns[N] = nios2_fpu_insns[i].option;
              ps[N] = nios2_fpu_insns[i].pragma_seen;
            }
        }
    }

  if (errors)
    fatal_error ("conflicting use of -mcustom switches, #pragmas, and/or "
		 "__builtin_custom_ functions");
}

static void
nios2_handle_custom_fpu_cfg (const char *cfg, int is_pragma)
{
#undef NIOS2_FPU_INSN
#define NIOS2_FPU_INSN(opt, insn, args) \
  int opt = nios2_fpu_insns[NIOS2_CONCAT (nios2_fpu_, insn)].N;
NIOS2_FOR_ALL_FPU_INSNS

  /*
   * ??? These are just some sample possibilities.  We'll change these
   * at the last minute to match the capabilities of the actual fpu.
   */
  if (!strcasecmp (cfg, "60-1"))
    {
      fmuls = 252;
      fadds = 253;
      fsubs = 254;
      flag_single_precision_constant = 1;
    }
  else if (!strcasecmp (cfg, "60-2"))
    {
      fmuls = 252;
      fadds = 253;
      fsubs = 254;
      fdivs = 255;
      flag_single_precision_constant = 1;
    }
  else if (!strcasecmp (cfg, "72-3"))
    {
      floatus = 243;
      fixsi   = 244;
      floatis = 245;
      fcmpgts = 246;
      fcmples = 249;
      fcmpeqs = 250;
      fcmpnes = 251;
      fmuls   = 252;
      fadds   = 253;
      fsubs   = 254;
      fdivs   = 255;
      flag_single_precision_constant = 1;
    }
  else
    warning (0, "ignoring unrecognized %sfpu-cfg' value `%s'",
             is_pragma ? "`#pragma custom_" : "switch -mcustom-", cfg);

#undef NIOS2_FPU_INSN
#define NIOS2_FPU_INSN(opt, insn, args) \
  nios2_fpu_insns[NIOS2_CONCAT (nios2_fpu_, insn)].N = opt;
NIOS2_FOR_ALL_FPU_INSNS

  /* Guard against errors in the standard configurations.  */
  nios2_custom_check_insns (is_pragma);
}

void
override_options (void)
{
  int i;

  /* Function to allocate machine-dependent function status.  */
  init_machine_status = &nios2_init_machine_status;

  nios2_section_threshold
    = g_switch_set ? g_switch_value : NIOS2_DEFAULT_GVALUE;


  /* #if !defined(TARGET_LINUX)  
     if (nios2_sys_nosys_string && *nios2_sys_nosys_string)
     {
     error ("invalid option '-msys=nosys%s'", nios2_sys_nosys_string);
     }
     #endif */


  /* If we don't have mul, we don't have mulx either!  */
  if (!TARGET_HAS_MUL && TARGET_HAS_MULX)
    target_flags &= ~MASK_HAS_MULX;

  /* Set up for stack limit checking.  */
  if (TARGET_STACK_CHECK)
    stack_limit_rtx = gen_rtx_REG(SImode, ET_REGNO);

  for (i = 0; i < nios2_fpu_max_insn; i++)
    {
      nios2_fpu_insns[i].is_double = (nios2_fpu_insns[i].args[0] == 'd'
                                      || nios2_fpu_insns[i].args[1] == 'd'
                                      || nios2_fpu_insns[i].args[2] == 'd');
      nios2_fpu_insns[i].needed_by_double = (i == nios2_fpu_nios2_fwrx
                                             || i == nios2_fpu_nios2_fwry
                                             || i == nios2_fpu_nios2_frdxlo
                                             || i == nios2_fpu_nios2_frdxhi
                                             || i == nios2_fpu_nios2_frdy);
      nios2_fpu_insns[i].needs_unsafe = (i == nios2_fpu_cossf2
                                         || i == nios2_fpu_cosdf2
                                         || i == nios2_fpu_sinsf2
                                         || i == nios2_fpu_sindf2
                                         || i == nios2_fpu_tansf2
                                         || i == nios2_fpu_tandf2
                                         || i == nios2_fpu_atansf2
                                         || i == nios2_fpu_atandf2
                                         || i == nios2_fpu_expsf2
                                         || i == nios2_fpu_expdf2
                                         || i == nios2_fpu_logsf2
                                         || i == nios2_fpu_logdf2);
      nios2_fpu_insns[i].needs_finite = (i == nios2_fpu_minsf3
                                         || i == nios2_fpu_maxsf3
                                         || i == nios2_fpu_mindf3
                                         || i == nios2_fpu_maxdf3);
    }

  /* We haven't seen any __builtin_custom functions yet.  */
  for (i = 0; i < 256; i++)
    builtin_custom_seen[i] = 0;

  /* Set up default handling for floating point custom instructions.
    
     Putting things in this order means that the -mcustom-fpu-cfg=
     switch will always be overridden by individual -mcustom-fadds=
     switches, regardless of the order in which they were specified
     on the command line.  ??? Remember to document this.  */
  if (nios2_custom_fpu_cfg_string && *nios2_custom_fpu_cfg_string)
    nios2_handle_custom_fpu_cfg (nios2_custom_fpu_cfg_string, 0);

  for (i = 0; i < nios2_fpu_max_insn; i++)
    nios2_custom_switch (*nios2_fpu_insns[i].pN,
                         &nios2_fpu_insns[i].N,
                         nios2_fpu_insns[i].option);

  nios2_custom_check_insns (0);
}

void
optimization_options (int level, int size)
{
  if (level || size)
    target_flags |= MASK_INLINE_MEMCPY;

  if (level >= 3 && !size)
    target_flags |= MASK_FAST_SW_DIV;
}

/* Allocate a chunk of memory for per-function machine-dependent data.  */
static struct machine_function *
nios2_init_machine_status (void)
{
  return ((struct machine_function *)
          ggc_alloc_cleared (sizeof (struct machine_function)));
}



/*****************
 * Describing Relative Costs of Operations
 *****************/

/* Compute a (partial) cost for rtx X.  Return true if the complete
   cost has been computed, and false if subexpressions should be
   scanned.  In either case, *TOTAL contains the cost result.  */



static bool
nios2_rtx_costs (rtx x, int code, int outer_code ATTRIBUTE_UNUSED, int *total)
{
  switch (code)
    {
      case CONST_INT:
        if (INTVAL (x) == 0)
          {
            *total = COSTS_N_INSNS (0);
            return true;
          }

#if defined(TARGET_ARCH_NIOS2DPX) && (TARGET_ARCH_NIOS2DPX == 1)
        else if (SMALL12_INT (INTVAL (x))
                || SMALL12_INT_UNSIGNED (INTVAL (x))
                || UPPER20_INT (INTVAL (x)))
          {
            *total = COSTS_N_INSNS (2);
            return true;
          }
#endif
        else if (SMALL_INT (INTVAL (x))
                || SMALL_INT_UNSIGNED (INTVAL (x))
                || UPPER16_INT (INTVAL (x)))
          {
            *total = COSTS_N_INSNS (2);
            return true;
          }
        else
          {
            *total = COSTS_N_INSNS (4);
            return true;
          }

      case LABEL_REF:
      case SYMBOL_REF:
        /* ??? gp relative stuff will fit in here.  */
        /* fall through */
      case CONST:
      case CONST_DOUBLE:
        {
          *total = COSTS_N_INSNS (4);
          return true;
        }

      case MULT:
        {
          *total = COSTS_N_INSNS (1);
          return false;
        }
      case SIGN_EXTEND:
        {
          *total = COSTS_N_INSNS (3);
          return false;
        }
      case ZERO_EXTEND:
        {
          *total = COSTS_N_INSNS (1);
          return false;
        }

      default:
        return false;
    }
}


/***************************************
 * INSTRUCTION SUPPORT
 *
 * These functions are used within the Machine Description to
 * handle common or complicated output and expansions from
 * instructions.
 ***************************************/

/* Return TRUE if X references a SYMBOL_REF.  */
static int
symbol_mentioned_p (rtx x)
{
  const char * fmt;
  int i;

  if (GET_CODE (x) == SYMBOL_REF)
    return 1;

  /* UNSPEC_TLS entries for a symbol include the SYMBOL_REF, but they
     are constant offsets, not symbols.  */
  if (GET_CODE (x) == UNSPEC && IS_UNSPEC_TLS (XINT (x, 1)))
    return 0;

  fmt = GET_RTX_FORMAT (GET_CODE (x));

  for (i = GET_RTX_LENGTH (GET_CODE (x)) - 1; i >= 0; i--)
    {
      if (fmt[i] == 'E')
        {
          int j;

          for (j = XVECLEN (x, i) - 1; j >= 0; j--)
            if (symbol_mentioned_p (XVECEXP (x, i, j)))
              return 1;
        }
      else if (fmt[i] == 'e' && symbol_mentioned_p (XEXP (x, i)))
        return 1;
    }

  return 0;
}

/* Return TRUE if X references a LABEL_REF.  */
static int
label_mentioned_p (rtx x)
{
  const char * fmt;
  int i;

  if (GET_CODE (x) == LABEL_REF)
    return 1;

  /* UNSPEC_TLS entries for a symbol include a LABEL_REF for the referencing
     instruction, but they are constant offsets, not symbols.  */
  if (GET_CODE (x) == UNSPEC && IS_UNSPEC_TLS (XINT (x, 1)))
    return 0;

  fmt = GET_RTX_FORMAT (GET_CODE (x));
  for (i = GET_RTX_LENGTH (GET_CODE (x)) - 1; i >= 0; i--)
    {
      if (fmt[i] == 'E')
        {
          int j;

          for (j = XVECLEN (x, i) - 1; j >= 0; j--)
            if (label_mentioned_p (XVECEXP (x, i, j)))
              return 1;
        }
      else if (fmt[i] == 'e' && label_mentioned_p (XEXP (x, i)))
        return 1;
    }

  return 0;
}

static int
tls_mentioned_p (rtx x)
{
  switch (GET_CODE (x))
    {
    case CONST:
      return tls_mentioned_p (XEXP (x, 0));

    case UNSPEC:
      if (IS_UNSPEC_TLS (XINT (x, 1)))
        return 1;

    default:
      return 0;
    }
}

/* Helper for nios2_tls_referenced_p.  */

static int
nios2_tls_operand_p_1 (rtx *x, void *data ATTRIBUTE_UNUSED)
{
  if (GET_CODE (*x) == SYMBOL_REF)
    return SYMBOL_REF_TLS_MODEL (*x) != 0;

  /* Don't recurse into UNSPEC_TLS looking for TLS symbols; these are
     TLS offsets, not real symbol references.  */
  if (GET_CODE (*x) == UNSPEC
      && IS_UNSPEC_TLS (XINT (*x, 1)))
    return -1;

  return 0;
}

/* Return TRUE if X contains any TLS symbol references.  */

static bool
nios2_tls_referenced_p (rtx x)
{
  if (! TARGET_HAVE_TLS)
    return false;

  return for_each_rtx (&x, nios2_tls_operand_p_1, NULL);
}

static bool
nios2_cannot_force_const_mem (rtx x)
{
  return nios2_tls_referenced_p (x);
}

/* Emit a call to __tls_get_addr.  TI is the argument to this function.  RET is
   an RTX for the return value location.  The entire insn sequence is
   returned.  */

static GTY(()) rtx nios2_tls_symbol;

static rtx
nios2_call_tls_get_addr (rtx ti)
{
  rtx arg = gen_rtx_REG (Pmode, FIRST_ARG_REGNO);
  rtx ret = gen_rtx_REG (Pmode, FIRST_RETVAL_REGNO);
  rtx fn, insn;
  
  if (!nios2_tls_symbol)
    nios2_tls_symbol = init_one_libfunc ("__tls_get_addr");

  emit_insn (gen_rtx_SET (Pmode, arg, ti));
  fn = gen_rtx_MEM (QImode, nios2_tls_symbol);
  insn = emit_call_insn (gen_call_value (ret, fn, const0_rtx));
  CONST_OR_PURE_CALL_P (insn) = 1;
  use_reg (&CALL_INSN_FUNCTION_USAGE (insn), ret);
  use_reg (&CALL_INSN_FUNCTION_USAGE (insn), arg);

  return ret;
}

/* Generate the code to access LOC, a thread local SYMBOL_REF.  The
   return value will be a valid address and move_operand (either a REG
   or a LO_SUM).  */

static rtx
nios2_legitimize_tls_address (rtx loc)
{
  rtx dest = gen_reg_rtx (Pmode);
  rtx ret, tmp1;
  enum tls_model model = SYMBOL_REF_TLS_MODEL (loc);

  switch (model)
    {
    case TLS_MODEL_GLOBAL_DYNAMIC:
      tmp1 = gen_reg_rtx (Pmode);
      emit_insn (gen_add_tls_gd (tmp1, pic_offset_table_rtx, loc));
      current_function_uses_pic_offset_table = 1;
      ret = nios2_call_tls_get_addr (tmp1);
      emit_insn (gen_rtx_SET (Pmode, dest, ret));
      break;

    case TLS_MODEL_LOCAL_DYNAMIC:
      tmp1 = gen_reg_rtx (Pmode);
      emit_insn (gen_add_tls_ldm (tmp1, pic_offset_table_rtx, loc));
      current_function_uses_pic_offset_table = 1;
      ret = nios2_call_tls_get_addr (tmp1);

      emit_insn (gen_add_tls_ldo (dest, ret, loc));

      break;

    case TLS_MODEL_INITIAL_EXEC:
      tmp1 = gen_reg_rtx (Pmode);
      emit_insn (gen_load_tls_ie (tmp1, pic_offset_table_rtx, loc));
      current_function_uses_pic_offset_table = 1;
      emit_insn (gen_add3_insn (dest,
				gen_rtx_REG (Pmode, THREAD_POINTER_REGNUM),
				tmp1));
      break;

    case TLS_MODEL_LOCAL_EXEC:
      emit_insn (gen_add_tls_le (dest,
				 gen_rtx_REG (Pmode, THREAD_POINTER_REGNUM),
				 loc));
      break;

    default:
      gcc_unreachable ();
    }

  return dest;
}

int
nios2_emit_move_sequence (rtx *operands, enum machine_mode mode)
{
  rtx to = operands[0];
  rtx from = operands[1];

  if (!register_operand (to, mode) && !reg_or_0_operand (from, mode))
    {
      if (no_new_pseudos)
        internal_error ("Trying to force_reg no_new_pseudos == 1");
      from = copy_to_mode_reg (mode, from);
    }

  /* Recognize the case where from is a reference to thread-local
     data and load its address to a register.  */
  if (nios2_tls_referenced_p (from))
    {
      rtx tmp = from;
      rtx addend = NULL;

      if (GET_CODE (tmp) == CONST && GET_CODE (XEXP (tmp, 0)) == PLUS)
        {
          addend = XEXP (XEXP (tmp, 0), 1);
          tmp = XEXP (XEXP (tmp, 0), 0);
        }

      gcc_assert (GET_CODE (tmp) == SYMBOL_REF);
      gcc_assert (SYMBOL_REF_TLS_MODEL (tmp) != 0);

      tmp = nios2_legitimize_tls_address (tmp);
      if (addend)
	{
          tmp = gen_rtx_PLUS (SImode, tmp, addend);
          tmp = force_operand (tmp, to);
        }
      from = tmp;
    }
  else if (flag_pic && (CONSTANT_P (from) || symbol_mentioned_p (from) ||
			label_mentioned_p (from)))
    from = nios2_legitimize_pic_address (from, SImode,
					 (no_new_pseudos ? to : 0));

  operands[0] = to;
  operands[1] = from;
  return 0;
}

/* Divide Support */

/*
  If -O3 is used, we want to output a table lookup for
  divides between small numbers (both num and den >= 0
  and < 0x10).  The overhead of this method in the worse
  case is 40 bytes in the text section (10 insns) and
  256 bytes in the data section.  Additional divides do
  not incur additional penalties in the data section.

  Code speed is improved for small divides by about 5x
  when using this method in the worse case (~9 cycles
  vs ~45).  And in the worse case divides not within the
  table are penalized by about 10% (~5 cycles vs ~45).
  However in the typical case the penalty is not as bad
  because doing the long divide in only 45 cycles is
  quite optimistic.

  ??? It would be nice to have some benchmarks other
  than Dhrystone to back this up.

  This bit of expansion is to create this instruction
  sequence as rtl.
        or      $8, $4, $5
        slli    $9, $4, 4
        cmpgeui $3, $8, 16
        beq     $3, $0, .L3
        or      $10, $9, $5
        add     $12, $11, divide_table
        ldbu    $2, 0($12)
        br      .L1
.L3:
        call    slow_div
.L1:
#       continue here with result in $2

  ??? Ideally I would like the emit libcall block to contain
  all of this code, but I don't know how to do that.  What it
  means is that if the divide can be eliminated, it may not
  completely disappear.

  ??? The __divsi3_table label should ideally be moved out
  of this block and into a global.  If it is placed into the
  sdata section we can save even more cycles by doing things
  gp relative.
*/
int
nios2_emit_expensive_div (rtx *operands, enum machine_mode mode)
{
  rtx or_result, shift_left_result;
  rtx lookup_value;
  rtx lab1, lab3;
  rtx insns;
  rtx libfunc;
  rtx final_result;
  rtx tmp;

  /* It may look a little generic, but only SImode
     is supported for now.  */
  gcc_assert (mode == SImode);

  libfunc = sdiv_optab->handlers[(int) SImode].libfunc;



  lab1 = gen_label_rtx ();
  lab3 = gen_label_rtx ();

  or_result = expand_simple_binop (SImode, IOR,
                                   operands[1], operands[2],
                                   0, 0, OPTAB_LIB_WIDEN);

  emit_cmp_and_jump_insns (or_result, GEN_INT (15), GTU, 0,
                           GET_MODE (or_result), 0, lab3);
  JUMP_LABEL (get_last_insn ()) = lab3;

  shift_left_result = expand_simple_binop (SImode, ASHIFT,
                                           operands[1], GEN_INT (4),
                                           0, 0, OPTAB_LIB_WIDEN);

  lookup_value = expand_simple_binop (SImode, IOR,
                                      shift_left_result, operands[2],
                                      0, 0, OPTAB_LIB_WIDEN);

  convert_move (operands[0],
    gen_rtx_MEM (QImode,
      gen_rtx_PLUS (SImode,
        lookup_value,
        gen_rtx_SYMBOL_REF (SImode, "__divsi3_table"))),
    1);


  tmp = emit_jump_insn (gen_jump (lab1));
  JUMP_LABEL (tmp) = lab1;
  emit_barrier ();

  emit_label (lab3);
  LABEL_NUSES (lab3) = 1;

  start_sequence ();
  final_result = emit_library_call_value (libfunc, NULL_RTX,
                                          LCT_CONST, SImode, 2,
                                          operands[1], SImode,
                                          operands[2], SImode);


  insns = get_insns ();
  end_sequence ();
  emit_libcall_block (insns, operands[0], final_result,
                      gen_rtx_DIV (SImode, operands[1], operands[2]));

  emit_label (lab1);
  LABEL_NUSES (lab1) = 1;
  return 1;
}

/* The function with address *ADDR is being called.  If the address
   needs to be loaded from the GOT, emit the instruction to do so and
   update *ADDR to point to the rtx for the loaded value.  */

void
nios2_adjust_call_address (rtx *addr)
{
  if (flag_pic
      && (GET_CODE (*addr) == SYMBOL_REF || GET_CODE (*addr) == LABEL_REF))
    {
      rtx addr_orig;
      current_function_uses_pic_offset_table = 1;
      addr_orig = *addr;
      *addr = gen_reg_rtx (GET_MODE (addr_orig));
      emit_insn (gen_pic_load_call_addr (*addr,
					 pic_offset_table_rtx, addr_orig));
    }
}

/* Branches/Compares.  */

/* The way of handling branches/compares
   in gcc is heavily borrowed from MIPS.  */

enum internal_test
{
  ITEST_EQ = 0,
  ITEST_NE,
  ITEST_GT,
  ITEST_GE,
  ITEST_LT,
  ITEST_LE,
  ITEST_GTU,
  ITEST_GEU,
  ITEST_LTU,
  ITEST_LEU,
  ITEST_MAX
};

static enum internal_test map_test_to_internal_test (enum rtx_code);

/* Cached operands, and operator to compare for use in set/branch/trap
   on condition codes.  */
rtx branch_cmp[2];
enum cmp_type branch_type;

/* Make normal rtx_code into something we can index from an array.  */

static enum internal_test
map_test_to_internal_test (enum rtx_code test_code)
{
  enum internal_test test = ITEST_MAX;

  switch (test_code)
    {
    case EQ:
      test = ITEST_EQ;
      break;
    case NE:
      test = ITEST_NE;
      break;
    case GT:
      test = ITEST_GT;
      break;
    case GE:
      test = ITEST_GE;
      break;
    case LT:
      test = ITEST_LT;
      break;
    case LE:
      test = ITEST_LE;
      break;
    case GTU:
      test = ITEST_GTU;
      break;
    case GEU:
      test = ITEST_GEU;
      break;
    case LTU:
      test = ITEST_LTU;
      break;
    case LEU:
      test = ITEST_LEU;
      break;
    default:
      break;
    }

  return test;
}

bool have_nios2_fpu_cmp_insn( enum rtx_code cond_t, enum cmp_type cmp_t );
enum rtx_code get_reverse_cond(enum rtx_code cond_t);

bool
have_nios2_fpu_cmp_insn( enum rtx_code cond_t, enum cmp_type cmp_t )
{
  if (cmp_t == CMP_SF)
    {
      switch (cond_t) 
	{
        case EQ:
          return (nios2_fpu_insns[nios2_fpu_nios2_seqsf].N >= 0);
        case NE:
          return (nios2_fpu_insns[nios2_fpu_nios2_snesf].N >= 0);
        case GT:
          return (nios2_fpu_insns[nios2_fpu_nios2_sgtsf].N >= 0);
        case GE:
          return (nios2_fpu_insns[nios2_fpu_nios2_sgesf].N >= 0);
        case LT:
          return (nios2_fpu_insns[nios2_fpu_nios2_sltsf].N >= 0);
        case LE:
          return (nios2_fpu_insns[nios2_fpu_nios2_slesf].N >= 0);
        default:
          break;
        }
    }
  else if (cmp_t == CMP_DF)
    {
      switch (cond_t) 
	{
	case EQ:
	  return (nios2_fpu_insns[nios2_fpu_nios2_seqdf].N >= 0);
	case NE:
	  return (nios2_fpu_insns[nios2_fpu_nios2_snedf].N >= 0);
	case GT:
	  return (nios2_fpu_insns[nios2_fpu_nios2_sgtdf].N >= 0);
	case GE:
	  return (nios2_fpu_insns[nios2_fpu_nios2_sgedf].N >= 0);
	case LT:
	  return (nios2_fpu_insns[nios2_fpu_nios2_sltdf].N >= 0);
	case LE:
	  return (nios2_fpu_insns[nios2_fpu_nios2_sledf].N >= 0);
	default:
	  break;
      }
    }

  return false;
}

/* Note that get_reverse_cond() is not the same as get_inverse_cond()
   get_reverse_cond() means that if the operand order is reversed,
   what is the operand that is needed to generate the same condition?  */
enum rtx_code
get_reverse_cond(enum rtx_code cond_t)
{
  switch (cond_t)
    {
      case GT: return LT;
      case GE: return LE;
      case LT: return GT;
      case LE: return GE;
      case GTU: return LTU;
      case GEU: return LEU;
      case LTU: return GTU;
      case LEU: return GEU;
      default: break;
    }

  return cond_t;
}


/* Generate the code to compare (and possibly branch) two integer values
   TEST_CODE is the comparison code we are trying to emulate
     (or implement directly)
   RESULT is where to store the result of the comparison,
     or null to emit a branch
   CMP0 CMP1 are the two comparison operands
   DESTINATION is the destination of the branch, or null to only compare.  */

void
gen_int_relational (enum rtx_code test_code, /* Relational test (EQ, etc).  */
                    rtx result,      /* Result to store comp. or 0 if branch.  */
                    rtx cmp0,        /* First operand to compare.  */
                    rtx cmp1,        /* Second operand to compare.  */
                    rtx destination) /* Destination of the branch, 
				        or 0 if compare.  */
{
  struct cmp_info
  {
    /* For register (or 0) compares.  */
    enum rtx_code test_code_reg;   /* Code to use in instruction (LT vs. LTU).  */
    int reverse_regs;              /* Reverse registers in test.  */

    /* for immediate compares */
    enum rtx_code test_code_const; /* Code to use in instruction (LT vs. LTU).  */
    int const_low;                 /* Low bound of constant we can accept.  */
    int const_high;                /* High bound of constant we can accept.  */
    int const_add;                 /* Constant to add.  */

    /* generic info */
    int unsignedp;                 /* != 0 for unsigned comparisons.  */
  };

#if defined(TARGET_ARCH_NIOS2DPX) && (TARGET_ARCH_NIOS2DPX == 1)
  static const struct cmp_info info[(int) ITEST_MAX] = {

    {EQ, 0, EQ, -2048, 2047, 0, 0}, /* EQ  */
    {NE, 0, NE, -2048, 2047, 0, 0}, /* NE  */

    {LT, 1, GE, -2049, 2046, 1, 0}, /* GT  */
    {GE, 0, GE, -2048, 2047, 0, 0}, /* GE  */
    {LT, 0, LT, -2048, 2407, 0, 0}, /* LT  */
    {GE, 1, LT, -2049, 2046, 1, 0}, /* LE  */

    {LTU, 1, GEU, 0, 4094, 1, 0}, /* GTU */
    {GEU, 0, GEU, 0, 4095, 0, 0}, /* GEU */
    {LTU, 0, LTU, 0, 4095, 0, 0}, /* LTU */
    {GEU, 1, LTU, 0, 4094, 1, 0}, /* LEU */
  };
#else
  static const struct cmp_info info[(int) ITEST_MAX] = {

    {EQ, 0, EQ, -32768, 32767, 0, 0}, /* EQ  */
    {NE, 0, NE, -32768, 32767, 0, 0}, /* NE  */

    {LT, 1, GE, -32769, 32766, 1, 0}, /* GT  */
    {GE, 0, GE, -32768, 32767, 0, 0}, /* GE  */
    {LT, 0, LT, -32768, 32767, 0, 0}, /* LT  */
    {GE, 1, LT, -32769, 32766, 1, 0}, /* LE  */

    {LTU, 1, GEU, 0, 65534, 1, 0}, /* GTU */
    {GEU, 0, GEU, 0, 65535, 0, 0}, /* GEU */
    {LTU, 0, LTU, 0, 65535, 0, 0}, /* LTU */
    {GEU, 1, LTU, 0, 65534, 1, 0}, /* LEU */
  };
#endif


  enum internal_test test;
  enum machine_mode mode;
  const struct cmp_info *p_info;
  int branch_p;


  test = map_test_to_internal_test (test_code);
  gcc_assert (test != ITEST_MAX);

  p_info = &info[(int) test];

  mode = GET_MODE (cmp0);
  if (mode == VOIDmode)
    mode = GET_MODE (cmp1);

  branch_p = (destination != 0);

  /* Handle floating point comparison directly. */
  if (branch_type == CMP_SF || branch_type == CMP_DF)
    {
  
      bool reverse_operands = false;

      enum machine_mode float_mode = (branch_type == CMP_SF) ? SFmode : DFmode;

      gcc_assert (register_operand (cmp0, float_mode) &&
	          register_operand (cmp1, float_mode));

      if (branch_p)
	{
          test_code = p_info->test_code_reg;
          reverse_operands = (p_info->reverse_regs);
        }

      if (!have_nios2_fpu_cmp_insn(test_code, branch_type) &&
           have_nios2_fpu_cmp_insn(get_reverse_cond(test_code), branch_type) )
        {
          test_code = get_reverse_cond(test_code);
          reverse_operands = !reverse_operands;
        }

      if (reverse_operands)
        {
          rtx temp = cmp0;
          cmp0 = cmp1;
          cmp1 = temp;
        }

      if (branch_p)
        {
          rtx cond = gen_rtx_fmt_ee (test_code, SImode, cmp0, cmp1);
          rtx label = gen_rtx_LABEL_REF (VOIDmode, destination);
          rtx insn = gen_rtx_SET (VOIDmode, pc_rtx,
                                  gen_rtx_IF_THEN_ELSE (VOIDmode,
                                                        cond, label, pc_rtx));

          emit_jump_insn (insn);
        }
      else
        emit_move_insn (result, gen_rtx_fmt_ee (test_code, SImode, cmp0,
						cmp1));
      return;
    }

  /* We can't, under any circumstances, have const_ints in cmp0
     ??? Actually we could have const0.  */
  if (GET_CODE (cmp0) == CONST_INT)
    cmp0 = force_reg (mode, cmp0);

  /* If the comparison is against an int not in legal range
     move it into a register.  */
  if (GET_CODE (cmp1) == CONST_INT)
    {
      HOST_WIDE_INT value = INTVAL (cmp1);

      if (value < p_info->const_low || value > p_info->const_high)
        cmp1 = force_reg (mode, cmp1);
    }

  /* Comparison to constants, may involve adding 1 to change a GT into GE.
     Comparison between two registers, may involve switching operands.  */
  if (GET_CODE (cmp1) == CONST_INT)
    {
      if (p_info->const_add != 0)
        {
          HOST_WIDE_INT new = INTVAL (cmp1) + p_info->const_add;

          /* If modification of cmp1 caused overflow,
             we would get the wrong answer if we follow the usual path;
             thus, x > 0xffffffffU would turn into x > 0U.  */
          gcc_assert ((p_info->unsignedp
                       ? (unsigned HOST_WIDE_INT) new >
                       (unsigned HOST_WIDE_INT) INTVAL (cmp1)
                       : new > INTVAL (cmp1)) == (p_info->const_add > 0));

          cmp1 = GEN_INT (new);
        }
    }

  else if (p_info->reverse_regs)
    {
      rtx temp = cmp0;
      cmp0 = cmp1;
      cmp1 = temp;
    }



  if (branch_p)
    {
      if (register_operand (cmp0, mode) && register_operand (cmp1, mode))
        {
          rtx insn;
          rtx cond = gen_rtx_fmt_ee (p_info->test_code_reg, mode, cmp0, cmp1);
          rtx label = gen_rtx_LABEL_REF (VOIDmode, destination);

          insn = gen_rtx_SET (VOIDmode, pc_rtx,
                              gen_rtx_IF_THEN_ELSE (VOIDmode,
                                                    cond, label, pc_rtx));

          emit_jump_insn (insn);
        }
      else
        {
          rtx cond, label;

          result = gen_reg_rtx (mode);

          emit_move_insn (result,
                          gen_rtx_fmt_ee (p_info->test_code_const, mode, cmp0,
                                          cmp1));

          cond = gen_rtx_NE (mode, result, const0_rtx);
          label = gen_rtx_LABEL_REF (VOIDmode, destination);

          emit_jump_insn (gen_rtx_SET (VOIDmode, pc_rtx,
                                       gen_rtx_IF_THEN_ELSE (VOIDmode,
                                                             cond,
                                                             label, pc_rtx)));
        }
    }
  else
    {
      if (register_operand (cmp0, mode) && register_operand (cmp1, mode))
        emit_move_insn (result,
          gen_rtx_fmt_ee (p_info->test_code_reg, mode, cmp0, cmp1));
      else
        emit_move_insn (result,
                        gen_rtx_fmt_ee (p_info->test_code_const, mode, cmp0,
                                        cmp1));
    }

}


/* ??? For now conditional moves are only supported
   when the mode of the operands being compared are
   the same as the ones being moved.  */

void
gen_conditional_move (rtx *operands, enum machine_mode mode)
{
  rtx insn, cond;
  rtx cmp_reg = gen_reg_rtx (mode);
  enum rtx_code cmp_code = GET_CODE (operands[1]);
  enum rtx_code move_code = EQ;

  /* Emit a comparison if it is not "simple".
     Simple comparisons are X eq 0 and X ne 0.  */
  if ((cmp_code == EQ || cmp_code == NE) && branch_cmp[1] == const0_rtx)
    {
      cmp_reg = branch_cmp[0];
      move_code = cmp_code;
    }
  else if ((cmp_code == EQ || cmp_code == NE) && branch_cmp[0] == const0_rtx)
    {
      cmp_reg = branch_cmp[1];
      move_code = cmp_code == EQ ? NE : EQ;
    }
  else
    gen_int_relational (cmp_code, cmp_reg, branch_cmp[0], branch_cmp[1],
                        NULL_RTX);

  cond = gen_rtx_fmt_ee (move_code, VOIDmode, cmp_reg, CONST0_RTX (mode));
  insn = gen_rtx_SET (mode, operands[0],
                      gen_rtx_IF_THEN_ELSE (mode,
                                            cond, operands[2], operands[3]));

  emit_insn (insn);
}

/*******************
 * Addressing Modes
 *******************/

int
nios2_legitimate_constant (rtx x)
{
  switch (GET_CODE (x))
    {
    case SYMBOL_REF:
      return !SYMBOL_REF_TLS_MODEL (x);
    case CONST:
      {
	rtx op = XEXP (x, 0);
	if (GET_CODE (op) != PLUS)
	  return false;
	return nios2_legitimate_constant (XEXP (op, 0))
	  && nios2_legitimate_constant (XEXP (op, 1));
      }
    default:
      return true;
    }
}

int
nios2_legitimate_address (rtx operand, enum machine_mode mode ATTRIBUTE_UNUSED,
                          int strict)
{
  int ret_val = 0;

  switch (GET_CODE (operand))
    {
      /* direct.  */
    case SYMBOL_REF:
      if (SYMBOL_REF_TLS_MODEL (operand))
	break;
      
      if (SYMBOL_REF_IN_NIOS2_SMALL_DATA_P (operand))
        {
          ret_val = 1;
          break;
        }
      /* else, fall through */
    case LABEL_REF:
    case CONST_INT:
    case CONST:
    case CONST_DOUBLE:
      /* ??? In here I need to add gp addressing */
      ret_val = 0;

      break;

      /* Register indirect.  */
    case REG:
      ret_val = REG_OK_FOR_BASE_P2 (operand, strict);
      break;

      /* Register indirect with displacement.  */
    case PLUS:
      {
        rtx op0 = XEXP (operand, 0);
        rtx op1 = XEXP (operand, 1);

#if defined(TARGET_ARCH_NIOS2DPX) && (TARGET_ARCH_NIOS2DPX == 1)
        if (REG_P (op0) && REG_P (op1))
          ret_val = 0;
        else if (REG_P (op0) && GET_CODE (op1) == CONST_INT)
          {
            ret_val = REG_OK_FOR_BASE_P2 (op0, strict)
              && SMALL12_INT (INTVAL (op1));
          }
        else if (REG_P (op1) && GET_CODE (op0) == CONST_INT)
          {
            ret_val = REG_OK_FOR_BASE_P2 (op1, strict)
              && SMALL12_INT (INTVAL (op0));
          }
        else {
          ret_val = 0;
        }
#else
        if (REG_P (op0) && REG_P (op1))
          ret_val = 0;
        else if (REG_P (op0) && GET_CODE (op1) == CONST_INT)
          ret_val = REG_OK_FOR_BASE_P2 (op0, strict)
            && SMALL_INT (INTVAL (op1));
        else if (REG_P (op1) && GET_CODE (op0) == CONST_INT)
          ret_val = REG_OK_FOR_BASE_P2 (op1, strict)
            && SMALL_INT (INTVAL (op0));
        else
          ret_val = 0;
#endif
      }
      break;

    default:
      ret_val = 0;
      break;
    }

  return ret_val;
}

/* Return true if EXP should be placed in the small data section.  */

static bool
nios2_in_small_data_p (tree exp)
{
  /* We want to merge strings, so we never consider them small data.  */
  if (TREE_CODE (exp) == STRING_CST)
    return false;

  if (TREE_CODE (exp) == VAR_DECL && DECL_SECTION_NAME (exp))
    {
      const char *section = TREE_STRING_POINTER (DECL_SECTION_NAME (exp));
      /* ??? these string names need moving into
         an array in some header file */
      if (nios2_section_threshold > 0
          && (strcmp (section, ".sbss") == 0
              || strncmp (section, ".sbss.", 6) == 0
              || strcmp (section, ".sdata") == 0
              || strncmp (section, ".sdata.", 7) == 0))
        return true;
    }
  else if (TREE_CODE (exp) == VAR_DECL)
    {
      HOST_WIDE_INT size = int_size_in_bytes (TREE_TYPE (exp));

      /* If this is an incomplete type with size 0, then we can't put it
         in sdata because it might be too big when completed.  */
      if (size > 0 && (unsigned HOST_WIDE_INT)size <= nios2_section_threshold)
        return true;
    }

  return false;
}

static void
nios2_encode_section_info (tree decl, rtx rtl, int first)
{

  rtx symbol;
  int flags;

  default_encode_section_info (decl, rtl, first);

  /* Careful not to prod global register variables.  */
  if (GET_CODE (rtl) != MEM)
    return;
  symbol = XEXP (rtl, 0);
  if (GET_CODE (symbol) != SYMBOL_REF)
    return;

  flags = SYMBOL_REF_FLAGS (symbol);

  /* We don't want weak variables to be addressed with gp in case they end up 
     with value 0 which is not within 2^15 of $gp.  */
  if (DECL_P (decl) && DECL_WEAK (decl))
    flags |= SYMBOL_FLAG_WEAK_DECL;

  SYMBOL_REF_FLAGS (symbol) = flags;
}


static unsigned int
nios2_section_type_flags (tree decl, const char *name, int reloc)
{
  unsigned int flags;

  flags = default_section_type_flags (decl, name, reloc);

  if (strcmp (name, ".sbss") == 0
      || strncmp (name, ".sbss.", 6) == 0
      || strcmp (name, ".sdata") == 0
      || strncmp (name, ".sdata.", 7) == 0)
    flags |= SECTION_SMALL;

  return flags;
}

/* Handle a #pragma reverse_bitfields.  */
static void
nios2_pragma_reverse_bitfields (struct cpp_reader *pfile ATTRIBUTE_UNUSED)
{
  nios2_pragma_reverse_bitfields_flag = 1; /* Reverse */
}

/* Handle a #pragma no_reverse_bitfields.  */
static void
nios2_pragma_no_reverse_bitfields (struct cpp_reader *pfile ATTRIBUTE_UNUSED)
{
  nios2_pragma_reverse_bitfields_flag = -1; /* Forward */
}

/* Handle the various #pragma custom_<switch>s.  */
static void
nios2_pragma_fpu (int *value, const char *opt, int *seen)
{
  tree t;
  if (c_lex (&t) != CPP_NUMBER)
    {
      error ("`#pragma custom_%s' value must be a number between 0 and 255",
             opt);
      return;
    }

  if (TREE_INT_CST_HIGH (t) == 0
      && TREE_INT_CST_LOW (t) <= 255)
    {
      *value = (int)TREE_INT_CST_LOW (t);
      *seen = 1;
    }
  else
    error ("`#pragma custom_%s' value must be between 0 and 255", opt);
  nios2_custom_check_insns (1);
}

/* Handle the various #pragma no_custom_<switch>s.  */
static void
nios2_pragma_no_fpu (int *value, const char *opt ATTRIBUTE_UNUSED)
{
  *value = -1;
  nios2_custom_check_insns (1);
}

#undef NIOS2_FPU_INSN
#define NIOS2_FPU_INSN(opt, insn, args) \
static void \
NIOS2_CONCAT (nios2_pragma_, insn) \
  (struct cpp_reader *pfile ATTRIBUTE_UNUSED) \
{ \
  nios2_fpu_info *inf = &(nios2_fpu_insns[NIOS2_CONCAT (nios2_fpu_, insn)]); \
  nios2_pragma_fpu (&(inf->N), inf->option, &(inf->pragma_seen)); \
} \
static void \
NIOS2_CONCAT (nios2_pragma_no_, insn) \
  (struct cpp_reader *pfile ATTRIBUTE_UNUSED) \
{ \
  nios2_fpu_info *inf = &(nios2_fpu_insns[NIOS2_CONCAT (nios2_fpu_, insn)]); \
  nios2_pragma_no_fpu (&(inf->N), inf->option); \
}
NIOS2_FOR_ALL_FPU_INSNS

static void
nios2_pragma_handle_custom_fpu_cfg (struct cpp_reader *pfile ATTRIBUTE_UNUSED)
{
  tree t;
  if (c_lex (&t) != CPP_STRING)
    {
      error ("`#pragma custom_fpu_cfg' value must be a string");
      return;
    }

  if (TREE_STRING_LENGTH (t) > 0)
    nios2_handle_custom_fpu_cfg (TREE_STRING_POINTER (t), 1);
}

void
nios2_register_target_pragmas (void)
{
  int i;

  c_register_pragma (0, "reverse_bitfields",
                     nios2_pragma_reverse_bitfields);
  c_register_pragma (0, "no_reverse_bitfields",
                     nios2_pragma_no_reverse_bitfields);

  for (i = 0; i < nios2_fpu_max_insn; i++)
    {
      nios2_fpu_info *inf = &(nios2_fpu_insns[i]);
      c_register_pragma (0, inf->pname, inf->pragma);
      c_register_pragma (0, inf->nopname, inf->nopragma);
    }

  c_register_pragma (0, "custom_fpu_cfg",
                     nios2_pragma_handle_custom_fpu_cfg);
}

/* Handle an attribute requiring a FUNCTION_DECL;
   arguments as in struct attribute_spec.handler.  */
static tree
nios2_handle_fndecl_attribute (tree *node, tree name, tree args ATTRIBUTE_UNUSED,
			     int flags ATTRIBUTE_UNUSED, bool *no_add_attrs)
{
  if (TREE_CODE (*node) != FUNCTION_DECL)
    {
      warning (OPT_Wattributes, "%qs attribute only applies to functions",
	       IDENTIFIER_POINTER (name));
      *no_add_attrs = true;
    }

  return NULL_TREE;
}

/* Handle an attribute requiring a FUNCTION_DECL;
   arguments as in struct attribute_spec.handler.  */
static tree
nios2_handle_task_attribute (tree *node, tree name, tree args ATTRIBUTE_UNUSED,
			     int flags ATTRIBUTE_UNUSED, bool *no_add_attrs)
{
  if (TREE_CODE (*node) != FUNCTION_DECL)
    {
      warning (OPT_Wattributes, "%qs attribute only applies to functions",
	       IDENTIFIER_POINTER (name));
      *no_add_attrs = true;
    }

  return NULL_TREE;
}


/* Handle a "reverse_bitfields" or "no_reverse_bitfields" attribute.
   ??? What do these attributes mean on a union?  */
static tree
nios2_handle_struct_attribute (tree *node, tree name,
                               tree args ATTRIBUTE_UNUSED,
                               int flags ATTRIBUTE_UNUSED,
                               bool *no_add_attrs)
{
  tree *type = NULL;
  if (DECL_P (*node))
    {
      if (TREE_CODE (*node) == TYPE_DECL)
        type = &TREE_TYPE (*node);
    }
  else
    type = node;

  if (!(type && (TREE_CODE (*type) == RECORD_TYPE
                 || TREE_CODE (*type) == UNION_TYPE)))
    {
      warning (0, "`%s' attribute ignored", IDENTIFIER_POINTER (name));
      *no_add_attrs = true;
    }

  else if ((is_attribute_p ("reverse_bitfields", name)
            && lookup_attribute ("no_reverse_bitfields",
                                 TYPE_ATTRIBUTES (*type)))
           || ((is_attribute_p ("no_reverse_bitfields", name)
                && lookup_attribute ("reverse_bitfields",
                                     TYPE_ATTRIBUTES (*type)))))
    {
      warning (0, "`%s' incompatible attribute ignored",
               IDENTIFIER_POINTER (name));
      *no_add_attrs = true;
    }

  return NULL_TREE;
}

/* Add __attribute__ ((pragma_reverse_bitfields)) when in the scope of a
   #pragma reverse_bitfields, or __attribute__
   ((pragma_no_reverse_bitfields)) when in the scope of a #pragma
   no_reverse_bitfields.  This gets called before
   nios2_handle_struct_attribute above, so we can't just reuse the same
   attributes.  */
static void
nios2_insert_attributes (tree node, tree *attr_ptr)
{
  tree type = NULL;
  if (DECL_P (node))
    {
      if (TREE_CODE (node) == TYPE_DECL)
        type = TREE_TYPE (node);
    }
  else
    type = node;

  if (!type
      || (TREE_CODE (type) != RECORD_TYPE
          && TREE_CODE (type) != UNION_TYPE))
    {
      /* We can ignore things other than structs & unions.  */
      return;
    }

  if (lookup_attribute ("reverse_bitfields", TYPE_ATTRIBUTES (type))
      || lookup_attribute ("no_reverse_bitfields", TYPE_ATTRIBUTES (type)))
    {
      /* If an attribute is already set, it silently overrides the
         current #pragma, if any.  */
      return;
    }

  if (nios2_pragma_reverse_bitfields_flag)
    {
      const char *id = (nios2_pragma_reverse_bitfields_flag == 1 ?
                        "pragma_reverse_bitfields" :
                        "pragma_no_reverse_bitfields");
      /* No attribute set, and we are in the scope of a #pragma.  */
      *attr_ptr = tree_cons (get_identifier (id), NULL, *attr_ptr);
    }
}

/*****************************************
 * Position Independent Code
 *****************************************/

/* Emit code to load the PIC register.  */

static void
nios2_load_pic_register (void)
{
  rtx tmp = gen_rtx_REG (Pmode, TEMP_REG_NUM);
  
  emit_insn (gen_load_got_register (pic_offset_table_rtx, tmp));
  emit_insn (gen_add3_insn (pic_offset_table_rtx, pic_offset_table_rtx, tmp));
}

/* Nonzero if the constant value X is a legitimate general operand
   when generating PIC code.  It is given that flag_pic is on and
   that X satisfies CONSTANT_P or is a CONST_DOUBLE.  */

bool
nios2_legitimate_pic_operand_p (rtx x)
{
  rtx inner;

  /* UNSPEC_TLS is always PIC.  */
  if (tls_mentioned_p (x))
    return true;

  if (GET_CODE (x) == SYMBOL_REF)
    return false;
  if (GET_CODE (x) == LABEL_REF)
    return false;
  if (GET_CODE (x) == CONST)
    {
      inner = XEXP (x, 0);
      if (GET_CODE (inner) == PLUS &&
          GET_CODE (XEXP (inner, 0)) == SYMBOL_REF &&
	  GET_CODE (XEXP (inner, 1)) == CONST)
	return false;
    }
  return true;
}

rtx
nios2_legitimize_pic_address (rtx orig,
			      enum machine_mode mode ATTRIBUTE_UNUSED, rtx reg)
{
  if (GET_CODE (orig) == SYMBOL_REF
      || GET_CODE (orig) == LABEL_REF)
    {
      if (reg == 0)
	{
	  gcc_assert (!no_new_pseudos);
	  reg = gen_reg_rtx (Pmode);
	}

      emit_insn (gen_pic_load_addr (reg, pic_offset_table_rtx, orig));

      current_function_uses_pic_offset_table = 1;

      return reg;
    }
  else if (GET_CODE (orig) == CONST)
    {
      rtx base, offset;

      if (GET_CODE (XEXP (orig, 0)) == PLUS
	  && XEXP (XEXP (orig, 0), 0) == pic_offset_table_rtx)
	return orig;

      if (GET_CODE (XEXP (orig, 0)) == UNSPEC
	  && IS_UNSPEC_TLS (XINT (XEXP (orig, 0), 1)))
	return orig;

      if (reg == 0)
	{
	  gcc_assert (!no_new_pseudos);
	  reg = gen_reg_rtx (Pmode);
	}

      gcc_assert (GET_CODE (XEXP (orig, 0)) == PLUS);

      base = nios2_legitimize_pic_address (XEXP (XEXP (orig, 0), 0), Pmode,
					   reg);
      offset = nios2_legitimize_pic_address (XEXP (XEXP (orig, 0), 1), Pmode,
					     base == reg ? 0 : reg);

      if (GET_CODE (offset) == CONST_INT)
	return plus_constant (base, INTVAL (offset));

      return gen_rtx_PLUS (Pmode, base, offset);
    }

  return orig;
}

/* Test for various thread-local symbols.  */

/* Return TRUE if X is a thread-local symbol.  */

static bool
nios2_tls_symbol_p (rtx x)
{
  if (! TARGET_HAVE_TLS)
    return false;

  if (GET_CODE (x) != SYMBOL_REF)
    return false;

  return SYMBOL_REF_TLS_MODEL (x) != 0;
}

rtx
nios2_legitimize_address (rtx x, rtx orig_x, enum machine_mode mode)
{
  if (nios2_tls_symbol_p (x))
    return nios2_legitimize_tls_address (x);

  if (flag_pic)
    {
      /* We need to find and carefully transform any SYMBOL and LABEL
         references; so go back to the original address expression.  */
      rtx new_x = nios2_legitimize_pic_address (orig_x, mode, NULL_RTX);

      if (new_x != orig_x)
        x = new_x;
    }

  return x;
}

/*****************************************
 * Defining the Output Assembler Language
 *****************************************/

/* -------------- *
 * Output of Data
 * -------------- */


/* -------------------------------- *
 * Output of Assembler Instructions
 * -------------------------------- */


/* print the operand OP to file stream
   FILE modified by LETTER. LETTER
   can be one of:
     i: print "i" if OP is an immediate, except 0
     o: print "io" if OP is volatile

     z: for const0_rtx print $0 instead of 0
     H: for %hiadj
     L: for %lo
     T: for %hi20adj
     B: for %lo12
     
     U: for upper half of 32 bit value
     D: for the upper 32-bits of a 64-bit double value
 */

void
nios2_print_operand (FILE *file, rtx op, int letter)
{

  switch (letter)
    {
    case 'i':
      if (CONSTANT_P (op) && (op != const0_rtx))
        fprintf (file, "i");
      return;

    case 'o':
      if (GET_CODE (op) == MEM 
          && ((MEM_VOLATILE_P (op) && TARGET_NO_CACHE_VOLATILE)
              || TARGET_BYPASS_CACHE))
        fprintf (file, "io");
      return;

    default:
      break;
    }

  if (comparison_operator (op, VOIDmode))
    {
      if (letter == 0)
        {
          fprintf (file, "%s", GET_RTX_NAME (GET_CODE (op)));
          return;
        }
    }


  switch (GET_CODE (op))
    {
    case REG:
      if (letter == 0 || letter == 'z')
        {
          fprintf (file, "%s", reg_names[REGNO (op)]);
          return;
        }
      else if (letter == 'D')
        {
          fprintf (file, "%s", reg_names[REGNO (op)+1]);
          return;
        }
      break;

    case CONST_INT:
      if (INTVAL (op) == 0 && letter == 'z')
        {
          fprintf (file, "zero");
          return;
        }
      else if (letter == 'U')
        {
          HOST_WIDE_INT val = INTVAL (op);
          rtx new_op;
/*           val = (val / 65536) & 0xFFFF; */
          val = (val >> 16) & 0xFFFF;
          new_op = GEN_INT (val);
          output_addr_const (file, new_op);
          return;
        }

      /* else, fall through.  */
    case CONST:
    case LABEL_REF:
    case SYMBOL_REF:
    case CONST_DOUBLE:
      if (letter == 0 || letter == 'z')
        {
          output_addr_const (file, op);
          return;
        }
      else if (letter == 'H')
        {
          fprintf (file, "%%hiadj(");
          output_addr_const (file, op);
          fprintf (file, ")");
          return;
        }
      else if (letter == 'L')
        {
          fprintf (file, "%%lo(");
          output_addr_const (file, op);
          fprintf (file, ")");
          return;
        }
#if defined(TARGET_ARCH_NIOS2DPX) && (TARGET_ARCH_NIOS2DPX == 1)
      else if (letter == 'T')
        {
          fprintf (file, "%%hi20adj(");
          output_addr_const (file, op);
          fprintf (file, ")");
          return;
        }
      else if (letter == 'B')
        {
          fprintf (file, "%%lo12(");
          output_addr_const (file, op);
          fprintf (file, ")");
          return;
        }
#endif
      break;


    case SUBREG:
    case MEM:
      if (letter == 0)
        {
          output_address (op);
          return;
        }
      break;

    case CODE_LABEL:
      if (letter == 0)
        {
          output_addr_const (file, op);
          return;
        }
      break;

    default:
      break;
    }

  fprintf (stderr, "Missing way to print (%c) ", letter);
  debug_rtx (op);
  gcc_unreachable ();
}

static int gprel_constant (rtx);

static int
gprel_constant (rtx op)
{
  if (GET_CODE (op) == SYMBOL_REF
      && SYMBOL_REF_IN_NIOS2_SMALL_DATA_P (op))
    return 1;
  else if (GET_CODE (op) == CONST
           && GET_CODE (XEXP (op, 0)) == PLUS)
    return gprel_constant (XEXP (XEXP (op, 0), 0));
  else
    return 0;
}

void
nios2_print_operand_address (FILE *file, rtx op)
{
  switch (GET_CODE (op))
    {
    case CONST:
    case CONST_INT:
    case LABEL_REF:
    case CONST_DOUBLE:
    case SYMBOL_REF:
      if (gprel_constant (op))
        {
          fprintf (file, "%%gprel(");
          output_addr_const (file, op);
          fprintf (file, ")(%s)", reg_names[GP_REGNO]);
          return;
        }

      break;

    case PLUS:
      {
        rtx op0 = XEXP (op, 0);
        rtx op1 = XEXP (op, 1);

        if (REG_P (op0) && CONSTANT_P (op1))
          {
            output_addr_const (file, op1);
            fprintf (file, "(%s)", reg_names[REGNO (op0)]);
            return;
          }
        else if (REG_P (op1) && CONSTANT_P (op0))
          {
            output_addr_const (file, op0);
            fprintf (file, "(%s)", reg_names[REGNO (op1)]);
            return;
          }
      }
      break;

    case REG:
      fprintf (file, "0(%s)", reg_names[REGNO (op)]);
      return;

    case MEM:
      {
        rtx base = XEXP (op, 0);
        PRINT_OPERAND_ADDRESS (file, base);
        return;
      }
    default:
      break;
    }

  fprintf (stderr, "Missing way to print address\n");
  debug_rtx (op);
  gcc_unreachable ();
}



/****************************
 * Debug information
 ****************************/

static void
nios2_output_dwarf_dtprel (FILE *file, int size, rtx x)
{
  gcc_assert (size == 4);
  /* fputs ("\t.4byte\t%tls_ldo(", file); */
  fprintf (file, "\t.4byte\t%%tls_ldo(");
  output_addr_const (file, x);
  /* fputs (")", file); */
  fprintf (file,")");
}


/****************************
 * Predicates
 ****************************/

/* ToDo -- move predicates to predicates.md */

/* An operand to a call or sibcall.  This must be an immediate operand
   or a register.  */
int
call_operand (rtx x, enum machine_mode mode)
{
  return (immediate_operand (x, mode)
	  || register_operand (x, mode));
}

int
arith_operand (rtx op, enum machine_mode mode)
{
  if (GET_CODE (op) == CONST_INT && SMALL_INT (INTVAL (op)))
    return 1;

  return register_operand (op, mode);
}

int
uns_arith_operand (rtx op, enum machine_mode mode)
{
#if defined(TARGET_ARCH_NIOS2DPX) && (TARGET_ARCH_NIOS2DPX == 1)
  if (GET_CODE (op) == CONST_INT && SMALL12_INT_UNSIGNED (INTVAL (op)))
    return 1;
#else
  if (GET_CODE (op) == CONST_INT && SMALL_INT_UNSIGNED (INTVAL (op)))
    return 1;
#endif

  return register_operand (op, mode);
}

int
logical_operand (rtx op, enum machine_mode mode)
{
  if (GET_CODE (op) == CONST_INT
      && (SMALL_INT_UNSIGNED (INTVAL (op)) || UPPER16_INT (INTVAL (op))))
    return 1;

  return register_operand (op, mode);
}

int
shift_operand (rtx op, enum machine_mode mode)
{
  if (GET_CODE (op) == CONST_INT && SHIFT_INT (INTVAL (op)))
    return 1;

  return register_operand (op, mode);
}

int
rdwrctl_operand (rtx op, enum machine_mode mode ATTRIBUTE_UNUSED)
{
  return GET_CODE (op) == CONST_INT && RDWRCTL_INT (INTVAL (op));
}

/* Return truth value of whether OP is a register or the constant 0.  */

int
reg_or_0_operand (rtx op, enum machine_mode mode)
{
  switch (GET_CODE (op))
    {
    case CONST_INT:
      return INTVAL (op) == 0;

    case CONST_DOUBLE:
      return op == CONST0_RTX (mode);

    default:
      break;
    }

  return register_operand (op, mode);
}

int
equality_op (rtx op, enum machine_mode mode)
{
  if (mode != GET_MODE (op))
    return 0;

  return GET_CODE (op) == EQ || GET_CODE (op) == NE;
}

int
custom_insn_opcode (rtx op, enum machine_mode mode ATTRIBUTE_UNUSED)
{
  return GET_CODE (op) == CONST_INT && CUSTOM_INSN_OPCODE (INTVAL (op));
}




/*****************************************************************************
**
** custom fpu instruction output
**
*****************************************************************************/

static const char *nios2_custom_fpu_insn_zdz (rtx, int, const char *);
static const char *nios2_custom_fpu_insn_zsz (rtx, int, const char *);
static const char *nios2_custom_fpu_insn_szz (rtx, int, const char *);
static const char *nios2_custom_fpu_insn_sss (rtx, int, const char *);
static const char *nios2_custom_fpu_insn_ssz (rtx, int, const char *);
static const char *nios2_custom_fpu_insn_iss (rtx, int, const char *);
static const char *nios2_custom_fpu_insn_ddd (rtx, int, const char *);
static const char *nios2_custom_fpu_insn_ddz (rtx, int, const char *);
static const char *nios2_custom_fpu_insn_idd (rtx, int, const char *);
static const char *nios2_custom_fpu_insn_siz (rtx, int, const char *);
static const char *nios2_custom_fpu_insn_suz (rtx, int, const char *);
static const char *nios2_custom_fpu_insn_diz (rtx, int, const char *);
static const char *nios2_custom_fpu_insn_duz (rtx, int, const char *);
static const char *nios2_custom_fpu_insn_isz (rtx, int, const char *);
static const char *nios2_custom_fpu_insn_usz (rtx, int, const char *);
static const char *nios2_custom_fpu_insn_idz (rtx, int, const char *);
static const char *nios2_custom_fpu_insn_udz (rtx, int, const char *);
static const char *nios2_custom_fpu_insn_dsz (rtx, int, const char *);
static const char *nios2_custom_fpu_insn_sdz (rtx, int, const char *);

static const char *
nios2_custom_fpu_insn_zdz (rtx insn, int N, const char *opt)
{
  static char buf[1024];

  if (N < 0)
    fatal_insn ("attempt to use disabled fpu instruction", insn);
  if (snprintf (buf, sizeof (buf),
                "custom\t%d, zero, %%0, %%D0 # %s %%0",
                N, opt) >= (int)sizeof (buf))
    fatal_insn ("buffer overflow", insn);
  return buf;
}

static const char *
nios2_custom_fpu_insn_zsz (rtx insn, int N, const char *opt)
{
  static char buf[1024];

  if (N < 0)
    fatal_insn ("attempt to use disabled fpu instruction", insn);
  if (snprintf (buf, sizeof (buf),
                "custom\t%d, zero, %%0, zero # %s %%0",
                N, opt) >= (int)sizeof (buf))
    fatal_insn ("buffer overflow", insn);
  return buf;
}

static const char *
nios2_custom_fpu_insn_szz (rtx insn, int N, const char *opt)
{
  static char buf[1024];

  if (N < 0)
    fatal_insn ("attempt to use disabled fpu instruction", insn);
  if (snprintf (buf, sizeof (buf),
                "custom\t%d, %%0, zero, zero # %s %%0",
                N, opt) >= (int)sizeof (buf))
    fatal_insn ("buffer overflow", insn);
  return buf;
}

static const char *
nios2_custom_fpu_insn_sss (rtx insn, int N, const char *opt)
{
  static char buf[1024];

  if (N < 0)
    fatal_insn ("attempt to use disabled fpu instruction", insn);
  if (snprintf (buf, sizeof (buf),
                "custom\t%d, %%0, %%1, %%2 # %s %%0, %%1, %%2",
                N, opt) >= (int)sizeof (buf))
    fatal_insn ("buffer overflow", insn);
  return buf;
}

static const char *
nios2_custom_fpu_insn_ssz (rtx insn, int N, const char *opt)
{
  static char buf[1024];

  if (N < 0)
    fatal_insn ("attempt to use disabled fpu instruction", insn);
  if (snprintf (buf, sizeof (buf),
                "custom\t%d, %%0, %%1, zero # %s %%0, %%1",
                N, opt) >= (int)sizeof (buf))
    fatal_insn ("buffer overflow", insn);
  return buf;
}

static const char *
nios2_custom_fpu_insn_iss (rtx insn, int N, const char *opt)
{
  return nios2_custom_fpu_insn_sss (insn, N, opt);
}

static const char *
nios2_custom_fpu_insn_ddd (rtx insn, int N, const char *opt)
{
  static char buf[1024];

  if (N < 0
      || nios2_fpu_insns[nios2_fpu_nios2_frdy].N < 0
      || nios2_fpu_insns[nios2_fpu_nios2_fwrx].N < 0)
    fatal_insn ("attempt to use disabled fpu instruction", insn);
  if (snprintf (buf, sizeof (buf),
                "custom\t%d, zero, %%1, %%D1 # fwrx %%1\n\t"
                "custom\t%d, %%D0, %%2, %%D2 # %s %%0, %%1, %%2\n\t"
                "custom\t%d, %%0, zero, zero # frdy %%0",
                nios2_fpu_insns[nios2_fpu_nios2_fwrx].N,
                N, opt,
                nios2_fpu_insns[nios2_fpu_nios2_frdy].N) >= (int)sizeof (buf))
    fatal_insn ("buffer overflow", insn);
  return buf;
}

static const char *
nios2_custom_fpu_insn_ddz (rtx insn, int N, const char *opt)
{
  static char buf[1024];

  if (N < 0 || nios2_fpu_insns[nios2_fpu_nios2_frdy].N < 0)
    fatal_insn ("attempt to use disabled fpu instruction", insn);
  if (snprintf (buf, sizeof (buf),
                "custom\t%d, %%D0, %%1, %%D1 # %s %%0, %%1\n\t"
                "custom\t%d, %%0, zero, zero # frdy %%0",
                N, opt,
                nios2_fpu_insns[nios2_fpu_nios2_frdy].N) >= (int)sizeof (buf))
    fatal_insn ("buffer overflow", insn);
  return buf;
}

static const char *
nios2_custom_fpu_insn_idd (rtx insn, int N, const char *opt)
{
  static char buf[1024];

  if (N < 0 || nios2_fpu_insns[nios2_fpu_nios2_fwrx].N < 0)
    fatal_insn ("attempt to use disabled fpu instruction", insn);
  if (snprintf (buf, sizeof (buf),
                "custom\t%d, zero, %%1, %%D1 # fwrx %%1\n\t"
                "custom\t%d, %%0, %%2, %%D2 # %s %%0, %%1, %%2",
                nios2_fpu_insns[nios2_fpu_nios2_fwrx].N,
                N, opt) >= (int)sizeof (buf))
    fatal_insn ("buffer overflow", insn);
  return buf;
}

static const char *
nios2_custom_fpu_insn_siz (rtx insn, int N, const char *opt)
{
  return nios2_custom_fpu_insn_ssz (insn, N, opt);
}

static const char *
nios2_custom_fpu_insn_suz (rtx insn, int N, const char *opt)
{
  return nios2_custom_fpu_insn_ssz (insn, N, opt);
}

static const char *
nios2_custom_fpu_insn_diz (rtx insn, int N, const char *opt)
{
  return nios2_custom_fpu_insn_dsz (insn, N, opt);
}

static const char *
nios2_custom_fpu_insn_duz (rtx insn, int N, const char *opt)
{
  return nios2_custom_fpu_insn_dsz (insn, N, opt);
}

static const char *
nios2_custom_fpu_insn_isz (rtx insn, int N, const char *opt)
{
  return nios2_custom_fpu_insn_ssz (insn, N, opt);
}

static const char *
nios2_custom_fpu_insn_usz (rtx insn, int N, const char *opt)
{
  return nios2_custom_fpu_insn_ssz (insn, N, opt);
}

static const char *
nios2_custom_fpu_insn_idz (rtx insn, int N, const char *opt)
{
  return nios2_custom_fpu_insn_sdz (insn, N, opt);
}

static const char *
nios2_custom_fpu_insn_udz (rtx insn, int N, const char *opt)
{
  return nios2_custom_fpu_insn_sdz (insn, N, opt);
}

static const char *
nios2_custom_fpu_insn_dsz (rtx insn, int N, const char *opt)
{
  static char buf[1024];

  if (N < 0 || nios2_fpu_insns[nios2_fpu_nios2_frdy].N < 0)
    fatal_insn ("attempt to use disabled fpu instruction", insn);
  if (snprintf (buf, sizeof (buf),
                "custom\t%d, %%D0, %%1, zero # %s %%0, %%1\n\t"
                "custom\t%d, %%0, zero, zero # frdy %%0",
                N, opt,
                nios2_fpu_insns[nios2_fpu_nios2_frdy].N) >= (int)sizeof (buf))
    fatal_insn ("buffer overflow", insn);
  return buf;
}

static const char *
nios2_custom_fpu_insn_sdz (rtx insn, int N, const char *opt)
{
  static char buf[1024];

  if (N < 0)
    fatal_insn ("attempt to use disabled fpu instruction", insn);
  if (snprintf (buf, sizeof (buf),
                "custom\t%d, %%0, %%1, %%D1 # %s %%0, %%1",
                N, opt) >= (int)sizeof (buf))
    fatal_insn ("buffer overflow", insn);
  return buf;
}

#undef NIOS2_FPU_INSN
#define NIOS2_FPU_INSN(opt, insn, args) \
static const char * \
NIOS2_CONCAT (nios2_output_fpu_insn_, insn) (rtx i) \
{ \
  return NIOS2_CONCAT (nios2_custom_fpu_insn_, args) \
           (i, \
            nios2_fpu_insns[NIOS2_CONCAT (nios2_fpu_, insn)].N, \
            nios2_fpu_insns[NIOS2_CONCAT (nios2_fpu_, insn)].option); \
}
NIOS2_FOR_ALL_FPU_INSNS



const char *
nios2_output_fpu_insn_cmps (rtx insn, enum rtx_code cond)
{
  static char buf[1024];
  int N, rv;
  const char *opt;

  int operandL = 2;
  int operandR = 3;

  if (!have_nios2_fpu_cmp_insn(cond, CMP_SF) &&
       have_nios2_fpu_cmp_insn(get_reverse_cond(cond), CMP_SF) ) {

    int temp = operandL;
    operandL = operandR;
    operandR = temp;

    cond = get_reverse_cond(cond);
  }

  if (!have_nios2_fpu_cmp_insn(cond, CMP_SF))
    abort ();
  
  switch (cond)
    {
    case EQ:
      N = nios2_fpu_insns[nios2_fpu_nios2_seqsf].N;
      opt = "fcmpeqs";
      break;
    case NE:
      N = nios2_fpu_insns[nios2_fpu_nios2_snesf].N;
      opt = "fcmpnes";
      break;
    case GT:
      N = nios2_fpu_insns[nios2_fpu_nios2_sgtsf].N;
      opt = "fcmpgts";
      break;
    case GE:
      N = nios2_fpu_insns[nios2_fpu_nios2_sgesf].N;
      opt = "fcmpges";
      break;
    case LT:
      N = nios2_fpu_insns[nios2_fpu_nios2_sltsf].N;
      opt = "fcmplts";
      break;
    case LE:
      N = nios2_fpu_insns[nios2_fpu_nios2_slesf].N;
      opt = "fcmples"; break;
    default:
      fatal_insn ("bad single compare", insn);
    }

  if (N < 0)
    fatal_insn ("attempt to use disabled fpu instruction", insn);

  /* ??? This raises the whole vexing issue of how to handle
     out-of-range branches.  Punt for now, seeing as how nios2-elf-as
     doesn't even _try_ to handle out-of-range branches yet!  */
  rv = snprintf (buf, sizeof (buf),
                ".set\tnoat\n\t"
                "custom\t%d, at, %%%d, %%%d # %s at, %%%d, %%%d\n\t"
                "bne\tat, zero, %%l1\n\t"
                ".set\tat",
                 N, operandL, operandR, opt, operandL, operandR);

  if (rv >= ((int)sizeof(buf)))
    {
      fatal_insn ("buffer overflow", insn);
    }
  else if (rv == -1)
    {
      fatal_insn ("instruction encoding error", insn);
    }

  return buf;
}

const char *
nios2_output_fpu_insn_cmpd (rtx insn, enum rtx_code cond)
{
  static char buf[1024];
  int N, rv;
  const char *opt;

  int operandL = 2;
  int operandR = 3;

  if ( !have_nios2_fpu_cmp_insn(cond, CMP_DF) &&
       have_nios2_fpu_cmp_insn(get_reverse_cond(cond), CMP_DF) ) 
    {

      int temp = operandL;
      operandL = operandR;
      operandR = temp;

      cond = get_reverse_cond(cond);
    }

  if (!have_nios2_fpu_cmp_insn(cond, CMP_DF))
    abort ();

  switch (cond)
    {
    case EQ:
      N = nios2_fpu_insns[nios2_fpu_nios2_seqdf].N;
      opt = "fcmpeqd";
      break;
    case NE:
      N = nios2_fpu_insns[nios2_fpu_nios2_snedf].N;
      opt = "fcmpned";
      break;
    case GT:
      N = nios2_fpu_insns[nios2_fpu_nios2_sgtdf].N;
      opt = "fcmpgtd";
      break;
    case GE:
      N = nios2_fpu_insns[nios2_fpu_nios2_sgedf].N;
      opt = "fcmpged";
      break;
    case LT:
      N = nios2_fpu_insns[nios2_fpu_nios2_sltdf].N;
      opt = "fcmpltd";
      break;
    case LE:
      N = nios2_fpu_insns[nios2_fpu_nios2_sledf].N;
      opt = "fcmpled";
      break;
    default:
      fatal_insn ("bad double compare", insn);
    }

  if (N < 0 || nios2_fpu_insns[nios2_fpu_nios2_fwrx].N < 0)
    fatal_insn ("attempt to use disabled fpu instruction", insn);
  
  rv = snprintf (buf, sizeof (buf),
                ".set\tnoat\n\t"
                "custom\t%d, zero, %%%d, %%D%d # fwrx %%%d\n\t"
                "custom\t%d, at, %%%d, %%D%d # %s at, %%%d, %%%d\n\t"
                "bne\tat, zero, %%l1\n\t"
                ".set\tat",
                nios2_fpu_insns[nios2_fpu_nios2_fwrx].N, operandL, operandL, operandL,
                 N, operandR, operandR, opt, operandL, operandR);

    if (rv >= ((int)sizeof(buf)))
    {
      fatal_insn ("buffer overflow", insn);
    }
   else if (rv == -1)
    {
      fatal_insn ("instruction encoding error", insn);
    }

  return buf;
}




/*****************************************************************************
**
** Instruction scheduler
**
*****************************************************************************/
static int
nios2_issue_rate (void)
{
#ifdef MAX_DFA_ISSUE_RATE
  return MAX_DFA_ISSUE_RATE;
#else
  return 1;
#endif
}


const char *
asm_output_opcode (FILE *file ATTRIBUTE_UNUSED,
                   const char *ptr ATTRIBUTE_UNUSED)
{
  const char *p;

  p = ptr;
  return ptr;
}



/*****************************************************************************
**
** Function arguments
**
*****************************************************************************/

void
init_cumulative_args (CUMULATIVE_ARGS *cum,
                      tree fntype ATTRIBUTE_UNUSED,
                      rtx libname ATTRIBUTE_UNUSED,
                      tree fndecl ATTRIBUTE_UNUSED,
                      int n_named_args ATTRIBUTE_UNUSED)
{
  cum->regs_used = 0;
}


/* Define where to put the arguments to a function.  Value is zero to
   push the argument on the stack, or a hard register in which to
   store the argument.

   MODE is the argument's machine mode.
   TYPE is the data type of the argument (as a tree).
   This is null for libcalls where that information may
   not be available.
   CUM is a variable of type CUMULATIVE_ARGS which gives info about
   the preceding args and about the function being called.
   NAMED is nonzero if this argument is a named parameter
   (otherwise it is an extra parameter matching an ellipsis).  */
rtx
function_arg (const CUMULATIVE_ARGS *cum, enum machine_mode mode,
              tree type ATTRIBUTE_UNUSED, int named ATTRIBUTE_UNUSED)
{
  rtx return_rtx = NULL_RTX;

  if (cum->regs_used < NUM_ARG_REGS)
    return_rtx = gen_rtx_REG (mode, FIRST_ARG_REGNO + cum->regs_used);

  return return_rtx;
}

/* Return number of bytes, at the beginning of the argument, that must be
   put in registers.  0 is the argument is entirely in registers or entirely
   in memory.  */

static int
nios2_arg_partial_bytes (CUMULATIVE_ARGS *cum,
                         enum machine_mode mode, tree type,
                         bool named ATTRIBUTE_UNUSED)
{
  HOST_WIDE_INT param_size;

  if (mode == BLKmode)
    {
      param_size = int_size_in_bytes (type);
      if (param_size < 0)
        internal_error
          ("Do not know how to handle large structs or variable length types");
    }
  else
    param_size = GET_MODE_SIZE (mode);

  /* Convert to words (round up).  */
  param_size = (3 + param_size) / 4;

  if (cum->regs_used < NUM_ARG_REGS
      && cum->regs_used + param_size > NUM_ARG_REGS)
    return (NUM_ARG_REGS - cum->regs_used) * UNITS_PER_WORD;
  else
    return 0;
}

static bool 
nios2_pass_by_reference (CUMULATIVE_ARGS *cum ATTRIBUTE_UNUSED,
			 enum machine_mode mode ATTRIBUTE_UNUSED,
			 tree type ATTRIBUTE_UNUSED,
			 bool named ATTRIBUTE_UNUSED)
{
  return false;
}


/* Update the data in CUM to advance over an argument
   of mode MODE and data type TYPE.
   (TYPE is null for libcalls where that information may not be available.)  */

void
function_arg_advance (CUMULATIVE_ARGS *cum, enum machine_mode mode,
                      tree type ATTRIBUTE_UNUSED, int named ATTRIBUTE_UNUSED)
{
  HOST_WIDE_INT param_size;

  if (mode == BLKmode)
    {
      param_size = int_size_in_bytes (type);
      if (param_size < 0)
        internal_error
          ("Do not know how to handle large structs or variable length types");
    }
  else
    param_size = GET_MODE_SIZE (mode);

  /* Convert to words (round up).  */
  param_size = (3 + param_size) / 4;

  if (cum->regs_used + param_size > NUM_ARG_REGS)
    cum->regs_used = NUM_ARG_REGS;
  else
    cum->regs_used += param_size;

  return;
}

int
nios2_function_arg_padding_upward (enum machine_mode mode, tree type)
{
  /* On little-endian targets, the first byte of every stack argument
     is passed in the first byte of the stack slot.  */
  if (!BYTES_BIG_ENDIAN)
    return 1;

  /* Otherwise, integral types are padded downward: the last byte of a
     stack argument is passed in the last byte of the stack slot.  */
  if (type != 0
      ? INTEGRAL_TYPE_P (type) || POINTER_TYPE_P (type)
      : GET_MODE_CLASS (mode) == MODE_INT)
    return 0;

  /* Arguments smaller than a stack slot are padded downward.  */
  if (mode != BLKmode)
    return (GET_MODE_BITSIZE (mode) >= PARM_BOUNDARY) ? 1 : 0;
  else
    return ((int_size_in_bytes (type) >= (PARM_BOUNDARY / BITS_PER_UNIT))
            ? 1 : 0);
}

int
nios2_block_reg_padding_upward (enum machine_mode mode, tree type,
                         int first ATTRIBUTE_UNUSED)
{
  /* ??? Do we need to treat floating point specially, ala MIPS?  */
  return nios2_function_arg_padding_upward (mode, type);
}

int
nios2_return_in_memory (tree type)
{
  int res = ((int_size_in_bytes (type) > (2 * UNITS_PER_WORD))
             || (int_size_in_bytes (type) == -1));

  return res;
}

/* ??? It may be possible to eliminate the copyback and implement
   my own va_arg type, but that is more work for now.  */
void
nios2_setup_incoming_varargs (CUMULATIVE_ARGS *cum,
                              enum machine_mode mode, tree type,
                              int *pretend_size, int second_time)
{
  CUMULATIVE_ARGS local_cum;
  int regs_to_push;
  int pret_size;

  local_cum = *cum;
  FUNCTION_ARG_ADVANCE (local_cum, mode, type, 1);

  regs_to_push = NUM_ARG_REGS - local_cum.regs_used;

  if (!second_time)
    {
      if (regs_to_push > 0)
        {
          rtx ptr, mem;

          ptr = virtual_incoming_args_rtx;
          mem = gen_rtx_MEM (BLKmode, ptr);

          /* va_arg is an array access in this case, which causes
             it to get MEM_IN_STRUCT_P set.  We must set it here
             so that the insn scheduler won't assume that these
             stores can't possibly overlap with the va_arg loads.  */
          MEM_SET_IN_STRUCT_P (mem, 1);

          emit_insn (gen_blockage ());
          move_block_from_reg (local_cum.regs_used + FIRST_ARG_REGNO, mem,
                               regs_to_push);
          emit_insn (gen_blockage ());
        }
    }

  pret_size = regs_to_push * UNITS_PER_WORD;

  if (pret_size)
    *pretend_size = pret_size;
}



/*****************************************************************************
**
** builtins
**
** This method for handling builtins is from CSP where _many_ more types of
** expanders have already been written. Check there first before writing
** new ones.
**
*****************************************************************************/

enum nios2_builtins
{
  NIOS2_BUILTIN_LDBIO,
  NIOS2_BUILTIN_LDBUIO,
  NIOS2_BUILTIN_LDHIO,
  NIOS2_BUILTIN_LDHUIO,
  NIOS2_BUILTIN_LDWIO,
  NIOS2_BUILTIN_STBIO,
  NIOS2_BUILTIN_STHIO,
  NIOS2_BUILTIN_STWIO,
  NIOS2_BUILTIN_SYNC,
  NIOS2_BUILTIN_RDCTL,
  NIOS2_BUILTIN_WRCTL,

#if defined(TARGET_ARCH_NIOS2DPX) && (TARGET_ARCH_NIOS2DPX == 1)
  NIOS2_BUILTIN_SND,
#endif

#undef NIOS2_DO_BUILTIN
#define NIOS2_DO_BUILTIN(upper, lower, handler) \
  NIOS2_CONCAT (NIOS2_BUILTIN_CUSTOM_, upper),
NIOS2_FOR_ALL_CUSTOM_BUILTINS

  NIOS2_FIRST_FPU_INSN,

#undef NIOS2_FPU_INSN
#define NIOS2_FPU_INSN(opt, insn, args) \
  NIOS2_CONCAT (NIOS2_BUILTIN_FPU_, opt),
NIOS2_FOR_ALL_FPU_INSNS

  NIOS2_LAST_FPU_INSN,

  LIM_NIOS2_BUILTINS
};

struct builtin_description
{
    const enum insn_code icode;
    const char *const name;
    const enum nios2_builtins code;
    const tree *type;
    rtx (* expander) (const struct builtin_description *,
                      tree, rtx, rtx, enum machine_mode, int);
};

static rtx nios2_expand_STXIO (const struct builtin_description *,
                               tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_LDXIO (const struct builtin_description *,
                               tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_sync (const struct builtin_description *,
                              tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_rdctl (const struct builtin_description *,
                               tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_wrctl (const struct builtin_description *,
                               tree, rtx, rtx, enum machine_mode, int);

#if defined(TARGET_ARCH_NIOS2DPX) && (TARGET_ARCH_NIOS2DPX == 1)
static rtx nios2_expand_snd (const struct builtin_description *,
                              tree, rtx, rtx, enum machine_mode, int);
#endif

static rtx nios2_expand_custom_n (const struct builtin_description *,
                                  tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_custom_Xn (const struct builtin_description *,
                                   tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_custom_nX (const struct builtin_description *,
                                   tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_custom_XnX (const struct builtin_description *,
                                    tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_custom_nXX (const struct builtin_description *,
                                    tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_custom_XnXX (const struct builtin_description *,
                                     tree, rtx, rtx, enum machine_mode, int);

static rtx nios2_expand_custom_zdz (const struct builtin_description *,
                                    tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_custom_zsz (const struct builtin_description *,
                                    tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_custom_szz (const struct builtin_description *,
                                    tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_custom_sss (const struct builtin_description *,
                                    tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_custom_ssz (const struct builtin_description *,
                                    tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_custom_iss (const struct builtin_description *,
                                    tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_custom_ddd (const struct builtin_description *,
                                    tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_custom_ddz (const struct builtin_description *,
                                    tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_custom_idd (const struct builtin_description *,
                                    tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_custom_siz (const struct builtin_description *,
                                    tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_custom_suz (const struct builtin_description *,
                                    tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_custom_diz (const struct builtin_description *,
                                    tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_custom_duz (const struct builtin_description *,
                                    tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_custom_isz (const struct builtin_description *,
                                    tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_custom_usz (const struct builtin_description *,
                                    tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_custom_idz (const struct builtin_description *,
                                    tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_custom_udz (const struct builtin_description *,
                                    tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_custom_dsz (const struct builtin_description *,
                                    tree, rtx, rtx, enum machine_mode, int);
static rtx nios2_expand_custom_sdz (const struct builtin_description *,
                                    tree, rtx, rtx, enum machine_mode, int);

static tree endlink;

/* int fn (volatile const void *)
 */
static tree int_ftype_volatile_const_void_p;

/* int fn (int)
 */
static tree int_ftype_int;

/* void fn (int, int)
 */
static tree void_ftype_int_int;

/* int fn (int, int)
 */
static tree int_ftype_int_int;

/* void fn (volatile void *, int)
 */
static tree void_ftype_volatile_void_p_int;

/* void fn (void)
 */
static tree void_ftype_void;

#undef NIOS2_DO_BUILTIN
#define NIOS2_DO_BUILTIN(upper, lower, handler) \
  static tree NIOS2_CONCAT (custom_, lower);
NIOS2_FOR_ALL_CUSTOM_BUILTINS

static tree custom_zdz;
static tree custom_zsz;
static tree custom_szz;
static tree custom_sss;
static tree custom_ssz;
static tree custom_iss;
static tree custom_ddd;
static tree custom_ddz;
static tree custom_idd;
static tree custom_siz;
static tree custom_suz;
static tree custom_diz;
static tree custom_duz;
static tree custom_isz;
static tree custom_usz;
static tree custom_idz;
static tree custom_udz;
static tree custom_dsz;
static tree custom_sdz;

static const struct builtin_description bdesc[] = {
    {CODE_FOR_ldbio, "__builtin_ldbio", NIOS2_BUILTIN_LDBIO, 
     &int_ftype_volatile_const_void_p, nios2_expand_LDXIO},
    {CODE_FOR_ldbuio, "__builtin_ldbuio", NIOS2_BUILTIN_LDBUIO, 
     &int_ftype_volatile_const_void_p, nios2_expand_LDXIO},
    {CODE_FOR_ldhio, "__builtin_ldhio", NIOS2_BUILTIN_LDHIO, 
     &int_ftype_volatile_const_void_p, nios2_expand_LDXIO},
    {CODE_FOR_ldhuio, "__builtin_ldhuio", NIOS2_BUILTIN_LDHUIO, 
     &int_ftype_volatile_const_void_p, nios2_expand_LDXIO},
    {CODE_FOR_ldwio, "__builtin_ldwio", NIOS2_BUILTIN_LDWIO, 
     &int_ftype_volatile_const_void_p, nios2_expand_LDXIO},

    {CODE_FOR_stbio, "__builtin_stbio", NIOS2_BUILTIN_STBIO, 
     &void_ftype_volatile_void_p_int, nios2_expand_STXIO},
    {CODE_FOR_sthio, "__builtin_sthio", NIOS2_BUILTIN_STHIO, 
     &void_ftype_volatile_void_p_int, nios2_expand_STXIO},
    {CODE_FOR_stwio, "__builtin_stwio", NIOS2_BUILTIN_STWIO, 
     &void_ftype_volatile_void_p_int, nios2_expand_STXIO},

    {CODE_FOR_sync, "__builtin_sync", NIOS2_BUILTIN_SYNC, 
     &void_ftype_void, nios2_expand_sync},
    {CODE_FOR_rdctl, "__builtin_rdctl", NIOS2_BUILTIN_RDCTL, 
     &int_ftype_int, nios2_expand_rdctl},
    {CODE_FOR_wrctl, "__builtin_wrctl", NIOS2_BUILTIN_WRCTL, 
     &void_ftype_int_int, nios2_expand_wrctl},

#if defined(TARGET_ARCH_NIOS2DPX) && (TARGET_ARCH_NIOS2DPX == 1)
    {CODE_FOR_snd, "__builtin_snd", NIOS2_BUILTIN_SND, 
     &int_ftype_int_int, nios2_expand_snd},
#endif

#undef NIOS2_DO_BUILTIN
#define NIOS2_DO_BUILTIN(upper, lower, handler) \
    {NIOS2_CONCAT (CODE_FOR_custom_, lower), \
     "__builtin_custom_" NIOS2_STRINGIFY (lower), \
     NIOS2_CONCAT (NIOS2_BUILTIN_CUSTOM_, upper), \
     &NIOS2_CONCAT (custom_, lower), \
     NIOS2_CONCAT (nios2_expand_custom_, handler)},
NIOS2_FOR_ALL_CUSTOM_BUILTINS

#undef NIOS2_FPU_INSN
#define NIOS2_FPU_INSN(opt, insn, args) \
    {NIOS2_CONCAT (CODE_FOR_, insn), \
     "__builtin_custom_" NIOS2_STRINGIFY (opt), \
     NIOS2_CONCAT (NIOS2_BUILTIN_FPU_, opt), \
     &NIOS2_CONCAT (custom_, args), \
     NIOS2_CONCAT (nios2_expand_custom_, args)},
NIOS2_FOR_ALL_FPU_INSNS

    {0, 0, 0, 0, 0},
};

static void
nios2_init_builtins (void)
{
  const struct builtin_description *d;


  endlink = void_list_node;

  /* int fn (volatile const void *)
   */
  int_ftype_volatile_const_void_p = build_function_type (
    integer_type_node,
    tree_cons (NULL_TREE, 
	       build_qualified_type (ptr_type_node, 
				     TYPE_QUAL_CONST | TYPE_QUAL_VOLATILE),
               endlink));

  /* void fn (volatile void *, int)
   */
  void_ftype_volatile_void_p_int = build_function_type (
    void_type_node,
    tree_cons (NULL_TREE, 
	       build_qualified_type (ptr_type_node, TYPE_QUAL_VOLATILE),
               tree_cons (NULL_TREE, integer_type_node, endlink)));

  /* void fn (void)
   */
  void_ftype_void
      = build_function_type (void_type_node,
                             endlink);

  /* int fn (int)
   */
  int_ftype_int
      = build_function_type (integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             endlink));

  /* void fn (int, int)
   */
  void_ftype_int_int
      = build_function_type (void_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             endlink)));

  /* int fn (int, int)
   */
  int_ftype_int_int
      = build_function_type (integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             endlink)));


  custom_n
      = build_function_type (void_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             endlink));
  custom_ni
      = build_function_type (void_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             endlink)));
  custom_nf
      = build_function_type (void_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             endlink)));
  custom_np
      = build_function_type (void_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             endlink)));
  custom_nii
      = build_function_type (void_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             endlink))));
  custom_nif
      = build_function_type (void_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             endlink))));
  custom_nip
      = build_function_type (void_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             endlink))));
  custom_nfi
      = build_function_type (void_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             endlink))));
  custom_nff
      = build_function_type (void_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             endlink))));
  custom_nfp
      = build_function_type (void_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             endlink))));
  custom_npi
      = build_function_type (void_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             endlink))));
  custom_npf
      = build_function_type (void_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             endlink))));
  custom_npp
      = build_function_type (void_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             endlink))));

  custom_in
      = build_function_type (integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             endlink));
  custom_ini
      = build_function_type (integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             endlink)));
  custom_inf
      = build_function_type (integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             endlink)));
  custom_inp
      = build_function_type (integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             endlink)));
  custom_inii
      = build_function_type (integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             endlink))));
  custom_inif
      = build_function_type (integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             endlink))));
  custom_inip
      = build_function_type (integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             endlink))));
  custom_infi
      = build_function_type (integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             endlink))));
  custom_inff
      = build_function_type (integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             endlink))));
  custom_infp
      = build_function_type (integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             endlink))));
  custom_inpi
      = build_function_type (integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             endlink))));
  custom_inpf
      = build_function_type (integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             endlink))));
  custom_inpp
      = build_function_type (integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             endlink))));

  custom_fn
      = build_function_type (float_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             endlink));
  custom_fni
      = build_function_type (float_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             endlink)));
  custom_fnf
      = build_function_type (float_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             endlink)));
  custom_fnp
      = build_function_type (float_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             endlink)));
  custom_fnii
      = build_function_type (float_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             endlink))));
  custom_fnif
      = build_function_type (float_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             endlink))));
  custom_fnip
      = build_function_type (float_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             endlink))));
  custom_fnfi
      = build_function_type (float_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             endlink))));
  custom_fnff
      = build_function_type (float_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             endlink))));
  custom_fnfp
      = build_function_type (float_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             endlink))));
  custom_fnpi
      = build_function_type (float_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             endlink))));
  custom_fnpf
      = build_function_type (float_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             endlink))));
  custom_fnpp
      = build_function_type (float_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             endlink))));


  custom_pn
      = build_function_type (ptr_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             endlink));
  custom_pni
      = build_function_type (ptr_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             endlink)));
  custom_pnf
      = build_function_type (ptr_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             endlink)));
  custom_pnp
      = build_function_type (ptr_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             endlink)));
  custom_pnii
      = build_function_type (ptr_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             endlink))));
  custom_pnif
      = build_function_type (ptr_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             endlink))));
  custom_pnip
      = build_function_type (ptr_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             endlink))));
  custom_pnfi
      = build_function_type (ptr_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             endlink))));
  custom_pnff
      = build_function_type (ptr_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             endlink))));
  custom_pnfp
      = build_function_type (ptr_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             endlink))));
  custom_pnpi
      = build_function_type (ptr_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             endlink))));
  custom_pnpf
      = build_function_type (ptr_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             endlink))));
  custom_pnpp
      = build_function_type (ptr_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             tree_cons (NULL_TREE, ptr_type_node,
                             endlink))));

  custom_zdz
      = build_function_type (void_type_node,
                             tree_cons (NULL_TREE, double_type_node,
                             endlink));

  custom_zsz
      = build_function_type (void_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             endlink));

  custom_szz
      = build_function_type (float_type_node,
                             tree_cons (NULL_TREE, void_type_node,
                             endlink));

  custom_sss
      = build_function_type (float_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             endlink)));

  custom_ssz
      = build_function_type (float_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             endlink));

  custom_iss
      = build_function_type (integer_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             endlink)));

  custom_ddd
      = build_function_type (double_type_node,
                             tree_cons (NULL_TREE, double_type_node,
                             tree_cons (NULL_TREE, double_type_node,
                             endlink)));

  custom_ddz
      = build_function_type (double_type_node,
                             tree_cons (NULL_TREE, double_type_node,
                             endlink));

  custom_idd
      = build_function_type (integer_type_node,
                             tree_cons (NULL_TREE, double_type_node,
                             tree_cons (NULL_TREE, double_type_node,
                             endlink)));

  custom_siz
      = build_function_type (float_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             endlink));

  custom_suz
      = build_function_type (float_type_node,
                             tree_cons (NULL_TREE, unsigned_type_node,
                             endlink));

  custom_diz
      = build_function_type (double_type_node,
                             tree_cons (NULL_TREE, integer_type_node,
                             endlink));

  custom_duz
      = build_function_type (double_type_node,
                             tree_cons (NULL_TREE, unsigned_type_node,
                             endlink));

  custom_isz
      = build_function_type (integer_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             endlink));

  custom_usz
      = build_function_type (unsigned_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             endlink));

  custom_idz
      = build_function_type (integer_type_node,
                             tree_cons (NULL_TREE, double_type_node,
                             endlink));

  custom_udz
      = build_function_type (unsigned_type_node,
                             tree_cons (NULL_TREE, double_type_node,
                             endlink));

  custom_dsz
      = build_function_type (double_type_node,
                             tree_cons (NULL_TREE, float_type_node,
                             endlink));

  custom_sdz
      = build_function_type (float_type_node,
                             tree_cons (NULL_TREE, double_type_node,
                             endlink));


  for (d = bdesc; d->name; d++)
    builtin_function (d->name, *d->type, d->code,
                      BUILT_IN_MD, NULL, NULL);
}
/* Expand an expression EXP that calls a built-in function,
   with result going to TARGET if that's convenient
   (and in mode MODE if that's convenient).
   SUBTARGET may be used as the target for computing one of EXP's operands.
   IGNORE is nonzero if the value is to be ignored.  */

static rtx
nios2_expand_builtin (tree exp, rtx target, rtx subtarget,
                      enum machine_mode mode, int ignore)
{
  const struct builtin_description *d;
  tree fndecl = TREE_OPERAND (TREE_OPERAND (exp, 0), 0);
  unsigned int fcode = DECL_FUNCTION_CODE (fndecl);

  for (d = bdesc; d->name; d++)
    if (d->code == fcode)
      {
        if (d->code > NIOS2_FIRST_FPU_INSN && d->code < NIOS2_LAST_FPU_INSN)
          {
            nios2_fpu_info *inf = &nios2_fpu_insns[d->code - 
					           (NIOS2_FIRST_FPU_INSN + 1)];
            const struct insn_data *idata = &insn_data[d->icode];
            if (inf->N < 0)
              fatal_error ("Cannot call `%s' without specifying switch"
			   " `-mcustom-%s'",
                           d->name,
                           inf->option);
            if (inf->args[0] != 'z'
                && (!target
                    || !(idata->operand[0].predicate) (target,
                                                       idata->operand[0].mode)))
              target = gen_reg_rtx (idata->operand[0].mode);
          }
        return (d->expander) (d, exp, target, subtarget, mode, ignore);
      }

  /* We should have seen one of the functins we registered.  */
  gcc_unreachable ();
}

static rtx nios2_create_target (const struct builtin_description *, rtx);


static rtx
nios2_create_target (const struct builtin_description *d, rtx target)
{
  if (!target
      || !(*insn_data[d->icode].operand[0].predicate) (
	     target, insn_data[d->icode].operand[0].mode))
    {
      target = gen_reg_rtx (insn_data[d->icode].operand[0].mode);
    }

  return target;
}


static rtx nios2_extract_opcode (const struct builtin_description *, int, tree);
static rtx nios2_extract_operand (const struct builtin_description *, int, int, 
				  tree);
static rtx
nios2_extract_integer (const struct insn_data *idata, tree arglist, int index);

static rtx
nios2_extract_opcode (const struct builtin_description *d, int op, tree arglist)
{
  enum machine_mode mode = insn_data[d->icode].operand[op].mode;
  tree arg = TREE_VALUE (arglist);
  rtx opcode = expand_expr (arg, NULL_RTX, mode, 0);

  if (!(*insn_data[d->icode].operand[op].predicate) (opcode, mode))
    error ("Custom instruction opcode must be compile time constant in the "
	   "range 0-255 for %s", d->name);

  builtin_custom_seen[INTVAL (opcode)] = d->name;
  nios2_custom_check_insns (0);
  return opcode;
}

static rtx
nios2_extract_operand (const struct builtin_description *d, int op, int argnum, 
		       tree arglist)
{
  enum machine_mode mode = insn_data[d->icode].operand[op].mode;
  tree arg = TREE_VALUE (arglist);
  rtx operand = expand_expr (arg, NULL_RTX, mode, 0);

  if (!(*insn_data[d->icode].operand[op].predicate) (operand, mode))
    operand = copy_to_mode_reg (mode, operand);

  /* ??? Better errors would be nice.  */
  if (!(*insn_data[d->icode].operand[op].predicate) (operand, mode))
    error ("Invalid argument %d to %s", argnum, d->name);

  return operand;
}


static rtx
nios2_expand_custom_n (const struct builtin_description *d, tree exp,
                       rtx target ATTRIBUTE_UNUSED, 
		       rtx subtarget ATTRIBUTE_UNUSED,
                       enum machine_mode mode ATTRIBUTE_UNUSED, 
		       int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat;
  rtx opcode;

  /* custom_n should have exactly one operand.  */
  gcc_assert (insn_data[d->icode].n_operands == 1);

  opcode = nios2_extract_opcode (d, 0, arglist);

  pat = GEN_FCN (d->icode) (opcode);
  if (!pat)
    return 0;
  emit_insn (pat);
  return 0;
}

static rtx
nios2_expand_custom_Xn (const struct builtin_description *d, tree exp,
                        rtx target, rtx subtarget ATTRIBUTE_UNUSED,
                        enum machine_mode mode ATTRIBUTE_UNUSED,
                        int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat;
  rtx opcode;

  /* custom_Xn should have exactly two operands.  */
  gcc_assert (insn_data[d->icode].n_operands == 2);

  target = nios2_create_target (d, target);
  opcode = nios2_extract_opcode (d, 1, arglist);

  pat = GEN_FCN (d->icode) (target, opcode);
  if (!pat)
    return 0;
  emit_insn (pat);
  return target;
}

static rtx
nios2_expand_custom_nX (const struct builtin_description *d, tree exp,
                        rtx target ATTRIBUTE_UNUSED, 
		        rtx subtarget ATTRIBUTE_UNUSED,
                        enum machine_mode mode ATTRIBUTE_UNUSED, 
			int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat;
  rtx opcode;
  rtx operands[1];
  int i;


  /* custom_nX should have exactly two operands.  */
  gcc_assert (insn_data[d->icode].n_operands == 2);

  opcode = nios2_extract_opcode (d, 0, arglist);
  for (i = 0; i < 1; i++)
    {
      arglist = TREE_CHAIN (arglist);
      operands[i] = nios2_extract_operand (d, i + 1, i + 1, arglist);
    }

  pat = GEN_FCN (d->icode) (opcode, operands[0]);
  if (!pat)
    return 0;
  emit_insn (pat);
  return 0;
}

static rtx
nios2_expand_custom_XnX (const struct builtin_description *d, tree exp, 
			 rtx target, rtx subtarget ATTRIBUTE_UNUSED, 
			 enum machine_mode mode ATTRIBUTE_UNUSED,
                         int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat;
  rtx opcode;
  rtx operands[1];
  int i;

  /* custom_Xn should have exactly three operands.  */
  gcc_assert (insn_data[d->icode].n_operands == 3);

  target = nios2_create_target (d, target);
  opcode = nios2_extract_opcode (d, 1, arglist);

  for (i = 0; i < 1; i++)
    {
      arglist = TREE_CHAIN (arglist);
      operands[i] = nios2_extract_operand (d, i + 2, i + 1, arglist);
    }

  pat = GEN_FCN (d->icode) (target, opcode, operands[0]);

  if (!pat)
    return 0;
  emit_insn (pat);
  return target;
}

static rtx
nios2_expand_custom_nXX (const struct builtin_description *d, tree exp, 
			 rtx target ATTRIBUTE_UNUSED, 
			 rtx subtarget ATTRIBUTE_UNUSED, 
			 enum machine_mode mode ATTRIBUTE_UNUSED,
                         int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat;
  rtx opcode;
  rtx operands[2];
  int i;


  /* custom_nX should have exactly three operands.  */
  gcc_assert (insn_data[d->icode].n_operands == 3);

  opcode = nios2_extract_opcode (d, 0, arglist);
  for (i = 0; i < 2; i++)
    {
      arglist = TREE_CHAIN (arglist);
      operands[i] = nios2_extract_operand (d, i + 1, i + 1, arglist);
    }

  pat = GEN_FCN (d->icode) (opcode, operands[0], operands[1]);
  if (!pat)
    return 0;
  emit_insn (pat);
  return 0;
}

static rtx
nios2_expand_custom_XnXX (const struct builtin_description *d, tree exp, 
			  rtx target, rtx subtarget ATTRIBUTE_UNUSED, 
			  enum machine_mode mode ATTRIBUTE_UNUSED,
                          int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat;
  rtx opcode;
  rtx operands[2];
  int i;


  /* custom_XnX should have exactly four operands.  */
  gcc_assert (insn_data[d->icode].n_operands == 4);

  target = nios2_create_target (d, target);
  opcode = nios2_extract_opcode (d, 1, arglist);
  for (i = 0; i < 2; i++)
    {
      arglist = TREE_CHAIN (arglist);
      operands[i] = nios2_extract_operand (d, i + 2, i + 1, arglist);
    }

  pat = GEN_FCN (d->icode) (target, opcode, operands[0], operands[1]);

  if (!pat)
    return 0;
  emit_insn (pat);
  return target;
}



static rtx
nios2_expand_STXIO (const struct builtin_description *d, tree exp, 
		    rtx target ATTRIBUTE_UNUSED, 
		    rtx subtarget ATTRIBUTE_UNUSED, 
		    enum machine_mode mode ATTRIBUTE_UNUSED,
                    int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat;
  rtx store_dest, store_val;
  enum insn_code icode = d->icode;

  /* Stores should have exactly two operands.  */
  gcc_assert (insn_data[icode].n_operands == 2);

  /* Process the destination of the store.  */
  {
    enum machine_mode mode = insn_data[icode].operand[0].mode;
    tree arg = TREE_VALUE (arglist);
    store_dest = expand_expr (arg, NULL_RTX, VOIDmode, 0);

    store_dest = gen_rtx_MEM (mode, copy_to_mode_reg (Pmode, store_dest));

    /* ??? Better errors would be nice.  */
    if (!(*insn_data[icode].operand[0].predicate) (store_dest, mode))
      error ("Invalid argument 1 to %s", d->name);
  }


  /* Process the value to store.  */
  {
    enum machine_mode mode = insn_data[icode].operand[1].mode;
    tree arg = TREE_VALUE (TREE_CHAIN (arglist));
    store_val = expand_expr (arg, NULL_RTX, mode, 0);

    if (!(*insn_data[icode].operand[1].predicate) (store_val, mode))
      store_val = copy_to_mode_reg (mode, store_val);

    /* ??? Better errors would be nice.  */
    if (!(*insn_data[icode].operand[1].predicate) (store_val, mode))
      error ("Invalid argument 2 to %s", d->name);
  }

  pat = GEN_FCN (d->icode) (store_dest, store_val);
  if (!pat)
    return 0;
  emit_insn (pat);
  return 0;
}


static rtx
nios2_expand_LDXIO (const struct builtin_description * d, tree exp, rtx target,
                    rtx subtarget ATTRIBUTE_UNUSED, 
		    enum machine_mode mode ATTRIBUTE_UNUSED,
                    int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat;
  rtx ld_src;
  enum insn_code icode = d->icode;

  /* Loads should have exactly two operands.  */
  gcc_assert (insn_data[icode].n_operands == 2);

  target = nios2_create_target (d, target);

  {
    enum machine_mode mode = insn_data[icode].operand[1].mode;
    tree arg = TREE_VALUE (arglist);
    ld_src = expand_expr (arg, NULL_RTX, VOIDmode, 0);

    ld_src = gen_rtx_MEM (mode, copy_to_mode_reg (Pmode, ld_src));

    /* ??? Better errors would be nice.  */
    if (!(*insn_data[icode].operand[1].predicate) (ld_src, mode))
      error ("Invalid argument 1 to %s", d->name);
  }

  pat = GEN_FCN (d->icode) (target, ld_src);
  if (!pat)
    return 0;
  emit_insn (pat);
  return target;
}


static rtx
nios2_expand_sync (const struct builtin_description * d ATTRIBUTE_UNUSED,
                   tree exp ATTRIBUTE_UNUSED, rtx target ATTRIBUTE_UNUSED,
                   rtx subtarget ATTRIBUTE_UNUSED,
                   enum machine_mode mode ATTRIBUTE_UNUSED,
                   int ignore ATTRIBUTE_UNUSED)
{
  emit_insn (gen_sync ());
  return 0;
}

static rtx
nios2_expand_rdctl (const struct builtin_description * d ATTRIBUTE_UNUSED,
                   tree exp ATTRIBUTE_UNUSED, rtx target ATTRIBUTE_UNUSED,
                   rtx subtarget ATTRIBUTE_UNUSED,
                   enum machine_mode mode ATTRIBUTE_UNUSED,
                   int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat;
  rtx rdctl_reg;
  enum insn_code icode = d->icode;

  /* rdctl should have exactly two operands.  */
  gcc_assert (insn_data[icode].n_operands == 2);

  target = nios2_create_target (d, target);

  {
    enum machine_mode mode = insn_data[icode].operand[1].mode;
    tree arg = TREE_VALUE (arglist);
    rdctl_reg = expand_expr (arg, NULL_RTX, VOIDmode, 0);

    if (!(*insn_data[icode].operand[1].predicate) (rdctl_reg, mode))
      error ("Control register number must be in range 0-31 for %s", d->name);
  }

  pat = GEN_FCN (d->icode) (target, rdctl_reg);
  if (!pat)
    return 0;
  emit_insn (pat);
  return target;
}

static rtx
nios2_expand_wrctl (const struct builtin_description * d ATTRIBUTE_UNUSED,
                   tree exp ATTRIBUTE_UNUSED, rtx target ATTRIBUTE_UNUSED,
                   rtx subtarget ATTRIBUTE_UNUSED,
                   enum machine_mode mode ATTRIBUTE_UNUSED,
                   int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat;
  rtx wrctl_reg, store_val;
  enum insn_code icode = d->icode;

  /* Stores should have exactly two operands.  */
  gcc_assert (insn_data[icode].n_operands == 2);

  /* Process the destination of the store.  */
  {
    enum machine_mode mode = insn_data[icode].operand[0].mode;
    tree arg = TREE_VALUE (arglist);
    wrctl_reg = expand_expr (arg, NULL_RTX, VOIDmode, 0);

    if (!(*insn_data[icode].operand[0].predicate) (wrctl_reg, mode))
      error ("Control register number must be in range 0-31 for %s", d->name);
  }


  /* Process the value to store.  */
  {
    enum machine_mode mode = insn_data[icode].operand[1].mode;
    tree arg = TREE_VALUE (TREE_CHAIN (arglist));
    store_val = expand_expr (arg, NULL_RTX, mode, 0);

    if (!(*insn_data[icode].operand[1].predicate) (store_val, mode))
      store_val = copy_to_mode_reg (mode, store_val);

    /* ??? Better errors would be nice.  */
    if (!(*insn_data[icode].operand[1].predicate) (store_val, mode))
      error ("Invalid argument 2 to %s", d->name);
  }

  pat = GEN_FCN (d->icode) (wrctl_reg, store_val);
  if (!pat)
    return 0;
  emit_insn (pat);
  return 0;
}

#if defined(TARGET_ARCH_NIOS2DPX) && (TARGET_ARCH_NIOS2DPX == 1)
static rtx
nios2_expand_snd (const struct builtin_description * d,
                   tree exp, rtx target,
                   rtx subtarget ATTRIBUTE_UNUSED,
                   enum machine_mode mode ATTRIBUTE_UNUSED,
                   int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat = GEN_FCN (d->icode) (target,
                                nios2_extract_integer (&insn_data[d->icode],
                                                      arglist, 0),
                                nios2_extract_integer (&insn_data[d->icode],
                                                      arglist, 1));
  if (pat) 
      emit_insn (pat);

  return target;
}
#endif

static rtx
nios2_extract_double (const struct insn_data *idata, tree arglist, int index)
{
  rtx arg;

  while (index--)
    arglist = TREE_CHAIN (arglist);
  arg = expand_expr (TREE_VALUE (arglist), NULL_RTX, DFmode, 0);
  if (!(*(idata->operand[index+1].predicate)) (arg, DFmode))
    arg = copy_to_mode_reg (DFmode, arg);
  return arg;
}

static rtx
nios2_extract_float (const struct insn_data *idata, tree arglist, int index)
{
  rtx arg;

  while (index--)
    arglist = TREE_CHAIN (arglist);
  arg = expand_expr (TREE_VALUE (arglist), NULL_RTX, SFmode, 0);
  if (!(*(idata->operand[index+1].predicate)) (arg, SFmode))
    arg = copy_to_mode_reg (SFmode, arg);
  return arg;
}

static rtx
nios2_extract_integer (const struct insn_data *idata, tree arglist, int index)
{
  rtx arg;

  while (index--)
    arglist = TREE_CHAIN (arglist);
  arg = expand_expr (TREE_VALUE (arglist), NULL_RTX, SImode, 0);
  if (!(*(idata->operand[index+1].predicate)) (arg, SImode))
    arg = copy_to_mode_reg (SImode, arg);
  return arg;
}

static rtx
nios2_expand_custom_zdz (const struct builtin_description *d,
                         tree exp,
                         rtx target ATTRIBUTE_UNUSED,
                         rtx subtarget ATTRIBUTE_UNUSED,
                         enum machine_mode mode ATTRIBUTE_UNUSED,
                         int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat = GEN_FCN (d->icode) (nios2_extract_double (&insn_data[d->icode],
                                                      arglist, 0));
  if (pat)
    emit_insn (pat);
  return 0;
}

static rtx
nios2_expand_custom_zsz (const struct builtin_description *d,
                         tree exp,
                         rtx target ATTRIBUTE_UNUSED,
                         rtx subtarget ATTRIBUTE_UNUSED,
                         enum machine_mode mode ATTRIBUTE_UNUSED,
                         int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat = GEN_FCN (d->icode) (nios2_extract_float (&insn_data[d->icode],
                                                     arglist, 0));
  if (pat)
    emit_insn (pat);
  return 0;
}

static rtx
nios2_expand_custom_szz (const struct builtin_description *d,
                         tree exp ATTRIBUTE_UNUSED,
                         rtx target,
                         rtx subtarget ATTRIBUTE_UNUSED,
                         enum machine_mode mode ATTRIBUTE_UNUSED,
                         int ignore ATTRIBUTE_UNUSED)
{
  rtx pat = GEN_FCN (d->icode) (target);
  if (pat)
    emit_insn (pat);
  return target;
}

static rtx
nios2_expand_custom_sss (const struct builtin_description *d,
                         tree exp,
                         rtx target,
                         rtx subtarget ATTRIBUTE_UNUSED,
                         enum machine_mode mode ATTRIBUTE_UNUSED,
                         int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat = GEN_FCN (d->icode) (target,
                                nios2_extract_float (&insn_data[d->icode],
                                                     arglist, 0),
                                nios2_extract_float (&insn_data[d->icode],
                                                     arglist, 1));
  if (pat)
    emit_insn (pat);
  return target;
}

static rtx
nios2_expand_custom_ssz (const struct builtin_description *d,
                         tree exp,
                         rtx target,
                         rtx subtarget ATTRIBUTE_UNUSED,
                         enum machine_mode mode ATTRIBUTE_UNUSED,
                         int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat = GEN_FCN (d->icode) (target,
                                nios2_extract_float (&insn_data[d->icode],
                                                     arglist, 0));
  if (pat)
    emit_insn (pat);
  return target;
}

static rtx
nios2_expand_custom_iss (const struct builtin_description *d,
                         tree exp,
                         rtx target,
                         rtx subtarget ATTRIBUTE_UNUSED,
                         enum machine_mode mode ATTRIBUTE_UNUSED,
                         int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat = GEN_FCN (d->icode) (target,
                                nios2_extract_float (&insn_data[d->icode],
                                                     arglist, 0),
                                nios2_extract_float (&insn_data[d->icode],
                                                     arglist, 1));
  if (pat)
    emit_insn (pat);
  return target;
}

static rtx
nios2_expand_custom_ddd (const struct builtin_description *d,
                         tree exp,
                         rtx target,
                         rtx subtarget ATTRIBUTE_UNUSED,
                         enum machine_mode mode ATTRIBUTE_UNUSED,
                         int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat = GEN_FCN (d->icode) (target,
                                nios2_extract_double (&insn_data[d->icode],
                                                      arglist, 0),
                                nios2_extract_double (&insn_data[d->icode],
                                                      arglist, 1));
  if (pat)
    emit_insn (pat);
  return target;
}

static rtx
nios2_expand_custom_ddz (const struct builtin_description *d,
                         tree exp,
                         rtx target,
                         rtx subtarget ATTRIBUTE_UNUSED,
                         enum machine_mode mode ATTRIBUTE_UNUSED,
                         int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat = GEN_FCN (d->icode) (target,
                                nios2_extract_double (&insn_data[d->icode],
                                                      arglist, 0));
  if (pat)
    emit_insn (pat);
  return target;
}

static rtx
nios2_expand_custom_idd (const struct builtin_description *d,
                         tree exp,
                         rtx target,
                         rtx subtarget ATTRIBUTE_UNUSED,
                         enum machine_mode mode ATTRIBUTE_UNUSED,
                         int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat = GEN_FCN (d->icode) (target,
                                nios2_extract_double (&insn_data[d->icode],
                                                      arglist, 0),
                                nios2_extract_double (&insn_data[d->icode],
                                                      arglist, 1));
  if (pat)
    emit_insn (pat);
  return target;
}

static rtx
nios2_expand_custom_siz (const struct builtin_description *d,
                         tree exp,
                         rtx target,
                         rtx subtarget ATTRIBUTE_UNUSED,
                         enum machine_mode mode ATTRIBUTE_UNUSED,
                         int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat = GEN_FCN (d->icode) (target,
                                nios2_extract_integer (&insn_data[d->icode],
                                                       arglist, 0));
  if (pat)
    emit_insn (pat);
  return target;
}

static rtx
nios2_expand_custom_suz (const struct builtin_description *d,
                         tree exp,
                         rtx target,
                         rtx subtarget ATTRIBUTE_UNUSED,
                         enum machine_mode mode ATTRIBUTE_UNUSED,
                         int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat = GEN_FCN (d->icode) (target,
                                nios2_extract_integer (&insn_data[d->icode],
                                                       arglist, 0));
  if (pat)
    emit_insn (pat);
  return target;
}

static rtx
nios2_expand_custom_diz (const struct builtin_description *d,
                         tree exp,
                         rtx target,
                         rtx subtarget ATTRIBUTE_UNUSED,
                         enum machine_mode mode ATTRIBUTE_UNUSED,
                         int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat = GEN_FCN (d->icode) (target,
                                nios2_extract_integer (&insn_data[d->icode],
                                                       arglist, 0));
  if (pat)
    emit_insn (pat);
  return target;
}

static rtx
nios2_expand_custom_duz (const struct builtin_description *d,
                         tree exp,
                         rtx target,
                         rtx subtarget ATTRIBUTE_UNUSED,
                         enum machine_mode mode ATTRIBUTE_UNUSED,
                         int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat = GEN_FCN (d->icode) (target,
                                nios2_extract_integer (&insn_data[d->icode],
                                                       arglist, 0));
  if (pat)
    emit_insn (pat);
  return target;
}

static rtx
nios2_expand_custom_isz (const struct builtin_description *d,
                         tree exp,
                         rtx target,
                         rtx subtarget ATTRIBUTE_UNUSED,
                         enum machine_mode mode ATTRIBUTE_UNUSED,
                         int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat = GEN_FCN (d->icode) (target,
                                nios2_extract_float (&insn_data[d->icode],
                                                     arglist, 0));
  if (pat)
    emit_insn (pat);
  return target;
}

static rtx
nios2_expand_custom_usz (const struct builtin_description *d,
                         tree exp,
                         rtx target,
                         rtx subtarget ATTRIBUTE_UNUSED,
                         enum machine_mode mode ATTRIBUTE_UNUSED,
                         int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat = GEN_FCN (d->icode) (target,
                                nios2_extract_float (&insn_data[d->icode],
                                                     arglist, 0));
  if (pat)
    emit_insn (pat);
  return target;
}

static rtx
nios2_expand_custom_idz (const struct builtin_description *d,
                         tree exp,
                         rtx target,
                         rtx subtarget ATTRIBUTE_UNUSED,
                         enum machine_mode mode ATTRIBUTE_UNUSED,
                         int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat = GEN_FCN (d->icode) (target,
                                nios2_extract_double (&insn_data[d->icode],
                                                      arglist, 0));
  if (pat)
    emit_insn (pat);
  return target;
}

static rtx
nios2_expand_custom_udz (const struct builtin_description *d,
                         tree exp,
                         rtx target,
                         rtx subtarget ATTRIBUTE_UNUSED,
                         enum machine_mode mode ATTRIBUTE_UNUSED,
                         int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat = GEN_FCN (d->icode) (target,
                                nios2_extract_double (&insn_data[d->icode],
                                                      arglist, 0));
  if (pat)
    emit_insn (pat);
  return target;
}

static rtx
nios2_expand_custom_dsz (const struct builtin_description *d,
                         tree exp,
                         rtx target,
                         rtx subtarget ATTRIBUTE_UNUSED,
                         enum machine_mode mode ATTRIBUTE_UNUSED,
                         int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat = GEN_FCN (d->icode) (target,
                                nios2_extract_float (&insn_data[d->icode],
                                                     arglist, 0));
  if (pat)
    emit_insn (pat);
  return target;
}

static rtx
nios2_expand_custom_sdz (const struct builtin_description *d,
                         tree exp,
                         rtx target,
                         rtx subtarget ATTRIBUTE_UNUSED,
                         enum machine_mode mode ATTRIBUTE_UNUSED,
                         int ignore ATTRIBUTE_UNUSED)
{
  tree arglist = TREE_OPERAND (exp, 1);
  rtx pat = GEN_FCN (d->icode) (target,
                                nios2_extract_double (&insn_data[d->icode],
                                                      arglist, 0));
  if (pat)
    emit_insn (pat);
  return target;
}

#include "gt-nios2.h"

