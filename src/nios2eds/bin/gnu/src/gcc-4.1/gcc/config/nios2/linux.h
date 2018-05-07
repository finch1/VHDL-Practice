/* Definitions for Nios II running Linux-based GNU systems with
   ELF format.
   Copyright (C) 1995, 1996, 1997, 1998, 1999, 2000, 2002, 2003, 2004, 2008
   Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

GCC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GCC; see the file COPYING.  If not, write to
the Free Software Foundation, 51 Franklin Street, Fifth Floor,
Boston, MA 02110-1301, USA.  */

#undef LIB_SPEC
#define LIB_SPEC "-lc \
 %{pthread:-lpthread}"

#undef STARTFILE_SPEC
#define STARTFILE_SPEC \
"%{!shared: crt1.o%s} \
 crti.o%s %{static:crtbeginT.o%s;shared|pie:crtbeginS.o%s;:crtbegin.o%s}"

#undef ENDFILE_SPEC
#define ENDFILE_SPEC \
"%{shared|pie:crtendS.o%s;:crtend.o%s} crtn.o%s"

#define TARGET_OS_CPP_BUILTINS()                \
  do                                            \
    {                                           \
      LINUX_TARGET_OS_CPP_BUILTINS();           \
      if (flag_pic)                             \
        {                                       \
          builtin_define ("__PIC__");           \
          builtin_define ("__pic__");           \
        }                                       \
    }                                           \
  while (0)

#undef TARGET_LINUX
#define TARGET_LINUX 1

#undef SYSROOT_SUFFIX_SPEC
#define SYSROOT_SUFFIX_SPEC \
  "%{EB:/EB}"

#undef LINK_SPEC
#define LINK_SPEC LINK_SPEC_ENDIAN \
  " %{shared:-shared} \
    %{static:-Bstatic} \
    %{rdynamic:-export-dynamic}"

#define MD_UNWIND_SUPPORT "config/nios2/linux-unwind.h"
