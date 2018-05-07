/*
ALTERA specific. Was in 1.12 newlib for Nios II. 
I would assume that we'll need vfiprintf even without the INTEGER_ONLY flag
*/

#include <_ansi.h>
#include <stdio.h>

#include "local.h"
#include "fvwrite.h"

#ifdef _HAVE_STDC
#include <stdarg.h>
#else
#include <varargs.h>
#endif

int 
_DEFUN (_vfiprintf_r, (data, fp, fmt, ap),
	struct _reent *data _AND
	FILE * fp _AND
	_CONST char *fmt _AND
	va_list ap)
{
  int ret;

  _REENT_SMALL_CHECK_INIT(fp);
  _FILE_INIT_DEV_WRITE (fp);
  ret = ___vfiprintf_internal_r (data, fp, fmt, ap);
  va_end (ap);
  return ret;
}

