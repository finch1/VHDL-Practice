
#ifndef _GUI_H_
#define _GUI_H_

#include "simple_graphics.h"
#include "fonts.h"
#include "alt_video_display.h"
#include "gimp_bmp.h"
//#include "player_lib.h"


// Gradient box types
#define GRAD_DOWN       0
#define GRAD_UP         1
#define GRAD_LEFT       2
#define GRAD_RIGHT      3
#define GRAD_DOWN_RIGHT 4
#define GRAD_DOWN_LEFT  5
#define GRAD_UP_RIGHT   6
#define GRAD_UP_LEFT    7

#define BUTTON_TYPE_MOMENTARY 0
#define BUTTON_TYPE_ON_OFF    1
#define BUTTON_TYPE_ON_ONLY   2

#define BUTTON_STATE_OFF 0
#define BUTTON_STATE_ON  1

#define SLIDER_TYPE_ACCUMULATIVE   0
#define SLIDER_TYPE_INDICATOR      1

#define GO_MAIN_SCREEN              1
#define GO_EDIT_PLAYLIST_SCREEN     2

#define MAIN_SCREEN_ACTIVE            0
#define PLAYLIST_SCREEN_ACTIVE        1



typedef struct {
  struct abc_font_struct *font;
  unsigned char* chars[94];
} prerendered_font;

typedef struct {
  unsigned int loc_x;
  unsigned int loc_y;
  unsigned int size_x;
  unsigned int size_y;
  unsigned int type;
  unsigned int state;
  unsigned int needs_refresh;
  char* button_graphic_not_pressed;
  char* button_graphic_pressed;
  unsigned int is_selected;
  unsigned int pen_down_event_occured;
  unsigned int pen_up_event_occured;
} gui_button_struct;

typedef struct {
  unsigned int loc_x;
  unsigned int loc_y;
  unsigned int size_x;
  unsigned int size_y;
  unsigned int type;
  char* slider_graphic_slice_left;
  char* slider_graphic_slice_right;
  char* slider_graphic_slice_center;
  char* slider_graphic_slice_single;
  char* slider_graphic_background_center;
  char* slider_graphic_background_left;
  char* slider_graphic_background_right;
  unsigned int slice_width;
  unsigned int pct_displayed;
//  unsigned int pen_down_event_occured;
//  unsigned int pen_up_event_occured;
} gui_slider_struct;

typedef struct {
  int loc_x;
  int loc_y;
  int size_x;
  int size_y;
  int line_width;
  int total_scroll_items;
  int total_scroll_positions;
  int displayed_at_once;
  int bulb_height;
  int current_scroll_y;
  int display_reference_bulb;
  int reference_bulb_height;
  int reference_scroll_y;
} gui_simple_vertical_scroll_bar_struct;

typedef struct {
  unsigned int loc_x;
  unsigned int loc_y;
  unsigned int size_x;
  unsigned int size_y;
  prerendered_font* unselected_font;
  prerendered_font* selected_font;
  int num_displayed_at_once;
  void* top_displayed_playlist_node;
  int playlist_item_selected;
  unsigned int is_selected;
  unsigned int pen_down_event_occured;
  unsigned int pen_up_event_occured;
  gui_simple_vertical_scroll_bar_struct scroll;
  gui_button_struct edit_button;
  gui_button_struct random_button;  
  gui_button_struct repeat_button;  
  int command;
  void* command_target;
} gui_playlist_struct;

typedef struct {
  char title[16];
  char value[128];
} gui_now_playing_item_struct;

typedef struct {
  unsigned int loc_x;
  unsigned int loc_y;
  unsigned int size_x;
  unsigned int size_y;
  prerendered_font* label_font;
  prerendered_font* value_font;
  int num_displayed_at_once;
  int scroll_index;
  gui_now_playing_item_struct title;
  gui_now_playing_item_struct artist;
  gui_now_playing_item_struct album;
  gui_now_playing_item_struct track;
  gui_now_playing_item_struct year;
  gui_now_playing_item_struct genre;
  gui_now_playing_item_struct length;
  gui_now_playing_item_struct bit_rate;
  gui_now_playing_item_struct sample_rate;
  gui_now_playing_item_struct* display_order[9];
  gui_simple_vertical_scroll_bar_struct scroll;
} gui_now_playing_struct;

typedef struct {
  gui_button_struct      play_button;
  gui_button_struct      pause_button;
  gui_button_struct      skip_fwd_button;
  gui_button_struct      skip_back_button;
  gui_slider_struct      volume_slider;
  gui_slider_struct      balance_slider;
} gui_main_buttons_struct;

typedef struct {
  gui_button_struct      add_button;
} gui_playlist_buttons_struct;


typedef struct {
  int                      active_screen;
  int                      needs_update;
  gui_main_buttons_struct  gui_main_buttons;
  gui_now_playing_struct   gui_now_playing;
  gui_playlist_struct      gui_main_playlist;
  gui_main_buttons_struct  gui_playlist_buttons;
} gui_struct;

// Function Prototypes
void PrerenderButtons( gui_main_buttons_struct* gui_main_buttons );
//int UpdateGUIInputs( player_state_struct* player_state );
void DrawInitialScreenMain( gui_main_buttons_struct* gui_main_buttons, alt_video_display* display );
void PrerenderFonts( void );
void SetTotalScrollItems( gui_simple_vertical_scroll_bar_struct* scroll, int num_items );
void SetCurrentScrollIndex( gui_simple_vertical_scroll_bar_struct* scroll, int index );
void SetReferenceScrollIndex( gui_simple_vertical_scroll_bar_struct* scroll, int index );

#endif /* _LCD_TERMINAL_WINDOW_H_ */
