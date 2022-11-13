// sd_card_controller.v

// This file was auto-generated as part of a SOPC Builder generate operation.
// If you edit it your changes will probably be lost.

module sd_card_controller (
		input  wire [7:0]  avalon_slave_address,
		input  wire [3:0]  avalon_slave_byteenable,
		input  wire        avalon_slave_chipselect,
		input  wire        avalon_slave_read,
		output wire [31:0] avalon_slave_readdata,
		input  wire        avalon_slave_write,
		input  wire [31:0] avalon_slave_writedata,
		input  wire        clk,
		input  wire        reset_n,
		output wire        spi_clk,
		output wire        spi_cs_n,
		input  wire        spi_data_in,
		output wire        spi_data_out
	);

	sd_controller sd_card_controller (
		.clk                     (clk),                     // global_signals_clock.clk
		.reset_n                 (reset_n),                 //                     .reset_n
		.avalon_slave_address    (avalon_slave_address),    //         avalon_slave.address
		.avalon_slave_readdata   (avalon_slave_readdata),   //                     .readdata
		.avalon_slave_writedata  (avalon_slave_writedata),  //                     .writedata
		.avalon_slave_write      (avalon_slave_write),      //                     .write
		.avalon_slave_read       (avalon_slave_read),       //                     .read
		.avalon_slave_chipselect (avalon_slave_chipselect), //                     .chipselect
		.avalon_slave_byteenable (avalon_slave_byteenable), //                     .byteenable
		.spi_data_out            (spi_data_out),            //  avalon_slave_export.export
		.spi_data_in             (spi_data_in),             //                     .export
		.spi_cs_n                (spi_cs_n),                //                     .export
		.spi_clk                 (spi_clk)                  //                     .export
	);

endmodule
