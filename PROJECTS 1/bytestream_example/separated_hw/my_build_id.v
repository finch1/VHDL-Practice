module my_build_id
(
	// Clock Interface
	input csi_clock_clk,
	input csi_clock_reset,
	
	// MM Slave Interface
	output [31:0] avs_s0_readdata
);

// You can change the value of this id at any point in time, regardless of 
// whether or not you plan to regenerate the SOPC system.  Your next Quartus
// compilation should compile in the most recent value that you place here.
localparam BUILD_ID = 32'hA5A50001;

assign avs_s0_readdata = BUILD_ID;

endmodule
