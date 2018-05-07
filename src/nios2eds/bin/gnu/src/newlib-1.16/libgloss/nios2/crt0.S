#   
#   Copyright (c) 2003 Altera Corporation
#   All rights reserved.
#   
#   Redistribution and use in source and binary forms, with or without modification,
#   are permitted provided that the following conditions are met:
#   
#      o Redistributions of source code must retain the above copyright notice, 
#        this list of conditions and the following disclaimer. 
#      o Redistributions in binary form must reproduce the above copyright notice, 
#        this list of conditions and the following disclaimer in the documentation 
#        and/or other materials provided with the distribution. 
#      o Neither the name of Altera Corporation nor the names of its contributors 
#        may be used to endorse or promote products derived from this software 
#        without specific prior written permission. 
#   
#   THIS SOFTWARE IS PROVIDED BY ALTERA CORPORATION, THE COPYRIGHT HOLDER, AND ITS 
#   CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
#   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
#   PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR 
#   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
#   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
#   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
#   OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
#   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT(INCLUDING NEGLIGENCE OR 
#   OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED 
#   OF THE POSSIBILITY OF SUCH DAMAGE.  


	#
	# crt0.s
	#
	# NIOS2 startup code
	#

	# Startup code
	# ??? THIS IS NOT PROPER STARTUP CODE, IT
	# WON'T WORK ON THE PROCESSOR BECAUSE OF MISSING
	# CACHE INIT ROUTINES, PLEASE SEE ALTERA DOCS.
	# This will work with the simulator, which is
	# its real purpose.



	.section	.text
	.align	3
	.globl	_start
	.type	_start,@function

_start:

	# set up the stack pointer.
	# ??? we may want to check to see if
	# we should inherit caller's stack
#ifdef __nios2_6b__
	movhi20	sp, %hi20adj(nasys_stack_top)
	addi	sp, sp, %lo12(nasys_stack_top)
#else
	movhi	sp, %hiadj(nasys_stack_top)
	addi	sp, sp, %lo(nasys_stack_top)
#endif

	# make sure it is aligned
	nor	sp, sp, sp
	ori	sp, sp, 0x7 # clear lowest three bits
	nor	sp, sp, sp

	# set up the global pointer.
#ifdef __nios2_6b__
       	movhi20	gp, %hi20adj(_gp)
	addi	gp, gp, %lo12(_gp)
#else
	movhi	gp, %hiadj(_gp)
	addi	gp, gp, %lo(_gp)
#endif
        
	#set up the exception temporary
#ifdef __nios2_6b__
	movhi20	et, %hi20adj(_end)
	addi	et, et, %lo12(_end)
#else
	movhi	et, %hiadj(_end)
	addi	et, et, %lo(_end)
#endif

#ifdef __nios2_6b__
	movhi20	r2, %hi20adj(__start_2)
	addi	r2, r2, %lo12(__start_2)
#else
	movhi	r2, %hiadj(__start_2)
	addi	r2, r2, %lo(__start_2)
#endif
	jmp	r2

  
