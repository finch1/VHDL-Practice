;; Predicate definitions for Altera Nios2
;; Copyright (C) 2009 Free Software Foundation, Inc.
;;
;; This file is part of GCC.
;;
;; GCC is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; GCC is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU CC; see the file COPYING.  If not, write to
;; the Free Software Foundation, 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.  */


;; ToDo -- move predicates from nios2.c (line 2785) to this file

;; ;; Return 1 if OP is the zero constant for MODE.
;; (define_predicate "const0_operand"
;;   (and (match_code "const_int,const_double,const_vector")
;;       (match_test "op == CONST0_RTX (mode)")))

;; ;; Returns true if OP is either the constant zero or a register.
;; (define_predicate "reg_or_0_operand"
;;   (ior (match_operand 0 "register_operand")
;;        (match_operand 0 "const0_operand")))


(define_predicate "register_src_operand"
  (match_code "subreg,reg")
{
  if ((GET_CODE (op) == REG && !REG_OK_FOR_READ (op)))
      return 0;
  return register_operand (op, mode);
})


(define_predicate "register_dest_operand"
  (match_code "subreg,reg")
{
  if ((GET_CODE (op) == REG && !REG_OK_FOR_WRITE (op)))
      return 0;
  return register_operand (op, mode);
})


(define_predicate "general_src_operand"
  (match_code "const_int,const_double,const,symbol_ref,label_ref,subreg,reg,mem")
{
  if ((GET_CODE (op) == REG && !REG_OK_FOR_READ (op)))
      return 0;           
  return general_operand (op, mode);
})


(define_predicate "nonimmediate_src_operand"
  (match_code "subreg,reg,mem")
{
  if ((GET_CODE (op) == REG && !REG_OK_FOR_READ (op)))
      return 0;
  return nonimmediate_operand (op, mode);
})


(define_predicate "nonimmediate_dest_operand"
  (match_code "subreg,reg,mem")
{
  if ((GET_CODE (op) == REG && !REG_OK_FOR_WRITE (op)))
      return 0;
  return nonimmediate_operand (op, mode);
})


(define_predicate "arith_src_operand"
 (match_code "const_int,const,subreg,reg")
{
 if ((GET_CODE (op) == REG && !REG_OK_FOR_READ (op)))
     return 0;
 return arith_operand (op, mode);
})


(define_predicate "uns_arith_src_operand"
 (match_code "const_int,const,subreg,reg")
{
 if ((GET_CODE (op) == REG && !REG_OK_FOR_READ (op)))
     return 0;
 return uns_arith_operand (op, mode);
})


(define_predicate "logical_src_operand"
 (match_code "const_int,const,subreg,reg")
{
 if ((GET_CODE (op) == REG && !REG_OK_FOR_READ (op)))
     return 0;
 return logical_operand (op, mode);
})


(define_predicate "reg_or_0_src_operand"
 (match_code "subreg,reg")
{
 if ((GET_CODE (op) == REG && !REG_OK_FOR_READ (op)))
     return 0;
 return reg_or_0_operand (op, mode);
})
