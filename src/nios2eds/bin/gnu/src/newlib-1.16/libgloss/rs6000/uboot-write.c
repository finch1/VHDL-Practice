/*
 * write.c -- write function writes directly to a serial port.
 *
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

/* NS16550 UART support.  */

/* The ns16550's address */
extern volatile unsigned char __ns16550[] __attribute__ ((weak));

static ssize_t
write_ns16550 (const void *buf, size_t count)
{
  size_t c;
  
  for (c = 0; c != count; c++)
    {
      while (!(__ns16550[5] & 0x20))
	continue;
      __ns16550[0] = ((const unsigned char *)buf)[c];
    }
  return c;
}

/* PowerQUICC (MPC8xx) SMC1 (System Management Console) support.
   Only SMC1 is supported.  */

struct buffer_descriptor
{
  unsigned short status;
  unsigned short len;
  volatile unsigned char *buf;
};

/* The I/O map base for the processor.  */
extern unsigned char __smc_immr[] __attribute__ ((weak));

/* The offset of this SMC's configuration area in parameter RAM.  */
#define DPRAM_OFFSET 0x2000
#define DPRAM_SMC1 (DPRAM_OFFSET + 0x1c00 + 0x280)

static ssize_t
write_smc (const void *buf, size_t count)
{
  size_t c;
  unsigned short *smc1 = (unsigned short *) &__smc_immr[DPRAM_SMC1];
  unsigned short tbase = smc1[1];
  volatile struct buffer_descriptor *bd;
  volatile unsigned char *outbuf;

  bd = (struct buffer_descriptor *) &__smc_immr[DPRAM_OFFSET + tbase];
  outbuf = bd->buf;

  for (c = 0; c != count; c++)
    {
      outbuf[0] = ((const unsigned char *)buf)[c];
      bd->len = 1;
      bd->status |= 0x8000;
      asm ("eieio");
      while (bd->status & 0x8000)
	asm ("eieio");
    }
  return c;
}

/* "write" dispatcher.  */

ssize_t
write (int fd, const void *buf, size_t count)
{
  /* We only support stdout and stderr.  */
  if (fd != 1 && fd != 2)
    {
      errno = EBADF;
      return -1;
    }

  if (__ns16550 != 0)
    return write_ns16550 (buf, count);
  else if (__smc_immr != 0)
    return write_smc (buf, count);
  else
    {
      errno = ENOSYS;
      return -1;
    }
}
