// audio_controller.v

// This file was auto-generated as part of a SOPC Builder generate operation.
// If you edit it your changes will probably be lost.

module audio_controller (
		input  wire        adcdat,
		output wire        adclrck,
		input  wire [2:0]  avalon_slave_address,
		input  wire [3:0]  avalon_slave_byteenable,
		input  wire        avalon_slave_chipselect,
		output wire        avalon_slave_irq,
		input  wire        avalon_slave_read,
		output wire [31:0] avalon_slave_readdata,
		input  wire        avalon_slave_write,
		input  wire [31:0] avalon_slave_writedata,
		output wire        bclk,
		input  wire        clk,
		output wire        dacdat,
		output wire        daclrck,
		input  wire        reset_n,
		output wire        xck
	);

	audio_codec_WM8731 #(
		.DAC_FIFO_DEPTH (256)
	) audio_controller (
		.clk                     (clk),                     // global_signals_clock.clk
		.reset_n                 (reset_n),                 //                     .reset_n
		.avalon_slave_address    (avalon_slave_address),    //         avalon_slave.address
		.avalon_slave_readdata   (avalon_slave_readdata),   //                     .readdata
		.avalon_slave_writedata  (avalon_slave_writedata),  //                     .writedata
		.avalon_slave_write      (avalon_slave_write),      //                     .write
		.avalon_slave_read       (avalon_slave_read),       //                     .read
		.avalon_slave_chipselect (avalon_slave_chipselect), //                     .chipselect
		.avalon_slave_byteenable (avalon_slave_byteenable), //                     .byteenable
		.xck                     (xck),                     //  avalon_slave_export.export
		.bclk                    (bclk),                    //                     .export
		.dacdat                  (dacdat),                  //                     .export
		.daclrck                 (daclrck),                 //                     .export
		.adcdat                  (adcdat),                  //                     .export
		.adclrck                 (adclrck),                 //                     .export
		.avalon_slave_irq        (avalon_slave_irq)         //     interrupt_sender.irq
	);

endmodule
