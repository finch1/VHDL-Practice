// i2c_ctrl.h
// 2008/08/29  Nate Knight.

#include "system.h"

#define AV_CLOCKS_PER_SECOND          60000000
#define I2C_CLOCKS_PER_SECOND         100000

// TODO: Get this from HAL driver (when we create one)
//#define I2C_MASTER_BASE AUDIO_I2C_MASTER_BASE
//#define I2C_MASTER_BASE AUDIO_I2C_BASE

// here follows exactly the same set of higher level macros for accessing the I2C
// as those used on Nios II
#define IOWR_I2C_PRERLO(data)  IOWR(I2C_MASTER_BASE, 0, data)
#define IOWR_I2C_PRERHI(data)  IOWR(I2C_MASTER_BASE, 1, data)
#define IOWR_I2C_CTR(data)     IOWR(I2C_MASTER_BASE, 2, data)
#define IOWR_I2C_TXR(data)     IOWR(I2C_MASTER_BASE, 3, data)
#define IOWR_I2C_CR(data)      IOWR(I2C_MASTER_BASE, 4, data)
#define IORD_I2C_PRERLO        IORD(I2C_MASTER_BASE, 0)
#define IORD_I2C_PRERHI        IORD(I2C_MASTER_BASE, 1)
#define IORD_I2C_CTR           IORD(I2C_MASTER_BASE, 2)
#define IORD_I2C_RXR           IORD(I2C_MASTER_BASE, 3)
#define IORD_I2C_SR            IORD(I2C_MASTER_BASE, 4)
#define I2C_CR_STA             0x80
#define I2C_CR_STO             0x40
#define I2C_CR_RD              0x20
#define I2C_CR_WR              0x10
#define I2C_CR_ACK             0x08
#define I2C_CR_IACK            0x01
#define I2C_SR_TIP             0x2

// Function Prototypes
void init_i2c();
void i2c_write( unsigned char  i2c_address, 
                unsigned short data );

