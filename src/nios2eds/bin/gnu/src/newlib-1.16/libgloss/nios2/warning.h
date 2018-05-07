/* 
   Copyright (c) 2003 Altera Corporation
   All rights reserved.
   
   Redistribution and use in source and binary forms, with or without modification,
   are permitted provided that the following conditions are met:
   
      o Redistributions of source code must retain the above copyright notice, 
        this list of conditions and the following disclaimer. 
      o Redistributions in binary form must reproduce the above copyright notice, 
        this list of conditions and the following disclaimer in the documentation 
        and/or other materials provided with the distribution. 
      o Neither the name of Altera Corporation nor the names of its contributors 
        may be used to endorse or promote products derived from this software 
        without specific prior written permission. 
   
   THIS SOFTWARE IS PROVIDED BY ALTERA CORPORATION, THE COPYRIGHT HOLDER, AND ITS 
   CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
   PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR 
   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
   OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT(INCLUDING NEGLIGENCE OR 
   OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED 
   OF THE POSSIBILITY OF SUCH DAMAGE.  */


#ifndef __WARNING_H__
#define __WARNING_H__

#define link_warning(symbol, msg)


#if 0


#ifdef HAVE_GNU_LD
# ifdef HAVE_ELF

/* We want the .gnu.warning.SYMBOL section to be unallocated.  */
#  ifdef HAVE_ASM_PREVIOUS_DIRECTIVE
#   define __make_section_unallocated(section_string)   \
  asm(".section " section_string "\n\t .previous");
#  elif defined (HAVE_ASM_POPSECTION_DIRECTIVE)
#   define __make_section_unallocated(section_string)   \
  asm(".pushsection " section_string "\n\t .popsection");
#  else
#   define __make_section_unallocated(section_string)
#  endif

#  ifdef HAVE_SECTION_ATTRIBUTES
#   define link_warning(symbol, msg)                     \
  __make_section_unallocated (".gnu.warning." #symbol)  \
  static const char __evoke_link_warning_##symbol[]     \
    __attribute__ ((section (".gnu.warning." #symbol))) = msg;
#  else
#   define link_warning(symbol, msg)
#  endif

#else /* !ELF */

#  define link_warning(symbol, msg)             \
  asm(".stabs \"" msg "\",30,0,0,0\n"   \
      ".stabs \"" __SYMBOL_PREFIX #symbol "\",1,0,0,0\n");
# endif
#else /* !GNULD */
/* We will never be heard; they will all die horribly.  */
# define link_warning(symbol, msg)
#endif

#endif /* if 0 */

/* A canned warning for sysdeps/stub functions.  */
#define stub_warning(name) \
  link_warning (name, \
                "warning: " #name " is not implemented and will always fail")

#endif /* __WARNING_H__ */
