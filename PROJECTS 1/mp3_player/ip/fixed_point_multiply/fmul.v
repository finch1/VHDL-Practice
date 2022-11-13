// Copyright (C) 1991-2008 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

// PROGRAM "Quartus II"
// VERSION "Version 8.0 Build 215 05/29/2008 SJ Full Version"

module fmul(
	clk,
	reset,
	start,
	clk_en,
	dataa,
	datab,
	done,
	result
);

input	clk;
input	reset;
input	start;
input	clk_en;
input	[31:0] dataa;
input	[31:0] datab;
output	done;
reg	done;
output	[31:0] result;

wire	[63:0] r;





mult	b2v_inst(.clock(clk),
.aclr(reset),.dataa(dataa),.datab(datab),.result(r));


always@(posedge clk)
begin
	begin
	done <= start;
	end
end

assign	result[31:0] = r[59:28];


endmodule
