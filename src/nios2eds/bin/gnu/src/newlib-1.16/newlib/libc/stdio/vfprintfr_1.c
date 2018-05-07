
#include <_ansi.h>
#include <stdio.h>

#include "local.h"

#ifdef _HAVE_STDC
#include <stdarg.h>
#else
#include <varargs.h>
#endif

int 
_DEFUN (_vfprintf_r, (data, fp, fmt, ap),
	struct _reent *data _AND
	FILE * fp _AND
	_CONST char *fmt _AND
	va_list ap)
{
  int ret;
  _REENT_SMALL_CHECK_INIT(fp);
  ret = ___vfprintf_internal_r (data, fp, fmt, ap);
  va_end (ap);
  return ret;
}
