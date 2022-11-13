#if 1

//http://ecee.colorado.edu/~ecen4633/index_files/Lecture3_9072010.pdf
//http://www.johnloomis.org/NiosII/interrupts/exception2.html

#include <stdio.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "sys/alt_irq.h"
#include "alt_types.h"

#define ALT_ENHANCED_INTERRUPT_API_PRESENT

  //declare a global variable to hold the edge capture value
  volatile int edge_capture;

  static void handle_button_interrupts(void *context)
  {
	  //cast the context pointer to an integer pointer
	  volatile int *edge_capture_ptr = (volatile int*) context;


	  //read the edge capture register on the button PIO & Store value.
	  *edge_capture_ptr = IORD_ALTERA_AVALON_PIO_EDGE_CAP(KEY_BASE);

	  //write to the edge capture register to reset it
	  IOWR_ALTERA_AVALON_PIO_EDGE_CAP(KEY_BASE, 0x0);

	  //reset interrupt capability for the KEY PIO
//	  IOWR_ALTERA_AVALON_PIO_IRQ_MASK(KEY_BASE, 0x0);

	  if( *edge_capture_ptr == 0x1) //check if the first key was pressed
		  IOWR(LED_BASE, 0, ~(IORD_ALTERA_AVALON_PIO_DATA(LED_BASE))); // write 1 to the leds
  }


  //Initialize the button_pio
  static void init_button_pio()
  {
	  //recast the edge_capture pointer to match the alt_irq_register() function proto
	  void *edge_capture_ptr = (void*) &edge_capture;

	  //enable all 4 button interrupts
	  IOWR_ALTERA_AVALON_PIO_IRQ_MASK(KEY_BASE, 0x1);

	  //reset the edge capture register
	  IOWR_ALTERA_AVALON_PIO_EDGE_CAP(KEY_BASE, 0x0);

	  //register the ISR
	  alt_ic_isr_register(KEY_IRQ_INTERRUPT_CONTROLLER_ID, KEY_IRQ, handle_button_interrupts, edge_capture_ptr, 0x0);

  }

int main()
{
	int  i = 50000000;
  printf("Hello from Nios!\n");
  IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0x0);

  init_button_pio();

  while( i >= 0)
  {
	  while(i >= 0)
	  {
		  i--;
	  }
	  i = 50000000;
  }

  return 0;
}

#endif
