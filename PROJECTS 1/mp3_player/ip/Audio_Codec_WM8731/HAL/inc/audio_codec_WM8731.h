/*****************************************************************************
*  File:    audio_codec_WM8731.h
*
*  Purpose: Header file info for the WM8731 audio codec controller driver code.
*
*  Author: NGK
*
*****************************************************************************/
#ifndef _WM8731_CONTROLLER_
#define _WM8731_CONTROLLER_

#include "system.h"
#include "alt_types.h"
#include "sys/alt_dev.h"
#include "sys/alt_llist.h"

#define AUDIO_CTRL_REG_LINE_IN_L     0x0
#define AUDIO_CTRL_REG_LINE_IN_R     0x1
#define AUDIO_CTRL_REG_HEADPHONE_L   0x2
#define AUDIO_CTRL_REG_HEADPHONE_R   0x3
#define AUDIO_CTRL_REG_ANG_PATH_CTRL 0x4
#define AUDIO_CTRL_REG_DIG_PATH_CTRL 0x5
#define AUDIO_CTRL_REG_POWER_DOWN    0x6
#define AUDIO_CTRL_REG_IF_FORMAT     0x7
#define AUDIO_CTRL_REG_SAMPLING_CTRL 0x8
#define AUDIO_CTRL_REG_ACTIVE_CTRL   0x9
#define AUDIO_CTRL_REG_RESET         0xF

#define AUDIO_CODEC_CONTROLLER_RESET  0x01
#define AUDIO_CODEC_CONTROLLER_ENABLE 0x02
#define AUDIO_CODEC_CONTROLLER_INTERRUPT_ENABLE 0x08
#define AUDIO_CODEC_CONTROLLER_IRQ_N  0xFFFFFFFB

//#define DAC_FIFO_DEPTH 1024
#define DAC_FIFO_DEPTH 256

typedef struct {
  unsigned int* buffer;
  int depth;
  int read_index;
  int write_index;  
} sample_buffer_struct;

typedef struct {
  int controller_base;
  int irq_num;
  int fifo_depth;
  sample_buffer_struct* sample_buffer;
  int headphone_volume;  // 0 - 100
  int headphone_balance; // 0 - 100, 
                         // 0 = All Left, 
                         // 100 = All Right, 
                         // 50 = equal R/L
  
} alt_audio_codec;

typedef struct audio_codec_WM8731_dev audio_codec_WM8731_dev;

struct audio_codec_WM8731_dev
{
  alt_dev       dev;
  unsigned int  base;      /* Base address of the Controller */
  int           irq_num;
};

#define AUDIO_CODEC_WM8731_INSTANCE( name, WM8731_dev )  \
static audio_codec_WM8731_dev WM8731_dev =               \
{                                                        \
  {                                                      \
      ALT_LLIST_ENTRY,                                   \
      name##_NAME,                                       \
      NULL, /* open */                                   \
      NULL, /* close */                                  \
      NULL, /* read */                                   \
      NULL, /* write */                                  \
      NULL, /* lseek */                                  \
      NULL, /* fstat */                                  \
      NULL, /* ioctl */                                  \
   },                                                    \
   name##_BASE,                                          \
   name##_IRQ,                                           \
}

#define AUDIO_CODEC_WM8731_INIT( name, WM8731_dev )      \
    audio_codec_WM8731_dev_init (&WM8731_dev )

int audio_codec_WM8731_dev_init ( audio_codec_WM8731_dev* WM8731_dev );


// Function Prototypes
alt_audio_codec* alt_audio_codec_init( char*        audio_codec_name,
                                       unsigned int sampling_rate,
                                       unsigned int bclk_freq,
                                       unsigned int xck_freq,
                                       int          sample_buffer_depth,
                                       unsigned int avalon_slave_clk_freq );

alt_dev* audio_codec_WM8731_open( const char* name );

void reset_audio_codec_controller( alt_audio_codec* audio_codec );
void enable_audio_codec_controller( alt_audio_codec* audio_codec );
void disable_audio_codec_controller( alt_audio_codec* audio_codec );
void reset_audio_codec_controller_at_addr( unsigned int base_address );
void disable_audio_codec_controller_at_addr( unsigned int base_address );
void enable_audio_codec_controller_at_addr( unsigned int base_address );
void disable_audio_codec_controller_interrupts_at_addr( unsigned int base_address );
void enable_audio_codec_controller_interrupts_at_addr( unsigned int base_address );
void disable_audio_codec_controller_interrupts( alt_audio_codec* audio_codec );
void ensable_audio_codec_controller_interrupts( alt_audio_codec* audio_codec );
int set_sample_clk_divider( unsigned int base_addr, int sampling_freq, int avalon_slave_clk_freq  );
int set_bclk_divider( unsigned int base_addr, int bclk_freq, int avalon_slave_clk_freq );
void alt_audio_codec_isr( void* context, alt_u32 id );
int alt_audio_codec_write_samples( alt_audio_codec* audio_codec, short* right, short* left, int num_samples );
int alt_audio_codec_close( alt_audio_codec* audio_codec );



#endif /* _WM8731_CONTROLLER_ */
