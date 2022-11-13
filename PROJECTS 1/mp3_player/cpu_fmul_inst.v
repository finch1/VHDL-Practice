// cpu_fmul_inst.v

// This file was auto-generated as part of a SOPC Builder generate operation.
// If you edit it your changes will probably be lost.

module cpu_fmul_inst (
		input  wire        clk,
		input  wire        clk_en,
		input  wire [31:0] dataa,
		input  wire [31:0] datab,
		output wire        done,
		input  wire        reset,
		output wire [31:0] result,
		input  wire        start
	);

	fmul cpu_fmul_inst (
		.start  (start),  // nios_custom_instruction_slave_0.start
		.clk_en (clk_en), //                                .clk_en
		.dataa  (dataa),  //                                .dataa
		.datab  (datab),  //                                .datab
		.done   (done),   //                                .done
		.result (result), //                                .result
		.clk    (clk),    //                                .clk
		.reset  (reset)   //                                .reset
	);

endmodule
