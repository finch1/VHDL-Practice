/*
 *  $Id: //acds/rel/13.0sp1/ip/sopc/app/gnu/src/newlib-1.16/newlib/libc/sys/rtems/sys/utime.h#1 $
 */

#ifndef __UTIME_h__
#define __UTIME_h__

#ifdef __cplusplus
extern "C" {
#endif

/*
 *  POSIX 1003.1b 5.6.6 Set File Access and Modification Times
 */

struct utimbuf {
  time_t  actime;   /* Access time */
  time_t  modtime;  /* Modification time */
};

/* Functions */

int utime(
  const char           *path,
  const struct utimbuf *times
);

#ifdef __cplusplus
};
#endif

#endif /* _SYS_UTIME_H */
