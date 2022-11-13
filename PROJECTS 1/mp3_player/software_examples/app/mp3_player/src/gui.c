
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>

#include "simple_graphics.h"
#include "alt_video_display.h"
#include "gui.h"
#include "gimp_bmp.h"
#include "skin1.h"
#include "player_lib.h"
#include "audio_codec_WM8731.h"
#include "altera_avalon_performance_counter.h"

// This is our global LCD display
extern alt_video_display* display_global;

// This is our touch panel
extern alt_touchscreen touchscreen_global;

// This is our global audio codec
extern alt_audio_codec* audio_codec_global;

prerendered_font time_font;
prerendered_font now_playing_label_font;
prerendered_font now_playing_value_font;
prerendered_font playlist_font_gray;
prerendered_font playlist_font_white;

/*****************************************************************************
 *  Function: CopyImageToBuffer
 *
 *  Purpose: Copies an image to a video buffer of a different width.  The source and
 *           destination do not have to be contained in the same buffer,
 *           and can be differend widths.  This function is useful for copying
 *           images stored in RAM to the active frame buffer to be displayed.
 * 
 *  Returns: 0
 ****************************************************************************/
int CopyImageToBuffer( char* dest, char* src, 
                       int dest_width, 
                       int src_width, int src_height )
{
  int y;
  
  //Copy one line at a time from top to bottom
  for ( y = 0; y < src_height; y++ )
  {
    memcpy( dest, src, ( src_width * 4 ));
    src += ( src_width * 4 );
    dest += ( dest_width * 4 );
  }
  
  return( 0 );
}

/*****************************************************************************
 *  Function: CopyImageToCoords
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
int CopyImageToCoords( char* src, int dest_x, int dest_y, 
                       int src_width, int src_height, alt_video_display* display )
{
  char* dest;

  dest = (char*)(( display->buffer_ptrs[display->buffer_being_written]->buffer ) +
                 ( dest_y * ( display->width * 4 )) +
                 ( dest_x * 4 ));
 
  CopyImageToBuffer( dest, 
                     src, 
                     display->width, 
                     src_width, 
                     src_height );
  return( 0 );
}

/*****************************************************************************
 *  Function: CopyBlockToNextFrame
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
int CopyBlockToNextFrame( int x_start, int y_start, int x_end, int y_end, alt_video_display* display )
{
  char* dest;
  char* src;
  int y;
  int image_width = x_end - x_start;
  int screen_width_bytes = display->width * 4;  
  int image_width_bytes = image_width * 4;
  int start_offset = ( y_start * ( screen_width_bytes )) + ( x_start * 4 );
  
  src =  (char*)(( display->buffer_ptrs[display->buffer_being_displayed]->buffer ) +
                 start_offset );
  
  dest = (char*)(( display->buffer_ptrs[display->buffer_being_written]->buffer ) +
                 start_offset );


  for( y = y_start; y < y_end; y++ )
  {
    memcpy( dest, src, image_width_bytes);
    src += screen_width_bytes;
    dest += screen_width_bytes;
  }

  return( 0 );
}


/*****************************************************************************
 *  Function: DisplaySlider
 *
 *  Purpose: Copies an individual, pre-rendered selection slider to the 
 *           display
 * 
 *  Returns: 0
 ****************************************************************************/
int DisplaySlider( gui_slider_struct* slider, int loc_x, int loc_y, alt_video_display* display )
{
  char* src;
  char* dest;
  int num_slices_total, num_slices_to_display, indicator_pos;
  int i;

  // if the passed in location is -1, use the location stored in the button structure.    
  loc_x = loc_x < 0 ? slider->loc_x : loc_x;
  loc_y = loc_y < 0 ? slider->loc_y : loc_y;
  
  num_slices_total = slider->size_x / slider->slice_width;
      
  // Slider Background
  // Left
  CopyImageToCoords( slider->slider_graphic_background_left, slider->loc_x, slider->loc_y,
                     slider->slice_width, slider->size_y, display );    
  // Center
  for( i = 1; i < num_slices_total - 1; i++ )
  {
    CopyImageToCoords( slider->slider_graphic_background_center, 
                       slider->loc_x + ( i * slider->slice_width ), 
                       slider->loc_y, slider->slice_width, slider->size_y, display );
  }
  // Right
  CopyImageToCoords( slider->slider_graphic_background_right, 
                     slider->loc_x + ( i * slider->slice_width ), 
                     slider->loc_y, slider->slice_width, slider->size_y, display );  
/*
  src = slider->slider_graphic_background;
  dest = (char*)(( display->buffer_ptrs[display->buffer_being_written]->buffer ) +
                 ( loc_y * ( display->width * 4 )) +
                 ( loc_x * 4 ));
 
  CopyImageToBuffer( dest, 
                     src, 
                     display->width, 
                     slider->size_x, 
                     slider->size_y );
*/
  // Slider
  if( slider->type == SLIDER_TYPE_ACCUMULATIVE )
  {
    num_slices_to_display = (( slider->pct_displayed * ( num_slices_total - 1 )) / 100 ) + 1;
    
    if( num_slices_to_display == 1 )
    {
      CopyImageToCoords( slider->slider_graphic_slice_single, slider->loc_x, slider->loc_y,
                         slider->slice_width, slider->size_y, display );
    }
    else if( num_slices_to_display > 1 )
    {
      CopyImageToCoords( slider->slider_graphic_slice_left, slider->loc_x, slider->loc_y,
                         slider->slice_width, slider->size_y, display );    
      for( i = 1; i < num_slices_to_display - 1; i++ )
      {
        CopyImageToCoords( slider->slider_graphic_slice_center, 
                           slider->loc_x + ( i * slider->slice_width ), 
                           slider->loc_y, slider->slice_width, slider->size_y, display );
      }

      CopyImageToCoords( slider->slider_graphic_slice_right, 
                         slider->loc_x + ( i * slider->slice_width ), 
                         slider->loc_y, slider->slice_width, slider->size_y, display );
    }
  }
  else if( slider->type == SLIDER_TYPE_INDICATOR )
  {
    indicator_pos = (( slider->pct_displayed * ( slider->size_x - slider->slice_width )) / 100 );
    src = slider->slider_graphic_slice_single;
    dest = (char*)(( display->buffer_ptrs[display->buffer_being_written]->buffer ) +
                   ( slider->loc_y * ( display->width * 4 )) +
                   (( slider->loc_x + indicator_pos ) * 4 ));
   
    CopyImageToBuffer( dest, 
                       src, 
                       display->width, 
                       slider->slice_width, 
                       slider->size_y );
   
  }

  return( 0 );
}


/*****************************************************************************
 *  Function: load_gimp_graphic_to_pointer
 *
 *  Purpose: 
 * 
 *  Returns: 0
 ****************************************************************************/
int load_gimp_graphic_to_pointer( GimpImage* image_source, char** dest )
{
  bitmap_struct* image;
  int bytes;
  
  image = malloc(sizeof(bitmap_struct));

  load_gimp_bmp( image_source, image, 32);
  bytes = ( image->biHeight * image->biWidth * 4 );
  *dest = malloc( bytes );
  memcpy( dest, image->data, bytes );
  
  free_gimp_bmp_data( image );
  free( image );
  
  return( 0 );
}


/*****************************************************************************
 *  Function: PrerenderButton
 *
 *  Purpose: 
 * 
 *  Returns: 0
 ****************************************************************************/
int PrerenderButton( gui_button_struct* button, 
                     GimpImage* gimp_image_not_pressed, 
                     GimpImage* gimp_image_pressed,
                     int type )
{
  bitmap_struct* image;
  int bytes;
  
  image = malloc(sizeof(bitmap_struct));
  
  // unpressed graphic
  load_gimp_bmp( gimp_image_not_pressed, image, 32);
  bytes = ( image->biHeight * image->biWidth * 4 );
  button->button_graphic_not_pressed = malloc( bytes );
  memcpy( button->button_graphic_not_pressed, image->data, bytes );

  // pressed graphic
  load_gimp_bmp( gimp_image_pressed, image, 32);
  bytes = ( image->biHeight * image->biWidth * 4 );
  button->button_graphic_pressed = malloc( bytes );
  memcpy( button->button_graphic_pressed, image->data, bytes );

  button->size_x = image->biWidth;
  button->size_y = image->biHeight;
  
  button->type = type;
  
  button->is_selected = BUTTON_STATE_OFF;
  button->state = 0;
  button->needs_refresh = 0;

  free_gimp_bmp_data( image );
  free( image );
  
  return( 0 );
}


/*****************************************************************************
 *  Function: PrerenderSlider
 *
 *  Purpose: 
 * 
 *  Returns: 0
 ****************************************************************************/
int PrerenderSlider( gui_slider_struct* slider, 
                     GimpImage* background_center, 
                     GimpImage* background_left, 
                     GimpImage* background_right, 
                     GimpImage* slice_center,
                     GimpImage* slice_left,
                     GimpImage* slice_right,
                     GimpImage* slice_single,
                     int width,
                     int type,
                     int initial_value )
{
  bitmap_struct* image;
  int bytes;
  
  image = malloc(sizeof(bitmap_struct));

  // background center  
  load_gimp_bmp( background_center, image, 32);
  bytes = ( image->biHeight * image->biWidth * 4 );
  slider->slider_graphic_background_center = malloc( bytes );
  memcpy( slider->slider_graphic_background_center, image->data, bytes );
  free_gimp_bmp_data( image );
  
  // background left
  load_gimp_bmp( background_left, image, 32);
  bytes = ( image->biHeight * image->biWidth * 4 );
  slider->slider_graphic_background_left = malloc( bytes );
  memcpy( slider->slider_graphic_background_left, image->data, bytes );
  free_gimp_bmp_data( image );
 
  // background right
  load_gimp_bmp( background_right, image, 32);
  bytes = ( image->biHeight * image->biWidth * 4 );
  slider->slider_graphic_background_right = malloc( bytes );
  memcpy( slider->slider_graphic_background_right, image->data, bytes );
  free_gimp_bmp_data( image );
  
  slider->size_x = width;
  slider->size_y = image->biHeight;

  // slice_center
  load_gimp_bmp( slice_center, image, 32);
  bytes = ( image->biHeight * image->biWidth * 4 );
  slider->slider_graphic_slice_center = malloc( bytes );
  memcpy( slider->slider_graphic_slice_center, image->data, bytes );
  free_gimp_bmp_data( image );
  
  slider->slice_width = image->biWidth;

  // slice_left
  load_gimp_bmp( slice_left, image, 32);
  bytes = ( image->biHeight * image->biWidth * 4 );
  slider->slider_graphic_slice_left = malloc( bytes );
  memcpy( slider->slider_graphic_slice_left, image->data, bytes );
  free_gimp_bmp_data( image );
  
  // slice_right
  load_gimp_bmp( slice_right, image, 32);
  bytes = ( image->biHeight * image->biWidth * 4 );
  slider->slider_graphic_slice_right = malloc( bytes );
  memcpy( slider->slider_graphic_slice_right, image->data, bytes );
  free_gimp_bmp_data( image );
  
  // slice_single
  load_gimp_bmp( slice_single, image, 32);
  bytes = ( image->biHeight * image->biWidth * 4 );
  slider->slider_graphic_slice_single = malloc( bytes );
  memcpy( slider->slider_graphic_slice_single, image->data, bytes );
  free_gimp_bmp_data( image );
  
  free( image );
  slider->pct_displayed = initial_value;
  slider->type = type;
 
  return( 0 ); 
}
                      

/*****************************************************************************
 *  Function: DisplayGimpImage
 *
 *  Purpose: 
 * 
 *  Returns: 0
 ****************************************************************************/
void DisplayGimpImage( int loc_x, int loc_y, GimpImage* gimp_image, alt_video_display* display )
{
  bitmap_struct* image;
  int bytes;
  char* src;
  char* dest;
  
  image = malloc(sizeof(bitmap_struct));
  
  load_gimp_bmp( gimp_image, image, 32);
  bytes = ( image->biHeight * image->biWidth * 4 );

  src = image->data;
  dest = (char*)(( display->buffer_ptrs[display->buffer_being_written]->buffer ) +
                 ( loc_y * ( display->width * 4 )) +
                 ( loc_x * 4 ));
 
  CopyImageToBuffer( dest, 
                     src, 
                     display->width, 
                     image->biWidth,
                     image->biHeight );
  free_gimp_bmp_data( image );
  free( image );
  
}


/*****************************************************************************
 *  Function: DisplayMainButtons
 *
 *  Purpose: 
 * 
 *  Returns: 0
 ****************************************************************************/
void DisplayMainButtons( player_struct* player, alt_video_display* display )
{
    gui_main_buttons_struct* gui_main_buttons = &player->gui->gui_main_buttons;
    
    DisplayButton( &(gui_main_buttons->skip_back_button), -1, -1, display );
    DisplayButton( &(gui_main_buttons->play_button), -1, -1, display );
    DisplayButton( &(gui_main_buttons->pause_button), -1, -1, display );
    DisplayButton( &(gui_main_buttons->skip_fwd_button), -1, -1, display );

}

/*****************************************************************************
 *  Function: DisplaySliders
 *
 *  Purpose: 
 * 
 *  Returns: 0
 ****************************************************************************/
void DisplaySliders( gui_main_buttons_struct* gui_main_buttons, alt_video_display* display )
{
  DisplaySlider( &(gui_main_buttons->volume_slider), -1, -1, display );
  // Display title
  vid_print_string_alpha( gui_main_buttons->volume_slider.loc_x - 50, 
                          gui_main_buttons->volume_slider.loc_y + 0,
                          WINDOW_HEADING_COLOR, 
                          CLEAR_BACKGROUND, 
                          arial_24, 
                          display, 
                          "Vol" );
  
  DisplaySlider( &(gui_main_buttons->balance_slider), -1, -1, display );
  // Display title
  vid_print_string_alpha( gui_main_buttons->balance_slider.loc_x - 50, 
                          gui_main_buttons->balance_slider.loc_y + 0,
                          WINDOW_HEADING_COLOR, 
                          CLEAR_BACKGROUND, 
                          arial_24, 
                          display, 
                          "Bal" );
}



/*****************************************************************************
 *  Function: PrerenderButtons
 *
 *  Purpose: 
 * 
 *  Returns: 0
 ****************************************************************************/
void PrerenderButtons( gui_main_buttons_struct* gui_main_buttons )
{
  extern struct gimp_image_struct gimp_image_skip_fwd_pressed;
  extern struct gimp_image_struct gimp_image_skip_fwd_not_pressed;
  extern struct gimp_image_struct gimp_image_skip_back_pressed;
  extern struct gimp_image_struct gimp_image_skip_back_not_pressed;
  extern struct gimp_image_struct gimp_image_play_pressed;
  extern struct gimp_image_struct gimp_image_play_not_pressed;
  extern struct gimp_image_struct gimp_image_pause_pressed;
  extern struct gimp_image_struct gimp_image_pause_not_pressed;

  extern struct gimp_image_struct gimp_image_prog_bar_empty_center_10x27;
  extern struct gimp_image_struct gimp_image_prog_bar_empty_left_10x27;
  extern struct gimp_image_struct gimp_image_prog_bar_empty_right_10x27;
  extern struct gimp_image_struct gimp_image_prog_bar_on_10x27;
  extern struct gimp_image_struct gimp_image_prog_bar_on_left_10x27;
  extern struct gimp_image_struct gimp_image_prog_bar_on_right_10x27;  
  extern struct gimp_image_struct gimp_image_prog_bar_on_left_right_10x27;
  
  PrerenderButton( &gui_main_buttons->skip_fwd_button, 
                   &gimp_image_skip_fwd_not_pressed, 
                   &gimp_image_skip_fwd_pressed, 
                   BUTTON_TYPE_MOMENTARY );
  gui_main_buttons->skip_fwd_button.loc_x = SKIP_FWD_BUTTON_LOC_X;
  gui_main_buttons->skip_fwd_button.loc_y = SKIP_FWD_BUTTON_LOC_Y;
  gui_main_buttons->skip_fwd_button.needs_refresh = 1;
  
  PrerenderButton( &gui_main_buttons->skip_back_button, 
                   &gimp_image_skip_back_not_pressed, 
                   &gimp_image_skip_back_pressed, 
                   BUTTON_TYPE_MOMENTARY );
  gui_main_buttons->skip_back_button.loc_x = SKIP_BACK_BUTTON_LOC_X;
  gui_main_buttons->skip_back_button.loc_y = SKIP_BACK_BUTTON_LOC_Y;
  gui_main_buttons->skip_back_button.needs_refresh = 1;
  
  PrerenderButton( &gui_main_buttons->play_button, 
                   &gimp_image_play_not_pressed, 
                   &gimp_image_play_pressed, 
                   BUTTON_TYPE_ON_ONLY );
  gui_main_buttons->play_button.loc_x = PLAY_BUTTON_LOC_X;
  gui_main_buttons->play_button.loc_y = PLAY_BUTTON_LOC_Y;
  gui_main_buttons->play_button.state = BUTTON_STATE_ON;
  gui_main_buttons->play_button.needs_refresh = 1;
  
  PrerenderButton( &gui_main_buttons->pause_button, 
                   &gimp_image_pause_not_pressed, 
                   &gimp_image_pause_pressed, 
                   BUTTON_TYPE_ON_OFF );
  gui_main_buttons->pause_button.loc_x = PAUSE_BUTTON_LOC_X;
  gui_main_buttons->pause_button.loc_y = PAUSE_BUTTON_LOC_Y;
  gui_main_buttons->pause_button.needs_refresh = 1;
  
  PrerenderSlider( &gui_main_buttons->volume_slider, 
                   &gimp_image_prog_bar_empty_center_10x27,                    
                   &gimp_image_prog_bar_empty_left_10x27, 
                   &gimp_image_prog_bar_empty_right_10x27, 
                   &gimp_image_prog_bar_on_10x27,
                   &gimp_image_prog_bar_on_left_10x27,
                   &gimp_image_prog_bar_on_right_10x27,
                   &gimp_image_prog_bar_on_left_right_10x27,
                   VOL_SLIDER_WIDTH,
                   SLIDER_TYPE_ACCUMULATIVE,
                   50 );
  gui_main_buttons->volume_slider.loc_x = VOL_SLIDER_LOC_X;
  gui_main_buttons->volume_slider.loc_y = VOL_SLIDER_LOC_Y;
                   
  PrerenderSlider( &gui_main_buttons->balance_slider, 
                   &gimp_image_prog_bar_empty_center_10x27,                    
                   &gimp_image_prog_bar_empty_left_10x27, 
                   &gimp_image_prog_bar_empty_right_10x27, 
                   &gimp_image_prog_bar_on_10x27,
                   &gimp_image_prog_bar_on_left_10x27,
                   &gimp_image_prog_bar_on_right_10x27,
                   &gimp_image_prog_bar_on_left_right_10x27,
                   BAL_SLIDER_WIDTH,
                   SLIDER_TYPE_INDICATOR,
                   50 );
  gui_main_buttons->balance_slider.loc_x = BAL_SLIDER_LOC_X;
  gui_main_buttons->balance_slider.loc_y = BAL_SLIDER_LOC_Y;

}

/*****************************************************************************
 *  Function: DrawWindow
 *
 *  Purpose: 
 * 
 *  Returns: 0
 ****************************************************************************/
void DrawWindow( int start_x, int start_y, int width, int height, char* heading, alt_video_display* display )
{
  
  DrawRoundCornerGradBox( start_x, start_y, start_x + width, start_y + height, WINDOW_CORNER_RADIUS,
                          WINDOW_START_COLOR, WINDOW_END_COLOR, WINDOW_BACKGROUND_COLOR,
                          GRAD_DOWN_RIGHT, 100, display );

  vid_draw_round_corner_box ( start_x + WINDOW_BORDER_WIDTH, 
                              start_y + WINDOW_HEADER_HEIGHT, 
                              start_x + ( width - WINDOW_BORDER_WIDTH ), 
                              start_y + ( height - WINDOW_BORDER_WIDTH ), 
                              WINDOW_CORNER_RADIUS - WINDOW_BORDER_WIDTH, 
                              WINDOW_BACKGROUND_COLOR, 
                              DO_FILL, 
                              display );

  vid_draw_round_corner_box ( start_x + WINDOW_BORDER_WIDTH, 
                              start_y + WINDOW_HEADER_HEIGHT, 
                              start_x + ( width - WINDOW_BORDER_WIDTH ), 
                              start_y + ( height - WINDOW_BORDER_WIDTH ), 
                              WINDOW_CORNER_RADIUS - WINDOW_BORDER_WIDTH, 
                              0x0081c3, 
                              DO_NOT_FILL, 
                              display );

  vid_print_string_alpha( start_x + 30,
                          start_y + 8,
                          WINDOW_HEADING_COLOR, 
                          CLEAR_BACKGROUND, 
                          WINDOW_HEADING_FONT, 
                          display, 
                          heading );

}

/*****************************************************************************
 *  Function: DrawGradBox
 *
 *  Purpose: Draws a filled box with a color gradient.  start_color blends to   
 *           end_color.  amplitude specifies (in percent) how far the gradient
 *           should transition to the end_color.  direction specifies which
 *           direction the gradient should follow.
 * 
 *  Returns: 0
 * 
 ****************************************************************************/
int DrawGradBox( int horiz_start, 
                 int vert_start, 
                 int horiz_end, 
                 int vert_end, 
                 unsigned int start_color,
                 unsigned int end_color, 
                 int direction,
                 int amplitude,
                 alt_video_display* display )
{
  unsigned int temp_color;
  int x, y;
  unsigned int start_red, start_green, start_blue;
  unsigned int end_red, end_green, end_blue;
  int delta_red, delta_green, delta_blue;
  int incr_red, incr_green, incr_blue;
  int xincr_red, xincr_green, xincr_blue;
  int yincr_red, yincr_green, yincr_blue;
  unsigned int current_red, current_green, current_blue;
  int distance, effective_distance;
  int y_index, x_index;  
  
  start_red =   ( start_color >> 16 ) & 0xFF;
  start_green = ( start_color >> 8  ) & 0xFF;
  start_blue =  ( start_color >> 0  ) & 0xFF;

  end_red =     ( end_color   >> 16 ) & 0xFF;
  end_green =   ( end_color   >> 8  ) & 0xFF;
  end_blue =    ( end_color   >> 0  ) & 0xFF;
  
  delta_red =   ( end_red -   start_red );
  delta_green = ( end_green - start_green );
  delta_blue =  ( end_blue -  start_blue );
  
  if(( direction == GRAD_DOWN ) || 
     ( direction == GRAD_UP ) || 
     ( direction == GRAD_LEFT ) || 
     ( direction == GRAD_RIGHT ))
  {
    if(( direction == GRAD_DOWN ) || ( direction == GRAD_UP ))
      distance = ( vert_end - vert_start );
    else
      distance = ( horiz_end - horiz_start );
    
    effective_distance = ( distance * 100 ) / amplitude;

    incr_red = (( delta_red << 16 ) / ( effective_distance ));
    incr_green = (( delta_green << 16 ) / ( effective_distance ));
    incr_blue = (( delta_blue << 16 ) / ( effective_distance ));

    current_red = start_red << 16;
    current_green = start_green << 16;
    current_blue = start_blue << 16;

    if( direction == GRAD_DOWN )
    {
      for( y = vert_start; y < vert_end; y++ )
      {
        temp_color = ((( current_red   >> 16 ) << 16 & 0xFF0000 ) |
                      (( current_green >> 16 ) << 8  & 0x00FF00 ) |
                      (( current_blue  >> 16 ) << 0  & 0x0000FF ));

        vid_draw_line( horiz_start, y, horiz_end, y, 1, temp_color, display );

        current_red +=   incr_red;
        current_green += incr_green;
        current_blue  += incr_blue;
      }
    }
      if( direction == GRAD_UP )
    {
      for( y = vert_end - 1; y >= vert_start; y-- )
      {
        temp_color = ((( current_red   >> 16 ) << 16 & 0xFF0000 ) |
                      (( current_green >> 16 ) << 8  & 0x00FF00 ) |
                      (( current_blue  >> 16 ) << 0  & 0x0000FF ));

        vid_draw_line( horiz_start, y, horiz_end, y, 1, temp_color, display );

        current_red +=   incr_red;
        current_green += incr_green;
        current_blue  += incr_blue;
      }
    }

    if( direction == GRAD_RIGHT )
    {
      for( x = horiz_start; x < horiz_end; x++ )
      {
        temp_color = ((( current_red   >> 16 ) << 16 & 0xFF0000 ) |
                      (( current_green >> 16 ) << 8  & 0x00FF00 ) |
                      (( current_blue  >> 16 ) << 0  & 0x0000FF ));

        vid_draw_line( x, vert_start, x, vert_end, 1, temp_color, display );

        current_red +=   incr_red;
        current_green += incr_green;
        current_blue  += incr_blue;
      }
    }

    if( direction == GRAD_LEFT )
    {
      for( x = horiz_end - 1; x >= horiz_start; x-- )
      {
        temp_color = ((( current_red   >> 16 ) << 16 & 0xFF0000 ) |
                      (( current_green >> 16 ) << 8  & 0x00FF00 ) |
                      (( current_blue  >> 16 ) << 0  & 0x0000FF ));

        vid_draw_line( x, vert_start, x, vert_end, 1, temp_color, display );

        current_red +=   incr_red;
        current_green += incr_green;
        current_blue  += incr_blue;
      }
    }
  }

  if(( direction == GRAD_DOWN_RIGHT ) ||
     ( direction == GRAD_DOWN_LEFT ) ||
     ( direction == GRAD_UP_RIGHT ) ||
     ( direction == GRAD_UP_LEFT ))
  {
    distance = sqrt((( horiz_end - horiz_start ) * ( horiz_end - horiz_start )) +
                    (( vert_end - vert_start )   * ( vert_end - vert_start )));

    effective_distance = ( distance * 100 ) / amplitude;
    incr_red = (( delta_red << 16 ) / ( effective_distance ));
    incr_green = (( delta_green << 16 ) / ( effective_distance ));
    incr_blue = (( delta_blue << 16 ) / ( effective_distance ));
    
    xincr_red = ( incr_red * ( horiz_end - horiz_start )) / distance;
    xincr_green = ( incr_green * ( horiz_end - horiz_start )) / distance;
    xincr_blue = ( incr_blue * ( horiz_end - horiz_start )) / distance;

    yincr_red = ( incr_red * ( vert_end - vert_start )) / distance;
    yincr_green = ( incr_green * ( vert_end - vert_start )) / distance;
    yincr_blue = ( incr_blue * ( vert_end - vert_start )) / distance;
    
    start_red = start_red << 16;
    start_green = start_green << 16;
    start_blue = start_blue << 16;
    
    if( direction == GRAD_DOWN_RIGHT )
    {
      for( y = vert_start; y < vert_end; y++ )
      {
        y_index = y - vert_start;
        for( x = horiz_start; x < horiz_end; x++ )
        {
          x_index = x - horiz_start;
          temp_color = (((( start_red +   ( x_index * xincr_red ) +   ( y_index * yincr_red ))   >> 16 ) << 16 & 0xFF0000 ) |
                        ((( start_green + ( x_index * xincr_green ) + ( y_index * yincr_green )) >> 16 ) << 8  & 0x00FF00 ) |
                        ((( start_blue +  ( x_index * xincr_blue ) +  ( y_index * yincr_blue ))  >> 16 ) << 0  & 0x0000FF ));

          vid_set_pixel( x, y, temp_color, display);
        }
      }
    }
    
    if( direction == GRAD_DOWN_LEFT )
    {
      for( y = vert_start; y < vert_end; y++ )
      {
        y_index = y - vert_start;
        for( x = horiz_start; x < horiz_end; x++ )
        {
          x_index = ( horiz_end - x ) - 1;
          temp_color = (((( start_red +   ( x_index * xincr_red ) +   ( y_index * yincr_red ))   >> 16 ) << 16 & 0xFF0000 ) |
                        ((( start_green + ( x_index * xincr_green ) + ( y_index * yincr_green )) >> 16 ) << 8  & 0x00FF00 ) |
                        ((( start_blue +  ( x_index * xincr_blue ) +  ( y_index * yincr_blue ))  >> 16 ) << 0  & 0x0000FF ));

          vid_set_pixel( x, y, temp_color, display);
        }
      }
    }

    if( direction == GRAD_UP_RIGHT )
    {
      for( y = vert_start; y < vert_end; y++ )
      {
        y_index = ( vert_end - y ) - 1;
        for( x = horiz_start; x < horiz_end; x++ )
        {
          x_index = x - horiz_start;
          temp_color = (((( start_red +   ( x_index * xincr_red ) +   ( y_index * yincr_red ))   >> 16 ) << 16 & 0xFF0000 ) |
                        ((( start_green + ( x_index * xincr_green ) + ( y_index * yincr_green )) >> 16 ) << 8  & 0x00FF00 ) |
                        ((( start_blue +  ( x_index * xincr_blue ) +  ( y_index * yincr_blue ))  >> 16 ) << 0  & 0x0000FF ));

          vid_set_pixel( x, y, temp_color, display);
        }
      }
    }

    if( direction == GRAD_UP_LEFT )
    {
      for( y = vert_start; y < vert_end; y++ )
      {
        y_index = ( vert_end - y ) - 1;
        for( x = horiz_start; x < horiz_end; x++ )
        {
          x_index = ( horiz_end - x ) - 1;
          temp_color = (((( start_red +   ( x_index * xincr_red ) +   ( y_index * yincr_red ))   >> 16 ) << 16 & 0xFF0000 ) |
                        ((( start_green + ( x_index * xincr_green ) + ( y_index * yincr_green )) >> 16 ) << 8  & 0x00FF00 ) |
                        ((( start_blue +  ( x_index * xincr_blue ) +  ( y_index * yincr_blue ))  >> 16 ) << 0  & 0x0000FF ));

          vid_set_pixel( x, y, temp_color, display);
        }
      }
    }
  }
  return( 0 );
}

/*****************************************************************************
 *  Function: InverseRoundCornerPoints
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
void InverseRoundCornerPoints( int cx, int cy, int x, int y, 
                               int straight_width, int straight_height, int radius,
                               int color, char fill, alt_video_display* display)
{
  if(( x <= y  )&& ( x != 0 )) 
  {
    vid_draw_line( cx - radius,             cy + y + straight_height, cx - x,                       cy + y + straight_height, 1, color, display);
    vid_draw_line( cx + x + straight_width, cy + y + straight_height, cx + radius + straight_width, cy + y + straight_height, 1, color, display);
    vid_draw_line( cx - radius,             cy - y                  , cx - x,                       cy - y                  , 1, color, display);
    vid_draw_line( cx + x + straight_width, cy - y                  , cx + radius + straight_width, cy - y                  , 1, color, display);

    if( y < radius )
    {
      vid_draw_line( cx - radius,             cy + x + straight_height, cx - y,                       cy + x + straight_height, 1, color, display );
      vid_draw_line( cx + y + straight_width, cy + x + straight_height, cx + radius + straight_width, cy + x + straight_height, 1, color, display );
      vid_draw_line( cx - radius,             cy - x                  , cx - y,                       cy - x                  , 1, color, display );
      vid_draw_line( cx + y + straight_width, cy - x                  , cx + radius + straight_width, cy - x                  , 1, color, display );
    }
  }
}

/*****************************************************************************
 *  Function: FillInverseRoundCorners
 *
 *  Purpose: 
 * 
 *  Returns: 0
 * 
 ****************************************************************************/
void FillInverseRoundCorners ( int horiz_start, int vert_start, int horiz_end, int vert_end, 
                              int radius, int color, int fill, alt_video_display* display)
{
  unsigned int x, y;
  int p;
  int diameter;
  int temp;
  unsigned int width, height, straight_width, straight_height;

  // Make sure the start point us up and left of the end point
  if( horiz_start > horiz_end )
  {
    temp = horiz_end;
    horiz_end = horiz_start;
    horiz_start = temp;
  }
  
  if( vert_start > vert_end )
  {
    temp = vert_end;
    vert_end = vert_start;
    vert_start = temp;
  }
  
  // These are the overall dimensions of the box
  width = horiz_end - horiz_start;
  height = vert_end - vert_start;

  // Make sure our radius isnt more than the shortest dimension 
  // of the box, or it'll screw us all up
  if( radius > ( width / 2 ))
    radius = width / 2;

  if( radius > ( height / 2 ))
    radius = height / 2;
  
  // We use the diameter for some calculations, so we'll pre calculate it here.
  diameter = ( radius * 2 );

  // These are the lengths of the straight portions of the box edges.
  straight_width = width - diameter;
  straight_height = height - diameter;

  x = 0;
  y = radius;
  p = (5 - radius*4)/4;
   
  // Now start moving out from those points until the lines meet
  while (x < y) 
  {
    x++;
    if (p < 0) {
      p += 2*x+1;
    } else {
      y--;
      p += 2*(x-y)+1;
    }
    InverseRoundCornerPoints( horiz_start + radius, vert_start + radius, x, y, 
                              straight_width, straight_height, radius, color, fill, display );
  }
}


/*****************************************************************************
 *  Function: DrawRoundCornerGradBox
 *
 *  Purpose: 
 * 
 *  Returns: 0
 * 
 ****************************************************************************/
int DrawRoundCornerGradBox( int horiz_start, 
                            int vert_start, 
                            int horiz_end, 
                            int vert_end,
                            int radius,
                            unsigned int start_color,
                            unsigned int end_color,
                            unsigned int bg_color,
                            int direction,
                            int amplitude,
                            alt_video_display* display )
{
  DrawGradBox( horiz_start, vert_start, horiz_end, vert_end,
               start_color, end_color, direction, amplitude, display );
  

  FillInverseRoundCorners( horiz_start, vert_start, horiz_end, vert_end, 
                           radius, bg_color, DO_FILL, display );

}


/*****************************************************************************
 *  Function: CoordsAreInArea
 *
 *  Purpose: Determines if a set of coordinates are contained within a given
 *           area.  Useful for quickly seeing if touchscreen coordinates are
 *           within an active touchscreen area.
 * 
 *  Returns: (1) - Coordinates are contained in the area
 *           (0) - Coordinates are not contained in the area
 ****************************************************************************/
int CoordsAreInArea( int coord_x, int coord_y, int coords_are_active,
                     int start_x, int start_y, int end_x, int end_y)
{
  int ret_code;
  
  // If coordinates are contained within area and the pen is down
  if(( coord_x >= start_x ) && ( coord_x <= end_x ) &&
     ( coord_y >= start_y ) && ( coord_y <= end_y ) &&
     ( coords_are_active ))
  {
    ret_code = 1;
  }
  else
  {
    ret_code = 0;
  }
  
  return( ret_code );
}

/*****************************************************************************
 *  Function: CoordsAreOnSlider
 *
 *  Purpose: Determines if a set of coordinates are contained within a given
 *           slider.  
 * 
 *  Returns: (1) - Coordinates are contained in the area
 *           (0) - Coordinates are not contained in the area
 ****************************************************************************/
int CoordsAreOnSlider( int touchscreen_x, int touchscreen_y, gui_slider_struct* slider )
{
  int x_start, x_end, y_start, y_end;
  int ret_code;
  int pen_is_down;
  
  x_start = slider->loc_x;
  y_start = slider->loc_y;
  x_end = slider->loc_x + slider->size_x;
  y_end = slider->loc_y + slider->size_y;
  
  if( CoordsAreInArea( touchscreen_x, touchscreen_y, pen_is_down,
                       x_start, y_start, x_end, y_end ))
  {
    ret_code = 1;
  }
  else
  {
    ret_code = 0;
  }
  return( ret_code );
}


/*****************************************************************************
 *  Function: CoordsAreOnButton
 *
 *  Purpose: Determines if a set of coordinates are contained within a given
 *           button.  
 * 
 *  Returns: (1) - Coordinates are contained in the area
 *           (0) - Coordinates are not contained in the area
 ****************************************************************************/
int CoordsAreOnButton( int touchscreen_x, int touchscreen_y, int pen_is_down, gui_button_struct* button )
{
  int x_start, x_end, y_start, y_end;
  int ret_code;
  
  x_start = button->loc_x;
  y_start = button->loc_y;
  x_end = button->loc_x + button->size_x;
  y_end = button->loc_y + button->size_y;
  
  if( CoordsAreInArea( touchscreen_x, touchscreen_y, pen_is_down,
                         x_start, y_start, x_end, y_end ))
  {
    ret_code = 1;
  }
  else
  {
    ret_code = 0;
  }
  return( ret_code );
}

/*****************************************************************************
 *  Function: UpdateSlider
 *
 *  Purpose: Updates the state of an individual slider, based 
 *           on the touchscreen coordinates being passed in.  
 * 
 *  Returns: 0
 ****************************************************************************/
int UpdateSlider( alt_video_display* display,
                  int touchscreen_x,
                  int touchscreen_y,
                  int pen_is_down,
                  int desired_position,
                  gui_slider_struct* slider )
{
  int i;
  int pct_x;
  int update_display = 0;

//  printf( "DEBUG: Running UpdateSlider(), %d, %d, %d\n", touchscreen_x, touchscreen_y, pen_is_down );
//  printf( "DEBUG: Running UpdateSlider()\n" );
  if( CoordsAreOnSlider( touchscreen_x, touchscreen_y, slider ) && pen_is_down )
  {
//    printf( "DEBUG: Coords are on Slider %d, %d\n", touchscreen_x, touchscreen_y );
    slider->pct_displayed = (( touchscreen_x - slider->loc_x ) * 100 ) / slider->size_x;
    update_display = 1;
  }
  else if(( desired_position >= 0 ) && ( slider->pct_displayed != desired_position ))
  {
    slider->pct_displayed = desired_position;
    update_display = 1;
  }
  else if( pen_is_down )
  {

    if( CoordsAreOnSlider( touchscreen_x, touchscreen_y, slider ) && pen_is_down )
    {
      slider->pct_displayed = (( touchscreen_x - slider->loc_x ) * 100 ) / slider->size_x;
      update_display = 1;
    }
//    printf( "DEBUG: coords %d, %d != %d+%d, %d+%d\n", touchscreen_x, touchscreen_y,
//                                                      slider->loc_x, slider->size_x,
//                                                      slider->loc_y, slider->size_y );    
  }
    

  if( update_display )
  {
    for( i = 0; i < display->num_frame_buffers; i++ )
    {
      while( alt_video_display_buffer_is_available( display ));  
      DisplaySlider( slider, -1, -1, display );
      alt_video_display_register_written_buffer( display );
    }
  }  

  return( slider->pct_displayed );
}

/*****************************************************************************
 *  Function: DisplayButton
 *
 *  Purpose: Copies an individual, pre-rendered selection button to the 
 *           display
 * 
 *  Returns: 0
 ****************************************************************************/
int DisplayButton( gui_button_struct* button, int loc_x, int loc_y, alt_video_display* display )
{
  char* src;
  char* dest;

  // If the button was pressed, draw it as "down".
  if( button->is_selected || ( button->state == BUTTON_STATE_ON ))
    src = button->button_graphic_pressed;
  else
    src = button->button_graphic_not_pressed;
  
  // if the passed in location is -1, use the location stored in the button structure.    
  loc_x = loc_x < 0 ? button->loc_x : loc_x;
  loc_y = loc_y < 0 ? button->loc_y : loc_y;

  dest = (char*)(( display->buffer_ptrs[display->buffer_being_written]->buffer ) +
                 ( loc_y * ( display->width * 4 )) +
                 ( loc_x * 4 ));
 
  CopyImageToBuffer( dest, 
                     src, 
                     display->width, 
                     button->size_x, 
                     button->size_y );
    
  return( 0 );
}


/*****************************************************************************
 *  Function: UpdateButton
 *
 *  Purpose: Updates the state of an individual button, based 
 *           on the touchscreen coordinates being passed in.  This function 
 *           also detects and flags pen-up and pen-down events on the button.
 * 
 *  Returns: 0
 ****************************************************************************/
int UpdateButton( alt_video_display* display,
                  int touchscreen_x,
                  int touchscreen_y,
                  int pen_is_down,
                  gui_button_struct* button )
{
  int i;

  if( CoordsAreOnButton( touchscreen_x, touchscreen_y, pen_is_down, button ))
  {
    // Pen is now on button now, but wasn't last time = pen-down event
    if( button->is_selected == 0 )
    {
      button->is_selected = 1;
      button->pen_down_event_occured = 1;
      button->pen_up_event_occured = 0;
      for( i = 0; i < display->num_frame_buffers; i++ )
      {
        while ( alt_video_display_buffer_is_available( display ) != 0 );
        DisplayButton( button, -1, -1, display );
        alt_video_display_register_written_buffer( display );
      }
    }
    else
    {
      button->pen_down_event_occured = 0;
      button->pen_up_event_occured = 0;
    }
  }
  else
  {
    // Pen is not on button now, but was last time = pen-up event
    if( button->is_selected == 1 )
    {
      button->is_selected = 0;
      button->pen_down_event_occured = 0;
      // A pen up only occured if... well... the pen is up.
      // If we dont do this test, we could trigger a false pen up 
      // on the button if the user just slid the pen off.
      if( pen_is_down == 0 )
      {
        button->pen_up_event_occured = 1;
        if( button->type == BUTTON_TYPE_ON_OFF )
        {
          button->state = button->state == BUTTON_STATE_OFF ? BUTTON_STATE_ON : BUTTON_STATE_OFF;
        }
        else if( button->type == BUTTON_TYPE_ON_ONLY ) 
        {
          button->state = BUTTON_STATE_ON;
        }
      }
      else
      {
        button->pen_up_event_occured = 0;
      }
      
      for( i = 0; i < display->num_frame_buffers; i++ )
      {
        while ( alt_video_display_buffer_is_available( display ) != 0 );
        DisplayButton( button, -1, -1, display );
        alt_video_display_register_written_buffer( display );
      }
    }
    else if( button->needs_refresh )
    {
      for( i = 0; i < display->num_frame_buffers; i++ )
      {
        while ( alt_video_display_buffer_is_available( display ) != 0 );
        DisplayButton( button, -1, -1, display );
        alt_video_display_register_written_buffer( display );
      }
    }       
    else
    {
      button->pen_down_event_occured = 0;
      button->pen_up_event_occured = 0;
    }
  }
  
  button->needs_refresh = 0;
  
  return( 0 );
}

/*****************************************************************************
 *  Function: UpdateMainButtons
 *
 *  Purpose: Updates the state of the  buttons, and detects pen-up
 *           events on them.
 * 
 *  Returns: 0 - No pen-up event occured on the buttons
 *           1 - A pen-up event occured on a button.
 ****************************************************************************/
int UpdateMainButtons( alt_video_display* display, 
                   int touchscreen_x,
                   int touchscreen_y,
                   int pen_is_down,
                   gui_main_buttons_struct* gui_main_buttons )
{
  int ret_code = BUTTON_NOT_SELECTED;
  int i;

  // Update the gui buttons
  UpdateButton( display, touchscreen_x, touchscreen_y, pen_is_down, &gui_main_buttons->play_button );
  UpdateButton( display, touchscreen_x, touchscreen_y, pen_is_down, &gui_main_buttons->pause_button );
  UpdateButton( display, touchscreen_x, touchscreen_y, pen_is_down, &gui_main_buttons->skip_fwd_button );
  UpdateButton( display, touchscreen_x, touchscreen_y, pen_is_down, &gui_main_buttons->skip_back_button );

  // Check for pen-up events
  if(( gui_main_buttons->play_button.pen_up_event_occured ) ||
     ( gui_main_buttons->pause_button.pen_up_event_occured ) ||
     ( gui_main_buttons->skip_fwd_button.pen_up_event_occured ) ||
     ( gui_main_buttons->skip_back_button.pen_up_event_occured ))
  {
    ret_code = BUTTON_PEN_UP;
  }
  
  // Check for pen-down events
  else if(( gui_main_buttons->play_button.pen_down_event_occured ) ||
          ( gui_main_buttons->pause_button.pen_down_event_occured ) ||
          ( gui_main_buttons->skip_fwd_button.pen_down_event_occured ) ||
          ( gui_main_buttons->skip_back_button.pen_down_event_occured ))
  {
    ret_code = BUTTON_PEN_DOWN;
  }

  // Check for selected buttons
  else if(( gui_main_buttons->play_button.is_selected ) ||
          ( gui_main_buttons->pause_button.is_selected ) ||
          ( gui_main_buttons->skip_fwd_button.is_selected ) ||
          ( gui_main_buttons->skip_back_button.is_selected ))
  {
    ret_code = BUTTON_SELECTED;
  }
  
  else
  {
    ret_code = BUTTON_NOT_SELECTED;
  }  
  
  return( ret_code );
}    

/*****************************************************************************
 *  Function: vid_print_string_alpha_max_x
 *
 *  Purpose: 
 * 
 *  Returns: 0
 ****************************************************************************/
int vid_print_string_alpha_max_x( int horiz_offset, 
                                  int vert_offset, 
                                  int max_x,
                                  int color, 
                                  int background_color, 
                                  struct abc_font_struct font[], 
                                  alt_video_display * display, 
                                  char string[] )
{
  int i;
  char temp_string[256];
  
  strcpy( temp_string, string );
  
  for( i = strlen( string ) - 1; i > 0; i-- )
  {
    if( vid_string_pixel_length_alpha( font, temp_string ) > max_x )
    {
      temp_string[i] = 0x0;
    }
    else
    {
      break;
    }
  }
   
  vid_print_string_alpha( horiz_offset, vert_offset,
                          color, background_color, 
                          font, display, 
                          temp_string );
  return (0);
}

/*****************************************************************************
 *  Function: vid_print_string_alpha_prerendered
 *
 *  Purpose: 
 * 
 *  Returns: 0
 ****************************************************************************/
int vid_print_string_alpha_prerendered( int horiz_offset, 
                                        int vert_offset,
//                                        struct abc_font_struct font[],
                                        prerendered_font* prerend_font, 
                                        alt_video_display * display, 
                                        char string[])
{
  char* temp_str_ptr;
  char* temp_pixel_ptr;
  char* start_ptr;
  char* dest_ptr;
  struct abc_font_struct *font = prerend_font->font;

  temp_str_ptr = string;
  start_ptr = display->buffer_ptrs[display->buffer_being_written]->buffer + (horiz_offset * 4) + (vert_offset * display->width * 4 );
  dest_ptr = start_ptr;
  while( *temp_str_ptr != 0x0 )
  {
    // Make sure it's a legal character
    if( *temp_str_ptr >= 33 && *temp_str_ptr <= 126 )
    {
      CopyImageToBuffer( dest_ptr,
                         prerend_font->chars[*temp_str_ptr-33],
                         display->width,
                         font[*temp_str_ptr-33].bounds_width,
                         font[*temp_str_ptr-33].bounds_height );
      dest_ptr += (font[*temp_str_ptr-33].bounds_width * 4);
    }
    // or a Space
    else if( *temp_str_ptr == ' ' )
    {
      // advance the width of the '-' character.
      dest_ptr += (font['-' - 33].bounds_width * 4);
    }
//    else if( *temp_str_ptr == '\t' )
//    {
//      for( temp_pixel_ptr = start_ptr; temp_pixel_ptr <= dest_ptr; temp_pixel_ptr += ( AS_TAB_SPACES * 4 * font['-' - 33].bounds_width ));
//      dest_ptr = temp_pixel_ptr; 
//    }
    // Otherwise, print a '.'
    else
    {
      CopyImageToBuffer( dest_ptr,
                         prerend_font->chars['.' - 33],
                         display->width,
                         font['.' - 33].bounds_width,
                         font['.' - 33].bounds_height );
      dest_ptr += (font['.' - 33].bounds_width * 4);
    }
    temp_str_ptr++;                              
  }
  return( 0 );
}

/*****************************************************************************
 *  Function: vid_print_string_alpha_max_x
 *
 *  Purpose: 
 * 
 *  Returns: 0
 ****************************************************************************/
int vid_print_string_alpha_prerendered_max_x( int horiz_offset, 
                                              int vert_offset, 
                                              int max_x,
//                                              struct abc_font_struct font[],
                                              prerendered_font* prerend_font, 
                                              alt_video_display * display, 
                                              char string[] )
{
  int i;
  char temp_string[256];
  struct abc_font_struct *font = prerend_font->font;
    
  strcpy( temp_string, string );
  
  for( i = strlen( string ) - 1; i > 0; i-- )
  {
    if( vid_string_pixel_length_alpha( font, temp_string ) > max_x )
    {
      temp_string[i] = 0x0;
    }
    else
    {
      break;
    }
  }
   
  vid_print_string_alpha_prerendered( horiz_offset, 
                                      vert_offset,
//                                      font, 
                                      prerend_font, 
                                      display, 
                                      temp_string );

  return (0);
}

/*****************************************************************************
 *  Function: PrerenderFonts
 *
 *  Purpose: Prerenders a font so that it can be displayed more quickly.
 * 
 *  Returns: 0
 ****************************************************************************/
void PrerenderFonts( void )
{  
  PrerenderFont( arialroundedmtbold_58, &time_font,              0x007AB8, 0x0 );
  PrerenderFont( arial_28,              &now_playing_label_font, 0xc5c6c8, 0x0 );  
  PrerenderFont( arialbold_28,          &now_playing_value_font,  0xc5c6c8, 0x0 );  
  PrerenderFont( arial_24,              &playlist_font_gray,     0x858688, 0x0 );  
  PrerenderFont( arial_24,              &playlist_font_white,    0xffffff, 0x0 );  
}

/*****************************************************************************
 *  Function: PrerenderFont
 *
 *  Purpose: Prerenders a font so that it can be displayed more quickly.
 * 
 *  Returns: 0
 ****************************************************************************/
int PrerenderFont( struct abc_font_struct font[],
                   prerendered_font* pre_font,
                   int fg_color,
                   int bg_color )
{
  
  int i;

  // We're going to use the video library functions to render this, and
  // since those functions expect an alt_video_display type to which to write,
  // we create a small temporary one here and fill it out just enough to draw 
  // to it.
  alt_video_display* temp_buffer;

  pre_font->font = font;
  
  temp_buffer = (alt_video_display*) malloc(sizeof (alt_video_display));
  temp_buffer->color_depth = 32;
  temp_buffer->num_frame_buffers = 1;  
  temp_buffer->bytes_per_pixel = ( 4 );
  temp_buffer->buffer_being_written = 0;
  temp_buffer->buffer_ptrs[0] = (alt_video_frame*) malloc( sizeof( alt_video_frame ));

  for( i = 0; i < 94; i++ )
  {
    temp_buffer->width = font[i].bounds_width ;
    temp_buffer->height = font[i].bounds_height;
    temp_buffer->bytes_per_frame = (( temp_buffer->width * temp_buffer->height ) * 4 );
    temp_buffer->buffer_ptrs[0]->buffer = (void*) malloc( temp_buffer->bytes_per_frame );
    vid_print_char_alpha ( 0, 0, fg_color, i + 33, bg_color, font, temp_buffer );
    pre_font->chars[i] = temp_buffer->buffer_ptrs[0]->buffer;
  }
  
  free( temp_buffer->buffer_ptrs[0] );
  free( temp_buffer );

  return( 0 );
}


/*****************************************************************************
 *  Function: DisplayPlayTime
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
void DisplayPlayTime( player_struct* player, alt_video_display* display )
{
  player_state_struct* player_state = player->player_state;  
  gui_struct* gui = player->gui;  
  
  static int last_total_seconds = -1;
  static int last_bin_pct_played = -1;
  int bin_pct_played;
  int minutes_played, seconds_played;
  int total_seconds = player_state->samples_played_this_song / 44100;
  char timestring[16];
  int i;

  if( total_seconds != last_total_seconds )
  {
    seconds_played = total_seconds % 60;
    minutes_played = total_seconds / 60;
    sprintf( timestring, "%2.2d:%2.2d", minutes_played, seconds_played );

    bin_pct_played = (( player->playlist->now_playing->file_position - 
                    player->playlist->now_playing->length_of_id3v2_tag ) * 128 ) /
                  ( player->playlist->now_playing->file_length - 
                    player->playlist->now_playing->length_of_id3v2_tag );
    
    for( i = 0; i < display->num_frame_buffers; i++ )
    {
      while ( alt_video_display_buffer_is_available( display ) != 0 );

      // Clear Screen
      vid_draw_box ( 36, 56, 210, 140, 0x0, DO_FILL, display_global );    
    
      vid_print_string_alpha_prerendered( 44, 
                                          56,
//                                          arialroundedmtbold_58,
                                          &time_font, 
                                          display, 
                                          timestring );

      vid_draw_box ( 44, 126, 
                     44 + 160, 130,
                     0x858688, DO_FILL, display_global );  
      vid_draw_box ( 44, 126, 
                     44 + (( bin_pct_played * 160 ) / 128 ), 130, 
                     0xc5c6c8, DO_FILL, display_global );
      vid_draw_circle( 44 + (( bin_pct_played * 160 ) / 128 ), 128, 
                       6, 0x007AB8, DO_FILL, display );              
    
      alt_video_display_register_written_buffer( display );
    }    

    last_total_seconds = total_seconds;
    last_bin_pct_played = bin_pct_played;
  }
}

/*****************************************************************************
 *  Function: CoordsAreWithinCoords
 *
 *  Purpose:
 * 
 *  Returns: 
 ****************************************************************************/
int CoordsAreWithinBox( int touchscreen_x,
                        int touchscreen_y,
                        int pen_is_down,
                        int x_start, int y_start,
                        int x_end, int y_end )
{
  if(( pen_is_down ) && 
     ( touchscreen_x >= x_start ) &&
     ( touchscreen_x <= x_end ) &&
     ( touchscreen_y >= y_start ) &&
     ( touchscreen_y <= y_end ))
  {
    return( 1 );
  }
  else
  {
    return( 0 );
  }

}

/*****************************************************************************
 *  Function: UpdatePlayTime
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
int UpdatePlayTime( player_struct* player, 
                    int touchscreen_x,
                    int touchscreen_y,
                    int pen_is_down,
                    alt_video_display* display )
{
  player_state_struct* player_state = player->player_state;  
  
  int x_value, bin_pct, audio_data_length, desired_file_pos;
  
  if( CoordsAreWithinBox( touchscreen_x, touchscreen_y, pen_is_down, 
                          44, 120, 44 + 160, 136 ))
  {
    x_value = touchscreen_x - 44;
    bin_pct = ( x_value * 128 ) / 160;
    audio_data_length =( player->playlist->now_playing->file_length - 
                         player->playlist->now_playing->length_of_id3v2_tag );
    desired_file_pos = (( bin_pct * audio_data_length ) / 128 ) + 
                          player->playlist->now_playing->length_of_id3v2_tag;
    
    player->playlist->now_playing->file_position = desired_file_pos;
    player_state->samples_played_this_song = 
        ( bin_pct * player->playlist->now_playing->total_samples ) / 128;

  }
  DisplayPlayTime( player, display );
}
                      
                      


/*****************************************************************************
 *  Function: CoordsAreOnPlaylist
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
int CoordsAreOnPlaylist ( int touchscreen_x, int touchscreen_y, int pen_is_down, gui_playlist_struct* playlist_gui, int num_files )
{
  int num_displayed, line_height;
  
  if( num_files < playlist_gui->num_displayed_at_once  )
    num_displayed = num_files;
  else
    num_displayed = playlist_gui->num_displayed_at_once;
  
  line_height = playlist_gui->selected_font->font['A'].bounds_height;
  
  if(( pen_is_down ) && 
     ( touchscreen_x > playlist_gui->loc_x ) &&
     ( touchscreen_x < playlist_gui->loc_x + playlist_gui->size_x ) &&
     ( touchscreen_y > playlist_gui->loc_y ) &&
     ( touchscreen_y < playlist_gui->loc_y + ( num_displayed * line_height )))
  {
    return( 1 );
  }
  else
  {
    return( 0 );
  }
}

/*****************************************************************************
 *  Function: CoordsAreOnScrollBulb
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
int CoordsAreOnScrollBulb ( int touchscreen_x, int touchscreen_y, int pen_is_down, 
                            gui_simple_vertical_scroll_bar_struct* scroll  )
{
  int half_bulb_height = scroll->bulb_height / 2;
  int scroll_y_absolute = scroll->loc_y + scroll->current_scroll_y;
  
  if(( pen_is_down ) && 
     ( touchscreen_x > scroll->loc_x ) &&
     ( touchscreen_x < scroll->loc_x + scroll->size_x ) &&
     ( touchscreen_y > ( scroll_y_absolute - half_bulb_height )) &&
     ( touchscreen_y < ( scroll_y_absolute + half_bulb_height )))
  {
    return( 1 );
  }
  else
  {
    return( 0 );
  }
}

/*****************************************************************************
 *  Function: CoordsAreOnScroll
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
int CoordsAreOnScroll ( int touchscreen_x, int touchscreen_y, int pen_is_down, 
                        gui_simple_vertical_scroll_bar_struct* scroll  )
{

  if(( pen_is_down ) && 
     ( touchscreen_x > scroll->loc_x ) &&
     ( touchscreen_x < scroll->loc_x + scroll->size_x ) &&
     ( touchscreen_y > scroll->loc_y ) &&
     ( touchscreen_y < scroll->loc_y + scroll->size_y ))
  {
    return( 1 );
  }
  else
  {
    return( 0 );
  }
}

#define REFERENCE_POSITION  0
#define SCROLL_POSITION     1

/*****************************************************************************
 *  Function: CalculateScrollBulbCoords
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
void CalculateScrollBulbCoords( gui_simple_vertical_scroll_bar_struct* scroll,
                                int* bulb_start_y, int* bulb_end_y, int bulb_type )
{
  int bulb_height, bulb_pos;
  int bulb_center, bulb_min_y, bulb_max_y;
    
  if( bulb_type == SCROLL_POSITION )
  {
    bulb_height = scroll->bulb_height;
    bulb_center = scroll->current_scroll_y;
  }
  else if( bulb_type == REFERENCE_POSITION )
  {
    bulb_height = scroll->reference_bulb_height;
    bulb_center = scroll->reference_scroll_y;
  }
  else
  {
    return;
  }
  
//  bulb_center = ( position * scroll->size_y ) / scroll->total_scroll_positions;
  
//  bulb_swing = scroll->size_y - bulb_height;
//  bulb_pos = ( position * bulb_swing ) / scroll->total_scroll_positions;
  bulb_pos = bulb_center - ( bulb_height / 2 );
  bulb_min_y = 0;
  bulb_max_y = ( scroll->size_y - bulb_height ) - 1;

  if( bulb_pos < bulb_min_y )
  {
    bulb_pos = bulb_min_y;
  }
  else if( bulb_pos > bulb_max_y )
  {
    bulb_pos = bulb_max_y;
  }    
  
  *bulb_start_y = scroll->loc_y + bulb_pos;
  *bulb_end_y = *bulb_start_y + bulb_height;    
}

/*****************************************************************************
 *  Function: DisplaySimpleVertScroll
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
void DisplaySimpleVertScroll( gui_simple_vertical_scroll_bar_struct* scroll, alt_video_display* display )
{
  int vert_line_start_x, vert_line_end_x;
  int bulb_start_y, bulb_end_y;

  vert_line_start_x = scroll->loc_x + (( scroll->size_x - scroll->line_width ) / 2 );
  vert_line_end_x = vert_line_start_x + scroll->line_width;
  
  // Erase
  vid_draw_box ( scroll->loc_x, scroll->loc_y, 
                 scroll->loc_x + scroll->size_x,
                 scroll->loc_y + scroll->size_y, 
                 0x0, DO_FILL, display );  


  if( scroll->display_reference_bulb )
  {
    // Reference bulb
    CalculateScrollBulbCoords( scroll, &bulb_start_y, &bulb_end_y, REFERENCE_POSITION );
    vid_draw_box ( scroll->loc_x, 
                   bulb_start_y, 
                   scroll->loc_x + scroll->size_x, 
                   bulb_end_y, 
                   0xFFFFFF, 
                   DO_FILL, 
                   display );
  }

  // Vertical line
  vid_draw_box ( vert_line_start_x, 
                 scroll->loc_y, 
                 vert_line_end_x, 
                 scroll->loc_y + scroll->size_y, 
                 0x858688, 
                 DO_FILL, 
                 display );

  // Position bulb
  CalculateScrollBulbCoords( scroll, &bulb_start_y, &bulb_end_y, SCROLL_POSITION );
  vid_draw_round_corner_box ( scroll->loc_x, 
                              bulb_start_y, 
                              scroll->loc_x + scroll->size_x, 
                              bulb_end_y, 
                              3, 
                              0x858688, 
                              DO_FILL, 
                              display );
                              
}

/*****************************************************************************
 *  Function: InitializePlaylistGUI
 *
 *  Purpose: 
 * 
 *  Returns: void
 ****************************************************************************/
void InitializePlaylistGUI( player_struct* player )
{
  extern struct gimp_image_struct gimp_image_edit_pressed;
  extern struct gimp_image_struct gimp_image_edit_not_pressed;
  extern struct gimp_image_struct gimp_image_random_pressed;
  extern struct gimp_image_struct gimp_image_random_not_pressed;
  extern struct gimp_image_struct gimp_image_repeat_pressed;
  extern struct gimp_image_struct gimp_image_repeat_not_pressed;
    
  gui_struct* gui = player->gui;
  gui_playlist_struct* playlist_gui = &player->gui->gui_main_playlist;
  player_state_struct* player_state = player->player_state;
  playlist_struct* playlist = player->playlist;
    
  playlist_gui->loc_x =  PLAYLIST_GUI_LIST_X;
  playlist_gui->loc_y =  PLAYLIST_GUI_LIST_Y;
  playlist_gui->size_x = PLAYLIST_GUI_LIST_SIZE_X;
  playlist_gui->size_y = PLAYLIST_GUI_LIST_SIZE_Y;
  
  playlist_gui->unselected_font = &playlist_font_gray;
  playlist_gui->selected_font = &playlist_font_white;
  playlist_gui->num_displayed_at_once = PLAYLIST_GUI_NUM_DISPLAYED;
  playlist_gui->is_selected = 0;
  playlist_gui->pen_down_event_occured = 0;
  playlist_gui->pen_up_event_occured = 0;
  playlist_gui->top_displayed_playlist_node = playlist->list_start;
                
  playlist_gui->scroll.loc_x = PLAYLIST_GUI_SCROLL_X;
  playlist_gui->scroll.loc_y = PLAYLIST_GUI_SCROLL_Y;
  playlist_gui->scroll.size_x = PLAYLIST_GUI_SCROLL_SIZE_X;
  playlist_gui->scroll.size_y = PLAYLIST_GUI_SCROLL_SIZE_Y;
  playlist_gui->scroll.line_width = PLAYLIST_GUI_SCROLL_LINE_SIZE;
  playlist_gui->scroll.displayed_at_once = playlist_gui->num_displayed_at_once;
  
  playlist_gui->scroll.display_reference_bulb = 1;
  
  SetTotalScrollItems( &playlist_gui->scroll, playlist->num_files );
  SetCurrentScrollIndex( &playlist_gui->scroll, 0 );

  PrerenderButton( &playlist_gui->edit_button, 
                   &gimp_image_edit_not_pressed, 
                   &gimp_image_edit_pressed, 
                   BUTTON_TYPE_MOMENTARY );
  playlist_gui->edit_button.loc_x = ( PLAYLIST_GUI_LIST_X - 5 );
  playlist_gui->edit_button.loc_y = PLAYLIST_GUI_LIST_Y + PLAYLIST_GUI_LIST_SIZE_Y + 16;
  playlist_gui->edit_button.needs_refresh = 1;
  playlist_gui->edit_button.pen_up_event_occured = 0;
  playlist_gui->edit_button.pen_down_event_occured = 0;
  playlist_gui->edit_button.is_selected = 0;
    
  PrerenderButton( &playlist_gui->random_button, 
                   &gimp_image_random_not_pressed, 
                   &gimp_image_random_pressed, 
                   BUTTON_TYPE_ON_OFF );
  playlist_gui->random_button.loc_x = ( playlist_gui->edit_button.loc_x + 
                                        playlist_gui->edit_button.size_x )
                                        - 5;
  playlist_gui->random_button.loc_y = PLAYLIST_GUI_LIST_Y + PLAYLIST_GUI_LIST_SIZE_Y + 16;
  playlist_gui->random_button.state = BUTTON_STATE_OFF;
  playlist_gui->random_button.needs_refresh = 1;
  playlist_gui->random_button.pen_up_event_occured = 0;
  playlist_gui->random_button.pen_down_event_occured = 0;
  playlist_gui->random_button.is_selected = 0;

  PrerenderButton( &playlist_gui->repeat_button, 
                   &gimp_image_repeat_not_pressed, 
                   &gimp_image_repeat_pressed, 
                   BUTTON_TYPE_ON_OFF );
  playlist_gui->repeat_button.loc_x = ( playlist_gui->random_button.loc_x + 
                                        playlist_gui->random_button.size_x )
                                        - 5;
  playlist_gui->repeat_button.loc_y = PLAYLIST_GUI_LIST_Y + PLAYLIST_GUI_LIST_SIZE_Y + 16;
  playlist_gui->repeat_button.state = BUTTON_STATE_OFF;
  playlist_gui->repeat_button.needs_refresh = 1;
  playlist_gui->repeat_button.pen_up_event_occured = 0;
  playlist_gui->repeat_button.pen_down_event_occured = 0;
  playlist_gui->repeat_button.is_selected = 0;

  if( player_state->sequence_mode == MP3_RANDOM )
  {
    gui->gui_main_playlist.random_button.state = BUTTON_STATE_ON;
    gui->gui_main_playlist.random_button.needs_refresh = 1;
  }
  else
  {
    gui->gui_main_playlist.random_button.state = BUTTON_STATE_OFF;
    gui->gui_main_playlist.random_button.needs_refresh = 1;
  }
    
  if( player_state->repeat_playlist == MP3_REPEAT )
  {
    gui->gui_main_playlist.repeat_button.state = BUTTON_STATE_ON;
    gui->gui_main_playlist.repeat_button.needs_refresh = 1;
  }
  else
  {
    gui->gui_main_playlist.repeat_button.state = BUTTON_STATE_OFF;
    gui->gui_main_playlist.repeat_button.needs_refresh = 1;
  }  
}   

/*****************************************************************************
 *  Function: SetTotalScrollItems
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
void SetTotalScrollItems( gui_simple_vertical_scroll_bar_struct* scroll, int num_items )
{
  scroll->total_scroll_positions = ( num_items - scroll->displayed_at_once ) + 1;
  scroll->total_scroll_items = num_items;
//  scroll->bulb_height = ( scroll->displayed_at_once * scroll->size_y ) / scroll->total_scroll_positions;
  scroll->bulb_height = ( scroll->displayed_at_once * scroll->size_y ) / scroll->total_scroll_items;
  scroll->reference_bulb_height = scroll->size_y / scroll->total_scroll_items;
  
  if( scroll->reference_bulb_height < 2 )
  {
    scroll->reference_bulb_height = 2;
  }
}


/*****************************************************************************
 *  Function: SetCurrentScrollIndex
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
void SetCurrentScrollIndex( gui_simple_vertical_scroll_bar_struct* scroll, int index )
{
  scroll->current_scroll_y = (( index * ( scroll->size_y - scroll->bulb_height )) / 
                                scroll->total_scroll_positions ) + ( scroll->bulb_height / 2 );
}


/*****************************************************************************
 *  Function: SetReferenceScrollIndex
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
void SetReferenceScrollIndex( gui_simple_vertical_scroll_bar_struct* scroll, int index )
{
  scroll->reference_scroll_y = (( index * ( scroll->size_y - scroll->reference_bulb_height )) / 
                                ( scroll->total_scroll_items - 1 )) + ( scroll->reference_bulb_height / 2 );
}


/*****************************************************************************
 *  Function: ScrollPlaylistToIndex
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
void ScrollPlaylistToIndex( playlist_struct* playlist, gui_playlist_struct* playlist_gui, int position )
{
  int i;
  playlist_node_struct* current_node = playlist->list_start;
  
  for( i = 0; i < position; i++ )
  {
    current_node = current_node->next;  
  }
  playlist_gui->top_displayed_playlist_node = current_node;
}


/*****************************************************************************
 *  Function: CalculateScrollIndex
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
int CalculateScrollIndex( gui_simple_vertical_scroll_bar_struct* scroll )
{
  int scroll_index;
  int bulb_height = scroll->bulb_height;
  
  if( scroll->current_scroll_y <= (( bulb_height + 1 ) / 2 ))
  {
    scroll_index = 0;
  }
  else if( scroll->current_scroll_y >= ( scroll->size_y - (( bulb_height + 1 ) / 2 )))
  {
    scroll_index = scroll->total_scroll_positions - 1;
  }
  else
  {
    scroll_index = (( scroll->current_scroll_y - (( bulb_height + 1 ) / 2 )) * scroll->total_scroll_positions ) /
                    ( scroll->size_y - bulb_height );
  }

//  printf( "y = %d/%d, i = %d/%d\n", scroll->current_scroll_y, scroll->size_y, scroll_index, scroll->total_scroll_positions );  
  return( scroll_index );
}

/*****************************************************************************
 *  Function: UpdatePlaylistScroll
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
int UpdatePlaylistScroll( playlist_struct* playlist, 
                          gui_playlist_struct* playlist_gui, 
                          int touchscreen_x,
                          int touchscreen_y,
                          int pen_is_down )
{
  int scroll_index;
  int scroll_pixels_per_page, new_scroll_y, total_pixel_height;
  int coords_are_now_on_scroll, coords_are_now_on_bulb;
  int skip_scroll_calc = 0;
  static int last_coords_were_on_bulb = 0;
  static int last_coords_were_on_scroll = 0;
  
  coords_are_now_on_bulb = CoordsAreOnScrollBulb( touchscreen_x, touchscreen_y, pen_is_down, &playlist_gui->scroll );
  coords_are_now_on_scroll = CoordsAreOnScroll( touchscreen_x, touchscreen_y, pen_is_down, &playlist_gui->scroll );
  
  if( last_coords_were_on_bulb )
  {
    if( coords_are_now_on_scroll )
    {
      new_scroll_y = touchscreen_y - playlist_gui->scroll.loc_y;
    }
    else
    {
      skip_scroll_calc = 1;
    }      
    last_coords_were_on_bulb = coords_are_now_on_scroll;
  }
  else if( coords_are_now_on_bulb && !last_coords_were_on_scroll )
  {
    new_scroll_y = touchscreen_y - playlist_gui->scroll.loc_y;
    last_coords_were_on_bulb = 1;
//printf( "DEBUG: new_scroll_y = %d, current_scroll_y = %d\n", new_scroll_y, playlist_gui->scroll.current_scroll_y );    
  }
  else if( coords_are_now_on_scroll )
  {
    last_coords_were_on_scroll = 1;
    total_pixel_height = playlist->num_files * playlist_gui->unselected_font->font['A'].bounds_height;
    scroll_pixels_per_page = ( playlist_gui->unselected_font->font['A'].bounds_height * 
                               ( playlist_gui->scroll.displayed_at_once - 1 ) * ( playlist_gui->size_y - playlist_gui->scroll.bulb_height)) /
                                 total_pixel_height;
   
    new_scroll_y = touchscreen_y - playlist_gui->scroll.loc_y;                               

//printf( "DEBUG: scroll_pixels_per_page = %d, new_scroll_y = %d, current_scroll_y = %d\n", scroll_pixels_per_page, new_scroll_y, playlist_gui->scroll.current_scroll_y );  

    // Scrolls a max of one page at a time.
    if( new_scroll_y > ( playlist_gui->scroll.current_scroll_y + scroll_pixels_per_page ))
    {
      new_scroll_y = playlist_gui->scroll.current_scroll_y + scroll_pixels_per_page;
    }
    else if( new_scroll_y < ( playlist_gui->scroll.current_scroll_y - scroll_pixels_per_page ))
    {
      new_scroll_y = playlist_gui->scroll.current_scroll_y - scroll_pixels_per_page;
    }
  }
  else
  {
    last_coords_were_on_scroll = 0;
    skip_scroll_calc = 1;
  }
  
  if( !skip_scroll_calc )
  {
    playlist_gui->scroll.current_scroll_y = new_scroll_y;
    scroll_index = CalculateScrollIndex( &playlist_gui->scroll );
    ScrollPlaylistToIndex( playlist, playlist_gui, scroll_index );
  }

  return( 0 );
}

/*****************************************************************************
 *  Function: DisplayPlaylist
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
int DisplayPlaylist( player_struct* player, 
                     alt_video_display* display ) 
{
  playlist_struct* playlist = player->playlist;
  gui_playlist_struct* playlist_gui = &player->gui->gui_main_playlist;
                       
  int i, j;
  int num_to_display;
  playlist_node_struct* item_being_displayed;
  static playlist_node_struct* last_playing = NULL;
  prerendered_font* font;
  static int last_playlist_item_selected = -1;
  static int last_scroll_y = -1;
  
  if(( playlist->now_playing != last_playing ) || 
     ( playlist_gui->playlist_item_selected != last_playlist_item_selected ) ||
     ( playlist_gui->scroll.current_scroll_y != last_scroll_y ))
  {
    for( i = 0; i < display->num_frame_buffers; i++ )
    {
      while( alt_video_display_buffer_is_available( display ));
      
      item_being_displayed = playlist_gui->top_displayed_playlist_node;
  
      // Erase
      vid_draw_box ( playlist_gui->loc_x, playlist_gui->loc_y, 
                     playlist_gui->loc_x + playlist_gui->size_x,
                     playlist_gui->loc_y + playlist_gui->size_y, 
                     0x0, DO_FILL, display );  
                       
      if( playlist->num_files < playlist_gui->num_displayed_at_once  )
        num_to_display = playlist->num_files;
      else
        num_to_display = playlist_gui->num_displayed_at_once;
      
      for( j = 0; j < num_to_display; j++ )
      {
        if ( j == playlist_gui->playlist_item_selected )
          font =  playlist_gui->selected_font;        
        else if( item_being_displayed == playlist->now_playing )
          font =  playlist_gui->selected_font;
        else
          font = playlist_gui->unselected_font;
        
        vid_print_string_alpha_prerendered( playlist_gui->loc_x, 
                                            playlist_gui->loc_y + ( j * font->font['A'].bounds_height ),
                                            font,
                                            display, 
                                            item_being_displayed->track );
        
        vid_print_string_alpha_prerendered_max_x( playlist_gui->loc_x + 50,
                                                  playlist_gui->loc_y + ( j * font->font['A'].bounds_height ),
                                                  playlist_gui->size_x - 50, 
                                                  font,
                                                  display, 
                                                  item_being_displayed->title );
  
        item_being_displayed = item_being_displayed->next;
      }
      
      if( playlist->num_files > playlist_gui->scroll.displayed_at_once )
      {
        DisplaySimpleVertScroll( &playlist_gui->scroll, display );
      }
      
      alt_video_display_register_written_buffer( display );
    }
    last_playing = playlist->now_playing;
    last_scroll_y = playlist_gui->scroll.current_scroll_y;
  }
  
  last_playlist_item_selected = playlist_gui->playlist_item_selected;
  
  return( 0 );
}

/*****************************************************************************
 *  Function: GetPointerToRelativePlaylistNode
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
playlist_node_struct* GetPointerToRelativePlaylistNode( playlist_node_struct* start_node, int index )
{
  int i = 0;
  playlist_node_struct* node = start_node;
  
  for( i = 0;i < index; i++ )
  {
    node = node->next;
  }
  
  return( node );
}


/*****************************************************************************
 *  Function: UpdatePlaylist
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
int UpdatePlaylist( player_struct* player,
                    int touchscreen_x,
                    int touchscreen_y,
                    int pen_is_down,
                    alt_video_display* display )
{
  playlist_struct* playlist = player->playlist;
  gui_playlist_struct* playlist_gui = &player->gui->gui_main_playlist;
   
  int ret_code = MAD_FLOW_CONTINUE;

  UpdatePlaylistScroll( playlist, playlist_gui, touchscreen_x, 
                        touchscreen_y, pen_is_down );


  if( CoordsAreOnPlaylist ( touchscreen_x, touchscreen_y, pen_is_down, 
                            playlist_gui, playlist->num_files ))
  {
    // Pen is now on playlist now, but wasn't last time (pen-down event)
    if( playlist_gui->is_selected == 0 )
    {
      playlist_gui->is_selected = 1;
      playlist_gui->pen_down_event_occured = 1;
      playlist_gui->pen_up_event_occured = 0;
    }
    else
    {
      playlist_gui->pen_down_event_occured = 0;
      playlist_gui->pen_up_event_occured = 0;
    }
    
    playlist_gui->playlist_item_selected = ( touchscreen_y - playlist_gui->loc_y ) / 
                                           playlist_gui->selected_font->font['A'].bounds_height;    
  }
  else
  {
    // Pen is not on button now, but was last time = pen-up event
    if( playlist_gui->is_selected == 1 )
    {
      playlist_gui->is_selected = 0;
      playlist_gui->pen_down_event_occured = 0;
      // A pen up only occured if... well... the pen is up.
      // If we dont do this test, we could trigger a false pen up 
      // on the button if the user just slid the pen off.
      if( pen_is_down == 0 )
      {
        playlist_gui->pen_up_event_occured = 1;
        playlist_gui->command = COMMAND_SKIP_SPECIFIC;
        playlist_gui->command_target = GetPointerToRelativePlaylistNode( playlist_gui->top_displayed_playlist_node, 
                                                                         playlist_gui->playlist_item_selected );  
        ret_code = MAD_FLOW_STOP;
      }
      else
      {
        playlist_gui->pen_up_event_occured = 0;
      }
    }
    else
    {
      playlist_gui->pen_down_event_occured = 0;
      playlist_gui->pen_up_event_occured = 0;
    }
    
    playlist_gui->playlist_item_selected = -1; // -1 indicates no item selected
  }
  
  DisplayPlaylist( player, display ) ;
  

  return( ret_code );
}
  
/*****************************************************************************
 *  Function: InitializeNowPlayingGUI
 *
 *  Purpose: 
 * 
 *  Returns: void
 ****************************************************************************/
void InitializeNowPlayingGUI( player_struct* player )
{
  gui_now_playing_struct* now_playing_gui = &player->gui->gui_now_playing;
  
  now_playing_gui->loc_x = 230;
  now_playing_gui->loc_y = 62;
  now_playing_gui->size_x = 520;
  now_playing_gui->size_y = 68;
  now_playing_gui->label_font = &now_playing_label_font;
  now_playing_gui->value_font = &now_playing_value_font;
  now_playing_gui->num_displayed_at_once = 2;
  now_playing_gui->scroll_index = 0;
                
  now_playing_gui->scroll.loc_x = 760;
  now_playing_gui->scroll.loc_y = now_playing_gui->loc_y;
  now_playing_gui->scroll.size_x = 22;
  now_playing_gui->scroll.size_y = now_playing_gui->size_y - 6;
  now_playing_gui->scroll.line_width = 6;
  now_playing_gui->scroll.displayed_at_once = now_playing_gui->num_displayed_at_once;
  
  now_playing_gui->scroll.display_reference_bulb = 0;
  
  SetTotalScrollItems( &now_playing_gui->scroll, 9 );
  SetCurrentScrollIndex( &now_playing_gui->scroll, 0 );
}

/*****************************************************************************
 *  Function: DisplayNowPlayingElements
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
void DisplayNowPlayingElements( char* label_1, char* value_1, 
                                char* label_2, char* value_2,
                                gui_now_playing_struct* now_playing_gui, 
                                alt_video_display* display )
{
  // 1
  vid_print_string_alpha_prerendered( now_playing_gui->loc_x,
                                      now_playing_gui->loc_y,
                                      now_playing_gui->label_font,
                                      display, 
                                      label_1 );

  vid_print_string_alpha_prerendered_max_x( now_playing_gui->loc_x + 110,
                                            now_playing_gui->loc_y, 
                                            now_playing_gui->size_x - 110, 
                                            now_playing_gui->value_font,
                                            display, 
                                            value_1 );
  // 2
  vid_print_string_alpha_prerendered( now_playing_gui->loc_x,
                                      now_playing_gui->loc_y + 36,
                                      now_playing_gui->label_font,
                                      display, 
                                      label_2 );

  vid_print_string_alpha_prerendered_max_x( now_playing_gui->loc_x + 110,
                                            now_playing_gui->loc_y + 36, 
                                            now_playing_gui->size_x - 110, 
                                            now_playing_gui->value_font,
                                            display, 
                                            value_2 );
}

  
/*****************************************************************************
 *  Function: DisplayNowPlaying
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
void DisplayNowPlaying( player_struct* player, 
                        alt_video_display* display )
{
  playlist_node_struct* now_playing = player->playlist->now_playing; 
  gui_now_playing_struct* now_playing_gui = &player->gui->gui_now_playing;  

  int i;
  static playlist_node_struct* last_playing = NULL;
  static int last_scroll_y = -1;
//  int disp_title = 0;
//  char string[128];
//  int seconds;
  
  if(( last_playing != now_playing ) ||
     ( now_playing_gui->scroll.current_scroll_y != last_scroll_y ))
  {
    for( i = 0; i < display->num_frame_buffers; i++ )
    {
      while( alt_video_display_buffer_is_available( display ));

      // Clear Screen
      vid_draw_box ( now_playing_gui->loc_x,
                     now_playing_gui->loc_y, 
                     now_playing_gui->loc_x + now_playing_gui->size_x, 
                     now_playing_gui->loc_y + now_playing_gui->size_y, 
                     0x0, DO_FILL, display );    
      
      
      DisplayNowPlayingElements( now_playing_gui->display_order[now_playing_gui->scroll_index]->title, 
                                 now_playing_gui->display_order[now_playing_gui->scroll_index]->value, 
                                 now_playing_gui->display_order[now_playing_gui->scroll_index + 1]->title, 
                                 now_playing_gui->display_order[now_playing_gui->scroll_index + 1]->value,
                                 now_playing_gui, display );

      DisplaySimpleVertScroll( &now_playing_gui->scroll, display );
      
      alt_video_display_register_written_buffer( display );
    }
    last_playing = now_playing;
    last_scroll_y = now_playing_gui->scroll.current_scroll_y;
  }
}

/*****************************************************************************
 *  Function: UpdateNowPlayingScroll
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
int UpdateNowPlayingScroll( gui_now_playing_struct* now_playing_gui, 
                            int touchscreen_x,
                            int touchscreen_y,
                            int pen_is_down )
{
  int scroll_index;
  
  if( CoordsAreOnScroll( touchscreen_x, touchscreen_y, pen_is_down, &now_playing_gui->scroll ))
  {
    now_playing_gui->scroll.current_scroll_y = touchscreen_y - now_playing_gui->scroll.loc_y;
    now_playing_gui->scroll_index = CalculateScrollIndex( &now_playing_gui->scroll );
  }
  return( 0 );
}

void UpdateNowPlayingStrings( gui_now_playing_struct* gui,
                              playlist_node_struct* now_playing )
{
  int seconds;
  static gui_playlist_struct* last_playing = NULL;
  static int first_time_through = 1;
  
  if( first_time_through )
  {
    sprintf( gui->title.title, "Title:" );
    sprintf( gui->artist.title, "Artist:" );
    sprintf( gui->album.title, "Album:" );
    sprintf( gui->track.title, "Track:" );
    sprintf( gui->year.title, "Year:" );
    sprintf( gui->genre.title, "Genre:" );
    sprintf( gui->length.title, "Length:" );
    sprintf( gui->bit_rate.title, "BRate:" );
    sprintf( gui->sample_rate.title, "SRate:" );
    
    gui->display_order[0] = &gui->title;
    gui->display_order[1] = &gui->artist;
    gui->display_order[2] = &gui->album;
    gui->display_order[3] = &gui->track;
    gui->display_order[4] = &gui->year;
    gui->display_order[5] = &gui->genre;
    gui->display_order[6] = &gui->length;
    gui->display_order[7] = &gui->bit_rate;
    gui->display_order[7] = &gui->sample_rate;
       
    first_time_through = 0;
  }  
  
  if( now_playing != last_playing )
  {
    sprintf( gui->title.value, now_playing->title );
    sprintf( gui->artist.value, now_playing->artist );
    sprintf( gui->album.value, now_playing->album );
    sprintf( gui->track.value, now_playing->track );
    sprintf( gui->year.value, now_playing->year );
    sprintf( gui->genre.value, now_playing->genre );
    sprintf( gui->bit_rate.value, "%d", now_playing->bit_rate );
    sprintf( gui->sample_rate.value, "%d", now_playing->sample_rate );
    
    seconds = now_playing->total_samples / now_playing->sample_rate;
    sprintf( gui->length.value, "%d:%2.2d", seconds / 60, seconds % 60 );
  
    last_playing = now_playing;
  }
}

/*****************************************************************************
 *  Function: UpdateNowPlaying
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/

int UpdateNowPlaying( player_struct* player, 
                      int touchscreen_x,
                      int touchscreen_y,
                      int pen_is_down,
                      alt_video_display* display )
{
  player_state_struct* player_state = player->player_state;  
  gui_struct* gui = player->gui;  
    
  UpdateNowPlayingScroll( &gui->gui_now_playing, 
                          touchscreen_x,
                          touchscreen_y,
                          pen_is_down );
  
  UpdateNowPlayingStrings( &gui->gui_now_playing,
                           player->playlist->now_playing );
                            
  DisplayNowPlaying( player, display_global );
  
  return( 0 );
}   

/*****************************************************************************
 *  Function: DisplayStatusMessage
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
void DisplayStatusMessage( char* string, alt_video_display* display )
{
  int i;
  int string_pixel_length, start_x;
  
  string_pixel_length = vid_string_pixel_length_alpha( arialroundedmtbold_28, string );
  start_x = ( display->width - string_pixel_length ) / 2 ;
  
  for( i = 0; i < display->num_frame_buffers; i++ )
  {
    while ( alt_video_display_buffer_is_available( display ) != 0 );

    // Clear Screen
    vid_draw_box ( 44, 62, 770, 134, 0x0, DO_FILL, display_global );    
  
    vid_print_string_alpha( start_x, 80,
                            0xFFFFFF, //0x007AB8, 
                            CLEAR_BACKGROUND, 
                            arialroundedmtbold_28, 
                            display, 
                            string );

    alt_video_display_register_written_buffer( display );
  }    
}

/*****************************************************************************
 *  Function: ClearNowPlayingWindow
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
void ClearNowPlayingWindow( alt_video_display* display )
{
  int i;
  
  for( i = 0; i < display->num_frame_buffers; i++ )
  {
    while ( alt_video_display_buffer_is_available( display ) != 0 );

    // Clear Screen
    vid_draw_box ( 44, 62, 770, 134, 0x0, DO_FILL, display_global );    
  
    alt_video_display_register_written_buffer( display );
  }      
}

/*****************************************************************************
 *  Function: UpdateGUIMain
 *
 *  Purpose:
 * 
 *  Returns: 0
 ****************************************************************************/
int UpdateGUIMain( player_struct* player )
{
  player_state_struct* player_state = player->player_state;  
  gui_struct* gui = player->gui;  

  int pen_is_down = 0;
  int touchscreen_x, touchscreen_y;
  int ticks_at_last_pen_touch;
  unsigned int button_state = 0;
  unsigned int slider_state;
  int ret_code = MAD_FLOW_CONTINUE;
  static first_pass = 1;
  int i;
  
  // Gather the latest touchscreen coordinates
  alt_touchscreen_get_pen ( &touchscreen_global, &pen_is_down, &touchscreen_x, &touchscreen_y );

  // If there is activity on the touchscreen, reset the screensaver timeout
  if( pen_is_down )
//      ticks_at_last_pen_touch = OSTimeGet();
    ticks_at_last_pen_touch = alt_nticks();

  // Determine how the touchscreen coordinates affect the command buttons, 
  // and redraw them if neccessary.  Note that the command buttons can be
  // affected even if the touchscreen coordinates are somewhere other than on 
  // the command button, or even if the pen is up.  This is because you have to
  // redraw the buttons when the pen slides off or lifts up from them.
  button_state = UpdateMainButtons( display_global, touchscreen_x, touchscreen_y, 
                                    pen_is_down, &gui->gui_main_buttons );
  if( button_state == BUTTON_PEN_UP )
  {
    if( gui->gui_main_buttons.skip_fwd_button.pen_up_event_occured )
    {
      player_state->command = COMMAND_SKIP_FWD;
      ret_code = MAD_FLOW_STOP;
    }
    else if( gui->gui_main_buttons.skip_back_button.pen_up_event_occured )
    {
      player_state->command = COMMAND_SKIP_BACK;
      ret_code = MAD_FLOW_STOP;
    }
    else if( gui->gui_main_buttons.play_button.pen_up_event_occured )
    {
      player_state->command = COMMAND_PLAY;
      // Since pressing play can turn off pause, we need to make sure the pause button
      // gets turned off.
      gui->gui_main_buttons.pause_button.state = BUTTON_STATE_OFF;
      gui->gui_main_buttons.pause_button.needs_refresh = 1;
      ret_code = MAD_FLOW_CONTINUE;
    }
    else if( gui->gui_main_buttons.pause_button.pen_up_event_occured )
    {
      if( player_state->command == COMMAND_PAUSE )
      {
        player_state->command = COMMAND_PLAY;
        // Since pressing pause can turn on play, we need to make sure the play button
        // gets turned back on.
        gui->gui_main_buttons.play_button.state = BUTTON_STATE_ON;
        gui->gui_main_buttons.play_button.needs_refresh = 1;      
      }
      else if( player_state->command == COMMAND_PLAY )
      {
        player_state->command = COMMAND_PAUSE;
        // Since pressing pause can turn off play, we need to make sure the play button
        // gets turned off.
        gui->gui_main_buttons.play_button.state = BUTTON_STATE_OFF;
        gui->gui_main_buttons.play_button.needs_refresh = 1;
      }
    }
    else
    {
      ret_code = MAD_FLOW_CONTINUE;
    }
  }
  
  if( ret_code == MAD_FLOW_CONTINUE )
  {                             
//    printf( "DEBUG: Running UpdateSlider()\n" );
    slider_state = UpdateSlider( display_global, touchscreen_x, touchscreen_y, 
                                 pen_is_down, player_state->volume,
                                 &gui->gui_main_buttons.volume_slider );
    player_state->volume = slider_state;                    
  
    slider_state = UpdateSlider( display_global, touchscreen_x, touchscreen_y, 
                                 pen_is_down, player_state->balance,
                                 &gui->gui_main_buttons.balance_slider );
    player_state->balance = slider_state;                                                     
  
    audio_codec_set_headphone_volume( audio_codec_global, player_state->volume );
    audio_codec_set_headphone_balance( audio_codec_global, player_state->balance );

    UpdatePlayTime( player, 
                    touchscreen_x,
                    touchscreen_y,
                    pen_is_down,
                    display_global );
                    
    ret_code = UpdateNowPlaying( player, 
                                 touchscreen_x, 
                                 touchscreen_y,
                                 pen_is_down,
                                 display_global );


    ret_code = UpdatePlaylist( player, 
                               touchscreen_x, 
                               touchscreen_y,
                               pen_is_down,
                               display_global );

    // TODO: This whole playlist button group update needs to go in its own function
    UpdateButton( display_global, touchscreen_x, touchscreen_y, pen_is_down, 
                  &gui->gui_main_playlist.edit_button );

    UpdateButton( display_global, touchscreen_x, touchscreen_y, pen_is_down, 
                  &gui->gui_main_playlist.random_button );
                  
    UpdateButton( display_global, touchscreen_x, touchscreen_y, pen_is_down, 
                  &gui->gui_main_playlist.repeat_button );

    if( gui->gui_main_playlist.random_button.state == BUTTON_STATE_ON )
      player_state->sequence_mode = MP3_RANDOM;
    else
      player_state->sequence_mode = MP3_FORWARD;
                               
    if( gui->gui_main_playlist.repeat_button.state == BUTTON_STATE_ON )
      player_state->repeat_playlist = MP3_REPEAT;
    else
      player_state->repeat_playlist = MP3_NO_REPEAT;
      
    if( ret_code == MAD_FLOW_STOP )
    {
      player_state->command = gui->gui_main_playlist.command;
      player_state->command_target = gui->gui_main_playlist.command_target;
    }
  }
    
  return( ret_code ); 
}

/*****************************************************************************
 *  Function: DrawInitialScreenMain
 *
 *  Purpose: 
 * 
 *  Returns: 0
 ****************************************************************************/
void DrawInitialScreenMain( gui_main_buttons_struct* gui_main_buttons, alt_video_display* display )
{
  extern GimpImage gimp_image_altera_small;
  extern GimpImage gimp_image_prog_bar_empty;
  extern GimpImage gimp_image_prog_bar_on_10px;
  extern GimpImage gimp_image_prog_bar_on_left_10px;
  extern GimpImage gimp_image_prog_bar_on_right_10px;
  extern GimpImage gimp_image_prog_bar_on_left_right_10px;
  
  int i;
  
  for( i = 0; i < display->num_frame_buffers; i++ )
  {
    DrawWindow( 0, 0, 800, 150, "Now Playing", display );
    DrawWindow( 0, 160, 350, 250, "Playback Control", display );  
    DrawWindow( 360, 160, 440, 319, "Playlist", display );  
    
    // Altera Logo
    DisplayGimpImage( 10, 420, &gimp_image_altera_small, display );
  
    // Display Sliders
    DisplaySliders( gui_main_buttons, display );
    
    // Box around buttons

    DrawRoundCornerGradBox( SKIP_BACK_BUTTON_LOC_X - 10, 
                            SKIP_BACK_BUTTON_LOC_Y - 10, 
                            SKIP_FWD_BUTTON_LOC_X + 87 + 10, 
                            SKIP_FWD_BUTTON_LOC_Y + 56 + 10, 
                            WINDOW_CORNER_RADIUS,
                            WINDOW_END_COLOR, 
                            WINDOW_START_COLOR, 
                            WINDOW_BACKGROUND_COLOR,
                            GRAD_DOWN_RIGHT, 
                            100, 
                            display );
  
    vid_draw_round_corner_box ( SKIP_BACK_BUTTON_LOC_X - 4, 
                                SKIP_BACK_BUTTON_LOC_Y - 4, 
                                SKIP_FWD_BUTTON_LOC_X + 87 + 4, 
                                SKIP_FWD_BUTTON_LOC_Y + 56 + 4, 
                                WINDOW_CORNER_RADIUS - 6, 
                                WINDOW_BACKGROUND_COLOR, 
                                DO_FILL, 
                                display );

//    vid_draw_round_corner_box ( SKIP_BACK_BUTTON_LOC_X - 4, 
//                                SKIP_BACK_BUTTON_LOC_Y - 4, 
//                                SKIP_FWD_BUTTON_LOC_X + 87 + 4, 
//                                SKIP_FWD_BUTTON_LOC_Y + 56 + 4, 
//                                WINDOW_CORNER_RADIUS - 6, 
//                                0x0081c3, 
//                                DO_NOT_FILL, 
//                                display );    
    
    // Display Buttons
//    DisplayMainButtons( player, display );
  
    alt_video_display_register_written_buffer( display );
  }
}


  
  
  
  
  
  