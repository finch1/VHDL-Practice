module stream_back_pressure_gate

#(
	parameter TRIGGER_DEPTH	= 1500,
	parameter DATA_WIDTH	= 16
)

(
	// clock interface
	input csi_clock_clk,
	input csi_clock_reset,
	
	// ST sink ingress
	output	reg							asi_ingress_snk_ready,
	input								asi_ingress_snk_valid,
	input		[(DATA_WIDTH - 1):0]	asi_ingress_snk_data,
	
	// ST source ingress
	output	reg							aso_ingress_src_valid,
	output	reg	[(DATA_WIDTH - 1):0]	aso_ingress_src_data,
	
	// ST sink egress
	input								asi_egress_snk_valid,
	input		[(DATA_WIDTH - 1):0]	asi_egress_snk_data,
	
	// ST source egress
	input								aso_egress_src_ready,
	output	reg							aso_egress_src_valid,
	output	reg	[(DATA_WIDTH - 1):0]	aso_egress_src_data,
	
	// MM master interface
	output		[2:0]					avm_m0_address,
	output								avm_m0_read,
	input								avm_m0_waitrequest,
	input		[31:0]					avm_m0_readdata,
	input								avm_m0_readdatavalid,
	
	// MM slave interface
	input								avs_s0_write,
	input		[31:0]					avs_s0_writedata,
	output		[31:0]					avs_s0_readdata
);

// this variable will hold the current fill level of the ST_DC_FIFO
reg [15:0]	current_fill_level;

// this variable will hold the trigger level that we open the gate at
reg [15:0] trigger_depth;

//
// ST sink ingress
//
always @ (posedge csi_clock_clk or posedge csi_clock_reset)
begin
	if(csi_clock_reset)
	begin
		asi_ingress_snk_ready <= 0;
	end
	// wait until the FIFO level fills to our trigger and we are not currently ready
	else if((current_fill_level >= trigger_depth) && (!asi_ingress_snk_ready))
	begin
		asi_ingress_snk_ready <= 1;
	end
	// stay ready until valid is withdrawn
	else if((asi_ingress_snk_ready) && (!asi_ingress_snk_valid))
	begin
		asi_ingress_snk_ready <= 0;
	end
end

//
// ST source ingress
//
always @ (posedge csi_clock_clk or posedge csi_clock_reset)
begin
	if(csi_clock_reset)
	begin
		aso_ingress_src_valid <= 0;
		aso_ingress_src_data <= 0;
	end
	// as long as we're clocking data in from the sink, then our source will be valid
	else if(asi_ingress_snk_ready && asi_ingress_snk_valid)
	begin
		aso_ingress_src_valid <= 1;
		aso_ingress_src_data <= asi_ingress_snk_data;
	end
	else
	begin
		aso_ingress_src_valid <= 0;
	end
end

//
// ST sink egress
//
// nothing to do here

//
// ST source egress
//
always @ (posedge csi_clock_clk or posedge csi_clock_reset)
begin
	if(csi_clock_reset)
	begin
		aso_egress_src_valid	<= 0;
		aso_egress_src_data		<= 0;
	end
	// when the ingress sink goes ready we go valid
	else if(asi_ingress_snk_ready && aso_egress_src_ready && !aso_egress_src_valid)
	begin
		aso_egress_src_valid	<= 1;
		aso_egress_src_data		<= asi_egress_snk_data;
	end
	// we then stay valid as long as we see ready on our interface
	else if(aso_egress_src_ready && aso_egress_src_valid)
	begin
		aso_egress_src_valid	<= 1;
		aso_egress_src_data		<= asi_egress_snk_data;
	end
	else
	begin
		aso_egress_src_valid	<= 0;
	end
end

//
// MM master interface
//
// always read from location ZERO
assign avm_m0_address	= 0;
assign avm_m0_read		= 1'b1;

always @ (posedge csi_clock_clk or posedge csi_clock_reset)
begin
	if(csi_clock_reset)
	begin
		current_fill_level <= 0;
	end
	// update the current_fill_level on each valid readdata
	else if(avm_m0_readdatavalid)
	begin
		current_fill_level <= avm_m0_readdata[15:0];
	end
end

//
// MM slave interface
//
assign avs_s0_readdata = { {16{1'b0}}, trigger_depth };

always @ (posedge csi_clock_clk or posedge csi_clock_reset)
begin
	if(csi_clock_reset)
	begin
		trigger_depth <= TRIGGER_DEPTH;
	end
	// update the current_fill_level on each valid readdata
	else if(avs_s0_write)
	begin
		trigger_depth <= avs_s0_writedata[15:0];
	end
end

endmodule
