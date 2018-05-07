/*
 * uboot-sbrk.c -- allocate memory dynamically.

 * Copyright (c) 2007 CodeSourcery
 *
 * The authors hereby grant permission to use, copy, modify, distribute,
 * and license this software and its documentation for any purpose, provided
 * that existing copyright notices are retained in all copies and that this
 * notice is included verbatim in any distributions. No written agreement,
 * license, or royalty fee is required for any of the authorized uses.
 * Modifications to this software may be copyrighted by their authors
 * and need not follow the licensing terms described here, provided that
 * the new terms are clearly indicated on the first page of each file where
 * they apply.
 */

#include <unistd.h>
#include <errno.h>
#include "glue.h"

/* Grow the heap upwards until it hits the stack, but always leave at
   least 64K for stack growth.  */
#define SAFETY_GAP (64 * 1024)

static char *heap_ptr = &_end;

void *
sbrk (ptrdiff_t nbytes)
{
  register char *sp asm("1");
  char *base = heap_ptr;

  if (sp < heap_ptr + nbytes + SAFETY_GAP)
    {
      errno = ENOMEM;
      return ((char *) -1);
    }

  heap_ptr += nbytes;
  return base;
}
