/*****************************************************************************
*  File:    audio_codec_WM8731.c
*
*  Purpose: Driver code for the WM8731 audio codec chip
*
*  Author: NGK
*
*****************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/alt_cache.h>
#include <sys/alt_alarm.h>
#include "system.h"
#include "io.h"
#include "audio_codec_WM8731.h"
//#include "i2c_ctrl.h"
#include "priv/alt_file.h"
#include "altera_avalon_performance_counter.h"

/*****************************************************************************
*  Function: reset_audio_codec_controller
*
*  Purpose: 
*
*  Returns: 
*
*****************************************************************************/
void reset_audio_codec_controller( alt_audio_codec* audio_codec )
{
	reset_audio_codec_controller_at_addr( audio_codec->controller_base );
}

/*****************************************************************************
*  Function: enable_audio_codec_controller
*
*  Purpose: 
*
*  Returns: 
*
*****************************************************************************/
void enable_audio_codec_controller( alt_audio_codec* audio_codec )
{
	enable_audio_codec_controller_at_addr( audio_codec->controller_base );
}

/*****************************************************************************
*  Function: disable_audio_codec_controller
*
*  Purpose: 
*
*  Returns: 
*
*****************************************************************************/
void disable_audio_codec_controller( alt_audio_codec* audio_codec )
{
	disable_audio_codec_controller_at_addr( audio_codec->controller_base );
}

/*****************************************************************************
*  Function: enable_audio_codec_controller_interrupts
*
*  Purpose: 
*
*  Returns: 
*
*****************************************************************************/
void enable_audio_codec_controller_interrupts( alt_audio_codec* audio_codec )
{
	enable_audio_codec_controller_interrupts_at_addr( audio_codec->controller_base );
}

/*****************************************************************************
*  Function: disable_audio_codec_controller_interrupts
*
*  Purpose: 
*
*  Returns: 
*
*****************************************************************************/
void disable_audio_codec_controller_interrupts( alt_audio_codec* audio_codec )
{
	disable_audio_codec_controller_interrupts_at_addr( audio_codec->controller_base );
}
/*****************************************************************************
*  Function: reset_audio_codec_controller_at_addr
*
*  Purpose: 
*
*  Returns: 
*
*****************************************************************************/
void reset_audio_codec_controller_at_addr( unsigned int base_address )
{
  unsigned char current_value, write_value;
  
  current_value = IORD_8DIRECT( base_address, 0 );
  write_value = current_value | AUDIO_CODEC_CONTROLLER_RESET;
  IOWR_8DIRECT( base_address, 0, write_value );
}

/*****************************************************************************
*  Function: disable_audio_codec_controller_at_addr
*
*  Purpose: 
*
*  Returns: 
*
*****************************************************************************/
void disable_audio_codec_controller_at_addr( unsigned int base_address )
{
  unsigned char current_value, write_value;
  
  current_value = IORD_8DIRECT( base_address, 0 );
  write_value = current_value & ~AUDIO_CODEC_CONTROLLER_ENABLE;
  IOWR_8DIRECT( base_address, 0, write_value );  
}

/*****************************************************************************
*  Function: enable_audio_codec_controller_at_addr
*
*  Purpose: 
*
*  Returns: 
*
*****************************************************************************/
void enable_audio_codec_controller_at_addr( unsigned int base_address )
{
  unsigned char current_value, write_value;
  
  current_value = IORD_8DIRECT( base_address, 0 );
  write_value = current_value | AUDIO_CODEC_CONTROLLER_ENABLE;
  IOWR_8DIRECT( base_address, 0, write_value );    
}

/*****************************************************************************
*  Function: disable_audio_codec_controller_interrupts_at_addr
*
*  Purpose: 
*
*  Returns: 
*
*****************************************************************************/
void disable_audio_codec_controller_interrupts_at_addr( unsigned int base_address )
{
  unsigned char current_value, write_value;
  
  current_value = IORD_8DIRECT( base_address, 0 );
  write_value = current_value & ~AUDIO_CODEC_CONTROLLER_INTERRUPT_ENABLE;
  IOWR_8DIRECT( base_address, 0, write_value );  
}

/*****************************************************************************
*  Function: enable_audio_codec_controller_interrupts_at_addr
*
*  Purpose: 
*
*  Returns: 
*
*****************************************************************************/
void enable_audio_codec_controller_interrupts_at_addr( unsigned int base_address )
{
  unsigned char current_value, write_value;
  
  current_value = IORD_8DIRECT( base_address, 0 );
  write_value = current_value | AUDIO_CODEC_CONTROLLER_INTERRUPT_ENABLE;
  IOWR_8DIRECT( base_address, 0, write_value );    
}


/*****************************************************************************
*  Function: audio_codec_WM8731_dev_init
*
*  Purpose: HAL device driver initialization.  
*           Called by alt_sys_init.
*
*  Returns: 0 -     success
*           non-0 - failure
*
*****************************************************************************/
int audio_codec_WM8731_dev_init ( audio_codec_WM8731_dev* WM8731_dev )
{
  int ret_code = 0;
 
  ret_code = alt_dev_reg( &(WM8731_dev->dev) );
  
  disable_audio_codec_controller_at_addr( WM8731_dev->base );
  reset_audio_codec_controller_at_addr( WM8731_dev->base );

  return ret_code;
}


/******************************************************************
*  Function: audio_codec_WM8731_open
*
*  Purpose: Opens the codec controller for use.  
*           Returns a file descriptor for the controller
*
******************************************************************/
alt_dev* audio_codec_WM8731_open( const char* name )
{
  alt_dev* dev = (alt_dev*)alt_find_dev( name, &alt_dev_list );

  return dev;
}

/*****************************************************************************
*  Function: alt_audio_codec_close
*
*  Purpose: Closes the audio codec controller and frees all allocated memory
*
*****************************************************************************/
int alt_audio_codec_close( alt_audio_codec* audio_codec )
{
	disable_audio_codec_controller_at_addr( audio_codec->controller_base );
 	reset_audio_codec_controller_at_addr( audio_codec->controller_base );

	free( audio_codec->sample_buffer->buffer );
	free( audio_codec->sample_buffer );
	free( audio_codec );

	
  return( 0 );
}


/*****************************************************************************
*  Function: audio_codec_WM8731_init
*
*  Purpose: 
*
*  Returns: 0 -     success
*           non-0 - failure
*
*****************************************************************************/
alt_audio_codec* alt_audio_codec_init( char*        audio_codec_name,
                                       unsigned int sampling_rate,
                                       unsigned int bclk_freq,
                                       unsigned int xck_freq,
                                       int          sample_buffer_depth,
                                       unsigned int avalon_slave_clk_freq )
{
	alt_audio_codec* audio_codec;
  audio_codec_WM8731_dev* audio_dev;
  
  audio_dev = (audio_codec_WM8731_dev*)audio_codec_WM8731_open( audio_codec_name );

  audio_codec = malloc( sizeof( alt_audio_codec ));

	if( audio_codec )
	{
		audio_codec->controller_base = audio_dev->base;
	  audio_codec->irq_num = audio_dev->irq_num;
	  audio_codec->fifo_depth = DAC_FIFO_DEPTH;
		audio_codec->headphone_volume = 50;
		audio_codec->headphone_balance = 50;
		
		audio_codec->sample_buffer = (sample_buffer_struct*)(malloc( sizeof( sample_buffer_struct )));
		audio_codec->sample_buffer->buffer = (unsigned int*)malloc( sample_buffer_depth * sizeof( unsigned int ));
		audio_codec->sample_buffer->depth = sample_buffer_depth;
		audio_codec->sample_buffer->read_index = 0;
		audio_codec->sample_buffer->write_index = 0;

  	disable_audio_codec_controller_at_addr( audio_codec->controller_base );
  	reset_audio_codec_controller_at_addr( audio_codec->controller_base );

		// For now, we just set BCLK and XCK to the same frequency.
  	set_bclk_divider( audio_codec->controller_base, bclk_freq, avalon_slave_clk_freq );
  	set_sample_clk_divider( audio_codec->controller_base, sampling_rate, avalon_slave_clk_freq );
  
	  // Register the interrupt.
  	alt_irq_register( audio_codec->irq_num, audio_codec, alt_audio_codec_isr );

	  enable_audio_codec_controller_interrupts_at_addr( audio_codec->controller_base );
	  enable_audio_codec_controller_at_addr( audio_codec->controller_base );

		return( audio_codec );
	}
	else
	{
		return( NULL );
	}
}

/*****************************************************************************
*  Function: alt_audio_codec_write_samples
*
*  Purpose: 
*
*  Returns: 0 -     success
*           non-0 - failure
*
*****************************************************************************/
int alt_audio_codec_write_samples( alt_audio_codec* audio_codec, short* right, short* left, int num_samples )
{
	int samples_in_buffer;
	int free_space_in_buffer;
	int i;
	unsigned short left_sample, right_sample;
	unsigned int composite_sample;
	
	if( audio_codec->sample_buffer->write_index >= audio_codec->sample_buffer->read_index )
	{
		free_space_in_buffer = audio_codec->sample_buffer->read_index + ( audio_codec->sample_buffer->depth - audio_codec->sample_buffer->write_index );
	}
	else
	{
		free_space_in_buffer = audio_codec->sample_buffer->read_index - audio_codec->sample_buffer->write_index;
	}
	
	// This is just a safety buffer.
	free_space_in_buffer -= 20;
		
	enable_audio_codec_controller_interrupts( audio_codec );
	   
	if( free_space_in_buffer > num_samples )
  {
		for( i = 0; i < num_samples; i++ )
    { 
      left_sample = *left & 0xFFFF;
      right_sample = *right & 0xFFFF;
      composite_sample = ((( left_sample ) << 16 ) | right_sample );
      
      audio_codec->sample_buffer->buffer[audio_codec->sample_buffer->write_index] = composite_sample;
      audio_codec->sample_buffer->write_index = ( audio_codec->sample_buffer->write_index + 1 ) % ( audio_codec->sample_buffer->depth - 1 );
      left++;
      right++;
  	}
  	return( 0 );
  }
  else
  {
    return( -1 );
  }
}


/*****************************************************************************
*  Function: alt_audio_codec_isr
*
*  Purpose: 
*
*  Returns: 0 -     success
*           non-0 - failure
*
*****************************************************************************/
void alt_audio_codec_isr( void* context, alt_u32 id )
{
	int fifo_used, fifo_free, samples_in_buffer, samples_to_write;
	volatile unsigned int ctrl_status_reg;
	int i;
	alt_audio_codec* audio_codec = (alt_audio_codec*)context;

	fifo_used = IORD( audio_codec->controller_base, 0x1 );
	fifo_free = audio_codec->fifo_depth - fifo_used;
//	fifo_free = ( audio_codec->fifo_depth - fifo_used ) - 5;
	if( audio_codec->sample_buffer->write_index >= audio_codec->sample_buffer->read_index )
	{
		samples_in_buffer = audio_codec->sample_buffer->write_index - audio_codec->sample_buffer->read_index;
	}
	else
	{
		samples_in_buffer = ( audio_codec->sample_buffer->write_index + audio_codec->sample_buffer->depth ) - audio_codec->sample_buffer->read_index;
	}
	
	if( samples_in_buffer != 0 )
	{
		samples_to_write = ( samples_in_buffer > fifo_free ) ? fifo_free : samples_in_buffer;

	  PERF_BEGIN (PERFORMANCE_COUNTER_BASE, 3);

		for( i = 0; i < samples_to_write; i++ )
		{
			IOWR( audio_codec->controller_base, 0x2, audio_codec->sample_buffer->buffer[audio_codec->sample_buffer->read_index] );
			audio_codec->sample_buffer->read_index = ( audio_codec->sample_buffer->read_index + 1 ) % ( audio_codec->sample_buffer->depth - 1 );
		}

	  PERF_END (PERFORMANCE_COUNTER_BASE, 3);
	}
	// If there are no samples in the buffer, disable the audio controller's interrupt controller
	// the next time samples are placed into the buffer, that routine ( alt_audio_codec_write_samples)
	// will re-enable interrupts.
	else
	{
		disable_audio_codec_controller_interrupts( audio_codec );
	}
	
	// Clear the interrupt
	while( IORD_32DIRECT( audio_codec->controller_base, 0x0 ) & (~AUDIO_CODEC_CONTROLLER_IRQ_N ))
	{
		ctrl_status_reg = IORD( audio_codec->controller_base, 0x0 );
		IOWR( audio_codec->controller_base, 0x0, ( ctrl_status_reg & AUDIO_CODEC_CONTROLLER_IRQ_N ));
	}

}

/*****************************************************************************
*  Function: set_bclk_divider
*
*  Purpose: 
*
*  Returns: 0 -     success
*           non-0 - failure
*
*****************************************************************************/
int set_bclk_divider( unsigned int base_addr, int bclk_freq, int avalon_slave_clk_freq )
{
  unsigned char divider, divider_readback;
  
  divider = (unsigned char)( avalon_slave_clk_freq / bclk_freq );
  
  IOWR_8DIRECT( base_addr, 1, divider );
  divider_readback = IORD_8DIRECT( base_addr, 1 );
  
  if( divider_readback == divider )
  {
    return( 0 );
  }
  else
  {
    return( -1 );
  }
}

                          
/*****************************************************************************
*  Function: set_sample_clk_divider
*
*  Purpose: 
*
*  Returns: 0 -     success
*           non-0 - failure
*
*****************************************************************************/
int set_sample_clk_divider( unsigned int base_addr, int sampling_freq, int avalon_slave_clk_freq  )
{
  unsigned short divider, divider_readback;
  
  divider = (unsigned short)( avalon_slave_clk_freq / sampling_freq );
  
  IOWR_16DIRECT( base_addr, 2, divider );
  divider_readback = IORD_16DIRECT( base_addr, 2 );
  
  if( divider_readback == divider )
  {
    return( 0 );
  }
  else
  {
    return( -1 );
  }
}
