/*****************************************************************************
*  File:    sd_controller.c
*
*  Purpose: Driver code for the SD Card Controller
*
*  Author: NGK
*
*****************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/alt_cache.h>
#include "system.h"
#include "io.h"
#include "sd_controller.h"


sd_card_info_struct* sd_card_global;
sd_commands_struct* sd_cmd;

/*****************************************************************************
*  Function: sd_controller_dev_init
*
*  Purpose: HAL device driver initialization.  Calls the SD Card
*           controller intitialization routine and then registers
*           the filesystem with the HAL.
*           Called by alt_sys_init.
*
*  Returns: 0 -     success
*           non-0 - failure
*
*****************************************************************************/
int sd_controller_dev_init ( sd_controller_dev* sd_dev )
{
  int ret_code = 0;
  int i;
  
  sd_card_global = malloc( sizeof( sd_card_info_struct ));
  if( sd_card_global != NULL )
  {
    // Try to initialize 1000 times.  If we fail, then we really did fail.
  	for( i = 0; i < 1000; i++ )
  	{
  		ret_code = sd_controller_init( (unsigned int)sd_dev->base, sd_dev->dev.name );
  		if( !ret_code)
  		{
  			break; 
  		}
  		usleep( 1000 );
  	}
//  	sd_card_global->init_tries = i + 1;
  }
  else
  {
  	ret_code = COULDNT_ALLOC_MEM;
  }
  
  if( !ret_code )
  {
  	ret_code = alt_fs_reg( &(sd_dev->dev) );
  }
  else
  {
//  	sd_card_global->error_code = ret_code;
  }

 
  return ret_code;
}

/*****************************************************************************
*  Function: sd_controller_init
*
*  Purpose: Called by the HAL device driver initialization.  
*           Resets the physical SD Controller, sets up the SD Card
*           clock, and initializes the SD Card.
*
*  Returns: 0 -     success
*           non-0 - failure
*
*****************************************************************************/
int sd_controller_init( unsigned int base_addr, char* mount_point )
{
  
  int ret_code = 0;
  alt_u8 clock_div_value;
  alt_u32 ocr_reg_value;
  
  // Allocate our structures
  sd_cmd = malloc( sizeof( sd_commands_struct ) * 64 );
  
  // Set the name of the SD Card mount point
  strcpy( sd_card_global->mount_point, mount_point );
  
  // Initialize the SD commands
  sd_init_command_struct();  
 
  // Make the controller uncacheable since its register and memory contents can be changed
  // by the controller logic, invalidating the cache.
  base_addr = ( unsigned int )( alt_remap_uncached ( (void*)base_addr, 0x400 ));

  // Set the base address of the SPI controller
  sd_card_global->base_addr = base_addr;
  sd_card_global->data_buff_base_addr = base_addr + SD_DATA_BUFF_OFFSET;
  
  // Reset the controller
  IOWR_32DIRECT( sd_card_global->base_addr, SD_CONTROL_STATUS_OFFSET, SD_SYNC_RESET_BIT_MASK );
  
  // Calculate and write clock divider to start the SPI clock (+1 forces a round-up)
  // Use the CPU clock frequency to initialize the clock divider 
  // Then later, if neccessary, we'll set the actual clock rate from the application.
  // This is useful for when the controller is not on the same clock as the CPU.
  clock_div_value = (ALT_CPU_FREQ / SD_SPI_MAX_CLK_RATE) + 1;
  IOWR_8DIRECT( sd_card_global->base_addr, SD_CLK_DIV_REG_OFFSET, clock_div_value );
  sd_card_global->max_clk_rate = SD_SPI_MAX_CLK_RATE;
  
  // SD device needs at least 74 clocks before we can issue it any commands
  usleep(( 74 * 1000000 ) / SD_SPI_MAX_CLK_RATE );
  
  // Issue GO_IDLE_STATE command
  ret_code |= sd_sendreceive_spi( sd_card_global, GO_IDLE_STATE, SD_NO_ARG );

  // Issue OP_COND command 
  if( !ret_code )
    ret_code |= sd_sendreceive_spi( sd_card_global, OP_COND, SD_NO_ARG );

  // Issue READ_OCR command
  if( !ret_code )
  {
    ret_code = sd_sendreceive_spi( sd_card_global, READ_OCR, SD_NO_ARG );
    if( !ret_code )
    {
      // Read out OCR value from the controller's response register
      ocr_reg_value = IORD_32DIRECT( sd_card_global->base_addr, SD_COMMAND_RESP0_OFFSET );
  
      // Make sure operating voltages are compatile
      if(( ocr_reg_value & SD_OCR_VOLTAGE_32_36 ) == 0x0 )
        ret_code |= VOLTAGE_NOT_SUPPORTED;  // Does not support voltage range
      
      // Double-check that the busy bit is cleared
      if(( ocr_reg_value & SD_OCR_REG_BUSY_BIT_MASK ) == 0x0 )
        ret_code |= SD_CARD_BUSY;
    }
  }
  
  // Issue SEND_CID command then parse contents of CID register
  if( !ret_code )
  {
    ret_code |= sd_sendreceive_spi( sd_card_global, SEND_CID, SD_NO_ARG );
    sd_parse_cid_register( sd_card_global, (alt_u8*)(sd_card_global->data_buff_base_addr) );
  }
  
  // Issue SEND_CSD command then parse contents of CSD register
  if( !ret_code )
  {
    ret_code |= sd_sendreceive_spi( sd_card_global, SEND_CSD, SD_NO_ARG );
    sd_parse_csd_register( sd_card_global, (alt_u8*)(sd_card_global->data_buff_base_addr) );
  }
 
  // Issue SEND_STATUS command
  if( !ret_code )
    ret_code |= sd_sendreceive_spi( sd_card_global, SEND_STATUS, SD_NO_ARG );
  
  // Issue SET_BLOCKLEN command
  if( !ret_code )
    ret_code |= sd_sendreceive_spi( sd_card_global, SET_BLOCKLEN, (alt_u32)sd_card_global->read_block_length ); 
  
  // setup the timeout values in sysclk ticks
  sd_card_global->max_command_timeout_ticks = MAX_COMMAND_TIMEOUT_MS / (1000 / alt_ticks_per_second());
  sd_card_global->sd_max_timeout_ticks = SD_MAX_TIMEOUT_MS / (1000 / alt_ticks_per_second());
  sd_card_global->sd_max_timeout_write_block_ticks = SD_MAX_TIMEOUT_MS_WRITE_BLOCK / (1000 / alt_ticks_per_second());

  return( ret_code );

}

/*****************************************************************************
*  Function: sd_set_clock_to_max
*
*  Purpose: Sets the SD clock divider
*
*  Returns: Number of volumes mounted.
*
*****************************************************************************/
int sd_set_clock_to_max( int avalon_slave_clock_freq )
{
	int clock_div_value;
	
	clock_div_value = (avalon_slave_clock_freq / SD_SPI_MAX_CLK_RATE) + 1;
  IOWR_8DIRECT( sd_card_global->base_addr, SD_CLK_DIV_REG_OFFSET, clock_div_value );
  
  return( 0 );
}

/*****************************************************************************
*  Function: sd_fat_mount_all
*
*  Purpose: Mounts all SD Card FAT volumes.
*
*  Returns: Number of volumes mounted.
*
*****************************************************************************/
int sd_fat_mount_all( void )
{  
  int volumes_mounted = 0;

  volumes_mounted = rb_fat_disk_mount_all();

  return (volumes_mounted);
}

/*****************************************************************************
*  Function: sd_open
*
*  Purpose: SD Card-specific wrapper for FAT function open().
*
*****************************************************************************/
int sd_open( const char* pathname, int flags )
{
	return( rb_fat_open( pathname, flags ));
}

/*****************************************************************************
*  Function: sd_close
*
*  Purpose: SD Card-specific wrapper for FAT function close().
*
*****************************************************************************/
int sd_close(int fd)
{
	return( rb_fat_close( fd ));
}

/*****************************************************************************
*  Function: sd_read
*
*  Purpose: SD Card-specific wrapper for FAT function read().
*
*****************************************************************************/
ssize_t sd_read(int fd, void* buf, size_t count)
{
	return( rb_fat_read( fd, buf, count));
}

/*****************************************************************************
*  Function: sd_write
*
*  Purpose: SD Card-specific wrapper for FAT function write().
*
*****************************************************************************/
ssize_t sd_write(int fd, const void* buf, size_t count)
{
	return( rb_fat_write( fd, buf, count));
}

/*****************************************************************************
*  Function: sd_list
*
*  Purpose: Wrapper for FAT code which lists all the files in a directory.
*
*  Returns: Number of files found.
*
*****************************************************************************/
int sd_list( char* pathname, char* buf )
{
	return( rb_fat_list( pathname, buf ));
}

/*****************************************************************************
*  Function: sd_isdir
*
*  Purpose: Wrapper for FAT code which checks if a string is a directory.
*
*  Returns: 1 for true, 0 for false.
*
*****************************************************************************/
int sd_isdir( char* pathname )
{
	return( rb_isdir( pathname ));
}

/*****************************************************************************
*  Function: sd_lseek
*
*  Purpose: SD Card-specific wrapper for FAT function lseek().
*
*****************************************************************************/
int sd_lseek(int fd, off_t offset, int whence)
{
	return( rb_fat_lseek( fd, offset, whence ));
}

/*****************************************************************************
*  Function: sd_fstat
*
*  Purpose: SD Card-specific wrapper for FAT function rename().
*
*****************************************************************************/
int sd_fstat( int fd, struct stat *st )
{
	return( rb_fat_fstat( fd, st ));
}

/*****************************************************************************
*  Function: sd_filesize
*
*  Purpose: SD Card-specific wrapper for FAT function filesize().
*
*****************************************************************************/
off_t sd_filesize(int fd)
{
	return( rb_fat_filesize( fd ));
}

/*****************************************************************************
*  Function: sd_remove
*
*  Purpose: SD Card-specific wrapper for FAT function remove().
*
*****************************************************************************/
int sd_remove(const char* name)
{
	return( rb_fat_remove( name ));
}

/*****************************************************************************
*  Function: sd_creat
*
*  Purpose: SD Card-specific wrapper for FAT function creat().
*
*****************************************************************************/
int sd_creat(const char *pathname, mode_t mode)
{
	return( rb_fat_creat( pathname, mode ));
}

/*****************************************************************************
*  Function: sd_rename
*
*  Purpose: SD Card-specific wrapper for FAT function rename().
*
*****************************************************************************/
int sd_rename(const char* path, const char* newpath)
{
	return( rb_fat_rename( path, newpath ));
}

/*****************************************************************************
*  Function: sd_mkdir
*
*  Purpose: SD Card-specific wrapper for FAT function mkdir().
*
*****************************************************************************/
int sd_mkdir(const char *name, int mode)
{
	return( rb_fat_mkdir( name, mode ));
}

/*****************************************************************************
*  Function: sd_rmdir
*
*  Purpose: SD Card-specific wrapper for FAT function rmdir().
*
*****************************************************************************/
int sd_rmdir(const char* name)
{
	return( rb_fat_rmdir( name ));
}

/*****************************************************************************
*  Function: sd_open_wrapper
*
*  Purpose: We use this wrapper as the callback function from the 
*           HAL "open()" system call. Since that API uses file 
*           descriptor pointers instead of integer file descriptors,
*           we need to use the fd pointer to keep track of our 
*           integer file descriptor.  So we hijack the fd->priv 
*           pointer to do so.  We call the FAT function rb_fat_open()
*           to get our integer file descriptor.
*
*  Returns: Integer file descriptor
*
*****************************************************************************/
int sd_open_wrapper( alt_fd* fd, const char* pathname, int flags )
{
	int ret_code;
	
	// Reduce the path to just that found on the SD Card by stripping off the mount point
	pathname += strlen( sd_card_global->mount_point );
	
	ret_code = rb_fat_open( pathname, flags );
  
  // Here is our hijack of the fd->priv pointer to keep track of the
  // file descriptor given to us by rb_fat_open.
  fd->priv = malloc( sizeof( int ));
  *((int*)(fd->priv)) = ret_code;
	
	return( ret_code );
}

/*****************************************************************************
*  Function: sd_close_wrapper
*
*  Purpose: We use this wrapper as the callback function from the 
*           HAL "close()" system call. Since that API uses file 
*           descriptor pointers instead of integer file descriptors,
*           we need to retrieve our integer file descriptor from 
*           the fd->priv pointer.  We call the FAT function 
*           rb_fat_close() to close the file.
*
*  Returns: value returned from rb_fat_close (should be 0)
*
*****************************************************************************/
int sd_close_wrapper( alt_fd* fd )
{
	int ret_code;
	int temp_fd = *((int*)(fd->priv));
	
	ret_code = rb_fat_close( temp_fd );
	
	free( fd->priv );
	
	return( ret_code );
		
}

/*****************************************************************************
*  Function: sd_close_wrapper
*
*  Purpose: We use this wrapper as the callback function from the 
*           HAL "write()" system call. Since that API uses file 
*           descriptor pointers instead of integer file descriptors,
*           we need to retrieve our integer file descriptor from 
*           the fd->priv pointer.  We call the FAT function 
*           rb_fat_write() to close the file.
*
*  Returns: Value returned from rb_fat_write (should be number of 
*           bytes written)
*
*****************************************************************************/
ssize_t sd_write_wrapper( alt_fd* fd, const void* buf, size_t count )
{
	int ret_code;
	int temp_fd = *((int*)(fd->priv));
	
	ret_code = rb_fat_write( temp_fd, buf, count );
	
	return( ret_code );
	
}

/*****************************************************************************
*  Function: sd_read_wrapper
*
*  Purpose: We use this wrapper as the callback function from the 
*           HAL "read()" system call. Since that API uses file 
*           descriptor pointers instead of integer file descriptors,
*           we need to retrieve our integer file descriptor from 
*           the fd->priv pointer.  We call the FAT function 
*           rb_fat_read() to close the file.
*
*  Returns: Value returned from rb_fat_read (should be number of 
*           bytes read)
*
*****************************************************************************/
ssize_t sd_read_wrapper( alt_fd* fd, void* buf, size_t count)
{
	int temp_fd = *((int*)(fd->priv));
	
	return( rb_fat_read( temp_fd, buf, count ));
}

/*****************************************************************************
*  Function: sd_lseek_wrapper
*
*  Purpose: We use this wrapper as the callback function from the 
*           HAL "lseek()" system call. Since that API uses file 
*           descriptor pointers instead of integer file descriptors,
*           we need to retrieve our integer file descriptor from 
*           the fd->priv pointer.  We call the FAT function 
*           rb_fat_lseek() to close the file.
*
*  Returns: Value returned by rb_fat_lseek (should be current file
*           position after the seek)
*
*****************************************************************************/
off_t sd_lseek_wrapper( alt_fd* fd, off_t offset, int whence )
{
	int temp_fd = *((int*)(fd->priv));
	
	return( rb_fat_lseek( temp_fd, offset, whence ));	
}

/*****************************************************************************
*  Function: sd_fstat_wrapper
*
*  Purpose: We use this wrapper as the callback function from the 
*           HAL "fstat()" system call. Since that API uses file 
*           descriptor pointers instead of integer file descriptors,
*           we need to retrieve our integer file descriptor from 
*           the fd->priv pointer.  We call the FAT function 
*           rb_fat_fstat() to close the file.
*
*  Returns: Value returned by rb_fat_fstat (should be
*           0 - success, non-0 - failure.)
*
*****************************************************************************/
int sd_fstat_wrapper( alt_fd* fd, struct stat *st )
{
  int temp_fd = *((int*)(fd->priv));
	
	return( rb_fat_fstat( temp_fd, st ));
}

/*****************************************************************************
*  Function: sd_read_data_block
*
*  Purpose: Reads one block of data from the SD Card and returns it
*           in the pointer "data_buffer".
*
*  Returns: Value returned by SD_SendRecieveSPI (should be
*           0 - success, non-0 - failure.)
*
*****************************************************************************/
int sd_read_data_block( sd_card_info_struct* sd_card, char* data_buffer, alt_u32 read_address )
{
  int ret_code = 0;
//  alt_u32 card_status_reg, card_idle;         
    
  ret_code |= sd_sendreceive_spi( sd_card_global, READ_SINGLE_BLOCK, read_address );
  
  if( !ret_code )
    memcpy( data_buffer, (void*)(sd_card->data_buff_base_addr), sd_card->read_block_length );
  
/*
  // Issue SEND_STATUS command
  // Make sure the card's not still busy before we leave.
  if( !ret_code )
  {
    do
    {
      ret_code |= sd_sendreceive_spi( sd_card_global, SEND_STATUS, SD_NO_ARG );
      card_status_reg = IORD_32DIRECT( sd_card->base_addr, SD_COMMAND_RESP0_OFFSET );
      card_idle = ( card_status_reg >> 8 ) & 0x1; 
    } while( !card_idle );
  }
*/  
  return( ret_code );
}
  
/*****************************************************************************
*  Function: sd_write_data_block
*
*  Purpose: Writes one block of data to the SD Card.  Data is passed
*           in by the pointer "data_buffer".
*
*  Returns: Value returned by SD_SendRecieveSPI (should be
*           0 - success, non-0 - failure.)
*
*****************************************************************************/
int sd_write_data_block( sd_card_info_struct* sd_card, char* data_buffer, alt_u32 write_address )
{

  int ret_code = 0;
    
  memcpy((alt_u8*)sd_card->data_buff_base_addr, data_buffer, sd_card->read_block_length );

  ret_code |= sd_sendreceive_spi( sd_card_global, WRITE_BLOCK, write_address );
  
  return( ret_code );

}

/*****************************************************************************
*  Function: rb_fat_read_sectors
*
*  Purpose: Entry point into SD Card-specific code from FAT code.
*           Reads one block of data from the SD Card.  Data is passed
*           in by the pointer "data_buffer".
*
*  Returns: Value returned by sd_read_data_block (should be
*           0 - success, non-0 - failure.)
*
*****************************************************************************/
int rb_fat_read_sectors( unsigned long start,
                          int incount,
                          void* inbuf )
{
  int ret_code = 0;
  int errors = 0;
  int i;
  
  for( i = 0; i < incount; i++ )
  {
    ret_code = sd_read_data_block( sd_card_global, (char*) inbuf, (( start + i ) << 9 ));
    if( ret_code )
    	errors++;

    inbuf += 512;
  }
  
  if( errors )
  	return ( -1 );
 	else
 		return( 0 );
}

/*****************************************************************************
*  Function: rb_fat_write_sectors
*
*  Purpose: Entry point into SD Card-specific code from FAT code.
*           Writes one block of data to the SD Card.  Data is passed
*           in by the pointer "data_buffer".
*
*  Returns: Value returned by sd_write_data_block (should be
*           0 - success, non-0 - failure.)
*
*****************************************************************************/
int rb_fat_write_sectors( unsigned long start,
                          int count,
                          void* buf)
{
  int ret_code = 0;
  int i;

  for( i = 0; i < count; i++ )
  {
    ret_code |= sd_write_data_block( sd_card_global, (char*) buf, ( ( start + i ) << 9 ));
    buf += sd_card_global->read_block_length;
  }

  if( ret_code )
  	return ( -1 );
  else
  	return( 0 );
}
 

/*****************************************************************************
*  Function: sd_sendreceive_spi
*
*  Purpose: Sends an SD card command over SPI, and retrieves
*           a response
*
*  Returns: 0 -     success
*           non-0 - failure
*	
*****************************************************************************/
int sd_sendreceive_spi( sd_card_info_struct* sd_card, 
                       alt_u8 command, 
                       alt_u32 command_argument )
{
  int ret_code = 0;
  volatile alt_u16 crc_calc, crc_rec;
  volatile alt_u8 card_status, controller_status; 
//  volatile alt_u32 cmd_attempts;
//  volatile alt_u32 polls, max_polls;
  volatile alt_u8 ready, error;
  volatile alt_u8 data_response;
  volatile int current_ticks, max_command_timeout, sd_max_timeout;
  
    
  // Wait for controller ready bit before we issue the command
// replacing count based timeout with time based timout -- RSF
//  for( cmd_attempts = 0; cmd_attempts < MAX_COMMAND_ATTEMPTS; cmd_attempts++ )
//  {
//    ready = IORD_8DIRECT( sd_card->base_addr, SD_CONTROL_STATUS_OFFSET ) & SD_READY_BIT_MASK;
//    if ( ready ) 
//      break;       
//    if( cmd_attempts == MAX_COMMAND_ATTEMPTS )
//      ret_code |= CONTROLLER_NOT_READY;
//  }  

    current_ticks = alt_nticks();
    max_command_timeout = current_ticks + sd_card->max_command_timeout_ticks + 1;
    do
    {
    	ready = IORD_8DIRECT( sd_card->base_addr, SD_CONTROL_STATUS_OFFSET ) & SD_READY_BIT_MASK;
      if( ready )
      {
      	break;       
      }
        
      current_ticks = alt_nticks();
    } while(current_ticks < max_command_timeout);
    
    if(current_ticks >= max_command_timeout)
    {
        ret_code |= CONTROLLER_NOT_READY;
        return( ret_code );
    }

  // We repeatedly send the command until we get the expected status 
  // response from the SD card.  If we exceed MAX_COMMAND_ATTEMPTS, 
  // we exit with an error code.  The controller's command register
  // shifts itself out every time, so we need to reload it for each
  // command attempt.
// replacing count based timeout with time based timout -- RSF
//  for( cmd_attempts = 0; cmd_attempts < MAX_COMMAND_ATTEMPTS; cmd_attempts++ )
    current_ticks = alt_nticks();
    max_command_timeout = current_ticks + sd_card->max_command_timeout_ticks + 1;
  do
  {
    // Write command ID
    IOWR_8DIRECT( sd_card->base_addr, SD_COMMAND_ID_OFFSET, sd_cmd[command].command_id );
 
    // Write command argument
    IOWR_32DIRECT( sd_card->base_addr, SD_COMMAND_ARG_OFFSET, command_argument );

    // Write command CRC (only needed for CMD0)
    if( command == GO_IDLE_STATE )
      IOWR_8DIRECT( sd_card->base_addr, SD_COMMAND_CRC_OFFSET, 0x95 );
    else
      IOWR_8DIRECT( sd_card->base_addr, SD_COMMAND_CRC_OFFSET, 0x00 );

    // Write expected response length (in bits)
    IOWR_8DIRECT( sd_card->base_addr, SD_RESP_LENGTH_OFFSET, sd_cmd[command].response_length );
    
    //Write data response length expected from the command (in 32-bit words)
    IOWR_8DIRECT( sd_card->base_addr, SD_DATA_LENGTH_OFFSET, sd_cmd[command].data_words );
    
    // Write the data CRC (only for WRITE_BLOCK command)
    if( command == WRITE_BLOCK )
    {
      crc_calc = calc_crc16( (alt_u8*)(sd_card->data_buff_base_addr), ( sd_cmd[command].data_words << 2 ));
      IOWR_16DIRECT( sd_card->base_addr, SD_DATA_CRC_OFFSET, crc_calc );
    }

    // Set the controller go_bit to start command execution 
    controller_status = IORD_8DIRECT( sd_card->base_addr, SD_CONTROL_STATUS_OFFSET );
    IOWR_8DIRECT( sd_card->base_addr, SD_CONTROL_STATUS_OFFSET, ( controller_status | SD_GO_BIT_MASK ));

    // Write commands can take some time.  So we wait longer for them
// replacing count based timeout with time based timout -- RSF
//    if( command == WRITE_BLOCK )
//      max_polls = SD_MAX_POLLS_WRITE_BLOCK;
//    else
//      max_polls = SD_MAX_POLLS;
    current_ticks = alt_nticks();
    if( command == WRITE_BLOCK )
        sd_max_timeout = current_ticks + sd_card->sd_max_timeout_write_block_ticks + 1;
    else
        sd_max_timeout = current_ticks + sd_card->sd_max_timeout_ticks + 1;
    
    // Poll the ready_bit until the command is finished
    // This loop times out to prevent getting caught in an endless 
    // loop waiting for data from an unresponsive SD Card
// replacing count based timeout with time based timout -- RSF
//    for( polls = 0; polls < max_polls; polls++ )
    do
    {
      ready = ( IORD_8DIRECT( sd_card->base_addr, SD_CONTROL_STATUS_OFFSET ) & SD_READY_BIT_MASK );
      if( ready )
      {
        break;
      }
      current_ticks = alt_nticks();
    } while(current_ticks < sd_max_timeout);
    
//    if( polls == max_polls )
    if(current_ticks >= sd_max_timeout)
    {
      // Reset the controller because we're stuck
      IOWR_32DIRECT( sd_card->base_addr, SD_CONTROL_STATUS_OFFSET, SD_SYNC_RESET_BIT_MASK );
      ret_code |= NO_RESPONSE;
      break;
    }
    
    // Check the error bit in the controller
    error = IORD_8DIRECT( sd_card->base_addr, SD_CONTROL_STATUS_OFFSET ) & SD_ERROR_BIT_MASK;
    if( error )
    {
      ret_code |= CONTROLLER_ERROR;
      break;
    }
    
    // Check the data response for error flags
    // 0x5 - WRITE ACCEPTED
    // 0xB - CRC ERROR
    // 0xD - WRITE_ERROR
    if( !ret_code && ( command == WRITE_BLOCK ))
    {
      data_response = IORD_8DIRECT( sd_card->base_addr, SD_DATA_RESP_OFFSET );
      if(( data_response & 0x1F ) == 0xB )
        ret_code |= CRC_MISMATCH;
      else if(( data_response & 0x1F ) == 0xD )
        ret_code |= WRITE_ERROR;
      else if(( data_response & 0x1F ) != 0x5 )
       	ret_code |= MISC_ERROR;
      else
        ret_code |= SUCCESS;  
    }
    
    // Get the R1 portion of the response from the card.  This is the status 
    // of the card after the command. (where this portion will be in the 
    // response depends on the response type oo)
    if( sd_cmd[command].response_type == SD_R1 )
      card_status = IORD_32DIRECT( sd_card->base_addr, SD_COMMAND_RESP0_OFFSET ) & 0xFF;
    else if( sd_cmd[command].response_type == SD_R2 )
      card_status = ( IORD_32DIRECT( sd_card->base_addr, SD_COMMAND_RESP0_OFFSET ) >> 8 ) & 0xFF;
    else // SD_R3
      card_status = IORD_32DIRECT( sd_card->base_addr, SD_COMMAND_RESP1_OFFSET ) & 0xFF;
      
    // If the SD card status is what we expect, we're done.  If not, we re-issue
    // the command until either we get the expected response, or we time out
    if( card_status == sd_cmd[command].status_expected )
      break;

    current_ticks = alt_nticks();

  } while(current_ticks < max_command_timeout);

//  if( cmd_attempts == MAX_COMMAND_ATTEMPTS )
//    ret_code |= COMMAND_TIMEOUT;
    if(current_ticks >= max_command_timeout)
        ret_code |= COMMAND_TIMEOUT;
  
    // If we received data, check the CRC.
  if(( !ret_code ) && ( sd_cmd[command].receives_data ))
  {
    crc_rec = IORD_16DIRECT( sd_card->base_addr, SD_DATA_CRC_OFFSET );
    crc_calc = calc_crc16( (alt_u8*)(sd_card->data_buff_base_addr), ( sd_cmd[command].data_words << 2 ));
    if( crc_calc != crc_rec )
      ret_code |= CRC_MISMATCH;
  }  
 
  return( ret_code );
}

/*****************************************************************************
*  Function: sd_init_command_struct
*
*  Purpose: Initializes the structure we use to store SD Card commands.  These
*           commands are used anytime we interface directly with the SD Card.
*
*  Returns: void
*	
*****************************************************************************/
void sd_init_command_struct( void )
{
  //  GO_IDLE_STATE
  sd_cmd[GO_IDLE_STATE].command_id = SD_CMD0_ID;
  sd_cmd[GO_IDLE_STATE].response_type = SD_R1;
  sd_cmd[GO_IDLE_STATE].response_length = R1_LENGTH;
  sd_cmd[GO_IDLE_STATE].data_words = 0;
  sd_cmd[GO_IDLE_STATE].status_expected = 0x01;
  sd_cmd[GO_IDLE_STATE].receives_data = 0;  
  sd_cmd[GO_IDLE_STATE].sends_data = 0;  
  
  //  OP_COND
  sd_cmd[OP_COND].command_id = SD_CMD1_ID;
  sd_cmd[OP_COND].response_type = SD_R1;
  sd_cmd[OP_COND].response_length = R1_LENGTH;
  sd_cmd[OP_COND].data_words = 0;
  sd_cmd[OP_COND].status_expected = 0x00;
  sd_cmd[OP_COND].receives_data = 0;  
  sd_cmd[OP_COND].sends_data = 0;  
  
  //  SEND_CSD
  sd_cmd[SEND_CSD].command_id = SD_CMD9_ID;
  sd_cmd[SEND_CSD].response_type = SD_R1;
  sd_cmd[SEND_CSD].response_length = R1_LENGTH;
  sd_cmd[SEND_CSD].data_words = CSD_REG_LENGTH;
  sd_cmd[SEND_CSD].status_expected = 0x00;
  sd_cmd[SEND_CSD].receives_data = 1;  
  sd_cmd[SEND_CSD].sends_data = 0;  

  //  SEND_CID
  sd_cmd[SEND_CID].command_id = SD_CMD10_ID;
  sd_cmd[SEND_CID].response_type = SD_R1;
  sd_cmd[SEND_CID].response_length = R1_LENGTH;
  sd_cmd[SEND_CID].data_words = CID_REG_LENGTH;
  sd_cmd[SEND_CID].status_expected = 0x00;
  sd_cmd[SEND_CID].receives_data = 1;  
  sd_cmd[SEND_CID].sends_data = 0;  
  
  //  SEND_STATUS
  sd_cmd[SEND_STATUS].command_id = SD_CMD13_ID;
  sd_cmd[SEND_STATUS].response_type = SD_R2;
  sd_cmd[SEND_STATUS].response_length = R2_LENGTH;
  sd_cmd[SEND_STATUS].data_words = 0;
  sd_cmd[SEND_STATUS].status_expected = 0x00;
  sd_cmd[SEND_STATUS].receives_data = 0;  
  sd_cmd[SEND_STATUS].sends_data = 0;  

  //  SET_BLOCKLEN
  sd_cmd[SET_BLOCKLEN].command_id = SD_CMD16_ID;
  sd_cmd[SET_BLOCKLEN].response_type = SD_R1;
  sd_cmd[SET_BLOCKLEN].response_length = R1_LENGTH;
  sd_cmd[SET_BLOCKLEN].data_words = 0;
  sd_cmd[SET_BLOCKLEN].status_expected = 0x00;
  sd_cmd[SET_BLOCKLEN].receives_data = 0;  
  sd_cmd[SET_BLOCKLEN].sends_data = 0;  

  //  READ_SINGLE_BLOCK
  sd_cmd[READ_SINGLE_BLOCK].command_id = SD_CMD17_ID;
  sd_cmd[READ_SINGLE_BLOCK].response_type = SD_R1;
  sd_cmd[READ_SINGLE_BLOCK].response_length = R1_LENGTH;
  sd_cmd[READ_SINGLE_BLOCK].data_words = SD_DEFAULT_BLOCK_LENGTH / 4;
  sd_cmd[READ_SINGLE_BLOCK].status_expected = 0x00;
  sd_cmd[READ_SINGLE_BLOCK].receives_data = 1;  
  sd_cmd[READ_SINGLE_BLOCK].sends_data = 0;  
  
  //  WRITE_BLOCK
  sd_cmd[WRITE_BLOCK].command_id = SD_CMD24_ID;
  sd_cmd[WRITE_BLOCK].response_type = SD_R1;
  sd_cmd[WRITE_BLOCK].response_length = R1_LENGTH;
  sd_cmd[WRITE_BLOCK].data_words = SD_DEFAULT_BLOCK_LENGTH / 4;
  sd_cmd[WRITE_BLOCK].status_expected = 0x00;
  sd_cmd[WRITE_BLOCK].receives_data = 0;  
  sd_cmd[WRITE_BLOCK].sends_data = 1;  
  
  //  READ_OCR
  sd_cmd[READ_OCR].command_id = SD_CMD58_ID;
  sd_cmd[READ_OCR].response_type = SD_R3;
  sd_cmd[READ_OCR].response_length = R3_LENGTH;
  sd_cmd[READ_OCR].data_words = 0;
  sd_cmd[READ_OCR].status_expected = 0x00;
  sd_cmd[READ_OCR].receives_data = 0;  
  sd_cmd[READ_OCR].sends_data = 0;  
}  


/*****************************************************************************
*  Function: sd_parse_cid_register
*
*  Purpose: Parses through a response to the SEND_CID command, pulls out the
*           relevant info and inserts it into the sd_card structure.
*
*  Returns: 0
*	
*****************************************************************************/
int sd_parse_cid_register( sd_card_info_struct* sd_card, alt_u8* buff )
{
  int i, j;
  
  sd_card->mfg_id = buff[0];
  
  for( i = 0, j = 1; i < 2; i++, j++ )
    sd_card->oem_id[i] = buff[j];
  sd_card->oem_id[2] = '\0';

  for( i = 0, j = 3; i < 5; i++, j++ )
    sd_card->product_name[i] = buff[j];
  sd_card->product_name[5] = '\0';
  
  sd_card->product_revision = buff[8];

  sd_card->serial_num = buff[9] << 24 |
                        buff[10] << 16 |
                        buff[11] << 8  |
                        buff[12] << 0  ;
                        
  sd_card->mfg_date_code = buff[13] << 8 |
                           buff[14] << 0 ;
    
  return 0;
}  

/*****************************************************************************
*  Function: sd_parse_csd_register
*
*  Purpose: Parses through a response to the SEND_CSD command, pulls out the
*           relevant info and inserts it into the sd_card structure.
*
*  Returns: 0 -     success
*           non-0 - failure
*	
*****************************************************************************/
int sd_parse_csd_register( sd_card_info_struct* sd_card, alt_u8* buff )
{
  alt_u8 csd_read_bl_len, csd_tran_speed, i;
  alt_u32 csd_c_size, csd_c_size_mult, mult;
  int ret_code = 0;
  
  // Get the read block size
  csd_read_bl_len = buff[5] & 0x0F;

  // Block size is 2 ^ block_size_code
  sd_card->read_block_length = 1;
  for( i = 0; i < csd_read_bl_len; i++ )
    sd_card->read_block_length *= 2;
  
  // Get the capacity of the card
  csd_c_size = buff[6] << 16 |
               buff[7] << 8  |
               buff[8] << 0  ;
  csd_c_size = (( csd_c_size >> 6 ) & 0xFFF );        
  
  csd_c_size_mult = buff[9] << 8 |
                    buff[10] << 0 ;
  csd_c_size_mult = (( csd_c_size_mult >> 7 ) & 0x7 );
  
  // mult is 2 ^ (csd_c_size_mult + 2)
  for( i = 0, mult = 1; i < ( csd_c_size_mult + 2 ); i++ )
    mult *= 2;
  
  sd_card->capacity = (( csd_c_size + 1 ) * mult * sd_card->read_block_length );

  // RSF 2GB cards must report a block length of 1024, but the rest of this 
  // driver assumes 512, so ensure that our global is set to 512
  sd_card->read_block_length = 512;
  
  // Get max clock rate
  csd_tran_speed = buff[3];
  mult = csd_tran_speed & 0x7;
  csd_tran_speed >>= 3;
 
// mult: 0=100kbit/s, 1=1Mbit/s, 2=10Mbit/s, 3=100Mbit/s 
  // To avoid using floats in the next step, we divide all these by 10
  switch ( mult )
  {
    case 0: mult = 10000;     // 100000 / 10
      break;
    case 1: mult = 100000;    // 1000000 / 10
      break;
    case 2: mult = 1000000;   // 10000000 / 10
      break;
    case 3: mult = 10000000;  // 100000000 / 10
      break;
    default: ret_code |= BAD_MAX_CLK;
  }
    
  // 1=1.0, 2=1.2, 3=1.3, 4=1.5, 5=2.0, 6=2.5, 7=3.0,
  // 8=3.5, 9=4.0, A=4.5, B=5.0, C=5.5, D=6.0, E=7.0, F=8.0
  // To avoid floats, our mult has been divided by 10, so we can 
  // multiply our decimal values here by 10
  switch ( csd_tran_speed )
  {
    case 0x1: sd_card->max_clk_rate = ( 10 * mult ); // 1.0
      break;
    case 0x2: sd_card->max_clk_rate = ( 12 * mult ); // 1.2
      break;
    case 0x3: sd_card->max_clk_rate = ( 13 * mult ); // 1.3
      break;
    case 0x4: sd_card->max_clk_rate = ( 15 * mult ); // 1.5
      break;
    case 0x5: sd_card->max_clk_rate = ( 20 * mult ); // 2.0
      break;
    case 0x6: sd_card->max_clk_rate = ( 25 * mult ); // 2.5
      break;
    case 0x7: sd_card->max_clk_rate = ( 30 * mult ); // 3.0
      break;
    case 0x8: sd_card->max_clk_rate = ( 35 * mult ); // 3.5
      break;
    case 0x9: sd_card->max_clk_rate = ( 40 * mult ); // 4.0
      break;
    case 0xA: sd_card->max_clk_rate = ( 45 * mult ); // 4.5
      break;
    case 0xB: sd_card->max_clk_rate = ( 50 * mult ); // 5.0
      break;
    case 0xC: sd_card->max_clk_rate = ( 55 * mult ); // 5.5
      break;
    case 0xD: sd_card->max_clk_rate = ( 60 * mult ); // 6.0
      break;
    case 0xE: sd_card->max_clk_rate = ( 70 * mult ); // 7.0
      break;
    case 0xF: sd_card->max_clk_rate = ( 80 * mult ); // 8.0
      break;
    default: ret_code |= BAD_MAX_CLK;
  }
    
  return( ret_code );
}


/*****************************************************************************
*  Function: sd_print_card_info
*
*  Purpose: Prints all the SD Card info gathered from the SEND_CID and 
*           SEND_CSD commands
*
*  Returns: void
*	
*****************************************************************************/
void sd_print_card_info( sd_card_info_struct* sd_card )
{
  int month, year;
  printf("\n+-------------------- SD Card Info --------------------+\n" );
  printf("|                                                      |\n" );
  printf("|     Manufacturer ID:   %2.2X                            |\n", sd_card->mfg_id );
  printf("|     OEM ID:            %s                            |\n", sd_card->oem_id );
  printf("|     Product Name:      %s                         |\n", sd_card->product_name );
  printf("|     Product Revision:  0x%2.2X                          |\n", sd_card->product_revision );
  printf("|     Serial Number:     %8.8X                      |\n", (int)(sd_card->serial_num) );
  month = sd_card->mfg_date_code & 0x000F;
  year = 2000 + ( sd_card->mfg_date_code >> 4 );
  printf("|     Manufacture Date:  %d-%d                       |\n", month, year);
//  printf("|     RCA:               0x%8.8X                    |\n", sd_card->rca );  // Not used in SPI mode.
  printf("|     Max Clock Rate:    %2d MHz                        |\n", (int)(sd_card->max_clk_rate) / 1000000 );
  printf("|     Capacity:          %10d bytes              |\n", (int)(sd_card->capacity) );
  printf("|     Read Block Length: %d bytes                     |\n", (int)(sd_card->read_block_length) );
  printf("+------------------------------------------------------+\n" );
  
}

/*****************************************************************************
*  Function: calc_crc16
*
*  Purpose: Calculates a CRC16 value from a block of data.
*
*  Returns: CRC16 value
*	
*****************************************************************************/
alt_u16 calc_crc16( alt_u8* data, alt_u32 length )
{
  alt_u8 xor_flag;
  alt_u16 crc = 0;
  alt_u16 data_byte;
  int bit_index, byte_index;

  for( byte_index = 0; byte_index < length; byte_index++ )
  {
    data_byte = (alt_u16)data[byte_index];
    data_byte <<= 8;
    for ( bit_index = 0; bit_index < 8; bit_index++ )
    {
      if ((crc ^ data_byte) & 0x8000)
      {
        xor_flag = 1;
      }
      else
      {
        xor_flag = 0;
      }
      crc = crc << 1;
      if (xor_flag)
      {
        crc = crc ^ 0x1021; 
      }
      data_byte = data_byte << 1;
    }
  }
  return( crc );
}


/*****************************************************************************
*  Function: calc_crc7
*
*  Purpose: Calculates a CRC7 value from a block of data.
*
*  Returns: CRC7 value
*	
*****************************************************************************/
alt_u8 calc_crc7( alt_u8* data, alt_u32 length )
{
  int bit_index, byte_index;
  alt_u8 data_byte;
  alt_u8 crc = 0;
  
  for( byte_index = 0; byte_index < length; byte_index++ )
  {
    data_byte = data[byte_index];
    for( bit_index = 0; bit_index < 8; bit_index++ )
    {
      crc = crc << 1;
      if(( crc ^ data_byte ) & 0x80 )
        crc = crc ^ 0x09;
      data_byte <<= 1;
    }
    // Mask off the MSB of the 7-bit crc
    crc = crc & 0x7f; 
  }
  
  return( crc );
}

                          
