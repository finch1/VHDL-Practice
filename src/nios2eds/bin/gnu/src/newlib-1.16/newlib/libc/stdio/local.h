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
 *
 *	%W% (UofMD/Berkeley) %G%
 */

/*
 * Information local to this implementation of stdio,
 * in particular, macros and private variables.
 */

#include <_ansi.h>
#include <reent.h>
#include <stdarg.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#ifdef __SCLE
# include <io.h>
#endif

#ifdef WANT_SMALL_STDIO
#ifndef _REENT_SMALL
/* This is currently only a limitation because noone
   has written the code to support it :( */
#error "You must -D _REENT_SMALL to use WANT_SMALL_STDIO"
#endif
#endif


extern int    _EXFUN(__svfscanf_r,(struct _reent *,FILE *, _CONST char *,va_list));
extern int    _EXFUN(__svfiscanf_r,(struct _reent *,FILE *, _CONST char *,va_list));
extern FILE  *_EXFUN(__sfp,(struct _reent *));
extern int    _EXFUN(__sflags,(struct _reent *,_CONST char*, int*));
extern int    _EXFUN(__srefill_r,(struct _reent *,FILE *));
extern _READ_WRITE_RETURN_TYPE _EXFUN(__sread,(struct _reent *, void *, char *,
					       int));
extern _READ_WRITE_RETURN_TYPE _EXFUN(__swrite,(struct _reent *, void *,
						const char *, int));
extern _fpos_t _EXFUN(__sseek,(struct _reent *, void *, _fpos_t, int));
extern int    _EXFUN(__sclose,(struct _reent *, void *));
extern int    _EXFUN(__stextmode,(int));
extern _VOID   _EXFUN(__sinit,(struct _reent *));
extern _VOID   _EXFUN(_cleanup_r,(struct _reent *));
extern _VOID   _EXFUN(__smakebuf_r,(struct _reent *, FILE *));
extern int    _EXFUN(_fwalk,(struct _reent *, int (*)(FILE *)));
extern int    _EXFUN(_fwalk_reent,(struct _reent *, int (*)(struct _reent *, FILE *)));
struct _glue * _EXFUN(__sfmoreglue,(struct _reent *,int n));

#ifdef __LARGE64_FILES
extern _fpos64_t _EXFUN(__sseek64,(struct _reent *, void *, _fpos64_t, int));
extern _READ_WRITE_RETURN_TYPE _EXFUN(__swrite64,(struct _reent *, void *,
						  const char *, int));
#endif

/* ALTERA internal vfprintf and reentrant function */
extern int	_EXFUN(___vfprintf_internal_r, (struct _reent *, FILE *, const char *, __VALIST));
extern int	_EXFUN(__vfprintf_internal, (FILE *, const char *, __VALIST));

/* Called by the main entry point fns to ensure stdio has been initialized.  */

/* ALTERA WANT_SMALL_STDIO */
#ifdef WANT_SMALL_STDIO
#define CHECK_INIT(ptr, fp)
#else

#ifdef _REENT_SMALL
#define CHECK_INIT(ptr, fp) \
  do						\
    {						\
      if ((ptr) && !(ptr)->__sdidinit)		\
	__sinit (ptr);				\
      if ((fp) == (FILE *)&__sf_fake_stdin)	\
	(fp) = _stdin_r(ptr);			\
      else if ((fp) == (FILE *)&__sf_fake_stdout) \
	(fp) = _stdout_r(ptr);			\
      else if ((fp) == (FILE *)&__sf_fake_stderr) \
	(fp) = _stderr_r(ptr);			\
    }						\
  while (0)
#else /* !_REENT_SMALL   */
#define CHECK_INIT(ptr, fp) \
  do						\
    {						\
      if ((ptr) && !(ptr)->__sdidinit)		\
	__sinit (ptr);				\
    }						\
  while (0)
#endif /* !_REENT_SMALL  */
#endif /* !WANT_SMALL_STDIO */

/* ALTERA WANT_SMALL_STDIO */
#ifdef WANT_SMALL_STDIO
# define _FILE_INIT_DEV_WRITE(fp) ((fp)->_sfvwrite = __sfvwrite_small_dev)
# define _FILE_INIT_STR_WRITE(fp) \
do { \
  (fp)->_sfvwrite = __sfvwrite_small_str; \
  (fp)->_realloc_r = _NULL; \
} while(0)
# define _FILE_INIT_STR_MBF_WRITE(fp) \
do { \
  (fp)->_sfvwrite = __sfvwrite_small_str_mbf; \
  (fp)->_realloc_r = _realloc_r; /* this causes a warning (size_t vs int) that I don't know how to fix */ \
} while(0)
#else
# define _FILE_INIT_DEV_WRITE(fp) 
# define _FILE_INIT_STR_WRITE(fp) 
# define _FILE_INIT_STR_MBF_WRITE(fp)
#endif /* WANT_SMALL_STDIO */

#ifdef WANT_SMALL_STDIO
#define CHECK_STD_INIT(ptr)
#else /* !WANT_SMALL_STDIO */
#define CHECK_STD_INIT(ptr) \
  do						\
    {						\
      if ((ptr) && !(ptr)->__sdidinit)		\
	__sinit (ptr);				\
    }						\
  while (0)

/* Return true iff the given FILE cannot be written now.  */

#endif /* !WANT_SMALL_STDIO */ 

/* ALTERA WANT_SMALL_STDIO */
#ifdef WANT_SMALL_STDIO
#define	cantwrite(fp) \
  (((fp)->_flags & __SWR) == 0)
#else /* ALTERA !WANT_SMALL_STDIO */

#define	cantwrite(ptr, fp)                                     \
  ((((fp)->_flags & __SWR) == 0 || (fp)->_bf._base == NULL) && \
   __swsetup_r(ptr, fp))
#endif /* ALTERA WANT_SMALL_STDIO */

/* Test whether the given stdio file has an active ungetc buffer;
   release such a buffer, without restoring ordinary unread data.  */

#define	HASUB(fp) ((fp)->_ub._base != NULL)
#define	FREEUB(ptr, fp) {                    \
	if ((fp)->_ub._base != (fp)->_ubuf) \
		_free_r(ptr, (char *)(fp)->_ub._base); \
	(fp)->_ub._base = NULL; \
}

/* Test for an fgetline() buffer.  */

#define	HASLB(fp) ((fp)->_lb._base != NULL)
#define	FREELB(ptr, fp) { _free_r(ptr,(char *)(fp)->_lb._base); \
      (fp)->_lb._base = NULL; }

/* WARNING: _dcvt is defined in the stdlib directory, not here!  */

char *_EXFUN(_dcvt,(struct _reent *, char *, double, int, int, char, int));
char *_EXFUN(_sicvt,(char *, short, char));
char *_EXFUN(_icvt,(char *, int, char));
char *_EXFUN(_licvt,(char *, long, char));
#ifdef __GNUC__
char *_EXFUN(_llicvt,(char *, long long, char));
#endif

#define CVT_BUF_SIZE 128

#define	NDYNAMIC 4	/* add four more whenever necessary */

#ifdef __SINGLE_THREAD__
#define __sfp_lock_acquire()
#define __sfp_lock_release()
#define __sinit_lock_acquire()
#define __sinit_lock_release()
#else
_VOID _EXFUN(__sfp_lock_acquire,(_VOID));
_VOID _EXFUN(__sfp_lock_release,(_VOID));
_VOID _EXFUN(__sinit_lock_acquire,(_VOID));
_VOID _EXFUN(__sinit_lock_release,(_VOID));
#endif
