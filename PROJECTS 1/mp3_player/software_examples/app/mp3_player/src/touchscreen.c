#include "alt_touchscreen.h"
#include "system.h"

/*****************************************************************************
 *  Function: InitTouchscreen
 *
 *  Purpose: Initialize the touchscreen and set the calibration values.
 * 
 *  Returns: 0
 ****************************************************************************/
int InitTouchscreen( alt_touchscreen* touchscreen )
{

  // Initialize the touch panel
  alt_touchscreen_init ( touchscreen,
                         TOUCH_PANEL_SPI_BASE,
                         TOUCH_PANEL_SPI_IRQ,
                         TOUCH_PANEL_PEN_IRQ_N_BASE,
                         60,    // 60 samples/sec
                         ALT_TOUCHSCREEN_SWAP_XY);

  // Calibrate the touch panel
  alt_touchscreen_calibrate_upper_right (touchscreen,
//           3946,   3849,    // ADC readings
           3974,   3849,    // ADC readings
            799,      0  ); // pixel coords
  alt_touchscreen_calibrate_lower_left  (touchscreen,
           132,    148,     // ADC readings
             0,    479  );  // pixel coords

  return( 0 );
}
