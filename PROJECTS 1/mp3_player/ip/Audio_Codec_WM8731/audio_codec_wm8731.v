/*****************************************************************************
*  File:    audio_codec_wm8731.v
*
*  Purpose: Verilog code that implements a controller for a WM8731 audio
*           coded chip.  SOPC Builder compatible.
*
*  Author: NGK
*
*****************************************************************************/


module audio_codec_WM8731
(
  // Avalon Slave
  clk,
  reset_n,
  avalon_slave_address,
  avalon_slave_readdata,
  avalon_slave_writedata,
  avalon_slave_write,
  avalon_slave_read,
  avalon_slave_chipselect,
  avalon_slave_byteenable,
  avalon_slave_irq,

  // Audio Interface Exports
  xck,
  bclk,
  dacdat,
  daclrck,
  adcdat,
  adclrck
  
/*  
  // Temp for testing
  control_status_reg,
  clk_12mhz_divide_value,
  sample_clk_divide_value,
  dac_fifo_data_in ,
  dac_fifo_data_out ,
  dac_fifo_empty ,
  dac_fifo_read_req ,
  dac_fifo_write_req ,
  dac_fifo_used ,
  dac_sample_data_shift_reg,
  sample_shift_en,
  sample_clk_en,
  register_sample_en,
  sample_shift_counter,
  delayed_avalon_slave_write,
  one_cycle_pulse_avalon_slave_write,
  delayed_avalon_slave_chipselect,
  delayed_dac_data_reg_addr_en,
  dac_data_reg,
*/
  
  
);

	// Avalon Slave
	input clk;
	input reset_n;
	input [2:0] avalon_slave_address;
	input [3:0] avalon_slave_byteenable;
	input avalon_slave_chipselect;
	input avalon_slave_write;
	input [31:0] avalon_slave_writedata;
	output [31:0] avalon_slave_readdata;
	input avalon_slave_read;
	output avalon_slave_irq;
	
	// Audio Interface Exports
	output xck;
	output bclk;
	output dacdat;
	output daclrck;
	input  adcdat;
	output adclrck;
/*	
	// Temp for testing
	output[31:0] control_status_reg;
	output[7:0]  clk_12mhz_divide_value;
	output[15:0] sample_clk_divide_value;
  output[ 31: 0]                       dac_fifo_data_in;
  output[ 31: 0]                       dac_fifo_data_out;
  output                               dac_fifo_empty;
  output                               dac_fifo_read_req;
  output                               dac_fifo_write_req;
  output[DAC_FIFO_COUNTER_WIDTH-1 : 0]     dac_fifo_used;
  output[31:0]                         dac_sample_data_shift_reg;
  output sample_shift_en;
  output sample_clk_en;
  output register_sample_en;
  output [5:0] sample_shift_counter;
  output                                delayed_avalon_slave_write;
  output                                one_cycle_pulse_avalon_slave_write;
  output                                delayed_avalon_slave_chipselect;
  output                                delayed_dac_data_reg_addr_en;
	output [31:0]                         dac_data_reg;
*/

  /*###################################################################################
  #                             COMPONENT PARAMETERS                                  #
  ###################################################################################*/
  parameter DAC_FIFO_DEPTH = 1024;
  localparam DAC_FIFO_COUNTER_WIDTH = ( log2( DAC_FIFO_DEPTH ));
  localparam DAC_FIFO_USED_PAD_WIDTH = ( 32 - DAC_FIFO_COUNTER_WIDTH );
  localparam DAC_FIFO_READ_THRESHOLD = DAC_FIFO_DEPTH / 2;
  
  function integer log2;
    input [31:0] value;
    for (log2=0; value>0; log2=log2+1)
      value = value>>1;
  endfunction

  
  /*###################################################################################
  #                         INTERNAL COMPONENT SIGNALS                                #
  ###################################################################################*/

	wire [DAC_FIFO_USED_PAD_WIDTH-1 : 0]   dac_fifo_used_pad;  // Needed to pad the dac_fifo_used register
	
	wire [31:0]                        control_status_reg;
	wire [31:0]                        control_status_reg_indata;
	wire [31:0]                        control_status_reg_indataen;
	
	reg                                irq_enable;
	wire                               ctrl_reg_irq_enable;
	
	wire                               soft_reset;
	wire                               soft_enable;

  wire [31:0]                        dac_data_reg;
  wire                               dac_data_reg_addr_en;

	wire [31:0]                        dac_fifo_used_reg;

  wire [7:0]                         clk_12mhz_divide_value;
  wire [15:0]                        sample_clk_divide_value;
  wire                               clk_12mhz_en_high;
  wire                               clk_12mhz_en_low ;
  reg                                clk_12mhz;        
  wire                               sample_clk_en;
  reg                                ready_for_sample;
  
  reg 	                             sample_shift_en;
  reg [5:0]                          sample_shift_counter;
//  reg                                register_sample_en;
  reg [31:0]                         dac_sample_data_shift_reg;

  
  wire[ 31: 0]                       dac_fifo_data_in;
  wire[ 31: 0]                       dac_fifo_data_out;
  wire                               dac_fifo_empty;
  wire                               dac_fifo_read_req;
//  wire                               fifo_read_clk;
//  wire                               fifo_write_clk;
  wire                               dac_fifo_write_req;
  wire[DAC_FIFO_COUNTER_WIDTH-1 : 0] dac_fifo_used;
  
  reg                                delayed_avalon_slave_write;
  wire                               one_cycle_pulse_avalon_slave_write;
  reg                                delayed_avalon_slave_chipselect;
  reg                                delayed_dac_data_reg_addr_en;
  
	reg  [7:0]                         clk_12mhz_divider_counter;
	reg  [15:0]                        sample_clk_divider_counter;
	reg                                daclrck_reg;

  wire[ 31: 0]                       dac_sample_data_from_fifo;
  reg [ 31: 0]                       last_good_data_from_fifo;
	
	
  /*###################################################################################
  #                         AVALON SLAVE REGISTER MAP                                 #
  #####################################################################################
	
	Offset Name               Function
	                         | 31 ...... 16 | 15 .... 8 | 7 .. 4 |  3    |  2  |   1    |   0   ||  R/W
	===================================================================================================
	 0x0   Control/Status    | samp clk div | 12mhz Div | unused | IRQen | IRQ | Enable | Reset ||  R/W
	-------------------------+------------------------------------------------------------------++
	 0x1 DAC FIFO words used |             DAC Fifo Words Used                                  ||   R
	-------------------------+------------------------------------------------------------------++
	 0x2 DAC FIFO data port  |             DAC Fifo Data Input                                  ||   W
	-------------------------+------------------------------------------------------------------++ 
	 0x3 ADC FIFO words used |             ADC Fifo Words Used                                  ||   R
	-------------------------+------------------------------------------------------------------++
	 0x4 ADC FIFO data port  |             ADC Fifo Data Output                                 ||   W
	-------------------------+------------------------------------------------------------------++ 
	
  ###################################################################################*/
  // Write logic
	
	// Address 0x0
	// Control/Status Reg 
	avalon_mm_read_write_reg_32 control_status_reg_inst
	(
		.clk                     ( clk ),
	  .reset_n                 ( reset_n ),
	  .avalon_slave_address_en ( avalon_slave_address == 0 ),
	  .avalon_slave_writedata  ( avalon_slave_writedata ),
	  .avalon_slave_write      ( avalon_slave_write ),
	  .avalon_slave_read       ( avalon_slave_read ),
	  .avalon_slave_chipselect ( avalon_slave_chipselect ),
	  .avalon_slave_byteenable ( avalon_slave_byteenable ),
	  .reg_data_in             ( control_status_reg_indata ),
	  .reg_data_set_en         ( control_status_reg_indataen ),
	  .reg_data_out            ( control_status_reg )
	);
	
	assign soft_reset = control_status_reg[0];
	assign soft_enable = control_status_reg[1];
	assign clk_12mhz_divide_value = control_status_reg[15:8];
	assign sample_clk_divide_value = control_status_reg[31:16];

  // We need to clear the soft reset immediatly after it goes active.
  assign control_status_reg_indata[0] = 0;
  assign control_status_reg_indataen[0] = soft_reset;

  // IRQ enable
  assign ctrl_reg_irq_enable = control_status_reg[3];

  // IRQ register
  //  input
  assign control_status_reg_indata[2] = 1;
  assign control_status_reg_indataen[2] = irq_enable & soft_enable & ctrl_reg_irq_enable; 
  //  output
  assign avalon_slave_irq = control_status_reg[2];


	// Address 0x2
	// DAC Data Port
	assign dac_data_reg_addr_en = ( avalon_slave_address == 2 );
	avalon_mm_read_write_reg_32 dac_data_reg_inst
	(
		.clk                     ( clk ),
	  .reset_n                 ( reset_n ),
	  .avalon_slave_address_en ( dac_data_reg_addr_en ),
	  .avalon_slave_writedata  ( avalon_slave_writedata ),
	  .avalon_slave_write      ( avalon_slave_write ),
	  .avalon_slave_chipselect ( avalon_slave_chipselect ),
	  .avalon_slave_byteenable ( avalon_slave_byteenable ),
	  .reg_data_out            ( dac_data_reg )
	);

	
	// In order to give our fifo a one-cycle write pulse, 
	// we need to save a delayed avalon write signal so we
	// can tell when it goes low, and issue the fifo write pulse
	// then.  And since this will be a cycle after the other bus
	// signals have expired, we need to register them too.

	// delayed avalon slave write
	always @(posedge clk or negedge reset_n)
	  if (~reset_n)
	    delayed_avalon_slave_write <= 0;
	  else
      delayed_avalon_slave_write <= avalon_slave_write;

	assign one_cycle_pulse_avalon_slave_write = (( ~avalon_slave_write ) && ( delayed_avalon_slave_write ));

	// delayed avalon slave chipselect
	always @(posedge clk or negedge reset_n)
	  if (~reset_n)
	    delayed_avalon_slave_chipselect <= 0;
	  else
      delayed_avalon_slave_chipselect <= avalon_slave_chipselect;

	// delayed dac_data_reg_addr_en
	always @(posedge clk or negedge reset_n)
	  if (~reset_n)
	    delayed_dac_data_reg_addr_en <= 0;
	  else
      delayed_dac_data_reg_addr_en <= dac_data_reg_addr_en;

  /*#################################################################################*/
  // Read logic
  
	assign dac_fifo_used_pad = 0;
  assign avalon_slave_readdata = ((avalon_slave_address == 0))? control_status_reg :
                                 ((avalon_slave_address == 1))? dac_fifo_used_reg :
                                  32'h0;


  /*##############################################################
  #                  THESE ARE THE CLOCK DIVIDERS                #
  ##############################################################*/
  
  // We use a 12MHz clock for both Bclk and Xck.  The WM8731 allows
  // us to drive a 12MHz clock on xck instead of the true sampling
  // rate in a mode called "USB mode".  This potentially saves
  // us a PLL, so we are happy to do it.  The software driver
  // is what puts us in "USB mode".
  
	// clk_12mhz_divider_counter
	always @(posedge clk or negedge reset_n)
	  if (~reset_n)
	    clk_12mhz_divider_counter <= 0;
	  else if ( soft_reset )
      clk_12mhz_divider_counter <= 0;
	  else if (( clk_12mhz_divide_value != 0 ) && soft_enable )
	    if ( clk_12mhz_divider_counter < ( clk_12mhz_divide_value - 1 ))
	      clk_12mhz_divider_counter <= clk_12mhz_divider_counter + 1;
	    else
	      clk_12mhz_divider_counter <= 0;
	  else
	    clk_12mhz_divider_counter <= clk_12mhz_divider_counter;
	
	// clk_12mhz output
	always @(posedge clk or negedge reset_n)
	  if (~reset_n)
	    clk_12mhz <= 0;
	  else if( clk_12mhz_divider_counter == (( clk_12mhz_divide_value - 1 ) >> 1 ))
	    clk_12mhz <= 0;
	  else if( clk_12mhz_divider_counter == ( clk_12mhz_divide_value - 1 ))
	    clk_12mhz <= 1;
	  else
	    clk_12mhz <= clk_12mhz;

	assign xck = clk_12mhz;
	assign bclk = clk_12mhz;
	assign clk_12mhz_en_high = ( clk_12mhz_divider_counter == ( clk_12mhz_divide_value - 1 ));
	assign clk_12mhz_en_low = ( clk_12mhz_divider_counter == (( clk_12mhz_divide_value - 1 ) >> 1 ));

	// sample clock divider
	always @(posedge clk or negedge reset_n)
	  if (~reset_n)
	    sample_clk_divider_counter <= 0;
	  else if ( soft_reset )
	    sample_clk_divider_counter <= 0;
	  else if (( sample_clk_divide_value !=  0  ) && soft_enable )
	    if ( sample_clk_divider_counter < ( sample_clk_divide_value - 1 ))
	      sample_clk_divider_counter <= sample_clk_divider_counter + 1;
	    else
	      sample_clk_divider_counter <= 0;
	  else
	    sample_clk_divider_counter <= sample_clk_divider_counter;
	
	// ready for sample
	always @(posedge clk or negedge reset_n)
	  if (~reset_n)
	    ready_for_sample <= 0;
	  else if(( sample_clk_divider_counter == sample_clk_divide_value - 1 ) && soft_enable )
	    ready_for_sample <= 1;
	  else if( sample_clk_en )
	    ready_for_sample <= 0;

  // This synchronizes the sample clock enable with the 12MHz clock.
  assign sample_clk_en = ( ready_for_sample && clk_12mhz_en_low && soft_enable );

/*
	// sample clock (enable) output
	always @(posedge clk or negedge reset_n)
	  if (~reset_n)
	    sample_clk_en <= 0;
	  else if( ready_for_sample &&  && soft_enable )
	    sample_clk_en <= 1;
	  else
	    sample_clk_en <= 0;
*/

  /*##############################################################
  #                 THIS IS THE DAC SAMPLE FIFO                  #
  ##############################################################*/

  scfifo the_dac_scfifo
    (
      .aclr    ( !reset_n ),
      .sclr    ( soft_reset ),
      .data    ( dac_fifo_data_in ),
      .q       ( dac_fifo_data_out ),
      .clock   ( clk ),
      .empty   ( dac_fifo_empty ),
      .rdreq   ( dac_fifo_read_req ),
      .wrreq   ( dac_fifo_write_req ),
      .usedw   ( dac_fifo_used )
    ) ;
  defparam the_dac_scfifo.LPM_NUMWORDS =  DAC_FIFO_DEPTH,
           the_dac_scfifo.LPM_SHOWAHEAD = "ON",
           the_dac_scfifo.LPM_WIDTH =     32;

//	assign dac_fifo_write_req = avalon_slave_write && avalon_slave_chipselect && (avalon_slave_address == 2);
//	assign dac_fifo_write_req = one_cycle_pulse_avalon_slave_write && delayed_avalon_slave_chipselect && (delayed_avalon_slave_address == 2);
	assign dac_fifo_write_req = one_cycle_pulse_avalon_slave_write & delayed_avalon_slave_chipselect & delayed_dac_data_reg_addr_en;
//	assign dac_fifo_data_in = avalon_slave_writedata;
	assign dac_fifo_data_in = dac_data_reg;
//	assign fifo_write_clk = clk;
	assign dac_fifo_used_reg = { dac_fifo_used_pad, dac_fifo_used };
	
	assign dac_sample_data_from_fifo = dac_fifo_data_out;
//	assign  = fifo_rdempty;
	assign dac_fifo_read_req = sample_clk_en;
//	assign fifo_read_clk = clk;

	// Save last good data
	always @(posedge clk or negedge reset_n)
	  if (~reset_n)
	    last_good_data_from_fifo <= 0;
	  else if( dac_fifo_read_req  && ~dac_fifo_empty )
	    last_good_data_from_fifo <= dac_fifo_data_out;
	  else 
	    last_good_data_from_fifo <= last_good_data_from_fifo;

	always @(posedge clk or negedge reset_n)
	  if (~reset_n)
	    irq_enable <= 0;
	  else if( dac_fifo_used < DAC_FIFO_READ_THRESHOLD )
	    irq_enable <= 1;
	  else 
	    irq_enable <= 0;
	
  /*##############################################################
  #               THIS IS THE DAC SAMPLE SHIFTER                 #
  ##############################################################*/
	// sample shift enable
	// This enables the shifting out of the audio data serially on dacdat
	always @(posedge clk or negedge reset_n)
	  if (~reset_n)
	    sample_shift_en <= 0;
	  else if( sample_clk_en )
	    sample_shift_en <= 1;
	  else if( sample_shift_counter == 32 )
	    sample_shift_en <= 0;
	  else
	    sample_shift_en <= sample_shift_en;

	// sample shift counter
	always @(posedge clk or negedge reset_n)
	  if (~reset_n)
	    sample_shift_counter <= 0;
	  else if ( ~sample_shift_en )
	    sample_shift_counter = 0;
	  else if ( sample_shift_en && clk_12mhz_en_low )
	    sample_shift_counter = sample_shift_counter + 1;
	  else
	    sample_shift_counter <= sample_shift_counter;

	// enable signal that registers sample from fifo. ( 1 cycle delay of sample_clk_en )
//	always @(posedge clk or negedge reset_n)
//	  if (~reset_n)
//	    register_sample_en <= 0;
//	  else
//	  	register_sample_en <= sample_clk_en;

	// sample data shift reg
	always @(posedge clk or negedge reset_n)
	  if ( ~reset_n )
	    dac_sample_data_shift_reg <= 0;
	  else if ( sample_clk_en && ~dac_fifo_empty )
	    dac_sample_data_shift_reg = dac_sample_data_from_fifo;
	  else if ( sample_clk_en && dac_fifo_empty )
	    dac_sample_data_shift_reg = last_good_data_from_fifo;
	  else if ( sample_shift_en && clk_12mhz_en_low )
	    dac_sample_data_shift_reg <= { dac_sample_data_shift_reg[30:0] , 1'b0} ;


	assign dacdat = dac_sample_data_shift_reg[31];

	// daclrck (and adclrck) register
	always @(posedge clk or negedge reset_n)
	  if ( ~reset_n )
	    daclrck_reg <= 0;
	  else if ( sample_clk_en )
	  	daclrck_reg = 1;
//	  else if (( sample_shift_counter == 15 ) && clk_12mhz_en_low )  // Left justified mode
//	    daclrck_reg = 0;
	  else if (( sample_shift_counter == 0 ) && clk_12mhz_en_low )  // DSP mode
	    daclrck_reg = 0;
	  else
	    daclrck_reg <= daclrck_reg;
	    
	assign daclrck = daclrck_reg;
	assign adclrck = daclrck_reg;


endmodule

