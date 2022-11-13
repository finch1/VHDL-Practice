/*****************************************************************************
*  File:    sd_controller.h
*
*  Purpose: Header file info for the SD Card Controller driver code.
*
*  Author: NGK
*
*****************************************************************************/
#ifndef _SD_CONTROLLER_H_
#define _SD_CONTROLLER_H_

#include "system.h"
#include "alt_types.h"
#include "sys/alt_dev.h"
#include "sys/alt_llist.h"
#include "fat_file.h"

// Macros for SD pin manipulation
#define Set_Dir_To_Output(x)     IOWR(x, 1, 1)
#define Set_Dir_To_Input(x)      IOWR(x, 1, 0)
#define Drive_Sig_Low(x)         IOWR(x, 0, 0)
#define Drive_Sig_High(x)        IOWR(x, 0, 1)
#define Read_SD_Pin(x)           IORD(x, 0)

#define SD_SPI_MAX_CLK_RATE 20000000
//#define SD_SPI_MAX_CLK_RATE 10000000

#define GO_IDLE_STATE      0 
#define OP_COND            1 
#define SEND_CSD           9
#define SEND_CID          10
#define SEND_STATUS       13
#define SET_BLOCKLEN      16
#define READ_SINGLE_BLOCK 17
#define WRITE_BLOCK       24
#define READ_OCR          58

// SD Command ID definitions
#define SD_CMD0_ID   0x40  //  GO_IDLE_STATE
#define SD_CMD1_ID   0x41  //  OP_COND
#define SD_CMD9_ID   0x49  //  SEND_CSD
#define SD_CMD10_ID  0x4A  //  SEND_CID
#define SD_CMD13_ID  0x4D  //  SEND_STATUS
#define SD_CMD16_ID  0x50  //  SET_BLOCKLEN
#define SD_CMD17_ID  0x51  //  READ_SINGLE_BLOCK
#define SD_CMD24_ID  0x58  //  WRITE_BLOCK
//#define SD_CMD55  0x77  //  APP_CMD
#define SD_CMD58_ID  0x7A  //  READ_OCR
//#define SD_ACMD41 0x69  //  SD_APP_OP_COND


// For readability when sending sd commands.
#define SD_NO_ARG 0x0

// R1 Response bit values
#define SD_R1_RESP_IDLE_STATE_MASK      0x01
#define SD_R1_RESP_ERASE_RESET_MASK     0x02
#define SD_R1_RESP_ILLEGAL_COMMAND_MASK 0x04
#define SD_R1_RESP_COM_CRC_ERROR_MASK   0x08
#define SD_R1_RESP_ERASE_SEQ_ERROR_MASK 0x10
#define SD_R1_RESP_ADDRESS_ERROR_MASK   0x20
#define SD_R1_RESP_PARAMETER_ERROR_MASK 0x40


// Register Map
/*
Offset Name             Function
                        |31 ...... 24|23 ....... 16|15 ....... 8|7 ....... 0|
=============================================================================
 0x0   Control/Status   | DATA LENGTH| RESP LENGTH | CLK DIVIDE |ERR|D|SR|GO|
------------------------+------------+-------------+------------+-----------+
 0x4   Command / CRC    |                          |  CMD CRC   |  COMMAND  |
------------------------+------------+-------------+------------+-----------+
 0x8   Command Arg      |             COMMAND_ARGUMENT[31:0]                |
------------------------+------------+-------------+------------+-----------+
 0xC   Command Resp0    |                  RESP[31:0]                       |
------------------------+------------+-------------+------------+-----------+
 0x10  Command Resp1    |         CRC16            |  DATA_RESP |RESP[39:32]|
------------------------+------------+-------------+------------+-----------*/

#define SD_CONTROL_STATUS_OFFSET    0x0
#define SD_CLK_DIV_REG_OFFSET       0x1
#define SD_RESP_LENGTH_OFFSET       0x2
#define SD_DATA_LENGTH_OFFSET       0x3
#define SD_COMMAND_ID_OFFSET        0x4
#define SD_COMMAND_CRC_OFFSET       0x5
#define SD_COMMAND_ARG_OFFSET       0x8
#define SD_COMMAND_RESP0_OFFSET     0xC
#define SD_COMMAND_RESP1_OFFSET     0x10
#define SD_DATA_RESP_OFFSET         0x11
#define SD_DATA_CRC_OFFSET          0x12


#define SD_DATA_BUFF_OFFSET         0x200

#define SD_GO_BIT_MASK              0x00000001
#define SD_SYNC_RESET_BIT_MASK      0x00000002
#define SD_READY_BIT_MASK           0x00000004
#define SD_ERROR_BIT_MASK           0x00000008

// Command Timing values in cycles
#define NEC 8
#define NAC 8
#define NAC_MAX 200000
#define NWR 8

// Max command attempts before we timeout and give up
// This isnt listed in the datasheet, but the card typically responds 
// within 5000 tries after powerup (quicker if already initialized once ),
// so we'll double it for our max of 10000 for good measure
//#define MAX_COMMAND_ATTEMPTS  10000 
#define MAX_COMMAND_TIMEOUT_MS       1000   // changing this from a timeout loop count to an actual 1 second timeout 

// This is the maximum number of times we'll poll the controller for
// the ready bit before we time out.  Prevents lockup due to an unresponsive
// SD Card.
//#define SD_MAX_POLLS             10000
//#define SD_MAX_POLLS_WRITE_BLOCK 1000000

#define SD_MAX_TIMEOUT_MS             100   // changing this from a timeout loop count to an actual 0.1 second timeout
#define SD_MAX_TIMEOUT_MS_WRITE_BLOCK 250   // changing this from a timeout loop count to an actual 0.250 second timeout



// SD Card Response types
#define SD_R1 1
#define SD_R2 2
#define SD_R3 3

#define R1_LENGTH 8
#define R2_LENGTH 16
#define R3_LENGTH 40

#define CID_REG_LENGTH 4 // in words (16 bytes)
#define CSD_REG_LENGTH 4 // in words (16 bytes)

// Arguments for SET_BLOCKLEN command
#define SD_BLOCK_LENGTH_256  0x00000100
#define SD_BLOCK_LENGTH_512  0x00000200
#define SD_BLOCK_LENGTH_1024 0x00000400
#define SD_DEFAULT_BLOCK_LENGTH SD_BLOCK_LENGTH_512

// Arguments for SD_APP_OP_COND command
#define SD_OCR_VOLTAGE_32_36 0x00F00000   // We support 3.2V - 3.6V

// We need to check this bit in the OCR register
#define SD_OCR_REG_BUSY_BIT_MASK 0x80000000

// Return error codes (one-hot encoded so they can be or'd together)
// Also the low 8-bits aren't used because the SPI response code
// goes there.
#define SUCCESS               0x0  
#define BAD_MAX_CLK           0x100   
#define CRC_MISMATCH          0x200 
#define NOT_IN_TRANS          0x400 
#define MISC_ERROR            0x800   
#define WRITE_ERROR           0x1000  
#define NO_RESPONSE           0x2000  
#define CONTROLLER_ERROR      0x4000  
#define COMMAND_TIMEOUT       0x8000  
#define CONTROLLER_NOT_READY  0x10000 
#define VOLTAGE_NOT_SUPPORTED 0x20000 
#define SD_CARD_BUSY          0x40000
#define COULDNT_ALLOC_MEM     0x80000


// SD Card state values (found in SD Card Status register)
#define SD_IDLE  0
#define SD_READY 1
#define SD_IDENT 2
#define SD_STBY  3
#define SD_TRANS 4
#define SD_DATA  5
#define SD_RCV   6
#define SD_PRG   7
#define SD_DIS   8


typedef struct sd_controller_dev sd_controller_dev;

struct sd_controller_dev
{
  alt_dev  dev;
  alt_u8*  base;      /* Base address of the SD Card Controller */
};

#define SD_CONTROLLER_INSTANCE( name, sd_dev )       \
static sd_controller_dev sd_dev =                    \
{                                                    \
  {                                                  \
      ALT_LLIST_ENTRY,                               \
      name##_NAME,                                   \
      sd_open_wrapper, /* open */                    \
      sd_close_wrapper, /* close */                  \
      sd_read_wrapper, /* read */                    \
      sd_write_wrapper, /* write */                  \
      sd_lseek_wrapper, /* lseek */                  \
      sd_fstat_wrapper, /* fstat */                  \
      NULL, /* ioctl */                              \
   },                                                \
   name##_BASE,                                      \
}

#define SD_CONTROLLER_INIT( name, sd_dev )           \
    sd_controller_dev_init (&sd_dev )

int sd_controller_dev_init ( sd_controller_dev* sd_dev );

// Structure that keeps track of each command's properties
typedef struct {
  alt_u8 command_id;
  alt_u8 response_type;
  alt_u8 response_length;
  alt_u8 status_expected;
  alt_u32 data_words;
  alt_u8 receives_data;
  alt_u8 sends_data;
} sd_commands_struct;
  

typedef struct {
	char mount_point[128];
  alt_u32 base_addr;
  alt_u32 data_buff_base_addr;
  alt_u8  mfg_id;
  alt_u8  oem_id[3];
  alt_u8  product_name[6];
  alt_u8  product_revision;
  alt_u32 serial_num;
  alt_u16 mfg_date_code;
//  alt_u32 rca;  // Not used in SPI mode
  alt_u32 read_block_length;
  alt_u32 capacity;
  alt_u32 max_clk_rate;
  alt_u32 max_command_timeout_ticks;
  alt_u32 sd_max_timeout_ticks;
  alt_u32 sd_max_timeout_write_block_ticks;
} sd_card_info_struct;


// Function Prototypes
int     sd_sendreceive_spi    ( sd_card_info_struct* sd_card, 
                                alt_u8 command_id, 
                                alt_u32 command_argument );
int     sd_controller_init    ( unsigned int base_addr, char* mount_point );
int     sd_fat_mount_all      ( void );
int     sd_set_clock_to_max   ( int avalon_slave_clock_freq );
int     sd_read_data_block    ( sd_card_info_struct* sd_card, char* data_buffer, alt_u32 read_address );
int     sd_write_data_block   ( sd_card_info_struct* sd_card, char* data_buffer, alt_u32 write_address );
void    sd_init_command_struct( void );
int     sd_parse_cid_register ( sd_card_info_struct* sd_card, alt_u8* buff );
int     sd_parse_csd_register ( sd_card_info_struct* sd_card, alt_u8* buff );
void    sd_print_card_info    ( sd_card_info_struct* sd_card );
alt_u8  calc_crc7             ( alt_u8* data, alt_u32 length );
alt_u16 calc_crc16            ( alt_u8* data, alt_u32 length );

// These are the functions used by the FAT code to access sectors on the SD Card.
int     rb_fat_read_sectors   ( unsigned long start, int incount, void* inbuf );
int     rb_fat_write_sectors  ( unsigned long start, int count, void* buf);

// These are the wrappers for hooking into HAL API
int     sd_open_wrapper       ( alt_fd* fd, const char* pathname, int flags );
int     sd_close_wrapper      ( alt_fd* fd );
ssize_t sd_read_wrapper       ( alt_fd* fd, void* buf, size_t count);
ssize_t sd_write_wrapper      ( alt_fd* fd, const void* buf, size_t count );
off_t   sd_lseek_wrapper      ( alt_fd* fd, off_t offset, int whence );
int     sd_fstat_wrapper      ( alt_fd* fd, struct stat *st );


// These are SD card specific wrappers for general FAT functions.
int     sd_open               ( const char* pathname, int flags );
int     sd_close              ( int fd );
ssize_t sd_read               ( int fd, void* buf, size_t count );
ssize_t sd_write              ( int fd, const void* buf, size_t count );
int     sd_lseek              ( int fd, off_t offset, int whence );
int     sd_fstat              ( int fd, struct stat *st );

// These are SD card-specific wrappers for FAT functions not supported by HAL.
int     sd_list               ( char* pathname, char* buf );
int     sd_isdir              ( char* pathname );
off_t   sd_filesize           ( int fd );
int     sd_remove             ( const char* name );
int     sd_creat              ( const char *pathname, mode_t mode );
int     sd_rename             ( const char* path, const char* newpath );
int     sd_mkdir              ( const char *name, int mode );
int     sd_rmdir              ( const char* name );
/*
// Temp for test
alt_u8 response_R(alt_u8 s);
alt_u8 send_cmd(alt_u8 *in);
alt_u8 SD_read_lba(alt_u8 *buff, alt_u32 lba, alt_u32 seccnt);
*/

#endif /* _SD_CONTROLLER_H_ */
