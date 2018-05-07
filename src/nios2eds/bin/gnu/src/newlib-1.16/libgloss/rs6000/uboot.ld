OUTPUT_FORMAT("elf32-powerpc", "elf32-powerpc",
	      "elf32-powerpc")
OUTPUT_ARCH(powerpc)
ENTRY(_start)

STARTUP(uboot-crt0.o)
GROUP(-luboot -lc -lgcc)

MEMORY
{
  ram (rwx) : ORIGIN = 0x40000, LENGTH = 16M - 0x4000
}

/* Let U-Boot provide the stack.  */
PROVIDE (__stack = 0);

SECTIONS
{
  .text		:
  {
    *(.text .text.* .gnu.linkonce.t.*)
    /* .gnu.warning sections are handled specially by elf32.em.  */
    *(.gnu.warning)
  } =0
  .init		:
  {
    KEEP (*(.init))
  } =0
  .fini		:
  {
    KEEP (*(.fini))
  } =0
  .plt   : { *(.plt) }

  .eh_frame	: { KEEP (*(.eh_frame)) }
  .gcc_except_table	  : { *(.gcc_except_table) }
  .rodata	  : { *(.rodata .rodata.*) *(.gnu.linkonce.r*) }
  .rodata1	  : { *(.rodata1) }

  _etext = .;
  PROVIDE (etext = .);

  .sdata2   : { *(.sdata2 .sdata2.*) }
  .sbss2   : { *(.sbss2 .sbss2.*) }

  .data    :
  {
    *(.data .data.* .gnu.linkonce.d.*)
  }
  .data1   : { *(.data1 .data1.*) }
  .got1		  : { *(.got1) }

  .got2		  :  { *(.got2) }
  .ctors :
  {
    KEEP (*ecrti.o(.ctors))
    KEEP (*crtbegin.o(.ctors))
    KEEP (*(EXCLUDE_FILE (*crtend.o *ecrtn.o) .ctors))
    KEEP (*(SORT(.ctors.*)))
    KEEP (*crtend.o(.ctors))
    KEEP (*ecrtn.o(.ctors))
  }
  .dtors :
  {
    KEEP (*ecrti.o(.dtors))
    KEEP (*crtbegin.o(.dtors))
    KEEP (*(EXCLUDE_FILE (*crtend.o *ecrtn.o) .dtors))
    KEEP (*(SORT(.dtors.*)))
    KEEP (*crtend.o(.dtors))
    KEEP (*ecrtn.o(.dtors))
  }
  .jcr		  : { KEEP (*(.jcr)) }
  .fixup	  : { *(.fixup) }
  .got		  : { *(.got) }
  .got.plt	  : { *(.got.plt) }
  /* We want the small data sections together, so single-instruction offsets
     can access them all, and initialized data all before uninitialized, so
     we can shorten the on-disk segment size.  */
  .sdata	  : { *(.sdata .sdata.*) }
  _edata  =  .;
  PROVIDE (edata = .);
  .sbss      :
  {
    PROVIDE (__sbss_start = .);
    *(.sbss .sbss.*)
    *(.scommon)
    . = ALIGN(4);
    PROVIDE (__sbss_end = .);
  }
  .bss       :
  {
   PROVIDE (__bss_start = .);
   *(.dynbss)
   *(.bss .bss.* .gnu.linkonce.b.*)
   *(COMMON)
   . = ALIGN(4);
  }
  _end = . ;
  PROVIDE (end = .);
  /* These are needed for ELF backends which have not yet been
     converted to the new style linker.  */
  .stab 0 : { *(.stab) }
  .stabstr 0 : { *(.stabstr) }
  /* DWARF debug sections.
     Symbols in the DWARF debugging sections are relative to the beginning
     of the section so we begin them at 0.  */
  /* DWARF 1 */
  .debug          0 : { *(.debug) }
  .line           0 : { *(.line) }
  /* GNU DWARF 1 extensions */
  .debug_srcinfo  0 : { *(.debug_srcinfo) }
  .debug_sfnames  0 : { *(.debug_sfnames) }
  /* DWARF 1.1 and DWARF 2 */
  .debug_aranges  0 : { *(.debug_aranges) }
  .debug_pubnames 0 : { *(.debug_pubnames) }
  /* DWARF 2 */
  .debug_info     0 : { *(.debug_info) }
  .debug_abbrev   0 : { *(.debug_abbrev) }
  .debug_line     0 : { *(.debug_line) }
  .debug_frame    0 : { *(.debug_frame) }
  .debug_str      0 : { *(.debug_str) }
  .debug_loc      0 : { *(.debug_loc) }
  .debug_macinfo  0 : { *(.debug_macinfo) }
  .debug_ranges   0 : { *(.debug_ranges) }
  /* SGI/MIPS DWARF 2 extensions */
  .debug_weaknames 0 : { *(.debug_weaknames) }
  .debug_funcnames 0 : { *(.debug_funcnames) }
  .debug_typenames 0 : { *(.debug_typenames) }
  .debug_varnames  0 : { *(.debug_varnames) }
  /* These must appear regardless of  .  */
}
