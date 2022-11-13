module my_dut
(
	// Clock Interface
	input csi_clock_clk,
	input csi_clock_reset,
	
	// ST Sink Interface
	input [15:0] asi_sink_data,
	
	// ST Source Interface
	output [15:0] aso_source_data
);

// this example simply inverts the data
assign aso_source_data = ~asi_sink_data;

endmodule
