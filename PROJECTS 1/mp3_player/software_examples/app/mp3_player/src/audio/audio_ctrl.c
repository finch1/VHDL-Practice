// audio_ctrl.c

#include "audio_ctrl.h"
#include "io.h"
#include <unistd.h>


int audio_codec_write_ctrl( unsigned char reg_addr, unsigned short data )
{
	unsigned char first_byte, second_byte;
	unsigned short i2c_complete_data_word;
	
	// First byte contains the reg address and bit 8 of the data
	// This is a weird requirement of the audio codec chip
  first_byte = ( reg_addr << 1 ) | (( data >> 8 ) & 0x1 );
  // Second byte contains bits 7:0 of the data
  second_byte = data & 0xFF;

	i2c_complete_data_word = ( first_byte << 8 | second_byte );
	
	// The address of the audio codec is always 0x1A
	// TODO: Make this a define.
	i2c_write( AUDIO_CODEC_I2C_ADDRESS, i2c_complete_data_word );
	
	return( 0 );
}


int audio_codec_init_i2c( alt_audio_codec* audio_codec )
{  
    
  disable_audio_codec_controller( audio_codec );
  reset_audio_codec_controller( audio_codec );
  
//  audio_codec_set_headphone_volume( audio_codec, 0 );
  
  // Initialize the audio codec chip.
  audio_codec_write_ctrl( AUDIO_CTRL_REG_RESET,         0x000 );  // RESET                                                                                  
  audio_codec_write_ctrl( AUDIO_CTRL_REG_DIG_PATH_CTRL, 0x008 );  // Digital audio path: DAC soft mute on, De-emphasis off                                 
  audio_codec_write_ctrl( AUDIO_CTRL_REG_POWER_DOWN,    0x0E7 );  // power down control: CLKOUT-down, OSC-down, Mic-down, adc-down, line-in down                                   
  audio_codec_write_ctrl( AUDIO_CTRL_REG_IF_FORMAT,     0x003 );  // slave mode and DSP mode                                                          
  audio_codec_write_ctrl( AUDIO_CTRL_REG_ANG_PATH_CTRL, 0x0d0 );  // sound select: sidetone ATT -15dB, sidetone off, DAC select, LineIn to ADC, by-pass off 
  audio_codec_write_ctrl( AUDIO_CTRL_REG_SAMPLING_CTRL, 0x023 );  // mclk: 44  kHz sampling                                                                 
  audio_codec_write_ctrl( AUDIO_CTRL_REG_LINE_IN_L,     0x117 );  // L/R input                                                                              
  audio_codec_write_ctrl( AUDIO_CTRL_REG_ACTIVE_CTRL,   0x001 );  // activate digital interface                                                             
  
  audio_codec_write_ctrl( AUDIO_CTRL_REG_POWER_DOWN,    0x067 );  // turn on power
  audio_codec_write_ctrl( AUDIO_CTRL_REG_DIG_PATH_CTRL, 0x000 );  // unmute                                 

  audio_codec_set_headphone_volume( audio_codec, audio_codec->headphone_volume );
  enable_audio_codec_controller( audio_codec ); 
    
  return( 0 );
}

int audio_codec_set_headphone_volume( alt_audio_codec* audio_codec, int volume )
{
 
  char min = 0x2F;  // 00101111  47
  char max = 0x7F;  // 01111111  127
  // default = 0x79 // 01111001
  unsigned char r_volume_code, l_volume_code, l_pct, r_pct;
  
  audio_codec->headphone_volume = volume;
  
  // Calculate balance
  if( audio_codec->headphone_balance <= 50 )
  {
    l_pct = 100;
  }
  else
  {
    l_pct = ( 50 - ( audio_codec->headphone_balance - 50 ) * 2 );
  }
  
  if( audio_codec->headphone_balance >= 50 )
  {
    r_pct = 100;
  }
  else
  {
    r_pct = ( audio_codec->headphone_balance * 2 );
  }
  
  l_volume_code = (((((( audio_codec->headphone_volume * l_pct ) / 100 ) * 80 ) / 100 ) + 48 ) - 1 );
  r_volume_code = (((((( audio_codec->headphone_volume * r_pct ) / 100 ) * 80 ) / 100 ) + 48 ) - 1 );
  
  audio_codec_write_ctrl( AUDIO_CTRL_REG_HEADPHONE_L, l_volume_code );                                                                       
  audio_codec_write_ctrl( AUDIO_CTRL_REG_HEADPHONE_R, r_volume_code ); 
  
  return( 0 );
}                                                                      
  
int audio_codec_set_headphone_balance( alt_audio_codec* audio_codec, int balance )
{
 
  char min = 0x2F;  // 00101111  47
  char max = 0x7F;  // 01111111  127
  // default = 0x79 // 01111001
  unsigned char r_volume_code, l_volume_code, l_pct, r_pct;
  
  audio_codec->headphone_balance = balance;
  
  // Calculate balance
  if( audio_codec->headphone_balance <= 50 )
  {
    l_pct = 100;
  }
  else
  {
    l_pct = ( 100 - ( audio_codec->headphone_balance - 50 ) * 2 );
  }
  
  if( audio_codec->headphone_balance >= 50 )
  {
    r_pct = 100;
  }
  else
  {
    r_pct = ( audio_codec->headphone_balance * 2 );
  }
  
  l_volume_code = (((((( audio_codec->headphone_volume * l_pct ) / 100 ) * 80 ) / 100 ) + 48 ) - 1 );
  r_volume_code = (((((( audio_codec->headphone_volume * r_pct ) / 100 ) * 80 ) / 100 ) + 48 ) - 1 );
  
  audio_codec_write_ctrl( AUDIO_CTRL_REG_HEADPHONE_L, l_volume_code );                                                                       
  audio_codec_write_ctrl( AUDIO_CTRL_REG_HEADPHONE_R, r_volume_code ); 
  
  return( 0 );
}                                                                      

