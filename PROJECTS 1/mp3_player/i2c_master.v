// i2c_master.v

// This file was auto-generated as part of a SOPC Builder generate operation.
// If you edit it your changes will probably be lost.

module i2c_master (
		output wire        scl_pad_io,
		inout  wire        sda_pad_io,
		output wire        wb_ack_o,
		input  wire [2:0]  wb_adr_i,
		input  wire        wb_clk_i,
		input  wire        wb_cs_i,
		input  wire [31:0] wb_dat_i,
		output wire [31:0] wb_dat_o,
		output wire        wb_err_o,
		output wire        wb_inta_o,
		input  wire        wb_rst_i,
		input  wire        wb_we_i
	);

	opencores_i2c_master i2c_master (
		.wb_clk_i   (wb_clk_i),   //  avalon_slave_0_clock.clk
		.wb_rst_i   (wb_rst_i),   //                      .reset
		.scl_pad_io (scl_pad_io), // global_signals_export.export
		.sda_pad_io (sda_pad_io), //                      .export
		.wb_ack_o   (wb_ack_o),   //        avalon_slave_0.waitrequest_n
		.wb_adr_i   (wb_adr_i),   //                      .address
		.wb_cs_i    (wb_cs_i),    //                      .chipselect
		.wb_dat_i   (wb_dat_i),   //                      .writedata
		.wb_dat_o   (wb_dat_o),   //                      .readdata
		.wb_we_i    (wb_we_i),    //                      .write
		.wb_inta_o  (wb_inta_o),  //    avalon_slave_0_irq.irq
		.wb_err_o   (wb_err_o)    // avalon_slave_0_export.export
	);

endmodule
