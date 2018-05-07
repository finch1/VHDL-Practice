 /******************************************************************************
 *                                                                             *
 * License Agreement                                                           *
 *                                                                             *
 * Copyright (c) 2006 Altera Corporation, San Jose, California, USA.           *
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
 * Altera does not recommend, suggest or require that this reference design    *
 * file be used in conjunction or combination with any other product.          *
 ******************************************************************************/

#include "alt_quad_seven_seg.h"

/*
* new_quad_seven_seg
*
* Takes the base of the PIO for the Quad Seven Segment display
* and the refresh rate and creates a quad_seven_seg struct. It inicializes
* the struct and then returns the pointer.
*
*/
quad_seven_seg_values* new_quad_seven_seg(alt_u32 quad_seven_seg_pio_base, alt_u32 seven_seg_refresh)
{
    volatile quad_seven_seg_values* new = (volatile quad_seven_seg_values*) malloc(sizeof(quad_seven_seg_values));
    if (new == NULL)
    {
        return NULL;
    }
    new->pio_base = quad_seven_seg_pio_base;
    new->refresh = seven_seg_refresh;
    new->digit_select[0] = 0x8;
    new->digit_select[1] = 0x4;
    new->digit_select[2] = 0x2;
    new->digit_select[3] = 0x1;
    new->last_digit = 3;
    new->is_positive = YES;
    new->is_hex[0] = YES;
    new->is_hex[1] = YES;
    new->is_hex[2] = YES;
    new->is_hex[3] = YES;
    new->digit[0] = 0;
    new->digit[1] = 0;
    new->digit[2] = 0;
    new->digit[3] = 0;
    return new;
}

/*
* sevenseg_set_hex
*
* Takes the base of the PIO for the Quad Seven Segment display, a decimal
* value to be displayed, wether that value is positive, if it is to be displayed
* as hex and which digit of the display to put it on. It then writes the appropriate
* translated value to the quad seven segment display.
*
*/
void sevenseg_set_hex(alt_u32 quad_seven_seg_pio_base, alt_u8 value, alt_u8 is_pos, alt_u8 is_hex, alt_u8 digit)
{
    unsigned int data;
    static alt_u8 segments[33] = {
        0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x98, /* 0-9 */
        0x88, 0x83, 0xA7, 0xA1, 0x86, 0x8E, 0xFF,                   /* a-f and blank*/
        0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x02, 0x78, 0x00, 0x18, /* 0.-9. */
        0x08, 0x03, 0x27, 0x21, 0x06, 0x0E};                        /* a.-f. */

    if(is_hex)
    {
        data = digit << 9 | is_pos << 8 | (segments[value]);
    }
    else
    {
        data = digit << 9 | is_pos << 8 | value;
    }

    IOWR_ALTERA_AVALON_PIO_DATA(quad_seven_seg_pio_base, data);
}


alt_u32 update_the_quad_seven_seg(void* context)
{
    quad_seven_seg_values* seven_seg = (quad_seven_seg_values *) context;

    switch (seven_seg->last_digit)
    {
        case 0:
           sevenseg_set_hex(seven_seg->pio_base, seven_seg->digit[1],seven_seg->is_positive,seven_seg->is_hex[1],seven_seg->digit_select[1]);
           seven_seg->last_digit = 1;
           break;
        case 1:
           sevenseg_set_hex(seven_seg->pio_base, seven_seg->digit[2],seven_seg->is_positive,seven_seg->is_hex[2],seven_seg->digit_select[2]);
           seven_seg->last_digit = 2;
           break;
        case 2:
           sevenseg_set_hex(seven_seg->pio_base, seven_seg->digit[3],seven_seg->is_positive,seven_seg->is_hex[3],seven_seg->digit_select[3]);
           seven_seg->last_digit = 3;
           break;
        case 3:
           sevenseg_set_hex(seven_seg->pio_base, seven_seg->digit[0],seven_seg->is_positive,seven_seg->is_hex[0],seven_seg->digit_select[0]);
           seven_seg->last_digit = 0;
           break;
    }

    return (alt_u32) seven_seg->refresh;
}

quad_seven_seg_values* QUAD_SEVEN_SEG_INIT(alt_u32 quad_seven_seg_pio_base, alt_u32 seven_seg_refresh)
{
    volatile quad_seven_seg_values* seven_seg = new_quad_seven_seg(quad_seven_seg_pio_base, seven_seg_refresh);
    if(seven_seg == NULL)
    {
        return NULL;
    }
    alt_alarm* update_the_quad_seven_seg_alarm = (alt_alarm*) malloc(sizeof(alt_alarm));
    if(update_the_quad_seven_seg_alarm == NULL)
    {
        return NULL;
    }

    if (alt_alarm_start (update_the_quad_seven_seg_alarm,
                         seven_seg_refresh,
                         update_the_quad_seven_seg,
                         seven_seg) < 0)
    {
      printf ("No system clock available\n");
      return NULL;
    }
    else
    {
        return seven_seg;
    }
}


