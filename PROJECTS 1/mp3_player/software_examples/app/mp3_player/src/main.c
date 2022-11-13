/***********************************************************************
 *                                                                     *
 * File:     main.c                                                    *
 *                                                                     *
 * Purpose:  Top level file for NEEK MP3 Player application.           *
 *                                                                     *
 * Author:   N. Knight                                                 *
 *           Altera Corporation                                        *
 *           Sept 2008                                                *
 **********************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include "simple_graphics.h"
#include "alt_video_display.h"
#include "alt_touchscreen.h"
#include "touchscreen.h"
#include "sd_controller.h"
#include "player_lib.h"
#include "audio_codec_WM8731.h"
#include "altera_avalon_performance_counter.h"
#include "gui.h"
#include "gimp_bmp.h"

// This is our LCD display
alt_video_display* display_global;

// This is our touch panel
alt_touchscreen touchscreen_global;

// This is our audio output device
alt_audio_codec* audio_codec_global;

// This is our SD card
extern sd_card_info_struct* sd_card_global;


/*****************************************************************************
 *  Function: main
 *
 *  Returns: 0
 ****************************************************************************/
int main( void )
{
	int volumes_mounted;
  gui_struct gui;
  player_state_struct player_state; 
  player_struct player;
  
  player.gui = &gui;
//  playlist_struct* playlist;
//  playlist_struct* database;
  player.playlist = NiosIIMP3_InitPlaylist();
  player.database = NiosIIMP3_InitPlaylist();

  // Initialize and start the LCD display
  printf("Initializing LCD display controller  ");
  display_global = alt_video_display_init( "/dev/lcd_controller",     // Name of video controller
                                    800,                              // Width of display
                                    480,                              // Height of display
                                    32,                               // Color depth (32 or 16)
                                    ALT_VIDEO_DISPLAY_USE_HEAP,       // Where we want our frame buffers
                                    0,                                // Where we want our descriptors (n/a here)
                                    2 );                              // How many frame buffers we want

  if( display_global )
    printf(" - OK\n");
  else
    printf(" - FAILED\n");    

  // Initialize the touchscreen    
  printf("Initializing Touchscreen             ");
  if( !InitTouchscreen( &touchscreen_global ))
    printf(" - OK\n");
  else
    printf(" - FAILED\n");    
    
  printf( "****************************************************\n" );
  printf( "*                    MP3 Player                    *\n" );
  printf( "****************************************************\n\n" );

  // Initialize the GUI.
  printf("Initializing GUI Elements            ");
  DisplayStatusMessage( "Starting Up", display_global );
  PrerenderButtons( &gui.gui_main_buttons );
  PrerenderFonts();
  DrawInitialScreenMain( &gui.gui_main_buttons, display_global );
  printf(" - OK\n");

  // Initialize the I2C controller
  printf("Initializing I2C controller          ");
	init_i2c();  
  printf(" - OK\n");

  // Initialize the Audio Codec controller
  printf("Initializing Audio Codec Controller  ");
  audio_codec_global = alt_audio_codec_init( "/dev/audio_controller",
                                             DEFAULT_SAMPLING_RATE,
                                             BCLK_FREQ,
                                             XCK_FREQ,
                                             OUTPUT_BUFFER_SIZE,
                                             AUDIO_CONTROLLER_SLAVE_PORT_CLK );
  if( audio_codec_global )
  {
	  printf(" - OK\n");
  }	
                                      
  // Then the I2C initialization of the actual audio codec chip.
  printf("Initializing Audio Codec Device      ");
  if( !audio_codec_init_i2c( audio_codec_global ))
  {
	  printf(" - OK\n");
	}
  
  // Reset the performance counter 
  PERF_RESET (PERFORMANCE_COUNTER_BASE);

  // Begin measuring:

  // Initialize and mount the filesystem.
  printf("Initializing Filesystem              ");
	// Since the sd card controller is not on the cpu clock, we need
	// to re-set it's clock divider using the actual avalon slave clock freq.
	sd_set_clock_to_max( 80000000 );
  volumes_mounted = sd_fat_mount_all();

  if( volumes_mounted <= 0 )
  {
    printf( " - FAILED\n" );    
  }
  else
  {
    printf(" - OK\n");
  }

  NiosIIMP3_IndexSDCard( player.playlist );

//  printf("Randomizing Playlist                 ");
//  if( !RandomizePlaylist( playlist ))
//    printf(" - OK\n\n");
//  else
//    printf(" - FAILED\n\n");

  PERF_START_MEASURING (PERFORMANCE_COUNTER_BASE);
  
  NiosIIMP3_PlayPlaylist( &player );

  PERF_STOP_MEASURING (PERFORMANCE_COUNTER_BASE);

  NiosIIMP3_FreePlaylist( player.playlist );
  alt_audio_codec_close( audio_codec_global );

  perf_print_formatted_report( PERFORMANCE_COUNTER_BASE,            
                               ALT_CPU_FREQ,        // defined in "system.h"
                               4,                   // How many sections to print
                               "Input",
                               "Decode",
                               "Output",
                               "Free" );             // Display-name of section(s).


  
}

