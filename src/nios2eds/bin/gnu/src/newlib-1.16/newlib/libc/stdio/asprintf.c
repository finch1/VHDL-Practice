/*
 * Copyright (c) 1990, 2007 The Regents of the University of California.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms are permitted
 * provided that the above copyright notice and this paragraph are
 * duplicated in all such forms and that any documentation,
 * advertising materials, and other materials related to such
 * distribution and use acknowledge that the software was developed
 * by the University of California, Berkeley.  The name of the
 * University may not be used to endorse or promote products derived
 * from this software without specific prior written permission.
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
 */
/* This code was copied from sprintf.c */
/* doc in sprintf.c */

#include <_ansi.h>
#include <reent.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <limits.h>
#include "local.h"
#include "fvwrite.h"

int
_DEFUN(_asprintf_r, (ptr, strp, fmt),
       struct _reent *ptr _AND
       char **strp        _AND
       const char *fmt _DOTS)
{
  int ret;
  va_list ap;
  
/* ALTERA WANT_SMALL_STDIO */
#ifdef WANT_SMALL_STDIO
  /* the FILE struct only supports dev writes,
     the __sFILE_small_str struct is a superset
     which support string writes as well */
  struct __sFILE_small_str f;
#else
  FILE f;
#endif /* WANT_SMALL_STDIO */

  /* mark a zero-length reallocatable buffer */
  f._flags = __SWR | __SSTR | __SMBF;
  f._bf._base = f._p = NULL;
  f._bf._size = f._w = 0;
  f._file = -1;  /* No file. */
  va_start (ap, fmt);
  _FILE_INIT_STR_MBF_WRITE (&f);
  ret = ___vfprintf_internal_r (ptr, (FILE *)&f, fmt, ap);
  /* ret = _vfprintf_r (ptr, &f, fmt, ap); */
  va_end (ap);
  if (ret >= 0)
    {
      *f._p = 0;
      *strp = f._bf._base;
    }
  return (ret);
}

#ifndef _REENT_ONLY

int
_DEFUN(asprintf, (strp, fmt),
       char **strp _AND
       const char *fmt _DOTS)
{
  int ret;
  va_list ap;
#ifdef WANT_SMALL_STDIO
  /* the FILE struct only supports dev writes,
     the __sFILE_small_str struct is a superset
     which support string writes as well */
  struct __sFILE_small_str f;
#else
  FILE f;
#endif

  /* mark a zero-length reallocatable buffer */
  f._flags = __SWR | __SSTR | __SMBF;
  f._bf._base = f._p = NULL;
  f._bf._size = f._w = 0;
  f._file = -1;  /* No file. */
  va_start (ap, fmt);
  _FILE_INIT_STR_MBF_WRITE (&f);
  ret = __vfprintf_internal ((FILE *)&f, fmt, ap);
  va_end (ap);
  if (ret >= 0)
    {
      *f._p = 0;
      *strp = f._bf._base;
    }
  return (ret);
}

#endif /* ! _REENT_ONLY */
