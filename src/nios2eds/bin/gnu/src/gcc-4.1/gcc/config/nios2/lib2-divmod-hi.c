
/* We include auto-host.h here to get HAVE_GAS_HIDDEN.  This is
   supposedly valid even though this is a "target" file.  */
#include "auto-host.h"
#undef gid_t
#undef pid_t
#undef rlim_t
#undef ssize_t
#undef uid_t
#undef vfork


#include "tconfig.h"
#include "tsystem.h"
#include "coretypes.h"
#include "tm.h"


/* Don't use `fancy_abort' here even if config.h says to use it.  */
#ifdef abort
#undef abort
#endif


#ifdef HAVE_GAS_HIDDEN
#define ATTRIBUTE_HIDDEN  __attribute__ ((__visibility__ ("hidden")))
#else
#define ATTRIBUTE_HIDDEN
#endif

#ifndef MIN_UNITS_PER_WORD
#define MIN_UNITS_PER_WORD UNITS_PER_WORD
#endif

#include "libgcc2.h"

extern HItype __modhi3 (HItype, HItype);
extern HItype __divhi3 (HItype, HItype);
extern UHItype __umodhi3 (UHItype, UHItype);
extern UHItype __udivhi3 (UHItype, UHItype);

static UHItype udivmodhi4(UHItype, UHItype, word_type);

static UHItype
udivmodhi4(UHItype num, UHItype den, word_type modwanted)
{
  UHItype bit = 1;
  UHItype res = 0;

  while (den < num && bit && !(den & (1L<<15)))
    {
      den <<=1;
      bit <<=1;
    }
  while (bit)
    {
      if (num >= den)
	{
	  num -= den;
	  res |= bit;
	}
      bit >>=1;
      den >>=1;
    }
  if (modwanted) return num;
  return res;
}


HItype
__divhi3 (HItype a, HItype b)
{
  word_type neg = 0;
  HItype res;

  if (a < 0)
    {
      a = -a;
      neg = !neg;
    }

  if (b < 0)
    {
      b = -b;
      neg = !neg;
    }

  res = udivmodhi4 (a, b, 0);

  if (neg)
    res = -res;

  return res;
}


HItype
__modhi3 (HItype a, HItype b)
{
  word_type neg = 0;
  HItype res;

  if (a < 0)
    {
      a = -a;
      neg = 1;
    }

  if (b < 0)
    b = -b;

  res = udivmodhi4 (a, b, 1);

  if (neg)
    res = -res;

  return res;
}


UHItype
__udivhi3 (UHItype a, UHItype b)
{
  return udivmodhi4 (a, b, 0);
}


UHItype
__umodhi3 (UHItype a, UHItype b)
{
  return udivmodhi4 (a, b, 1);
}

