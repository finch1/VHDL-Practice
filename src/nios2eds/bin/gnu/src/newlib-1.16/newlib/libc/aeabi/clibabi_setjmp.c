#include <setjmp.h>
#include "hidden.h"

/* __aeabi_JMP_BUF_SIZE is measured in 8-byte double-words.  */

const int __aeabi_JMP_BUF_SIZE HIDDEN = (_JBLEN + 1) / 2;
