;; NOT ASSIGNED TO FSF.  COPYRIGHT ALTERA.
;;
;; Machine Description for Altera NIOS 2 DPX.
;;    Copyright (C) 2005 Altera 
;;    Contributed by Jonah Graham (jgraham@altera.com) and 
;;      Will Reece (wreece@altera.com).
;; 
;; This file is part of GNU CC.
;; 
;; GNU CC is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;; 
;; GNU CC is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License
;; along with GNU CC; see the file COPYING.  If not, write to
;; the Free Software Foundation, 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.  */




;*****************************************************************************
;*
;* constraint strings
;*
;*****************************************************************************
;
; We use the following constraint letters for constants
;
;
;  I: -32768 to -32767
;  J: 0 to 65535
;  K: $nnnn0000 for some nnnn
;  L: 0 to 31 (for shift counts)
;  M: 0
;  N: 0 to 255 (for custom instruction numbers)
;  O: 0 to 31 (for control register numbers)
;
;  /* for 6b */
;  P: -2048 to 2047
;  Q: 0 to 4095
;  R: $nnnnn000 for some nnnnn
;
; We use the following built-in register classes:
;
;  r: general purpose register (r0..r31)
;  m: memory operand
;  i: An immediate integer operand (one with constant value).

;; `i'
;;     An immediate integer operand (one with constant value) is allowed. This includes symbolic constants whose values will be known only at assembly time or later.


;; `n'
;;     An immediate integer operand with a known numeric value is allowed. Many systems cannot support assembly-time constants for operands less than a word wide. Constraints for these operands should use `n' rather than `i'.


;
; Plus, we define the following constraint strings:
;
;  S: symbol that is in the "small data" area
;  Dnn: Dnn_REG (just rnn)
;
;
;
; Output FILE stream modified by LETTER. %LETTER
; can be one of:
;    i: print "i" if OP is an immediate, except 0
;    o: print "io" if OP is volatile
;
;    z: for const0_rtx print $0 instead of 0
;    H: for %hiadj
;    L: for %lo
;
;    T: for %hiadj20
;    B: for %lo12
;
;    U: for upper half of 32 bit value
;    D: for the upper 32-bits of a 64-bit double value
 ;



;*****************************************************************************
;*
;* constants
;*
;*****************************************************************************

;; Register Numbers
(define_constants
  [(R0_REGNUM        0)		; Zero Register
   (SCRATCH_REGNUM  24)		; Compiler Scratch register

   (TX0_REGNUM      72)
   (TX1_REGNUM      73)
   (TX2_REGNUM      74)
   (TX3_REGNUM      75)
   (TX4_REGNUM      76)
   (TX5_REGNUM      77)
   (TX6_REGNUM      78)
   (TX7_REGNUM      79)
   (TX8_REGNUM      80)
   (TX9_REGNUM      81)
   (TX10_REGNUM     82)
   (TX11_REGNUM     83)
   (TX12_REGNUM     84)
   (TX13_REGNUM     85)
   (TX14_REGNUM     86)
   (TX15_REGNUM     87)
   (TX16_REGNUM     88)
   (TX17_REGNUM     89)
   (TX18_REGNUM     90)
   (TX19_REGNUM     91)
   (TX20_REGNUM     92)
   (TX21_REGNUM     93)
   (TX22_REGNUM     94)
   (TX23_REGNUM     95)
   (TX24_REGNUM     96)
   (TX25_REGNUM     97)
   (TX26_REGNUM     98)
   (TX27_REGNUM     99)
   (TX28_REGNUM    100)
   (TX29_REGNUM    101)
   (TX30_REGNUM    102)
   (TX31_REGNUM    103)

   (CRO0_REGNUM     168)
   (CRO1_REGNUM     169)
   (CRO2_REGNUM     170)
   (CRO3_REGNUM     171)
   (CRO4_REGNUM     172)
   (CRO5_REGNUM     173)
   (CRO6_REGNUM     174)
   (CRO7_REGNUM     175)
   (CRO8_REGNUM     176)
   (CRO9_REGNUM     177)
   (CRO10_REGNUM    178)
   (CRO11_REGNUM    179)
   (CRO12_REGNUM    180)
   (CRO13_REGNUM    181)
   (CRO14_REGNUM    182)
   (CRO15_REGNUM    183)
   (CRO16_REGNUM    184)
   (CRO17_REGNUM    185)
   (CRO18_REGNUM    186)
   (CRO19_REGNUM    187)
   (CRO20_REGNUM    188)
   (CRO21_REGNUM    189)
   (CRO22_REGNUM    190)
   (CRO23_REGNUM    191)
   (CRO24_REGNUM    192)
   (CRO25_REGNUM    193)
   (CRO26_REGNUM    194)
   (CRO27_REGNUM    195)
   (CRO28_REGNUM    196)
   (CRO29_REGNUM    197)
   (CRO30_REGNUM    198)
   (CRO31_REGNUM    199)

  ]
)

;; These are used with unspec_volatile.
(define_constants [
  (UNSPEC_BLOCKAGE 0)
  (UNSPEC_LDBIO 1)
  (UNSPEC_LDBUIO 2)
  (UNSPEC_LDHIO 3)
  (UNSPEC_LDHUIO 4)
  (UNSPEC_LDWIO 5)
  (UNSPEC_STBIO 6)
  (UNSPEC_STHIO 7)
  (UNSPEC_STWIO 8)
  (UNSPEC_SYNC 9)
  (UNSPEC_WRCTL 10)
  (UNSPEC_RDCTL 11)
  (UNSPEC_TRAP 12)
  (UNSPEC_STACK_OVERFLOW_DETECT_AND_TRAP 13)
  (UNSPEC_FCOSS 14)
  (UNSPEC_FCOSD 15)
  (UNSPEC_FSINS 16)
  (UNSPEC_FSIND 17)
  (UNSPEC_FTANS 18)
  (UNSPEC_FTAND 19)
  (UNSPEC_FATANS 20)
  (UNSPEC_FATAND 21)
  (UNSPEC_FEXPS 22)
  (UNSPEC_FEXPD 23)
  (UNSPEC_FLOGS 24)
  (UNSPEC_FLOGD 25)
  (UNSPEC_FWRX 26)
  (UNSPEC_FWRY 27)
  (UNSPEC_FRDXLO 28)
  (UNSPEC_FRDXHI 29)
  (UNSPEC_FRDY 30)
  (UNSPEC_LOAD_GOT_REGISTER 31)
  (UNSPEC_PIC_SYM 32)
  (UNSPEC_PIC_CALL_SYM 33)
  (UNSPEC_TLS 34)
  (UNSPEC_TLS_LDM 35)
  (UNSPEC_LOAD_TLS_IE 36)
  (UNSPEC_ADD_TLS_LE 37)
  (UNSPEC_ADD_TLS_GD 38)
  (UNSPEC_ADD_TLS_LDM 39)
  (UNSPEC_ADD_TLS_LDO 40)
  (UNSPEC_EH_RETURN 41)
  (UNSPEC_SND 42)

  ;; Note that values 100..151 are used by custom instructions, see below.
])



;; Include predicate definitions
(include "predicates.md")



;*****************************************************************************
;*
;* instruction scheduler
;*
;*****************************************************************************

; No schedule info is currently available, using an assumption that no
; instruction can use the results of the previous instruction without
; incuring a stall.

; length of an instruction (in bytes)
(define_attr "length" "" (const_int 4))
(define_attr "type" 
  "unknown,complex,control,alu,cond_alu,st,ld,shift,mul,div,custom" 
  (const_string "complex"))

(define_asm_attributes
 [(set_attr "length" "4")
  (set_attr "type" "complex")])

(define_automaton "nios2dpx")
(automata_option "v")
;(automata_option "no-minimization")
(automata_option "ndfa")

; The nios2 pipeline is fairly straightforward for the fast model.
; Every alu operation is pipelined so that an instruction can
; be issued every cycle. However, there are still potential
; stalls which this description tries to deal with.

(define_cpu_unit "cpu" "nios2dpx")

(define_insn_reservation "complex" 1
  (eq_attr "type" "complex")
  "cpu")

(define_insn_reservation "control" 1
  (eq_attr "type" "control")
  "cpu")

(define_insn_reservation "alu" 1
  (eq_attr "type" "alu")
  "cpu")

(define_insn_reservation "cond_alu" 1
  (eq_attr "type" "cond_alu")
  "cpu")

(define_insn_reservation "st" 1
  (eq_attr "type" "st")
  "cpu")
  
(define_insn_reservation "custom" 1
  (eq_attr "type" "custom")
  "cpu")

; shifts, muls and lds have three cycle latency
(define_insn_reservation "ld" 3
  (eq_attr "type" "ld")
  "cpu")

(define_insn_reservation "shift" 3
  (eq_attr "type" "shift")
  "cpu")

(define_insn_reservation "mul" 3
  (eq_attr "type" "mul")
  "cpu")

(define_insn_reservation "div" 1
  (eq_attr "type" "div")
  "cpu")


;*****************************************************************************
;*
;* MOV Instructions
;*
;*****************************************************************************

(define_expand "movqi"
  [(set (match_operand:QI 0 "nonimmediate_dest_operand" "")
        (match_operand:QI 1 "general_src_operand" ""))]
  ""
{
  if (nios2_emit_move_sequence (operands, QImode))
    DONE;
})

(define_insn "movqi_internal"
  [(set (match_operand:QI 0 "nonimmediate_dest_operand" "=m,r,r, r")
        (match_operand:QI 1 "general_src_operand"       "rM,m,rM,P"))]
  "(register_operand (operands[0], QImode)
    || reg_or_0_operand (operands[1], QImode))"
  "@
    stb%o0\\t%z1, %0
    ldbu%o1\\t%0, %1
    mov\\t%0, %z1
    movi\\t%0, %1"
  [(set_attr "type" "st,ld,alu,alu")])

(define_insn "ldbio"
  [(set (match_operand:SI 0 "register_dest_operand" "=r")
        (unspec_volatile:SI [(const_int 0)] UNSPEC_LDBIO))
   (use (match_operand:SI 1 "memory_operand" "m"))]
  ""
  "ldbio\\t%0, %1"
  [(set_attr "type" "ld")])

(define_insn "ldbuio"
  [(set (match_operand:SI 0 "register_dest_operand" "=r")
        (unspec_volatile:SI [(const_int 0)] UNSPEC_LDBUIO))
   (use (match_operand:SI 1 "memory_operand" "m"))]
  ""
  "ldbuio\\t%0, %1"
  [(set_attr "type" "ld")])

(define_insn "stbio"
  [(set (match_operand:SI 0 "memory_operand" "=m")
        (match_operand:SI 1 "reg_or_0_src_operand"   "rM"))
   (unspec_volatile:SI [(const_int 0)] UNSPEC_STBIO)]
  ""
  "stbio\\t%z1, %0"
  [(set_attr "type" "st")])


(define_expand "movhi"
  [(set (match_operand:HI 0 "nonimmediate_dest_operand" "")
        (match_operand:HI 1 "general_src_operand" ""))]
  ""
{
  if (nios2_emit_move_sequence (operands, HImode))
    DONE;
})

(define_insn "movhi_internal"
  [(set (match_operand:HI 0 "nonimmediate_dest_operand" "=m,r,r, r,r")
        (match_operand:HI 1 "general_src_operand"       "rM,m,rM,I,J"))]
  "(register_operand (operands[0], HImode)
    || reg_or_0_operand (operands[1], HImode))"
  "@
    sth%o0\\t%z1, %0
    ldhu%o1\\t%0, %1
    mov\\t%0, %z1
    ori\\t%0, zero, %L1
    ori\\t%0, zero, %1"
  [(set_attr "type" "st,ld,alu,alu,alu")])

(define_insn "ldhio"
  [(set (match_operand:SI 0 "register_dest_operand" "=r")
        (unspec_volatile:SI [(const_int 0)] UNSPEC_LDHIO))
   (use (match_operand:SI 1 "memory_operand" "m"))]
  ""
  "ldhio\\t%0, %1"
  [(set_attr "type" "ld")])

(define_insn "ldhuio"
  [(set (match_operand:SI 0 "register_dest_operand" "=r")
        (unspec_volatile:SI [(const_int 0)] UNSPEC_LDHUIO))
   (use (match_operand:SI 1 "memory_operand" "m"))]
  ""
  "ldhuio\\t%0, %1"
  [(set_attr "type" "ld")])

(define_insn "sthio"
  [(set (match_operand:SI 0 "memory_operand" "=m")
        (match_operand:SI 1 "reg_or_0_src_operand"   "rM"))
   (unspec_volatile:SI [(const_int 0)] UNSPEC_STHIO)]
  ""
  "sthio\\t%z1, %0"
  [(set_attr "type" "st")])

(define_expand "movsi"
  [(set (match_operand:SI 0 "nonimmediate_dest_operand" "")
        (match_operand:SI 1 "general_src_operand" ""))]
  ""
{
  if (nios2_emit_move_sequence (operands, SImode))
    DONE;
})

; extension register case uses et/r24 as a temporary scratch register - dpx does not have et
(define_insn "movsi_internal"
  [(set (match_operand:SI 0 "nonimmediate_dest_operand" "=m,r,r, r,r,r,r,c,x")
        (match_operand:SI 1 "general_src_operand"       "rM,m,rM,P,Q,R,S,i,i"))]
  "(register_operand (operands[0], SImode)
    || reg_or_0_operand (operands[1], SImode))"
  "@
    stw%o0\\t%z1, %0
    ldw%o1\\t%0, %1
    mov\\t%0, %z1
    movi\\t%0, %1
    movui\\t%0, %1
    movhi20\\t%0, %T1
    addi\\t%0, gp, %%gprel(%1)
    movhi20\\t%0, %T1\;addi\\t%0, %0, %B1
    movhi20\\tr24, %T1\;addi\\t%0, r24, %B1"
  [(set_attr "type" "st,ld,alu,alu,alu,alu,alu,alu,alu")])

(define_insn "ldwio"
  [(set (match_operand:SI 0 "register_dest_operand" "=r")
        (unspec_volatile:SI [(const_int 0)] UNSPEC_LDWIO))
   (use (match_operand:SI 1 "memory_operand" "m"))]
  ""
  "ldwio\\t%0, %1"
  [(set_attr "type" "ld")])

(define_insn "stwio"
  [(set (match_operand:SI 0 "memory_operand" "=m")
        (match_operand:SI 1 "reg_or_0_src_operand" "rM"))
   (unspec_volatile:SI [(const_int 0)] UNSPEC_STWIO)]
  ""
  "stwio\\t%z1, %0"
  [(set_attr "type" "st")])



;*****************************************************************************
;*
;* zero extension
;*
;*****************************************************************************


(define_insn "zero_extendhisi2"
  [(set (match_operand:SI 0 "register_dest_operand" "=r,r")
        (zero_extend:SI (match_operand:HI 1 "nonimmediate_src_operand" "r,m")))]
  ""
  "@
    andi\\t%0, %1, 0xffff
    ldhu%o1\\t%0, %1"
  [(set_attr "type"     "alu,ld")])

(define_insn "zero_extendqihi2"
  [(set (match_operand:HI 0 "register_dest_operand" "=r,r")
        (zero_extend:HI (match_operand:QI 1 "nonimmediate_src_operand" "r,m")))]
  ""
  "@
    andi\\t%0, %1, 0xff
    ldbu%o1\\t%0, %1"
  [(set_attr "type"     "alu,ld")])

(define_insn "zero_extendqisi2"
  [(set (match_operand:SI 0 "register_dest_operand" "=r,r")
        (zero_extend:SI (match_operand:QI 1 "nonimmediate_src_operand" "r,m")))]
  ""
  "@
    andi\\t%0, %1, 0xff
    ldbu%o1\\t%0, %1"
  [(set_attr "type"     "alu,ld")])



;*****************************************************************************
;*      
;* sign extension
;*
;*****************************************************************************
(define_expand "extendhisi2"
  [(set (match_operand:SI 0 "register_dest_operand" "")
        (sign_extend:SI (match_operand:HI 1 "nonimmediate_src_operand" "")))]
  ""
{
})

(define_insn "*extendhisi2"
  [(set (match_operand:SI 0 "register_dest_operand" "=r")
        (sign_extend:SI (match_operand:HI 1 "register_src_operand" "r")))]
  ""
  "#")

(define_split
  [(set (match_operand:SI 0 "register_dest_operand" "")
        (sign_extend:SI (match_operand:HI 1 "register_src_operand" "")))]
  "reload_completed"
  [(set (match_dup 0)
        (and:SI (match_dup 1) (const_int 65535)))
   (set (match_dup 0)
        (xor:SI (match_dup 0) (const_int 32768)))
   (set (match_dup 0)
        (plus:SI (match_dup 0) (const_int -32768)))]
  "operands[1] = gen_lowpart (SImode, operands[1]);")

(define_insn "extendhisi2_internal"
  [(set (match_operand:SI 0 "register_dest_operand" "=r")
        (sign_extend:SI (match_operand:HI 1 "memory_operand" "m")))]
  ""
  "ldh%o1\\t%0, %1"
  [(set_attr "type"     "ld")])


(define_expand "extendqihi2"
  [(set (match_operand:HI 0 "register_dest_operand" "")
        (sign_extend:HI (match_operand:QI 1 "nonimmediate_src_operand" "")))]
  ""
{
})

(define_insn "*extendqihi2"
  [(set (match_operand:HI 0 "register_dest_operand" "=r")
        (sign_extend:HI (match_operand:QI 1 "register_src_operand" "r")))]
  ""
  "#")

(define_split
  [(set (match_operand:HI 0 "register_dest_operand" "")
        (sign_extend:HI (match_operand:QI 1 "register_src_operand" "")))]
  "reload_completed"
  [(set (match_dup 0)
        (and:SI (match_dup 1) (const_int 255)))
   (set (match_dup 0)
        (xor:SI (match_dup 0) (const_int 128)))
   (set (match_dup 0)
        (plus:SI (match_dup 0) (const_int -128)))]
  "operands[0] = gen_lowpart (SImode, operands[0]);
   operands[1] = gen_lowpart (SImode, operands[1]);")



(define_insn "extendqihi2_internal"
  [(set (match_operand:HI 0 "register_dest_operand" "=r")
        (sign_extend:HI (match_operand:QI 1 "memory_operand" "m")))]
  ""
  "ldb%o1\\t%0, %1"
  [(set_attr "type"     "ld")])


(define_expand "extendqisi2"
  [(set (match_operand:SI 0 "register_dest_operand" "")
        (sign_extend:SI (match_operand:QI 1 "nonimmediate_src_operand" "")))]
  ""
{
})

(define_insn "*extendqisi2"
  [(set (match_operand:SI 0 "register_dest_operand" "=r")
        (sign_extend:SI (match_operand:QI 1 "register_src_operand" "r")))]
  ""
  "#")

(define_split
  [(set (match_operand:SI 0 "register_dest_operand" "")
        (sign_extend:SI (match_operand:QI 1 "register_src_operand" "")))]
  "reload_completed"
  [(set (match_dup 0)
        (and:SI (match_dup 1) (const_int 255)))
   (set (match_dup 0)
        (xor:SI (match_dup 0) (const_int 128)))
   (set (match_dup 0)
        (plus:SI (match_dup 0) (const_int -128)))]
  "operands[1] = gen_lowpart (SImode, operands[1]);")

(define_insn "extendqisi2_insn"
  [(set (match_operand:SI 0 "register_dest_operand" "=r")
        (sign_extend:SI (match_operand:QI 1 "memory_operand" "m")))]
  ""
  "ldb%o1\\t%0, %1"
  [(set_attr "type"     "ld")])




;*****************************************************************************
;*
;* Arithmetic Operations
;*
;*****************************************************************************

(define_expand "addsi3"
  [(set (match_operand:SI 0 "register_dest_operand"         "")
        (plus:SI (match_operand:SI 1 "register_src_operand" "")
                 (match_operand:SI 2 "arith_src_operand"    "")))]
  "TARGET_ARCH_NIOS2DPX"
{
  if (GET_CODE ( operands[2] ) == CONST_INT &&
               !(CONST_OK_FOR_LETTER_P (INTVAL (operands[2]), 'P')))
  {
     rtx scratch_reg = gen_reg_rtx(SImode);
     
     emit_insn (gen_movsi (scratch_reg, operands[2]));
     
     operands[2] = scratch_reg;     
  }
})

; use et/r24 as a temporary scratch register - dpx does not have et
(define_insn "*addsi3"
  [(set (match_operand:SI 0 "register_dest_operand"         "=r,r,r")
        (plus:SI (match_operand:SI 1 "register_src_operand" "r,r,r")
                 (match_operand:SI 2 "arith_src_operand"    "cM,P,I")))]
  "TARGET_ARCH_NIOS2DPX"
  {
    if (GET_CODE ( operands[2] ) == CONST_INT &&
               !(CONST_OK_FOR_LETTER_P (INTVAL (operands[2]), 'P')))
      {
        return "movhi20\\tr24, %T2\;addi\\tr24, r24, %B2\;add\\t%0, %1, r24";
      }
    else
      return "add%i2\\t%0, %1, %z2";
  }
  [(set_attr "type" "alu")])


(define_insn "addsf3"
  [(set (match_operand:SF 0 "register_operand"          "=c")
        (plus:SF (match_operand:SF 1 "register_operand" "%c")
                 (match_operand:SF 2 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_addsf3].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_addsf3].output) (insn);
  }
  [(set_attr "type" "custom")])


(define_insn "adddf3"
  [(set (match_operand:DF 0 "register_operand"          "=c")
        (plus:DF (match_operand:DF 1 "register_operand" "%c")
                 (match_operand:DF 2 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_adddf3].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_adddf3].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "subsi3"
  [(set (match_operand:SI 0 "register_dest_operand"          "=r")
        (minus:SI (match_operand:SI 1 "reg_or_0_src_operand" "rM")
                  (match_operand:SI 2 "register_src_operand" "c")))]
  ""
  "sub\\t%0, %z1, %2"
  [(set_attr "type" "alu")])

(define_insn "subsf3"
  [(set (match_operand:SF 0 "register_operand"          "=c")
        (minus:SF (match_operand:SF 1 "register_operand" "c")
                  (match_operand:SF 2 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_subsf3].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_subsf3].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "subdf3"
  [(set (match_operand:DF 0 "register_operand"          "=c")
        (minus:DF (match_operand:DF 1 "register_operand" "c")
                  (match_operand:DF 2 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_subdf3].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_subdf3].output) (insn);
  }
  [(set_attr "type" "custom")])



(define_insn "mulsi3"
  [(set (match_operand:SI 0 "register_dest_operand"         "=r,r")
        (mult:SI (match_operand:SI 1 "register_src_operand" "r,r")
                 (match_operand:SI 2 "arith_src_operand"    "cM,P")))]
  "TARGET_HAS_MUL"
  "mul%i2\\t%0, %1, %z2"
  [(set_attr "type" "mul")])


(define_insn "mulsf3"
  [(set (match_operand:SF 0 "register_operand"          "=c")
        (mult:SF (match_operand:SF 1 "register_operand" "%c")
                 (match_operand:SF 2 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_mulsf3].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_mulsf3].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "muldf3"
  [(set (match_operand:DF 0 "register_operand"          "=c")
        (mult:DF (match_operand:DF 1 "register_operand" "%c")
                 (match_operand:DF 2 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_muldf3].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_muldf3].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_expand "divsi3"
  [(set (match_operand:SI 0 "register_operand"            "=r")
        (div:SI (match_operand:SI 1 "register_operand"     "r")
                (match_operand:SI 2 "register_operand"     "r")))]
  ""
{
  if (!TARGET_HAS_DIV)
    {
      if (!TARGET_FAST_SW_DIV)
        FAIL;
      else
        {
          if (nios2_emit_expensive_div (operands, SImode))
            DONE;
        }
    }
})

(define_insn "divsi3_insn"
  [(set (match_operand:SI 0 "register_dest_operand"            "=r")
        (div:SI (match_operand:SI 1 "register_src_operand"     "r")
                (match_operand:SI 2 "register_src_operand"     "c")))]
  "TARGET_HAS_DIV"
  "div\\t%0, %1, %2"
  [(set_attr "type" "div")])

(define_insn "divsf3"
  [(set (match_operand:SF 0 "register_operand"          "=c")
        (div:SF (match_operand:SF 1 "register_operand" "c")
                (match_operand:SF 2 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_divsf3].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_divsf3].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "divdf3"
  [(set (match_operand:DF 0 "register_operand"          "=c")
        (div:DF (match_operand:DF 1 "register_operand" "c")
                (match_operand:DF 2 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_divdf3].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_divdf3].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "udivsi3"
  [(set (match_operand:SI 0 "register_operand"            "=c")
        (udiv:SI (match_operand:SI 1 "register_operand"     "c")
                (match_operand:SI 2 "register_operand"     "c")))]
  "TARGET_HAS_DIV"
  "divu\\t%0, %1, %2"
  [(set_attr "type" "div")])

(define_insn "smulsi3_highpart"
  [(set (match_operand:SI 0 "register_dest_operand"                        "=r")
        (truncate:SI
         (lshiftrt:DI
          (mult:DI (sign_extend:DI (match_operand:SI 1 "register_src_operand"  "r"))
                   (sign_extend:DI (match_operand:SI 2 "register_src_operand"  "c")))
          (const_int 32))))]
  "TARGET_HAS_MULX"
  "mulxss\\t%0, %1, %2"
  [(set_attr "type" "mul")])

(define_insn "umulsi3_highpart"
  [(set (match_operand:SI 0 "register_dest_operand"                            "=r")
        (truncate:SI
         (lshiftrt:DI
          (mult:DI (zero_extend:DI (match_operand:SI 1 "register_src_operand"  "r"))
                   (zero_extend:DI (match_operand:SI 2 "register_src_operand"  "c")))
          (const_int 32))))]
  "TARGET_HAS_MULX"
  "mulxuu\\t%0, %1, %2"
  [(set_attr "type" "mul")])


(define_expand "mulsidi3_little_endian"
    [(set (subreg:SI (match_operand:DI 0 "register_operand" "") 0)
          (mult:SI (match_operand:SI 1 "register_operand" "")
                   (match_operand:SI 2 "register_operand" "")))
     (set (subreg:SI (match_dup 0) 4)
          (truncate:SI (lshiftrt:DI (mult:DI (sign_extend:DI (match_dup 1))
                                             (sign_extend:DI (match_dup 2)))
                                    (const_int 32))))]
  "TARGET_HAS_MULX && !WORDS_BIG_ENDIAN"
  "")

(define_expand "mulsidi3_big_endian"
    [(set (subreg:SI (match_operand:DI 0 "register_operand" "") 4)
          (mult:SI (match_operand:SI 1 "register_operand" "")
                   (match_operand:SI 2 "register_operand" "")))
     (set (subreg:SI (match_dup 0) 0)
          (truncate:SI (lshiftrt:DI (mult:DI (sign_extend:DI (match_dup 1))
                                             (sign_extend:DI (match_dup 2)))
                                    (const_int 32))))]
  "TARGET_HAS_MULX && WORDS_BIG_ENDIAN"
  "")

(define_expand "mulsidi3"
    [(match_operand:DI 0 "register_operand" "")
     (match_operand:SI 1 "register_operand" "")
     (match_operand:SI 2 "register_operand" "")]
  "TARGET_HAS_MULX"
  {
    if (WORDS_BIG_ENDIAN)
    {
        emit_insn (gen_mulsidi3_big_endian (operands[0],
                                            operands[1],
                                            operands[2]));
    }
    else
    {
        emit_insn (gen_mulsidi3_little_endian (operands[0],
                                               operands[1],
                                               operands[2]));
    }
    DONE;
  })

(define_expand "umulsidi3_little_endian"
    [(set (subreg:SI (match_operand:DI 0 "register_operand" "") 0)
          (mult:SI (match_operand:SI 1 "register_operand" "")
                   (match_operand:SI 2 "register_operand" "")))
     (set (subreg:SI (match_dup 0) 4)
          (truncate:SI (lshiftrt:DI (mult:DI (zero_extend:DI (match_dup 1))
                                             (zero_extend:DI (match_dup 2)))
                                    (const_int 32))))]
  "TARGET_HAS_MULX && !WORDS_BIG_ENDIAN"
  "")

(define_expand "umulsidi3_big_endian"
    [(set (subreg:SI (match_operand:DI 0 "register_operand" "") 4)
          (mult:SI (match_operand:SI 1 "register_operand" "")
                   (match_operand:SI 2 "register_operand" "")))
     (set (subreg:SI (match_dup 0) 0)
          (truncate:SI (lshiftrt:DI (mult:DI (zero_extend:DI (match_dup 1))
                                             (zero_extend:DI (match_dup 2)))
                                    (const_int 32))))]
  "TARGET_HAS_MULX && WORDS_BIG_ENDIAN"
  "")

(define_expand "umulsidi3"
    [(match_operand:DI 0 "register_operand" "")
     (match_operand:SI 1 "register_operand" "")
     (match_operand:SI 2 "register_operand" "")]
  "TARGET_HAS_MULX"
  {
    if (WORDS_BIG_ENDIAN)
    {
        emit_insn (gen_umulsidi3_big_endian (operands[0],
                                             operands[1],
                                             operands[2]));
    }
    else
    {
        emit_insn (gen_umulsidi3_little_endian (operands[0],
                                                operands[1],
                                                operands[2]));
    }
    DONE;
  })


;*****************************************************************************
;*
;* Negate and ones complement
;*
;*****************************************************************************

(define_insn "negsi2"
  [(set (match_operand:SI 0 "register_dest_operand"        "=r")
        (neg:SI (match_operand:SI 1 "register_src_operand" "c")))]
  ""
{
  operands[2] = const0_rtx;
  return "sub\\t%0, %z2, %1";
}
  [(set_attr "type" "alu")])

(define_insn "negsf2"
  [(set (match_operand:SF 0 "register_operand"          "=c")
        (neg:SF (match_operand:SF 1 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_negsf2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_negsf2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "negdf2"
  [(set (match_operand:DF 0 "register_operand"          "=c")
        (neg:DF (match_operand:DF 1 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_negdf2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_negdf2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "one_cmplsi2"
  [(set (match_operand:SI 0 "register_dest_operand"        "=r")
        (not:SI (match_operand:SI 1 "register_src_operand" "r")))]
  ""
{
  operands[2] = const0_rtx;
  return "nor\\t%0, %1, %z2";
}
  [(set_attr "type" "alu")])


;*****************************************************************************
;*
;* Miscellaneous floating point
;*
;*****************************************************************************
(define_insn "nios2_fwrx"
  [(unspec_volatile [(match_operand:DF 0 "register_operand" "c")] UNSPEC_FWRX)]
  "nios2_fpu_insns[nios2_fpu_nios2_fwrx].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_nios2_fwrx].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "nios2_fwry"
  [(unspec_volatile [(match_operand:SF 0 "register_operand" "c")] UNSPEC_FWRY)]
  "nios2_fpu_insns[nios2_fpu_nios2_fwry].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_nios2_fwry].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "nios2_frdxlo"
  [(set (match_operand:SF 0 "register_operand" "=c")
        (unspec_volatile:SF [(const_int 0)] UNSPEC_FRDXLO))]
  "nios2_fpu_insns[nios2_fpu_nios2_frdxlo].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_nios2_frdxlo].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "nios2_frdxhi"
  [(set (match_operand:SF 0 "register_operand" "=c")
        (unspec_volatile:SF [(const_int 0)] UNSPEC_FRDXHI))]
  "nios2_fpu_insns[nios2_fpu_nios2_frdxhi].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_nios2_frdxhi].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "nios2_frdy"
  [(set (match_operand:SF 0 "register_operand" "=c")
        (unspec_volatile:SF [(const_int 0)] UNSPEC_FRDY))]
  "nios2_fpu_insns[nios2_fpu_nios2_frdy].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_nios2_frdy].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "minsf3"
  [(set (match_operand:SF 0 "register_operand" "=c")
        (if_then_else:SF (lt:SF (match_operand:SF 1 "register_operand" "%c")
                                (match_operand:SF 2 "register_operand" "c"))
          (match_dup 1)
          (match_dup 2)))]
  "nios2_fpu_insns[nios2_fpu_minsf3].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_minsf3].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "mindf3"
  [(set (match_operand:DF 0 "register_operand" "=c")
        (if_then_else:DF (lt:DF (match_operand:DF 1 "register_operand" "%c")
                                (match_operand:DF 2 "register_operand" "c"))
          (match_dup 1)
          (match_dup 2)))]
  "nios2_fpu_insns[nios2_fpu_mindf3].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_mindf3].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "maxsf3"
  [(set (match_operand:SF 0 "register_operand" "=c")
        (if_then_else:SF (lt:SF (match_operand:SF 1 "register_operand" "%c")
                                (match_operand:SF 2 "register_operand" "c"))
          (match_dup 2)
          (match_dup 1)))]
  "nios2_fpu_insns[nios2_fpu_maxsf3].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_maxsf3].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "maxdf3"
  [(set (match_operand:DF 0 "register_operand" "=c")
        (if_then_else:DF (lt:DF (match_operand:DF 1 "register_operand" "%c")
                                (match_operand:DF 2 "register_operand" "c"))
          (match_dup 2)
          (match_dup 1)))]
  "nios2_fpu_insns[nios2_fpu_maxdf3].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_maxdf3].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "abssf2"
  [(set (match_operand:SF 0 "register_operand" "=c")
        (abs:SF (match_operand:SF 1 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_abssf2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_abssf2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "absdf2"
  [(set (match_operand:DF 0 "register_operand" "=c")
        (abs:DF (match_operand:DF 1 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_absdf2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_absdf2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "sqrtsf2"
  [(set (match_operand:SF 0 "register_operand" "=c")
        (sqrt:SF (match_operand:SF 1 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_sqrtsf2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_sqrtsf2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "sqrtdf2"
  [(set (match_operand:DF 0 "register_operand" "=c")
        (sqrt:DF (match_operand:DF 1 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_sqrtdf2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_sqrtdf2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "cossf2"
  [(set (match_operand:SF 0 "register_operand" "=c")
        (unspec:SF [(match_operand:SF 1 "register_operand" "c")] UNSPEC_FCOSS))]
  "nios2_fpu_insns[nios2_fpu_cossf2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_cossf2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "cosdf2"
  [(set (match_operand:DF 0 "register_operand" "=c")
        (unspec:DF [(match_operand:DF 1 "register_operand" "c")] UNSPEC_FCOSD))]
  "nios2_fpu_insns[nios2_fpu_cosdf2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_cosdf2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "sinsf2"
  [(set (match_operand:SF 0 "register_operand" "=c")
        (unspec:SF [(match_operand:SF 1 "register_operand" "c")] UNSPEC_FSINS))]
  "nios2_fpu_insns[nios2_fpu_sinsf2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_sinsf2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "sindf2"
  [(set (match_operand:DF 0 "register_operand" "=c")
        (unspec:DF [(match_operand:DF 1 "register_operand" "c")] UNSPEC_FSIND))]
  "nios2_fpu_insns[nios2_fpu_sindf2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_sindf2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "tansf2"
  [(set (match_operand:SF 0 "register_operand" "=c")
        (unspec:SF [(match_operand:SF 1 "register_operand" "c")] UNSPEC_FTANS))]
  "nios2_fpu_insns[nios2_fpu_tansf2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_tansf2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "tandf2"
  [(set (match_operand:DF 0 "register_operand" "=c")
        (unspec:DF [(match_operand:DF 1 "register_operand" "c")] UNSPEC_FTAND))]
  "nios2_fpu_insns[nios2_fpu_tandf2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_tandf2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "atansf2"
  [(set (match_operand:SF 0 "register_operand" "=c")
        (unspec:SF [(match_operand:SF 1 "register_operand" "c")] UNSPEC_FATANS))]
  "nios2_fpu_insns[nios2_fpu_atansf2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_atansf2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "atandf2"
  [(set (match_operand:DF 0 "register_operand" "=c")
        (unspec:DF [(match_operand:DF 1 "register_operand" "c")] UNSPEC_FATAND))]
  "nios2_fpu_insns[nios2_fpu_atandf2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_atandf2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "expsf2"
  [(set (match_operand:SF 0 "register_operand" "=c")
        (unspec:SF [(match_operand:SF 1 "register_operand" "c")] UNSPEC_FEXPS))]
  "nios2_fpu_insns[nios2_fpu_expsf2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_expsf2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "expdf2"
  [(set (match_operand:DF 0 "register_operand" "=c")
        (unspec:DF [(match_operand:DF 1 "register_operand" "c")] UNSPEC_FEXPD))]
  "nios2_fpu_insns[nios2_fpu_expdf2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_expdf2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "logsf2"
  [(set (match_operand:SF 0 "register_operand" "=c")
        (unspec:SF [(match_operand:SF 1 "register_operand" "c")] UNSPEC_FLOGS))]
  "nios2_fpu_insns[nios2_fpu_logsf2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_logsf2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "logdf2"
  [(set (match_operand:DF 0 "register_operand" "=c")
        (unspec:DF [(match_operand:DF 1 "register_operand" "c")] UNSPEC_FLOGD))]
  "nios2_fpu_insns[nios2_fpu_logdf2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_logdf2].output) (insn);
  }
  [(set_attr "type" "custom")])


;*****************************************************************************
;*
;*  Logical Operations
;*
;*****************************************************************************

(define_insn "andsi3"
  [(set (match_operand:SI 0 "register_dest_operand"        "=r, r,r")
        (and:SI (match_operand:SI 1 "register_src_operand" "%r, r,r")
                (match_operand:SI 2 "logical_src_operand"  "cM,J,K")))]
  ""
  "@
    and\\t%0, %1, %z2
    and%i2\\t%0, %1, %2
    andh%i2\\t%0, %1, %U2"
  [(set_attr "type" "alu")])

(define_insn "iorsi3"
  [(set (match_operand:SI 0 "register_dest_operand"         "=r, r,r")
        (ior:SI (match_operand:SI 1 "register_src_operand"  "%r, r,r")
                (match_operand:SI 2 "logical_src_operand"   "cM,J,K")))]
  ""
  "@
    or\\t%0, %1, %z2
    or%i2\\t%0, %1, %2
    orh%i2\\t%0, %1, %U2"
  [(set_attr "type" "alu")])

(define_insn "*norsi3"
  [(set (match_operand:SI 0 "register_dest_operand"                  "=r")
        (and:SI (not:SI (match_operand:SI 1 "register_src_operand"   "%r"))
                (not:SI (match_operand:SI 2 "reg_or_0_src_operand"   "cM"))))]
  ""
  "nor\\t%0, %1, %z2"
  [(set_attr "type" "alu")])

(define_insn "xorsi3"
  [(set (match_operand:SI 0 "register_dest_operand"          "=r,r,r")
        (xor:SI (match_operand:SI 1 "register_src_operand"   "%r,r,r")
                (match_operand:SI 2 "logical_src_operand"    "cM,J,K")))]
  ""
  "@
    xor\\t%0, %1, %z2
    xor%i2\\t%0, %1, %2
    xorh%i2\\t%0, %1, %U2"
  [(set_attr "type" "alu")])



;*****************************************************************************
;*
;* Shifts
;*
;*****************************************************************************

(define_insn "ashlsi3"
  [(set (match_operand:SI 0 "register_dest_operand"           "=r,r")
        (ashift:SI (match_operand:SI 1 "register_src_operand" "r, r")
                   (match_operand:SI 2 "shift_operand"        "c, L")))]
  ""

{
        if( GET_CODE ( operands[2] ) == CONST_INT && INTVAL( operands[2] ) == 1 )
                return "add\t%0,%1,%1";
        return "sll%i2\t%0,%1,%z2";
}
  [(set_attr "type" "shift")])

(define_insn "ashrsi3"
  [(set (match_operand:SI 0 "register_dest_operand"             "=r,r")
        (ashiftrt:SI (match_operand:SI 1 "register_src_operand" "r,r")
                     (match_operand:SI 2 "shift_operand"        "c,L")))]
  ""
  "sra%i2\\t%0, %1, %z2"
  [(set_attr "type" "shift")])

(define_insn "lshrsi3"
  [(set (match_operand:SI 0 "register_dest_operand"             "=r,r")
        (lshiftrt:SI (match_operand:SI 1 "register_src_operand" "r,r")
                     (match_operand:SI 2 "shift_operand"        "c,L")))]
  ""
  "srl%i2\\t%0, %1, %z2"
  [(set_attr "type" "shift")])

(define_insn "rotlsi3"
  [(set (match_operand:SI 0 "register_dest_operand"           "=r,r")
        (rotate:SI (match_operand:SI 1 "register_src_operand" "r,r")
                   (match_operand:SI 2 "shift_operand"        "c,L")))]
  ""
  "rol%i2\\t%0, %1, %z2"
  [(set_attr "type" "shift")])

(define_insn "rotrsi3"
  [(set (match_operand:SI 0 "register_dest_operand"            "=r,r")
        (rotatert:SI (match_operand:SI 1 "register_src_operand" "r,r")
                     (match_operand:SI 2 "register_src_operand" "c,c")))]
  ""
  "ror\\t%0, %1, %2"
  [(set_attr "type" "shift")])

(define_insn "*shift_mul_constants"
  [(set (match_operand:SI 0 "register_dest_operand"                    "=r")
        (ashift:SI (mult:SI (match_operand:SI 1 "register_src_operand"  "r")
                            (match_operand:SI 2 "const_int_operand" "P"))
                   (match_operand:SI 3          "const_int_operand" "P")))]
  "TARGET_HAS_MUL && SMALL12_INT (INTVAL (operands[2]) << INTVAL (operands[3]))"
{
  HOST_WIDE_INT mul = INTVAL (operands[2]) << INTVAL (operands[3]);
  rtx ops[3];
  
  ops[0] = operands[0];
  ops[1] = operands[1];
  ops[2] = GEN_INT (mul);
  
  output_asm_insn ("muli\t%0, %1, %2", ops);
  return "";
}
  [(set_attr "type" "mul")])
  



;*****************************************************************************
;*
;* Converting between floating point and fixed point
;*
;*****************************************************************************
(define_insn "floatsisf2"
  [(set (match_operand:SF 0 "register_operand" "=c")
        (float:SF (match_operand:SI 1 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_floatsisf2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_floatsisf2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "floatsidf2"
  [(set (match_operand:DF 0 "register_operand" "=c")
        (float:DF (match_operand:SI 1 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_floatsidf2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_floatsidf2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "floatunssisf2"
  [(set (match_operand:SF 0 "register_operand" "=c")
        (unsigned_float:SF (match_operand:SI 1 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_floatunssisf2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_floatunssisf2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "floatunssidf2"
  [(set (match_operand:DF 0 "register_operand" "=c")
        (unsigned_float:DF (match_operand:SI 1 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_floatunssidf2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_floatunssidf2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "fixsfsi2"
  [(set (match_operand:SI 0 "register_operand" "=c")
        (fix:SI (match_operand:SF 1 "general_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_fixsfsi2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_fixsfsi2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "fixdfsi2"
  [(set (match_operand:SI 0 "register_operand" "=c")
        (fix:SI (match_operand:DF 1 "general_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_fixdfsi2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_fixdfsi2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "fixunssfsi2"
  [(set (match_operand:SI 0 "register_operand" "=c")
        (unsigned_fix:SI (match_operand:SF 1 "general_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_fixunssfsi2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_fixunssfsi2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "fixunsdfsi2"
  [(set (match_operand:SI 0 "register_operand" "=c")
        (unsigned_fix:SI (match_operand:DF 1 "general_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_fixunsdfsi2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_fixunsdfsi2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "extendsfdf2"
  [(set (match_operand:DF 0 "register_operand" "=c")
        (float_extend:DF (match_operand:SF 1 "general_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_extendsfdf2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_extendsfdf2].output) (insn);
  }
  [(set_attr "type" "custom")])

(define_insn "truncdfsf2"
  [(set (match_operand:SF 0 "register_operand" "=c")
        (float_truncate:SF (match_operand:DF 1 "general_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_truncdfsf2].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_truncdfsf2].output) (insn);
  }
  [(set_attr "type" "custom")])








;*****************************************************************************
;*
;* Prologue, Epilogue and Return
;*
;*****************************************************************************

(define_expand "prologue"
  [(const_int 1)]
  ""
{
  expand_prologue ();
  DONE;
})

(define_expand "epilogue"
  [(return)]
  ""
{
  expand_epilogue (false);
  DONE;
})

(define_expand "sibcall_epilogue"
  [(return)]
  ""
{
  expand_epilogue (true);
  DONE;
})

(define_insn "return"
  [(return)]
  "reload_completed && nios2_can_use_return_insn ()"
  "ret\\t"
)

(define_insn "return_from_naked_epilogue"
  [(return)]
  "reload_completed && nios2_naked_function_p ()"
  ""
)

(define_insn "return_from_task_epilogue"
  [(return)]
  "reload_completed"
  "exit"
)

(define_insn "return_from_epilogue"
  [(use (match_operand 0 "pmode_register_operand" ""))
   (return)]
  "reload_completed"
  "ret\\t"
)

;; Block any insns from being moved before this point, since the
;; profiling call to mcount can use various registers that aren't
;; saved or used to pass arguments.

(define_insn "blockage"
  [(unspec_volatile [(const_int 0)] UNSPEC_BLOCKAGE)]
  ""
  ""
  [(set_attr "type" "unknown")
   (set_attr "length" "0")])

;; This is used in compiling the unwind routines.
(define_expand "eh_return"
  [(use (match_operand 0 "general_operand"))]
  ""
{
  if (GET_MODE (operands[0]) != Pmode)
    operands[0] = convert_to_mode (Pmode, operands[0], 0);
  emit_insn (gen_eh_set_ra (operands[0]));

  DONE;
})

;; Clobber the return address on the stack.  We can't expand this
;; until we know where it will be put in the stack frame.

(define_insn "eh_set_ra"
  [(unspec [(match_operand:SI 0 "register_operand" "r")] UNSPEC_EH_RETURN)
   (clobber (match_scratch:SI 1 "=&r"))]
 ""
  "#")

(define_split
  [(unspec [(match_operand 0 "register_operand")] UNSPEC_EH_RETURN)
   (clobber (match_scratch 1))]
  "reload_completed"
  [(const_int 0)]
{
  nios2_set_return_address (operands[0], operands[1]);
  DONE;
})


;*****************************************************************************
;*
;* Jumps and Calls
;*
;*****************************************************************************

(define_insn "indirect_jump"
  [(set (pc) (match_operand:SI 0 "register_src_operand" "r"))]
  ""
  "jmp\\t%0"
  [(set_attr "type" "control")])

(define_insn "jump"
  [(set (pc)
        (label_ref (match_operand 0 "" "")))]
  ""
  "br\\t%0"
  [(set_attr "type" "control")])


(define_expand "call"
  [(parallel [(call (match_operand 0 "" "")
                    (match_operand 1 "" ""))
              (clobber (reg:SI 31))])]
  ""
  {
    nios2_adjust_call_address (&XEXP (operands[0], 0));
  }
)

(define_expand "call_value"
  [(parallel [(set (match_operand 0 "" "")
                   (call (match_operand 1 "" "")
                         (match_operand 2 "" "")))
              (clobber (reg:SI 31))])]
  ""
  {
    nios2_adjust_call_address (&XEXP (operands[1], 0));
  }
)

(define_insn "*call"
  [(call (mem:QI (match_operand:SI 0 "call_operand" "i,c"))
         (match_operand 1 "" ""))
   (clobber (reg:SI 31))]
  ""
  "@
   call\\t%0
   callr\\t%0"
  [(set_attr "type" "control,control")])

(define_insn "*call_value"
  [(set (match_operand 0 "" "")
        (call (mem:QI (match_operand:SI 1 "call_operand" "i,c"))
              (match_operand 2 "" "")))
   (clobber (reg:SI 31))]
  ""
  "@
   call\\t%1
   callr\\t%1"
  [(set_attr "type" "control,control")])

(define_expand "sibcall"
  [(parallel [(call (match_operand 0 "" "")
                    (match_operand 1 "" ""))
              (return)])]
  ""
  {
    nios2_adjust_call_address (&XEXP (operands[0], 0));
  }
)

(define_expand "sibcall_value"
  [(parallel [(set (match_operand 0 "" "")
                   (call (match_operand 1 "" "")
                         (match_operand 2 "" "")))
              (return)])]
  ""
  {
    nios2_adjust_call_address (&XEXP (operands[1], 0));
  }
)

(define_insn "*sibcall"
 [(call (mem:QI (match_operand:SI 0 "call_operand" "i,j"))
        (match_operand 1 "" ""))
  (return)]
  ""
  "@
   jmpi\\t%0
   jmp\\t%0"
)

(define_insn "*sibcall_value"
 [(set (match_operand 0 "register_operand" "")
       (call (mem:QI (match_operand:SI 1 "call_operand" "i,j"))
             (match_operand 2 "" "")))
  (return)]
  ""
  "@
   jmpi\\t%1
   jmp\\t%1"
)




(define_expand "tablejump"
  [(parallel [(set (pc) (match_operand 0 "register_src_operand" "r"))
              (use (label_ref (match_operand 1 "" "")))])]
  ""
  {
    if (flag_pic)
      {
        /* Hopefully, CSE will eliminate this copy.  */
        rtx reg1 = copy_addr_to_reg (gen_rtx_LABEL_REF (Pmode, operands[1]));
        rtx reg2 = gen_reg_rtx (SImode);

        emit_insn (gen_addsi3 (reg2, operands[0], reg1));
        operands[0] = reg2;
      }
  }
)

(define_insn "*tablejump"
  [(set (pc)
        (match_operand:SI 0 "register_src_operand" "r"))
   (use (label_ref (match_operand 1 "" "")))]
  ""
  "jmp\\t%0"
  [(set_attr "type" "control")])



;*****************************************************************************
;*
;* Comparisons
;*
;*****************************************************************************
;; Flow here is rather complex (based on MIPS):
;;
;;  1)  The cmp{si,di,sf,df} routine is called.  It deposits the
;;      arguments into the branch_cmp array, and the type into
;;      branch_type.  No RTL is generated.
;;
;;  2)  The appropriate branch define_expand is called, which then
;;      creates the appropriate RTL for the comparison and branch.
;;      Different CC modes are used, based on what type of branch is
;;      done, so that we can constrain things appropriately.  There
;;      are assumptions in the rest of GCC that break if we fold the
;;      operands into the branchs for integer operations, and use cc0
;;      for floating point, so we use the fp status register instead.
;;      If needed, an appropriate temporary is created to hold the
;;      of the integer compare.

(define_expand "cmpsi"
  [(set (cc0)
        (compare:CC (match_operand:SI 0 "register_src_operand" "")
                    (match_operand:SI 1 "arith_src_operand" "")))]
  ""
{
  branch_cmp[0] = operands[0];
  branch_cmp[1] = operands[1];
  branch_type = CMP_SI;
  DONE;
})

(define_expand "tstsi"
  [(set (cc0)
        (match_operand:SI 0 "register_src_operand" ""))]
  ""
{
  branch_cmp[0] = operands[0];
  branch_cmp[1] = const0_rtx;
  branch_type = CMP_SI;
  DONE;
})

(define_expand "cmpsf"
  [(set (cc0)
        (compare:CC (match_operand:SF 0 "register_operand" "")
                    (match_operand:SF 1 "register_operand" "")))]
  "(nios2_fpu_insns[nios2_fpu_nios2_sltsf].N >= 0
   || nios2_fpu_insns[nios2_fpu_nios2_sgtsf].N >= 0)
   && (nios2_fpu_insns[nios2_fpu_nios2_sgesf].N >= 0
   || nios2_fpu_insns[nios2_fpu_nios2_slesf].N >= 0)
   && nios2_fpu_insns[nios2_fpu_nios2_seqsf].N >= 0
   && nios2_fpu_insns[nios2_fpu_nios2_snesf].N >= 0"
{
  branch_cmp[0] = operands[0];
  branch_cmp[1] = operands[1];
  branch_type = CMP_SF;
  DONE;
})

(define_expand "cmpdf"
  [(set (cc0)
        (compare:CC (match_operand:DF 0 "register_operand" "")
                    (match_operand:DF 1 "register_operand" "")))]
  "(nios2_fpu_insns[nios2_fpu_nios2_sltdf].N >= 0
   || nios2_fpu_insns[nios2_fpu_nios2_sgtdf].N >= 0)   
   && (nios2_fpu_insns[nios2_fpu_nios2_sgedf].N >= 0
   || nios2_fpu_insns[nios2_fpu_nios2_sledf].N >= 0)
   && nios2_fpu_insns[nios2_fpu_nios2_seqdf].N >= 0
   && nios2_fpu_insns[nios2_fpu_nios2_snedf].N >= 0"
{
  branch_cmp[0] = operands[0];
  branch_cmp[1] = operands[1];
  branch_type = CMP_DF;
  DONE;
})


;*****************************************************************************
;*
;* setting a register from a comparison
;*
;*****************************************************************************

(define_expand "seq"
  [(set (match_operand:SI 0 "register_src_operand" "=r")
        (eq:SI (match_dup 1)
               (match_dup 2)))]
  ""
{
  if (branch_type != CMP_SI && branch_type != CMP_SF && branch_type != CMP_DF)
    FAIL;

  /* set up operands from compare.  */
  operands[1] = branch_cmp[0];
  operands[2] = branch_cmp[1];

  gen_int_relational (EQ, operands[0], operands[1], operands[2], NULL_RTX);
  DONE;
})


(define_insn "*seq"
  [(set (match_operand:SI 0 "register_dest_operand"       "=r")
        (eq:SI (match_operand:SI 1 "reg_or_0_src_operand" "%rM")
               (match_operand:SI 2 "arith_src_operand"    "cP")))]
  ""
  "cmpeq%i2\\t%0, %z1, %z2"
  [(set_attr "type" "alu")])


(define_insn "nios2_seqsf"
  [(set (match_operand:SI 0 "register_operand"        "=c")
        (eq:SI (match_operand:SF 1 "register_operand" "%c")
               (match_operand:SF 2 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_nios2_seqsf].N >= 0
   && nios2_fpu_insns[nios2_fpu_nios2_snesf].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_nios2_seqsf].output) (insn);
  }
  [(set_attr "type" "custom")])


(define_insn "nios2_seqdf"
  [(set (match_operand:SI 0 "register_operand"        "=c")
        (eq:SI (match_operand:DF 1 "register_operand" "%c")
               (match_operand:DF 2 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_nios2_seqdf].N >= 0
   && nios2_fpu_insns[nios2_fpu_nios2_snedf].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_nios2_seqdf].output) (insn);
  }
  [(set_attr "type" "custom")])


(define_expand "sne"
  [(set (match_operand:SI 0 "register_dest_operand" "=r")
        (ne:SI (match_dup 1)
               (match_dup 2)))]
  ""
{
  if (branch_type != CMP_SI && branch_type != CMP_SF && branch_type != CMP_DF)
    FAIL;

  /* set up operands from compare.  */
  operands[1] = branch_cmp[0];
  operands[2] = branch_cmp[1];

  gen_int_relational (NE, operands[0], operands[1], operands[2], NULL_RTX);
  DONE;
})


(define_insn "*sne"
  [(set (match_operand:SI 0 "register_dest_operand"        "=r")
        (ne:SI (match_operand:SI 1 "reg_or_0_src_operand"  "%rM")
               (match_operand:SI 2 "arith_src_operand"     "cP")))]
  ""
  "cmpne%i2\\t%0, %z1, %z2"
  [(set_attr "type" "alu")])


(define_insn "nios2_snesf"
  [(set (match_operand:SI 0 "register_operand"        "=c")
        (ne:SI (match_operand:SF 1 "register_operand" "%c")
               (match_operand:SF 2 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_nios2_seqsf].N >= 0
   && nios2_fpu_insns[nios2_fpu_nios2_snesf].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_nios2_snesf].output) (insn);
  }
  [(set_attr "type" "custom")])


(define_insn "nios2_snedf"
  [(set (match_operand:SI 0 "register_operand"        "=c")
        (ne:SI (match_operand:DF 1 "register_operand" "%c")
               (match_operand:DF 2 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_nios2_seqdf].N >= 0
   && nios2_fpu_insns[nios2_fpu_nios2_snedf].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_nios2_snedf].output) (insn);
  }
  [(set_attr "type" "custom")])


(define_expand "sgt"
  [(set (match_operand:SI 0 "register_operand" "=r")
        (gt:SI (match_dup 1)
               (match_dup 2)))]
  ""
{
  if (branch_type != CMP_SI && branch_type != CMP_SF && branch_type != CMP_DF)
    FAIL;

  /* set up operands from compare.  */
  operands[1] = branch_cmp[0];
  operands[2] = branch_cmp[1];

  gen_int_relational (GT, operands[0], operands[1], operands[2], NULL_RTX);
  DONE;
})


(define_insn "*sgt"
  [(set (match_operand:SI 0 "register_dest_operand"        "=r")
        (gt:SI (match_operand:SI 1 "reg_or_0_src_operand"  "rM")
               (match_operand:SI 2 "reg_or_0_src_operand"  "cM")))]
  ""
  "cmplt\\t%0, %z2, %z1"
  [(set_attr "type" "alu")])


(define_insn "nios2_sgtsf"
  [(set (match_operand:SI 0 "register_operand"        "=c")
        (gt:SI (match_operand:SF 1 "register_operand" "c")
               (match_operand:SF 2 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_nios2_sgtsf].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_nios2_sgtsf].output) (insn);
  }
  [(set_attr "type" "custom")])


(define_insn "nios2_sgtdf"
  [(set (match_operand:SI 0 "register_operand"        "=c")
        (gt:SI (match_operand:DF 1 "register_operand" "c")
               (match_operand:DF 2 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_nios2_sgtdf].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_nios2_sgtdf].output) (insn);
  }
  [(set_attr "type" "custom")])


(define_expand "sge"
  [(set (match_operand:SI 0 "register_operand" "=r")
        (ge:SI (match_dup 1)
               (match_dup 2)))]
  ""
{
  if (branch_type != CMP_SI && branch_type != CMP_SF && branch_type != CMP_DF)
    FAIL;

  /* set up operands from compare.  */
  operands[1] = branch_cmp[0];
  operands[2] = branch_cmp[1];

  gen_int_relational (GE, operands[0], operands[1], operands[2], NULL_RTX);
  DONE;
})


(define_insn "*sge"
  [(set (match_operand:SI 0 "register_dest_operand"        "=r")
        (ge:SI (match_operand:SI 1 "reg_or_0_src_operand"  "rM")
               (match_operand:SI 2 "arith_src_operand"     "cP")))]
  ""
  "cmpge%i2\\t%0, %z1, %z2"
  [(set_attr "type" "alu")])


(define_insn "nios2_sgesf"
  [(set (match_operand:SI 0 "register_operand"        "=c")
        (ge:SI (match_operand:SF 1 "register_operand" "c")
               (match_operand:SF 2 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_nios2_sgesf].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_nios2_sgesf].output) (insn);
  }
  [(set_attr "type" "custom")])


(define_insn "nios2_sgedf"
  [(set (match_operand:SI 0 "register_operand"        "=c")
        (ge:SI (match_operand:DF 1 "register_operand" "c")
               (match_operand:DF 2 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_nios2_sgedf].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_nios2_sgedf].output) (insn);
  }
  [(set_attr "type" "custom")])


(define_expand "sle"
  [(set (match_operand:SI 0 "register_operand" "=r")
        (le:SI (match_dup 1)
               (match_dup 2)))]
  ""
{
  if (branch_type != CMP_SI && branch_type != CMP_SF && branch_type != CMP_DF)
    FAIL;

  /* set up operands from compare.  */
  operands[1] = branch_cmp[0];
  operands[2] = branch_cmp[1];

  gen_int_relational (LE, operands[0], operands[1], operands[2], NULL_RTX);
  DONE;
})


(define_insn "*sle"
  [(set (match_operand:SI 0 "register_dest_operand"        "=r")
        (le:SI (match_operand:SI 1 "reg_or_0_src_operand"  "rM")
               (match_operand:SI 2 "reg_or_0_src_operand"  "cM")))]
  ""
  "cmpge\\t%0, %z2, %z1"
  [(set_attr "type" "alu")])


(define_insn "nios2_slesf"
  [(set (match_operand:SI 0 "register_operand"        "=c")
        (le:SI (match_operand:SF 1 "register_operand" "c")
               (match_operand:SF 2 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_nios2_slesf].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_nios2_slesf].output) (insn);
  }
  [(set_attr "type" "custom")])


(define_insn "nios2_sledf"
  [(set (match_operand:SI 0 "register_operand"        "=c")
        (le:SI (match_operand:DF 1 "register_operand" "c")
               (match_operand:DF 2 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_nios2_sledf].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_nios2_sledf].output) (insn);
  }
  [(set_attr "type" "custom")])


(define_expand "slt"
  [(set (match_operand:SI 0 "register_operand" "=r")
        (lt:SI (match_dup 1)
               (match_dup 2)))]
  ""
{
  if (branch_type != CMP_SI && branch_type != CMP_SF && branch_type != CMP_DF)
    FAIL;

  /* set up operands from compare.  */
  operands[1] = branch_cmp[0];
  operands[2] = branch_cmp[1];

  gen_int_relational (LT, operands[0], operands[1], operands[2], NULL_RTX);
  DONE;
})


(define_insn "*slt"
  [(set (match_operand:SI 0 "register_dest_operand"        "=r")
        (lt:SI (match_operand:SI 1 "reg_or_0_src_operand"  "rM")
               (match_operand:SI 2 "arith_src_operand"     "cP")))]
  ""
  "cmplt%i2\\t%0, %z1, %z2"
  [(set_attr "type" "alu")])


(define_insn "nios2_sltsf"
  [(set (match_operand:SI 0 "register_operand"        "=c")
        (lt:SI (match_operand:SF 1 "register_operand" "c")
               (match_operand:SF 2 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_nios2_sltsf].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_nios2_sltsf].output) (insn);
  }
  [(set_attr "type" "custom")])


(define_insn "nios2_sltdf"
  [(set (match_operand:SI 0 "register_operand"        "=c")
        (lt:SI (match_operand:DF 1 "register_operand" "c")
               (match_operand:DF 2 "register_operand" "c")))]
  "nios2_fpu_insns[nios2_fpu_nios2_sltdf].N >= 0"
  {
    return (*nios2_fpu_insns[nios2_fpu_nios2_sltdf].output) (insn);
  }
  [(set_attr "type" "custom")])


(define_expand "sgtu"
  [(set (match_operand:SI 0 "register_operand" "=r")
        (gtu:SI (match_dup 1)
                (match_dup 2)))]
  ""
{
  if (branch_type != CMP_SI)
    FAIL;

  /* set up operands from compare.  */
  operands[1] = branch_cmp[0];
  operands[2] = branch_cmp[1];

  gen_int_relational (GTU, operands[0], operands[1], operands[2], NULL_RTX);
  DONE;
})


(define_insn "*sgtu"
  [(set (match_operand:SI 0 "register_dest_operand"         "=r")
        (gtu:SI (match_operand:SI 1 "reg_or_0_src_operand"  "rM")
                (match_operand:SI 2 "reg_or_0_src_operand"  "cM")))]
  ""
  "cmpltu\\t%0, %z2, %z1"
  [(set_attr "type" "alu")])


(define_expand "sgeu"
  [(set (match_operand:SI 0 "register_operand" "=r")
        (geu:SI (match_dup 1)
                (match_dup 2)))]
  ""
{
  if (branch_type != CMP_SI)
    FAIL;

  /* set up operands from compare.  */
  operands[1] = branch_cmp[0];
  operands[2] = branch_cmp[1];

  gen_int_relational (GEU, operands[0], operands[1], operands[2], NULL_RTX);
  DONE;
})


(define_insn "*sgeu"
  [(set (match_operand:SI 0 "register_dest_operand"        "=r")
        (geu:SI (match_operand:SI 1 "reg_or_0_src_operand"  "rM")
                (match_operand:SI 2 "uns_arith_src_operand" "cQ")))]
  ""
  "cmpgeu%i2\\t%0, %z1, %z2"
  [(set_attr "type" "alu")])

(define_expand "sleu"
  [(set (match_operand:SI 0 "register_operand" "=r")
        (leu:SI (match_dup 1)
                (match_dup 2)))]
  ""
{
  if (branch_type != CMP_SI)
    FAIL;

  /* set up operands from compare.  */
  operands[1] = branch_cmp[0];
  operands[2] = branch_cmp[1];

  gen_int_relational (LEU, operands[0], operands[1], operands[2], NULL_RTX);
  DONE;
})


(define_insn "*sleu"
  [(set (match_operand:SI 0 "register_dest_operand"         "=r")
        (leu:SI (match_operand:SI 1 "reg_or_0_src_operand"  "rM")
                (match_operand:SI 2 "reg_or_0_src_operand"  "cM")))]
  ""
  "cmpgeu\\t%0, %z2, %z1"
  [(set_attr "type" "alu")])


(define_expand "sltu"
  [(set (match_operand:SI 0 "register_operand" "=r")
        (ltu:SI (match_dup 1)
                (match_dup 2)))]
  ""
{
  if (branch_type != CMP_SI)
    FAIL;

  /* set up operands from compare.  */
  operands[1] = branch_cmp[0];
  operands[2] = branch_cmp[1];

  gen_int_relational (LTU, operands[0], operands[1], operands[2], NULL_RTX);
  DONE;
})


(define_insn "*sltu"
  [(set (match_operand:SI 0 "register_dest_operand"         "=r")
        (ltu:SI (match_operand:SI 1 "reg_or_0_src_operand"  "rM")
                (match_operand:SI 2 "uns_arith_src_operand" "cQ")))]
  ""
  "cmpltu%i2\\t%0, %z1, %z2"
  [(set_attr "type" "alu")])




;*****************************************************************************
;*
;* branches
;*
;*****************************************************************************

(define_insn "*cbranch"
  [(set (pc)
        (if_then_else
         (match_operator:SI 0 "comparison_operator"
                            [(match_operand:SI 2 "reg_or_0_src_operand" "rM")
                             (match_operand:SI 3 "reg_or_0_operand" "cM")])
        (label_ref (match_operand 1 "" ""))
        (pc)))]
  ""
  "b%0\\t%z2, %z3, %l1"
  [(set_attr "type" "control")])


(define_insn "nios2_cbranch_sf"
  [(set (pc)
        (if_then_else
         (match_operator:SI 0 "comparison_operator"
                            [(match_operand:SF 2 "register_operand" "c")
                             (match_operand:SF 3 "register_operand" "c")])
        (label_ref (match_operand 1 "" ""))
        (pc)))]
  "(nios2_fpu_insns[nios2_fpu_nios2_sltsf].N >= 0
   || nios2_fpu_insns[nios2_fpu_nios2_sgtsf].N >= 0)
   && (nios2_fpu_insns[nios2_fpu_nios2_sgesf].N >= 0
   || nios2_fpu_insns[nios2_fpu_nios2_slesf].N >= 0)
   && nios2_fpu_insns[nios2_fpu_nios2_seqsf].N >= 0
   && nios2_fpu_insns[nios2_fpu_nios2_snesf].N >= 0"
  {
    return nios2_output_fpu_insn_cmps (insn, GET_CODE (operands[0]));
  }
  [(set_attr "type" "custom")])


(define_insn "nios2_cbranch_df"
  [(set (pc)
        (if_then_else
         (match_operator:SI 0 "comparison_operator"
                            [(match_operand:DF 2 "register_operand" "c")
                             (match_operand:DF 3 "register_operand" "c")])
        (label_ref (match_operand 1 "" ""))
        (pc)))]
  "(nios2_fpu_insns[nios2_fpu_nios2_sltdf].N >= 0
   || nios2_fpu_insns[nios2_fpu_nios2_sgtdf].N >= 0)
   && (nios2_fpu_insns[nios2_fpu_nios2_sgedf].N >= 0
   || nios2_fpu_insns[nios2_fpu_nios2_sledf].N >= 0)
   && nios2_fpu_insns[nios2_fpu_nios2_seqdf].N >= 0
   && nios2_fpu_insns[nios2_fpu_nios2_snedf].N >= 0"
  {
    return nios2_output_fpu_insn_cmpd (insn, GET_CODE (operands[0]));
  }
  [(set_attr "type" "custom")])


(define_expand "beq"
  [(set (pc)
        (if_then_else (eq:CC (cc0)
                             (const_int 0))
                      (label_ref (match_operand 0 "" ""))
                      (pc)))]
  ""
{
  gen_int_relational (EQ, NULL_RTX, branch_cmp[0], branch_cmp[1], operands[0]);
  DONE;
})


(define_expand "bne"
  [(set (pc)
        (if_then_else (ne:CC (cc0)
                             (const_int 0))
                      (label_ref (match_operand 0 "" ""))
                      (pc)))]
  ""
{
  gen_int_relational (NE, NULL_RTX, branch_cmp[0], branch_cmp[1], operands[0]);
  DONE;
})


(define_expand "bgt"
  [(set (pc)
        (if_then_else (gt:CC (cc0)
                             (const_int 0))
                      (label_ref (match_operand 0 "" ""))
                      (pc)))]
  ""
{
  gen_int_relational (GT, NULL_RTX, branch_cmp[0], branch_cmp[1], operands[0]);
  DONE;
})

(define_expand "bge"
  [(set (pc)
        (if_then_else (ge:CC (cc0)
                             (const_int 0))
                      (label_ref (match_operand 0 "" ""))
                      (pc)))]
  ""
{
  gen_int_relational (GE, NULL_RTX, branch_cmp[0], branch_cmp[1], operands[0]);
  DONE;
})

(define_expand "ble"
  [(set (pc)
        (if_then_else (le:CC (cc0)
                             (const_int 0))
                      (label_ref (match_operand 0 "" ""))
                      (pc)))]
  ""
{
  gen_int_relational (LE, NULL_RTX, branch_cmp[0], branch_cmp[1], operands[0]);
  DONE;
})

(define_expand "blt"
  [(set (pc)
        (if_then_else (lt:CC (cc0)
                             (const_int 0))
                      (label_ref (match_operand 0 "" ""))
                      (pc)))]
  ""
{
  gen_int_relational (LT, NULL_RTX, branch_cmp[0], branch_cmp[1], operands[0]);
  DONE;
})


(define_expand "bgtu"
  [(set (pc)
        (if_then_else (gtu:CC (cc0)
                              (const_int 0))
                      (label_ref (match_operand 0 "" ""))
                      (pc)))]
  ""
{
  gen_int_relational (GTU, NULL_RTX, branch_cmp[0], branch_cmp[1], operands[0]);
  DONE;
})

(define_expand "bgeu"
  [(set (pc)
        (if_then_else (geu:CC (cc0)
                              (const_int 0))
                      (label_ref (match_operand 0 "" ""))
                      (pc)))]
  ""
{
  gen_int_relational (GEU, NULL_RTX, branch_cmp[0], branch_cmp[1], operands[0]);
  DONE;
})

(define_expand "bleu"
  [(set (pc)
        (if_then_else (leu:CC (cc0)
                              (const_int 0))
                      (label_ref (match_operand 0 "" ""))
                      (pc)))]
  ""
{
  gen_int_relational (LEU, NULL_RTX, branch_cmp[0], branch_cmp[1], operands[0]);
  DONE;
})

(define_expand "bltu"
  [(set (pc)
        (if_then_else (ltu:CC (cc0)
                              (const_int 0))
                      (label_ref (match_operand 0 "" ""))
                      (pc)))]
  ""
{
  gen_int_relational (LTU, NULL_RTX, branch_cmp[0], branch_cmp[1], operands[0]);
  DONE;
})


;*****************************************************************************
;*
;* String and Block Operations
;*
;*****************************************************************************

; ??? This is all really a hack to get Dhrystone to work as fast as possible
;     things to be fixed:
;        * let the compiler core handle all of this, for that to work the extra
;          aliasing needs to be addressed.
;        * we use three temporary registers for loading and storing to ensure no
;          ld use stalls, this is excessive, because after the first ld/st only
;          two are needed. Only two would be needed all the way through if 
;          we could schedule with other code. Consider:
;           1  ld $1, 0($src)
;           2  ld $2, 4($src)
;           3  ld $3, 8($src)
;           4  st $1, 0($dest)
;           5  ld $1, 12($src)
;           6  st $2, 4($src)
;           7  etc.
;          The first store has to wait until 4. If it does not there will be one
;          cycle of stalling. However, if any other instruction could be placed
;          between 1 and 4, $3 would not be needed.
;        * In small we probably don't want to ever do this ourself because there
;          is no ld use stall.

(define_expand "movstrsi"
  [(parallel [(set (match_operand:BLK 0 "general_operand"  "")
                   (match_operand:BLK 1 "general_operand"  ""))
              (use (match_operand:SI 2 "const_int_operand" ""))
              (use (match_operand:SI 3 "const_int_operand" ""))
              (clobber (match_scratch:SI 4                "=&r"))
              (clobber (match_scratch:SI 5                "=&r"))
              (clobber (match_scratch:SI 6                "=&r"))])]
  "TARGET_INLINE_MEMCPY &&!TARGET_ARCH_NIOS2DPX"
{
  rtx ld_addr_reg, st_addr_reg;

  /* If the predicate for op2 fails in expr.c:emit_block_move_via_movstr 
     it trys to copy to a register, but does not re-try the predicate.
     ??? Intead of fixing expr.c, I fix it here. */
  if (!const_int_operand (operands[2], SImode))
    FAIL;

  /* ??? there are some magic numbers which need to be sorted out here.
         the basis for them is not increasing code size hugely or going
         out of range of offset addressing */
  if (INTVAL (operands[3]) < 4)
    FAIL;
  if (!optimize
      || (optimize_size && INTVAL (operands[2]) > 12)
      || (optimize < 3 && INTVAL (operands[2]) > 100)
      || INTVAL (operands[2]) > 200)
    FAIL;

  st_addr_reg
    = replace_equiv_address (operands[0],
                             copy_to_mode_reg (Pmode, XEXP (operands[0], 0)));
  ld_addr_reg
    = replace_equiv_address (operands[1],
                             copy_to_mode_reg (Pmode, XEXP (operands[1], 0)));
  emit_insn (gen_movstrsi_internal (st_addr_reg, ld_addr_reg,
                                    operands[2], operands[3]));

  DONE;
})


(define_insn "movstrsi_internal"
  [(set (match_operand:BLK 0 "memory_operand"   "=o")
        (match_operand:BLK 1 "memory_operand"    "o"))
   (use (match_operand:SI 2 "const_int_operand"  "i"))
   (use (match_operand:SI 3 "const_int_operand"  "i"))
   (clobber (match_scratch:SI 4                "=&r"))
   (clobber (match_scratch:SI 5                "=&r"))
   (clobber (match_scratch:SI 6                "=&r"))]
  "TARGET_INLINE_MEMCPY && !TARGET_ARCH_NIOS2DPX"
{
  int ld_offset = INTVAL (operands[2]);
  int ld_len = INTVAL (operands[2]);
  int ld_reg = 0;
  rtx ld_addr_reg = XEXP (operands[1], 0);
  int st_offset = INTVAL (operands[2]);
  int st_len = INTVAL (operands[2]);
  int st_reg = 0;
  rtx st_addr_reg = XEXP (operands[0], 0);
  int delay_count = 0;
  
  /* ops[0] is the address used by the insn
     ops[1] is the register being loaded or stored */
  rtx ops[2];
  
  gcc_assert (INTVAL (operands[3]) >= 4);
  
  while (ld_offset >= 4)
    {
      /* if the load use delay has been met, I can start
         storing */
      if (delay_count >= 3)
        {
          ops[0] = gen_rtx_MEM (SImode, 
                            plus_constant (st_addr_reg, st_len - st_offset));
          ops[1] = operands[st_reg + 4];                         
          output_asm_insn ("stw\t%1, %0", ops);
          
          st_reg = (st_reg + 1) % 3;
          st_offset -= 4;
        }
    
      ops[0] = gen_rtx_MEM (SImode, 
                        plus_constant (ld_addr_reg, ld_len - ld_offset));
      ops[1] = operands[ld_reg + 4];                     
      output_asm_insn ("ldw\t%1, %0", ops);
      
      ld_reg = (ld_reg + 1) % 3;
      ld_offset -= 4;
      delay_count++;
    }
  
  if (ld_offset >= 2)
    {
      /* if the load use delay has been met, I can start
         storing */
      if (delay_count >= 3)
        {
          ops[0] = gen_rtx_MEM (SImode, 
                            plus_constant (st_addr_reg, st_len - st_offset));
          ops[1] = operands[st_reg + 4];                         
          output_asm_insn ("stw\t%1, %0", ops);
          
          st_reg = (st_reg + 1) % 3;
          st_offset -= 4;
        }
    
      ops[0] = gen_rtx_MEM (HImode, 
                        plus_constant (ld_addr_reg, ld_len - ld_offset));
      ops[1] = operands[ld_reg + 4];                     
      output_asm_insn ("ldh\t%1, %0", ops);
      
      ld_reg = (ld_reg + 1) % 3;
      ld_offset -= 2;
      delay_count++;
    }
  
  if (ld_offset >= 1)
    {
      /* if the load use delay has been met, I can start
         storing */
      if (delay_count >= 3)
        {
          ops[0] = gen_rtx_MEM (SImode, 
                            plus_constant (st_addr_reg, st_len - st_offset));
          ops[1] = operands[st_reg + 4];                         
          output_asm_insn ("stw\t%1, %0", ops);
          
          st_reg = (st_reg + 1) % 3;
          st_offset -= 4;
        }
    
      ops[0] = gen_rtx_MEM (QImode, 
                        plus_constant (ld_addr_reg, ld_len - ld_offset));
      ops[1] = operands[ld_reg + 4];                     
      output_asm_insn ("ldb\t%1, %0", ops);
      
      ld_reg = (ld_reg + 1) % 3;
      ld_offset -= 1;
      delay_count++;
    }

    while (st_offset >= 4)
      {
        ops[0] = gen_rtx_MEM (SImode, 
                          plus_constant (st_addr_reg, st_len - st_offset));
        ops[1] = operands[st_reg + 4];                   
        output_asm_insn ("stw\t%1, %0", ops);

        st_reg = (st_reg + 1) % 3;
        st_offset -= 4;
      }
  
    while (st_offset >= 2)
      {
        ops[0] = gen_rtx_MEM (HImode, 
                          plus_constant (st_addr_reg, st_len - st_offset));
        ops[1] = operands[st_reg + 4];                   
        output_asm_insn ("sth\t%1, %0", ops);

        st_reg = (st_reg + 1) % 3;
        st_offset -= 2;
      }
  
    while (st_offset >= 1)
      {
        ops[0] = gen_rtx_MEM (QImode, 
                          plus_constant (st_addr_reg, st_len - st_offset));
        ops[1] = operands[st_reg + 4];                   
        output_asm_insn ("stb\t%1, %0", ops);

        st_reg = (st_reg + 1) % 3;
        st_offset -= 1;
      }
  
  return "";
}
; ??? lengths are not being used yet, but I will probably forget
; to update this once I am using lengths, so set it to something
; definetely big enough to cover it. 400 allows for 200 bytes
; of motion.
  [(set_attr "length" "400")])



;*****************************************************************************
;*
;* Custom instructions
;*
;*****************************************************************************

(define_constants [
  (CUSTOM_N 100)
  (CUSTOM_NI 101)
  (CUSTOM_NF 102)
  (CUSTOM_NP 103)
  (CUSTOM_NII 104)
  (CUSTOM_NIF 105)
  (CUSTOM_NIP 106)
  (CUSTOM_NFI 107)
  (CUSTOM_NFF 108)
  (CUSTOM_NFP 109)
  (CUSTOM_NPI 110)
  (CUSTOM_NPF 111)
  (CUSTOM_NPP 112)
  (CUSTOM_IN 113)
  (CUSTOM_INI 114)
  (CUSTOM_INF 115)
  (CUSTOM_INP 116)
  (CUSTOM_INII 117)
  (CUSTOM_INIF 118)
  (CUSTOM_INIP 119)
  (CUSTOM_INFI 120)
  (CUSTOM_INFF 121)
  (CUSTOM_INFP 122)
  (CUSTOM_INPI 123)
  (CUSTOM_INPF 124)
  (CUSTOM_INPP 125)
  (CUSTOM_FN 126)
  (CUSTOM_FNI 127)
  (CUSTOM_FNF 128)
  (CUSTOM_FNP 129)
  (CUSTOM_FNII 130)
  (CUSTOM_FNIF 131)
  (CUSTOM_FNIP 132)
  (CUSTOM_FNFI 133)
  (CUSTOM_FNFF 134)
  (CUSTOM_FNFP 135)
  (CUSTOM_FNPI 136)
  (CUSTOM_FNPF 137)
  (CUSTOM_FNPP 138)
  (CUSTOM_PN 139)
  (CUSTOM_PNI 140)
  (CUSTOM_PNF 141)
  (CUSTOM_PNP 142)
  (CUSTOM_PNII 143)
  (CUSTOM_PNIF 144)
  (CUSTOM_PNIP 145)
  (CUSTOM_PNFI 146)
  (CUSTOM_PNFF 147)
  (CUSTOM_PNFP 148)
  (CUSTOM_PNPI 149)
  (CUSTOM_PNPF 150)
  (CUSTOM_PNPP 151)
])


(define_insn "custom_n"
  [(unspec_volatile [(match_operand:SI 0 "custom_insn_opcode" "N")] CUSTOM_N)]
  ""
  "custom\\t%0, zero, zero, zero"
  [(set_attr "type" "custom")])

(define_insn "custom_ni"
  [(unspec_volatile [(match_operand:SI 0 "custom_insn_opcode" "N")
                     (match_operand:SI 1 "register_operand"   "c")] CUSTOM_NI)]
  ""
  "custom\\t%0, zero, %1, zero"
  [(set_attr "type" "custom")])

(define_insn "custom_nf"
  [(unspec_volatile [(match_operand:SI 0 "custom_insn_opcode" "N")
                     (match_operand:SF 1 "register_operand"   "c")] CUSTOM_NF)]
  ""
  "custom\\t%0, zero, %1, zero"
  [(set_attr "type" "custom")])

(define_insn "custom_np"
  [(unspec_volatile [(match_operand:SI 0 "custom_insn_opcode" "N")
                     (match_operand:SI 1 "register_operand"   "c")] CUSTOM_NP)]
  ""
  "custom\\t%0, zero, %1, zero"
  [(set_attr "type" "custom")])

(define_insn "custom_nii"
  [(unspec_volatile [(match_operand:SI 0 "custom_insn_opcode" "N")
                     (match_operand:SI 1 "register_operand"   "c")
                     (match_operand:SI 2 "register_operand"   "c")] CUSTOM_NII)]
  ""
  "custom\\t%0, zero, %1, %2"
  [(set_attr "type" "custom")])

(define_insn "custom_nif"
  [(unspec_volatile [(match_operand:SI 0 "custom_insn_opcode" "N")
                     (match_operand:SI 1 "register_operand"   "c")
                     (match_operand:SF 2 "register_operand"   "c")] CUSTOM_NIF)]
  ""
  "custom\\t%0, zero, %1, %2"
  [(set_attr "type" "custom")])

(define_insn "custom_nip"
  [(unspec_volatile [(match_operand:SI 0 "custom_insn_opcode" "N")
                     (match_operand:SI 1 "register_operand"   "c")
                     (match_operand:SI 2 "register_operand"   "c")] CUSTOM_NIP)]
  ""
  "custom\\t%0, zero, %1, %2"
  [(set_attr "type" "custom")])

(define_insn "custom_nfi"
  [(unspec_volatile [(match_operand:SI 0 "custom_insn_opcode" "N")
                     (match_operand:SF 1 "register_operand"   "c")
                     (match_operand:SI 2 "register_operand"   "c")] CUSTOM_NFI)]
  ""
  "custom\\t%0, zero, %1, %2"
  [(set_attr "type" "custom")])

(define_insn "custom_nff"
  [(unspec_volatile [(match_operand:SI 0 "custom_insn_opcode" "N")
                     (match_operand:SF 1 "register_operand"   "c")
                     (match_operand:SF 2 "register_operand"   "c")] CUSTOM_NFF)]
  ""
  "custom\\t%0, zero, %1, %2"
  [(set_attr "type" "custom")])

(define_insn "custom_nfp"
  [(unspec_volatile [(match_operand:SI 0 "custom_insn_opcode" "N")
                     (match_operand:SF 1 "register_operand"   "c")
                     (match_operand:SI 2 "register_operand"   "c")] CUSTOM_NFP)]
  ""
  "custom\\t%0, zero, %1, %2"
  [(set_attr "type" "custom")])

(define_insn "custom_npi"
  [(unspec_volatile [(match_operand:SI 0 "custom_insn_opcode" "N")
                     (match_operand:SI 1 "register_operand"   "c")
                     (match_operand:SI 2 "register_operand"   "c")] CUSTOM_NPI)]
  ""
  "custom\\t%0, zero, %1, %2"
  [(set_attr "type" "custom")])

(define_insn "custom_npf"
  [(unspec_volatile [(match_operand:SI 0 "custom_insn_opcode" "N")
                     (match_operand:SI 1 "register_operand"   "c")
                     (match_operand:SF 2 "register_operand"   "c")] CUSTOM_NPF)]
  ""
  "custom\\t%0, zero, %1, %2"
  [(set_attr "type" "custom")])

(define_insn "custom_npp"
  [(unspec_volatile [(match_operand:SI 0 "custom_insn_opcode" "N")
                     (match_operand:SI 1 "register_operand"   "c")
                     (match_operand:SI 2 "register_operand"   "c")] CUSTOM_NPP)]
  ""
  "custom\\t%0, zero, %1, %2"
  [(set_attr "type" "custom")])



(define_insn "custom_in"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")] 
	 CUSTOM_IN))]
  ""
  "custom\\t%1, %0, zero, zero"
  [(set_attr "type" "custom")])

(define_insn "custom_ini"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SI 2 "register_operand"   "c")] 
	 CUSTOM_INI))]
  ""
  "custom\\t%1, %0, %2, zero"
  [(set_attr "type" "custom")])

(define_insn "custom_inf"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SF 2 "register_operand"   "c")] 
	 CUSTOM_INF))]
  ""
  "custom\\t%1, %0, %2, zero"
  [(set_attr "type" "custom")])

(define_insn "custom_inp"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SI 2 "register_operand"   "c")] 
	 CUSTOM_INP))]
  ""
  "custom\\t%1, %0, %2, zero"
  [(set_attr "type" "custom")])

(define_insn "custom_inii"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SI 2 "register_operand"   "c")
                             (match_operand:SI 3 "register_operand"   "c")] 
	 CUSTOM_INII))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])

(define_insn "custom_inif"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SI 2 "register_operand"   "c")
                             (match_operand:SF 3 "register_operand"   "c")] 
	 CUSTOM_INIF))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])

(define_insn "custom_inip"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SI 2 "register_operand"   "c")
                             (match_operand:SI 3 "register_operand"   "c")] 
	 CUSTOM_INIP))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])

(define_insn "custom_infi"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SF 2 "register_operand"   "c")
                             (match_operand:SI 3 "register_operand"   "c")] 
	 CUSTOM_INFI))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])

(define_insn "custom_inff"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SF 2 "register_operand"   "c")
                             (match_operand:SF 3 "register_operand"   "c")] 
	 CUSTOM_INFF))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])

(define_insn "custom_infp"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SF 2 "register_operand"   "c")
                             (match_operand:SI 3 "register_operand"   "c")] 
	 CUSTOM_INFP))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])

(define_insn "custom_inpi"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SI 2 "register_operand"   "c")
                             (match_operand:SI 3 "register_operand"   "c")] 
	 CUSTOM_INPI))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])

(define_insn "custom_inpf"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SI 2 "register_operand"   "c")
                             (match_operand:SF 3 "register_operand"   "c")] 
	 CUSTOM_INPF))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])

(define_insn "custom_inpp"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SI 2 "register_operand"   "c")
                             (match_operand:SI 3 "register_operand"   "c")] 
	 CUSTOM_INPP))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])





(define_insn "custom_fn"
  [(set (match_operand:SF 0 "register_operand"   "=c")
        (unspec_volatile:SF [(match_operand:SI 1 "custom_insn_opcode" "N")] 
	 CUSTOM_FN))]
  ""
  "custom\\t%1, %0, zero, zero"
  [(set_attr "type" "custom")])

(define_insn "custom_fni"
  [(set (match_operand:SF 0 "register_operand"   "=c")
        (unspec_volatile:SF [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SI 2 "register_operand"   "c")] 
	 CUSTOM_FNI))]
  ""
  "custom\\t%1, %0, %2, zero"
  [(set_attr "type" "custom")])

(define_insn "custom_fnf"
  [(set (match_operand:SF 0 "register_operand"   "=c")
        (unspec_volatile:SF [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SF 2 "register_operand"   "c")] 
	 CUSTOM_FNF))]
  ""
  "custom\\t%1, %0, %2, zero"
  [(set_attr "type" "custom")])

(define_insn "custom_fnp"
  [(set (match_operand:SF 0 "register_operand"   "=c")
        (unspec_volatile:SF [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SI 2 "register_operand"   "c")] 
	 CUSTOM_FNP))]
  ""
  "custom\\t%1, %0, %2, zero"
  [(set_attr "type" "custom")])

(define_insn "custom_fnii"
  [(set (match_operand:SF 0 "register_operand"   "=c")
        (unspec_volatile:SF [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SI 2 "register_operand"   "c")
                             (match_operand:SI 3 "register_operand"   "c")] 
	 CUSTOM_FNII))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])

(define_insn "custom_fnif"
  [(set (match_operand:SF 0 "register_operand"   "=c")
        (unspec_volatile:SF [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SI 2 "register_operand"   "c")
                             (match_operand:SF 3 "register_operand"   "c")] 
	 CUSTOM_FNIF))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])

(define_insn "custom_fnip"
  [(set (match_operand:SF 0 "register_operand"   "=c")
        (unspec_volatile:SF [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SI 2 "register_operand"   "c")
                             (match_operand:SI 3 "register_operand"   "c")] 
	 CUSTOM_FNIP))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])

(define_insn "custom_fnfi"
  [(set (match_operand:SF 0 "register_operand"   "=c")
        (unspec_volatile:SF [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SF 2 "register_operand"   "c")
                             (match_operand:SI 3 "register_operand"   "c")] 
	 CUSTOM_FNFI))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])

(define_insn "custom_fnff"
  [(set (match_operand:SF 0 "register_operand"   "=c")
        (unspec_volatile:SF [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SF 2 "register_operand"   "c")
                             (match_operand:SF 3 "register_operand"   "c")] 
	 CUSTOM_FNFF))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])

(define_insn "custom_fnfp"
  [(set (match_operand:SF 0 "register_operand"   "=c")
        (unspec_volatile:SF [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SF 2 "register_operand"   "c")
                             (match_operand:SI 3 "register_operand"   "c")] 
	 CUSTOM_FNFP))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])

(define_insn "custom_fnpi"
  [(set (match_operand:SF 0 "register_operand"   "=c")
        (unspec_volatile:SF [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SI 2 "register_operand"   "c")
                             (match_operand:SI 3 "register_operand"   "c")] 
	 CUSTOM_FNPI))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])

(define_insn "custom_fnpf"
  [(set (match_operand:SF 0 "register_operand"   "=c")
        (unspec_volatile:SF [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SI 2 "register_operand"   "c")
                             (match_operand:SF 3 "register_operand"   "c")] 
	 CUSTOM_FNPF))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])

(define_insn "custom_fnpp"
  [(set (match_operand:SF 0 "register_operand"   "=c")
        (unspec_volatile:SF [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SI 2 "register_operand"   "c")
                             (match_operand:SI 3 "register_operand"   "c")] 
	 CUSTOM_FNPP))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])



(define_insn "custom_pn"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")] 
	 CUSTOM_PN))]
  ""
  "custom\\t%1, %0, zero, zero"
  [(set_attr "type" "custom")])

(define_insn "custom_pni"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SI 2 "register_operand"   "c")] 
	 CUSTOM_PNI))]
  ""
  "custom\\t%1, %0, %2, zero"
  [(set_attr "type" "custom")])

(define_insn "custom_pnf"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SF 2 "register_operand"   "c")] 
	 CUSTOM_PNF))]
  ""
  "custom\\t%1, %0, %2, zero"
  [(set_attr "type" "custom")])

(define_insn "custom_pnp"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SI 2 "register_operand"   "c")] 
	 CUSTOM_PNP))]
  ""
  "custom\\t%1, %0, %2, zero"
  [(set_attr "type" "custom")])

(define_insn "custom_pnii"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SI 2 "register_operand"   "c")
                             (match_operand:SI 3 "register_operand"   "c")] 
 	 CUSTOM_PNII))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])

(define_insn "custom_pnif"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SI 2 "register_operand"   "c")
                             (match_operand:SF 3 "register_operand"   "c")] 
	 CUSTOM_PNIF))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])

(define_insn "custom_pnip"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SI 2 "register_operand"   "c")
                             (match_operand:SI 3 "register_operand"   "c")] 
	 CUSTOM_PNIP))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])

(define_insn "custom_pnfi"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SF 2 "register_operand"   "c")
                             (match_operand:SI 3 "register_operand"   "c")] 
	 CUSTOM_PNFI))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])

(define_insn "custom_pnff"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SF 2 "register_operand"   "c")
                             (match_operand:SF 3 "register_operand"   "c")] 
	 CUSTOM_PNFF))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])

(define_insn "custom_pnfp"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SF 2 "register_operand"   "c")
                             (match_operand:SI 3 "register_operand"   "c")] 
	 CUSTOM_PNFP))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])

(define_insn "custom_pnpi"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SI 2 "register_operand"   "c")
                             (match_operand:SI 3 "register_operand"   "c")] 
	 CUSTOM_PNPI))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])

(define_insn "custom_pnpf"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SI 2 "register_operand"   "c")
                             (match_operand:SF 3 "register_operand"   "c")] 
	 CUSTOM_PNPF))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])

(define_insn "custom_pnpp"
  [(set (match_operand:SI 0 "register_operand"   "=c")
        (unspec_volatile:SI [(match_operand:SI 1 "custom_insn_opcode" "N")
                             (match_operand:SI 2 "register_operand"   "c")
                             (match_operand:SI 3 "register_operand"   "c")] 
	 CUSTOM_PNPP))]
  ""
  "custom\\t%1, %0, %2, %3"
  [(set_attr "type" "custom")])






;*****************************************************************************
;*
;* Misc
;*
;*****************************************************************************

(define_insn "nop"
  [(const_int 0)]
  ""
  "nop\\t"
  [(set_attr "type" "alu")])

(define_insn "sync"
  [(unspec_volatile [(const_int 0)] UNSPEC_SYNC)]
  ""
  "sync\\t"
  [(set_attr "type" "control")])


(define_insn "rdctl"
  [(set (match_operand:SI 0 "register_dest_operand" "=r")
        (unspec_volatile:SI [(match_operand:SI 1 "rdwrctl_operand" "O")] 
	 UNSPEC_RDCTL))]
  ""
  "rdctl\\t%0, ctl%1"
  [(set_attr "type" "control")])

(define_insn "wrctl"
  [(unspec_volatile:SI [(match_operand:SI 0 "rdwrctl_operand"  "O")
                        (match_operand:SI 1 "reg_or_0_src_operand" "rM")] 
    UNSPEC_WRCTL)]
  ""
  "wrctl\\tctl%0, %z1"
  [(set_attr "type" "control")])

;Used to signal a stack overflow 
(define_insn "trap"
  [(unspec_volatile [(const_int 0)] UNSPEC_TRAP)]
  ""
  "break\\t3"
  [(set_attr "type" "control")])
  
(define_insn "stack_overflow_detect_and_trap"
  [(unspec_volatile [(const_int 0)] UNSPEC_STACK_OVERFLOW_DETECT_AND_TRAP)]
  ""
  "bgeu\\tsp, et, 1f\;break\\t3\;1:"
  [(set_attr "type" "control")])

;Load the GOT register.
(define_insn "load_got_register"
  [(set (match_operand:SI 0 "register_operand" "=&c")
	 (unspec:SI [(const_int 0)] UNSPEC_LOAD_GOT_REGISTER))
   (set (match_operand:SI 1 "register_operand" "=c")
	 (unspec:SI [(const_int 0)] UNSPEC_LOAD_GOT_REGISTER))]
  ""
  "nextpc\\t%0
\\t1:
\\tmovhi20\\t%1, %%hiadj20(_GLOBAL_OFFSET_TABLE_ - 1b)
\\taddi\\t%1, %1, %%lo12(_GLOBAL_OFFSET_TABLE_ - 1b)"
  [(set_attr "length" "12")])

;; When generating pic, we need to load the symbol offset into a register.
;; So that the optimizer does not confuse this with a normal symbol load
;; we use an unspec.  The offset will be loaded from a constant pool entry,
;; since that is the only type of relocation we can use.

;; The rather odd constraints on the following are to force reload to leave
;; the insn alone, and to force the minipool generation pass to then move
;; the GOT symbol to memory.

;; FIXME:these uses look unnecessary.
(define_insn "pic_load_addr"
  [(set (match_operand:SI 0 "register_operand" "=c")
	(unspec:SI [(match_operand:SI 1 "register_operand" "c")
                    (match_operand:SI 2 "" "mX")] UNSPEC_PIC_SYM))
  (use (match_dup 1))]
  "flag_pic"
  "ldw\\t%0, %%got(%2)(%1)")

(define_insn "pic_load_call_addr"
  [(set (match_operand:SI 0 "register_operand" "=c")
	(unspec:SI [(match_operand:SI 1 "register_operand" "c")
                    (match_operand:SI 2 "" "mX")] UNSPEC_PIC_CALL_SYM))
   (use (match_dup 1))]
  "flag_pic"
  "ldw\\t%0, %%call(%2)(%1)")

;; TLS support

(define_insn "add_tls_gd"
  [(set (match_operand:SI 0 "register_operand" "=c")
	(unspec:SI [(match_operand:SI 1 "register_operand" "c")
		   (match_operand:SI 2 "" "mX")] UNSPEC_ADD_TLS_GD))]
  ""
  "addi\t%0, %1, %%tls_gd(%2)")

(define_insn "load_tls_ie"
  [(set (match_operand:SI 0 "register_operand" "=c")
	(unspec:SI [(match_operand:SI 1 "register_operand" "c")
		    (match_operand:SI 2 "" "mX")] UNSPEC_LOAD_TLS_IE))]
  ""
  "ldw\t%0, %%tls_ie(%2)(%1)")

(define_insn "add_tls_ldm"
  [(set (match_operand:SI 0 "register_operand" "=c")
	(unspec:SI [(match_operand:SI 1 "register_operand" "c")
		    (match_operand:SI 2 "" "mX")] UNSPEC_ADD_TLS_LDM))]
  ""
  "addi\t%0, %1, %%tls_ldm(%2)")

(define_insn "add_tls_ldo"
  [(set (match_operand:SI 0 "register_operand" "=c")
	(unspec:SI [(match_operand:SI 1 "register_operand" "c")
		    (match_operand:SI 2 "" "mX")] UNSPEC_ADD_TLS_LDO))]
  ""
  "addi\t%0, %1, %%tls_ldo(%2)")

(define_insn "add_tls_le"
  [(set (match_operand:SI 0 "register_operand" "=c")
	(unspec:SI [(match_operand:SI 1 "register_operand" "c")
		    (match_operand:SI 2 "" "mX")] UNSPEC_ADD_TLS_LE))]
  ""
  "addi\t%0, %1, %%tls_le(%2)")


(define_insn "snd"
  [(set (match_operand:SI 0 "register_dest_operand"         "=r,r")
        (unspec_volatile:SI [(match_operand:SI 1 "reg_or_0_src_operand" "rM,rM")
                             (match_operand:SI 2 "logical_src_operand"  "cM,J")] UNSPEC_SND))
                           (parallel [ 
                             (use (reg:SI TX0_REGNUM)) (use (reg:SI TX1_REGNUM)) (use (reg:SI TX2_REGNUM)) (use (reg:SI TX3_REGNUM))
                             (use (reg:SI TX4_REGNUM)) (use (reg:SI TX5_REGNUM)) (use (reg:SI TX6_REGNUM)) (use (reg:SI TX7_REGNUM))
                             (use (reg:SI TX8_REGNUM)) (use (reg:SI TX9_REGNUM)) (use (reg:SI TX10_REGNUM)) (use (reg:SI TX11_REGNUM))
                             (use (reg:SI TX12_REGNUM)) (use (reg:SI TX13_REGNUM)) (use (reg:SI TX14_REGNUM)) (use (reg:SI TX15_REGNUM))
                             ])
                           (parallel [
                             (use (reg:SI TX16_REGNUM)) (use (reg:SI TX17_REGNUM)) (use (reg:SI TX18_REGNUM)) (use (reg:SI TX19_REGNUM))
                             (use (reg:SI TX20_REGNUM)) (use (reg:SI TX21_REGNUM)) (use (reg:SI TX22_REGNUM)) (use (reg:SI TX23_REGNUM))
                             (use (reg:SI TX24_REGNUM)) (use (reg:SI TX25_REGNUM)) (use (reg:SI TX26_REGNUM)) (use (reg:SI TX27_REGNUM))
                             (use (reg:SI TX28_REGNUM)) (use (reg:SI TX29_REGNUM)) (use (reg:SI TX30_REGNUM)) (use (reg:SI TX31_REGNUM))
                             ])
                           (parallel [
                             (use (reg:SI CRO0_REGNUM)) (use (reg:SI CRO1_REGNUM)) (use (reg:SI CRO2_REGNUM)) (use (reg:SI CRO3_REGNUM))
                             (use (reg:SI CRO4_REGNUM)) (use (reg:SI CRO5_REGNUM)) (use (reg:SI CRO6_REGNUM)) (use (reg:SI CRO7_REGNUM))
                             (use (reg:SI CRO8_REGNUM)) (use (reg:SI CRO9_REGNUM)) (use (reg:SI CRO10_REGNUM)) (use (reg:SI CRO11_REGNUM))
                             (use (reg:SI CRO12_REGNUM)) (use (reg:SI CRO13_REGNUM)) (use (reg:SI CRO14_REGNUM)) (use (reg:SI CRO15_REGNUM))
                             ])
                           (parallel [
                             (use (reg:SI CRO16_REGNUM)) (use (reg:SI CRO17_REGNUM)) (use (reg:SI CRO18_REGNUM)) (use (reg:SI CRO19_REGNUM))
                             (use (reg:SI CRO20_REGNUM)) (use (reg:SI CRO21_REGNUM)) (use (reg:SI CRO22_REGNUM)) (use (reg:SI CRO23_REGNUM))
                             (use (reg:SI CRO24_REGNUM)) (use (reg:SI CRO25_REGNUM)) (use (reg:SI CRO26_REGNUM)) (use (reg:SI CRO27_REGNUM))
                             (use (reg:SI CRO28_REGNUM)) (use (reg:SI CRO29_REGNUM)) (use (reg:SI CRO30_REGNUM)) (use (reg:SI CRO31_REGNUM))
                             ])
                           ]
  "TARGET_ARCH_NIOS2DPX"
  "@
    snd\\t%0, %z1, %z2
    snd%i2\\t%0, %z1, %2"
  [(set_attr "type" "alu")])


;*****************************************************************************
;*
;* Peepholes
;*
;*****************************************************************************


;; Local Variables:
;; mode: lisp
;; End:
