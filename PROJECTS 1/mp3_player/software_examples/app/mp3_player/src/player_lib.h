#ifndef PLAYER_LIB_H
#define PLAYER_LIB_H

#include <sys/stat.h>
#include "mad.h"
#include "alt_touchscreen.h"
#include "gui.h"

/***********************************************************************
 *                                                                     *
 * File:     player_lib.h                                              *
 *                                                                     *
 * Purpose:  Contains handy info for our custom MP3 player functions.  *
 *                                                                     *
 * Author:   N. Knight                                                 *
 *           Altera Corporation                                        *
 *           Sept 2008                                                 *
 **********************************************************************/


#define MP3_FOLDER      "/MP3/media"
#define CONFIG_FOLDER   "/MP3/db"
#define SAVE_STATE_FILE "save_state.db"
#define DATABASE_FILE   "mp3_files.db"

#define AUDIO_CONTROLLER_SLAVE_PORT_CLK   ALT_CPU_FREQ

#define BCLK_FREQ                         12000000
#define XCK_FREQ                          12000000
#define DEFAULT_SAMPLING_RATE             44100 // 44k Sampling

#define SORT_ASC        0
#define SORT_DESC       1

#define FIELD_ARTIST    0
#define FIELD_ALBUM     1
#define FIELD_TRACK     2
#define FIELD_FILENAME  3

#define MAD_DITHER      0
#define NATE_DITHER     1
#define ROUND           2
#define WAV_FILE_DIRECT 3

#define OUTPUT_MODE     MAD_DITHER
#define OUTPUT_BITS     26

#define AUDIO_CODEC     0
#define WAV_FILE        1
#define OUTPUT_DEST     AUDIO_CODEC

#define COMMAND_PLAY           1
#define COMMAND_SKIP_FWD       2
#define COMMAND_SKIP_BACK      3
#define COMMAND_SKIP_SPECIFIC  4
#define COMMAND_PAUSE          5 

#define MP3_RANDOM             1
#define MP3_FORWARD            2
#define MP3_REVERSE            3

#define MP3_NO_REPEAT          1
#define MP3_REPEAT             2

#define SKIP_BACK_THRESHOLD   (3*DEFAULT_SAMPLING_RATE)

#define FILE_BUFFER_SIZE   0x1000
//#define OUTPUT_BUFFER_SIZE 0x10000
#define OUTPUT_BUFFER_SIZE 0x2400
//#define OUTPUT_BUFFER_SIZE 0x1200

typedef struct mad_decoder mad_decoder_type;

typedef struct playlist_node {
  struct playlist_node *next;
  struct playlist_node *prev;
  char* filename;
  char* title;
  char* artist;
  char* album;
  char* genre;
  char* year;
  char* track;
  char* length;
  unsigned int vbr;
  unsigned int vbr_scale;
  unsigned int version_id;
  unsigned int layer_index;
  unsigned int sample_rate;
  unsigned int bit_rate;
  unsigned int total_samples;  
  unsigned int file_length;
  unsigned int length_of_id3v2_tag;
  unsigned int file_position;
} playlist_node_struct;

typedef struct {
  playlist_node_struct* list_start;
  playlist_node_struct* now_playing;
  int num_files;
  int checksum;
} playlist_struct;

typedef struct {
  int command;
  void* command_target;
  unsigned int file_buffer_size;
  char* file_buffer;
  unsigned int sequence_mode;
  unsigned int repeat_playlist;
  int file_handle;
  int total_samples_played;
  int samples_played_this_song;
  int volume;
  int balance;
} player_state_struct;

typedef struct {
  gui_struct* gui;
  player_state_struct* player_state;
  playlist_struct* database;
  playlist_struct* playlist;
} player_struct;

// Function Prototypes
playlist_struct* NiosIIMP3_InitPlaylist( void );
int NiosIIMP3_FreePlaylist( playlist_struct* playlist );
int NiosIIMP3_ClearPlaylist( playlist_struct* playlist );
int NiosIIMP3_ResetPlaylist( playlist_struct* playlist );
void NiosIIMP3_PrintPlaylist( playlist_struct* playlist );
int AddFileToBottomOfPlaylist( char* filepath, playlist_struct* playlist );
int NiosIIMP3_AddAllFilesInDirToDatabase( char* dir, playlist_struct* playlist, int recursive );
int RemoveEntryFromPlaylist( playlist_node_struct* playlist_entry, playlist_struct* playlist );
int AddEntryToTopOfPlaylist( playlist_node_struct* playlist_entry, playlist_struct* playlist );
int CountPlaylistElements( playlist_struct* playlist );
int SeedRandomizer( void );
int RandomizePlaylist( playlist_struct* playlist );
int NiosIIMP3_PrintPlaylistToTerminal( playlist_struct* playlist );
int NiosIIMP3_PlayPlaylist( player_struct* player );
mad_decoder_type* NiosIIMP3_DecoderInit( player_state_struct* player_state );
int NiosIIMP3_DecoderStart( mad_decoder_type* decoder );
int NiosIIMP3_FillFileBuffer( player_struct* player, int file_pos_needed );
int TempAdjustVolBal( player_state_struct* player_state, alt_touchscreen* touchscreen );
int TempSwitchOutputMode( alt_touchscreen* touchscreen_global, int output_mode );
signed long audio_linear_dither_nate( unsigned int bits, mad_fixed_t sample );
int write_samples_to_wave_file( int file_handle, short* right, short* left, int num_samples );
int update_wave_file_header( int file_handle, int num_bytes );
int NiosIIMP3_ReadDatabaseFromSDCard( char* folder, char* playlist_filename, playlist_struct* playlist );
int NiosIIMP3_SaveDatabaseToSDCard( char* folder, char* playlist_filename, playlist_struct* playlist );

// Decoder callback functions
enum mad_flow NiosIIMP3_Input( void *data, struct mad_stream *stream );
enum mad_flow NiosIIMP3_Output(void *data,
         struct mad_header const *header,
         struct mad_pcm *pcm );
enum mad_flow NiosIIMP3_Error( void *data, 
                               struct mad_stream *stream, 
                               struct mad_frame *frame );



#endif /* PLAYER_LIB_H */
