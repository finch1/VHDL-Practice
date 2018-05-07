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

#ifdef _REENT_ONLY
int _REENT_ONLY_vfiprintf_c;
#else

int 
_DEFUN (vfiprintf, (fp, fmt0, ap),
	FILE * fp _AND
	_CONST char *fmt0 _AND
	va_list ap)
{
  int result;
  _REENT_SMALL_CHECK_INIT(fp);
  _FILE_INIT_DEV_WRITE (fp);
  result = __vfiprintf_internal (fp, fmt0, ap);
  return result;
}

#endif /* ! _REENT_ONLY */

