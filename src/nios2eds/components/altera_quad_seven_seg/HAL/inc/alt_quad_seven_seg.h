/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2007 Altera Corporation, San Jose, California, USA.           *
* All rights reserved.                                                        *
*                                                                             *
* Permission is hereby granted, free of charge, to any person obtaining a     *
* copy of this software and associated documentation files (the "Software"),  *
* to deal in the Software without restriction, including without limitation   *
* the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
* and/or sell copies of the Software, and to permit persons to whom the       *
* Software is furnished to do so, subject to the following conditions:        *
*                                                                             *
* The above copyright notice and this permission notice shall be included in  *
* all copies or substantial portions of the Software.                         *
*                                                                             *
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
* DEALINGS IN THE SOFTWARE.                                                   *
*                                                                             *
* This agreement shall be governed in all respects by the laws of the State   *
* of California and by the laws of the United States of America.              *
*                                                                             *
******************************************************************************/
#ifndef ALT_QUAD_SEVEN_SEG_H_
#define ALT_QUAD_SEVEN_SEG_H_

#include <stddef.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include "sys/alt_alarm.h"
#include "alt_types.h"
#include "system.h"
#include "altera_avalon_pio_regs.h"

#define YES 1
#define NO 0

//static alt_alarm g_alarm;

typedef struct quad_seven_seg_values
{
    alt_u32 pio_base;
    alt_u32 refresh;
    alt_u8 digit_select[4];
    alt_u8 last_digit; //can be 0 thru 3
    alt_u8 is_positive; //If this is 1 then the minus singn on the display is not illuminated
    alt_u8 is_hex[4];
    alt_u8 digit[4];
} quad_seven_seg_values;

//quad_seven_seg_values g_quad_struct;

/*
 * Prototypes for public API 
 */

quad_seven_seg_values* new_quad_seven_seg(alt_u32 quad_seven_seg_pio_base, alt_u32 seven_seg_refresh);

void sevenseg_set_hex(alt_u32 quad_seven_seg_pio_base, alt_u8 value, alt_u8 is_pos, alt_u8 is_hex, alt_u8 digit);

alt_u32 update_the_quad_seven_seg(void* context);

quad_seven_seg_values* QUAD_SEVEN_SEG_INIT(alt_u32 quad_seven_seg_pio_base, alt_u32 seven_seg_refresh);


#endif /*ALT_QUAD_SEVEN_SEG_H_*/
