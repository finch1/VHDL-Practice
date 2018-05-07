/* No user fns here.  Pesch 15apr92. */

/*
 * Copyright (c) 1990 The Regents of the University of California.
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

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <reent.h>
#include "local.h"
#include "fvwrite.h"

#ifndef WANT_SMALL_STDIO
int noWANT_SMALL_STDIO_fvwrite_small_dev_c;
#else


#define	MIN(a, b) ((a) < (b) ? (a) : (b))
#define	COPY(n)	  (void) memmove((void *) fp->_p, (void *) p, (size_t) (n))


int
__sfvwrite_small_dev (struct _reent *data, struct __sFILE_small_file * fp, _CONST char *str, int len)
{
  if (cantwrite (fp))
    return EOF; 
    
  if (fp->_file >= 0)
    {
      int len_left = len;
            
      while (len_left > 0)
        {
	  int new_write;
	  new_write = _write_r (data, fp->_file, str, MIN (len_left, BUFSIZ));
	  if (new_write <= 0)
	    goto err;
	  len_left = len_left - new_write;
	  str += new_write;
	}
      
      return 0;
    }
  /* else, we have an invalid FILE */

err:
  fp->_flags |= __SERR;
  return EOF;
}

#endif /* !WANT_SMALL_STDIO */
