// lcd_controller.v

// This file was auto-generated as part of a SOPC Builder generate operation.
// If you edit it your changes will probably be lost.

module lcd_controller (
		output wire        DEN,
		output wire        HD,
		output wire        LCD_RESET,
		output wire        NCLK,
		output wire [7:0]  RGB,
		output wire        SERIAL_SCEN,
		output wire        SERIAL_SCL,
		inout  wire        SERIAL_SDA,
		output wire        VD,
		input  wire        clk,
		input  wire        lcd_clk_in,
		output wire [31:0] master_address,
		output wire [3:0]  master_byteenable,
		input  wire        master_data_valid,
		output wire        master_read,
		input  wire [31:0] master_readdata,
		input  wire        master_waitrequest,
		input  wire        reset_n,
		input  wire [2:0]  slave_address,
		input  wire        slave_chipselect,
		output wire        slave_irq,
		output wire [31:0] slave_readdata,
		input  wire        slave_write,
		input  wire [31:0] slave_writedata
	);

	tpo_lcd_controller #(
		.NUM_COLUMNS    (800),
		.NUM_ROWS       (480),
		.FIFO_DEPTH     (1024),
		.DMA_DATA_WIDTH (32)
	) lcd_controller (
		.clk                (clk),                // global_signals_clock.clk
		.reset_n            (reset_n),            //                     .reset_n
		.slave_address      (slave_address),      //         avalon_slave.address
		.slave_readdata     (slave_readdata),     //                     .readdata
		.slave_writedata    (slave_writedata),    //                     .writedata
		.slave_write        (slave_write),        //                     .write
		.slave_chipselect   (slave_chipselect),   //                     .chipselect
		.slave_irq          (slave_irq),          //     avalon_slave_irq.irq
		.master_address     (master_address),     //        avalon_master.address
		.master_readdata    (master_readdata),    //                     .readdata
		.master_read        (master_read),        //                     .read
		.master_waitrequest (master_waitrequest), //                     .waitrequest
		.master_data_valid  (master_data_valid),  //                     .readdatavalid
		.master_byteenable  (master_byteenable),  //                     .byteenable
		.RGB                (RGB),                // avalon_master_export.export
		.NCLK               (NCLK),               //                     .export
		.HD                 (HD),                 //                     .export
		.VD                 (VD),                 //                     .export
		.DEN                (DEN),                //                     .export
		.SERIAL_SDA         (SERIAL_SDA),         //                     .export
		.SERIAL_SCL         (SERIAL_SCL),         //                     .export
		.SERIAL_SCEN        (SERIAL_SCEN),        //                     .export
		.LCD_RESET          (LCD_RESET),          //                     .export
		.lcd_clk_in         (lcd_clk_in)          //                     .export
	);

endmodule
