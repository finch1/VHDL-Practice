// i2c_ctrl.c
// 2007/12/21  H. Hagiwara , Altera Japan
// 2008/08/29  Modifications made by Nate Knight.

#include "io.h"

//#include "altera_avalon_pio_regs.h"
#include "alt_types.h"
#include "i2c_ctrl.h"

// a short delay of a few clock cycles
static void short_delay() 
{
	const int wait=1;
	volatile unsigned int delay_counter;
  for ( delay_counter = 0; delay_counter < wait; delay_counter++ );
}

// wait for the i2c to be ready - needed at lots of stages during i2c_read and
// i2c_write
static void i2c_wait_tip()
{
  while (( IORD_I2C_SR & I2C_SR_TIP ) > 0 )
  {
    // do nothing
    short_delay();
  }
}

void i2c_write( unsigned char i2c_address,  unsigned short data )
{
	unsigned char first_byte = ( data >> 8 ) & 0xFF;
	unsigned char second_byte = ( data >> 0 ) & 0xFF;
	i2c_address <<= 1; // 1 bit shift left because the lsb is always the write_n bit.  Needs to be 0 for a write
	
  i2c_wait_tip();
  short_delay();
  IOWR_I2C_TXR(i2c_address);
  short_delay();
  IOWR_I2C_CR(I2C_CR_STA | I2C_CR_WR);
  short_delay();
  i2c_wait_tip();
  short_delay();
  IOWR_I2C_TXR(first_byte);
  short_delay();
  IOWR_I2C_CR(I2C_CR_WR);
  short_delay();
  i2c_wait_tip();
  short_delay();
  IOWR_I2C_TXR(second_byte);
  short_delay();
  IOWR_I2C_CR(I2C_CR_WR | I2C_CR_STO);
  short_delay();
  i2c_wait_tip();
  short_delay();
}

// perform some avalon master writes to initialise the I2C master core
void init_i2c()
{
    int prescale;

    // setup prescaler for I2C_CLOCKS_PER_SECOND Hz with sysclk of AV_CLOCKS_PER_SECOND Hz
    prescale = (( AV_CLOCKS_PER_SECOND / I2C_CLOCKS_PER_SECOND ) - 1 );

    IOWR_I2C_PRERLO( prescale & 0xff );
    short_delay();
    IOWR_I2C_PRERHI(( prescale & 0xff00 ) >> 8 );
    short_delay();

    // enable core
    IOWR_I2C_CTR( 0x80 );
    short_delay();
}


