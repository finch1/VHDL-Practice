;; Machine Description for the RMI XLR Microprocessor
;; Copyright (C) 2006 Raza Microelectronics, Inc. (RMI)
;;
;; This program is free software.  You may use it, redistribute it
;; and/or modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version two
;; of the License or (at your option) any later version.
;;
;; This program is distributed in the hope that you will find it
;; useful.  Notwithstanding the foregoing, you understand and agree
;; that this program is provided by RMI as is, and without any
;; warranties, whether express, implied or statutory, including without
;; limitation any implied warranty of non-infringement, merchantability
;; or fitness for a particular purpose.  In no event will RMI be liable
;; for any loss of data, lost profits, cost of procurement of substitute
;; technology or services or for any direct, indirect, incidental,
;; consequential or special damages arising from the use of this program,
;; however caused.  Your unconditional agreement to these terms and
;; conditions is an express condition to, and shall be deemed to occur
;; upon, your use, redistribution and/or modification of this program.
;;
;; See the GNU General Public License for more details.

(define_automaton "xlr_main,xlr_muldiv")

;; definitions for xlr_main automaton
(define_cpu_unit "xlr_main_pipe" "xlr_main")

(define_insn_reservation "ir_xlr_alu_slt" 2
	(and  (eq_attr "cpu" "xlr") 
		(eq_attr "type" "slt"))
	"xlr_main_pipe")

;; integer arithmetic instructions
(define_insn_reservation "ir_xlr_alu" 1
	(and  (eq_attr "cpu" "xlr") 
		(eq_attr "type" "move,arith,shift,clz,logical,signext,const,unknown,multi,nop"))
	"xlr_main_pipe")

;; integer arithmetic instructions
(define_insn_reservation "ir_xlr_condmove" 2
	(and  (eq_attr "cpu" "xlr") 
		(eq_attr "type" "condmove"))
	"xlr_main_pipe")

;; load/store instructions
(define_insn_reservation "ir_xlr_load" 4
	(and  (eq_attr "cpu" "xlr") (eq_attr "type" "load"))
	"xlr_main_pipe")

(define_insn_reservation "ir_xlr_store" 1
	(and  (eq_attr "cpu" "xlr") (eq_attr "type" "store"))
	"xlr_main_pipe")

(define_insn_reservation "ir_xlr_branch" 1
	(and  (eq_attr "cpu" "xlr") (eq_attr "type" "branch,jump,call"))
	"xlr_main_pipe")

;; coprocessor move instructions
(define_insn_reservation "ir_xlr_xfer" 2
	(and  (eq_attr "cpu" "xlr") (eq_attr "type" "mfc,mtc"))
	"xlr_main_pipe")

(define_bypass 1 "ir_xlr_alu_slt" "ir_xlr_branch")
(define_bypass 5 "ir_xlr_xfer" "ir_xlr_xfer")

;; definitions for the xlr_muldiv automaton
(define_cpu_unit "xlr_imuldiv_nopipe" "xlr_muldiv")

(define_insn_reservation "ir_xlr_imul" 8
	(and  (eq_attr "cpu" "xlr") (eq_attr "type" "imul,imul3,imadd"))
	"xlr_main_pipe,xlr_imuldiv_nopipe*6")

(define_insn_reservation "ir_xlr_div" 68
	(and  (eq_attr "cpu" "xlr") (eq_attr "type" "idiv"))
	"xlr_main_pipe,xlr_imuldiv_nopipe*67")

(define_insn_reservation "xlr_hilo" 2
	(and (eq_attr "cpu" "xlr") (eq_attr "type" "mfhilo,mthilo"))
	"xlr_imuldiv_nopipe")
	
