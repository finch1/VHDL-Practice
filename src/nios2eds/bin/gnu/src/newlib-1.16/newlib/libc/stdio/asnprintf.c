/* Copyright (C) 2007 Eric Blake
 * Permission to use, copy, modify, and distribute this software
 * is freely granted, provided that this notice is preserved.
 */
/* This code was derived from asprintf.c */
/* doc in sprintf.c */

#include <_ansi.h>
#include <reent.h>
#include <stdio.h>
#include <stdarg.h>
#include <limits.h>
#include <errno.h>

char *
_DEFUN(_asnprintf_r, (ptr, buf, lenp, fmt),
       struct _reent *ptr _AND
       char *buf _AND
       size_t *lenp _AND
       const char *fmt _DOTS)
{
  int ret;
  va_list ap;
  
  /* ALTERA SMALL C */
  #ifdef WANT_SMALL_STDIO
  /* the FILE struct only supports dev writes,
     the __sFILE_small_str struct is a superset
     which support string writes as well */
  struct __sFILE_small_str f;
  #else /* !WANT_SMALL_STDIO*/
  FILE f;
  #endif 
  
  size_t len = *lenp;

  if (buf && len)
    {
      /* mark an existing buffer, but allow allocation of larger string */
      f._flags = __SWR | __SSTR | __SOPT;
    }
  else
    {
      /* mark a zero-length reallocatable buffer */
      f._flags = __SWR | __SSTR | __SMBF;
      len = 0;
      buf = NULL;
    }
  f._bf._base = f._p = (unsigned char *) buf;
  /* For now, inherit the 32-bit signed limit of FILE._bf._size.
     FIXME - it would be nice to rewrite sys/reent.h to support size_t
     for _size.  */
  if (len > INT_MAX)
    {
      ptr->_errno = EOVERFLOW;
      return NULL;
    }
  f._bf._size = f._w = len;
  f._file = -1;  /* No file. */
  va_start (ap, fmt);
  _FILE_INIT_STR_WRITE (&f);
  ret = ___vfprintf_internal_r (ptr, (FILE *)&f, fmt, ap);
  /*
  ret = _vfprintf_r (ptr, &f, fmt, ap);
  */
  va_end (ap);
  if (ret < 0)
    return NULL;
  *lenp = ret;
  *f._p = '\0';
  return (char *) f._bf._base;
}

#ifndef _REENT_ONLY

char *
_DEFUN(asnprintf, (buf, lenp, fmt),
       char *buf _AND
       size_t *lenp _AND
       const char *fmt _DOTS)
{
  int ret;
  va_list ap;
  /* ALTERA SMALL C */
  #ifdef WANT_SMALL_STDIO
  /* the FILE struct only supports dev writes,
     the __sFILE_small_str struct is a superset
     which support string writes as well */
  struct __sFILE_small_str f;
  #else /* !WANT_SMALL_STDIO*/
  FILE f;
  #endif 
  size_t len = *lenp;
  struct _reent *ptr = _REENT;

  if (buf && len)
    {
      /* mark an existing buffer, but allow allocation of larger string */
      f._flags = __SWR | __SSTR | __SOPT;
    }
  else
    {
      /* mark a zero-length reallocatable buffer */
      f._flags = __SWR | __SSTR | __SMBF;
      len = 0;
      buf = NULL;
    }
  f._bf._base = f._p = (unsigned char *) buf;
  /* For now, inherit the 32-bit signed limit of FILE._bf._size.
     FIXME - it would be nice to rewrite sys/reent.h to support size_t
     for _size.  */
  if (len > INT_MAX)
    {
      ptr->_errno = EOVERFLOW;
      return NULL;
    }
  f._bf._size = f._w = len;
  f._file = -1;  /* No file. */
  va_start (ap, fmt);
  _FILE_INIT_STR_WRITE (&f);
  ret = ___vfprintf_internal_r (ptr, (FILE *)&f, fmt, ap);
  /*
  ret = _vfprintf_r (ptr, &f, fmt, ap);
  */
  va_end (ap);
  if (ret < 0)
    return NULL;
  *lenp = ret;
  *f._p = '\0';
  return (char *) f._bf._base;
}

#endif /* ! _REENT_ONLY */
