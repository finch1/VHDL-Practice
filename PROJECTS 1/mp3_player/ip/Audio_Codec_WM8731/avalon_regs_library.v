module avalon_mm_write_reg_32
(
  // Avalon Slave
  clk,
  reset_n,
  avalon_slave_address_en,
  avalon_slave_writedata,
  avalon_slave_write,
  avalon_slave_chipselect,
  avalon_slave_byteenable,
  
  // Raw data
  reg_data_out
);

// Avalon Slave
input clk;
input reset_n;
input avalon_slave_address_en;
input [3:0] avalon_slave_byteenable;
input avalon_slave_chipselect;
input avalon_slave_write;
input [31:0] avalon_slave_writedata;

output [31:0] reg_data_out;

reg [31:0] register_data;

	// 7:0
	always @(posedge clk or negedge reset_n)
	begin
		if (~reset_n)
		  register_data[7:0] <= 0;
		else if ( avalon_slave_chipselect & avalon_slave_write & 
		        ( avalon_slave_address_en ) & avalon_slave_byteenable[0] )
		  register_data[7:0] <= avalon_slave_writedata[7:0];
		else 
		  register_data[7:0] <= register_data[7:0];
	end
	
	// 15:8
	always @(posedge clk or negedge reset_n)
	begin
		if (~reset_n)
		  register_data[15:8] <= 0;
		else if ( avalon_slave_chipselect & avalon_slave_write & 
		        ( avalon_slave_address_en ) & avalon_slave_byteenable[1] )
		  register_data[15:8] <= avalon_slave_writedata[15:8];
		else 
		  register_data[15:8] <= register_data[15:8];
	end
	
	// 23:16
	always @(posedge clk or negedge reset_n)
	begin
		if (~reset_n)
		  register_data[23:16] <= 0;
		else if ( avalon_slave_chipselect & avalon_slave_write & 
		        ( avalon_slave_address_en ) & avalon_slave_byteenable[2] )
		  register_data[23:16] <= avalon_slave_writedata[23:16];
		else 
		  register_data[23:16] <= register_data[23:16];
	end
	
	// 31:24
	always @(posedge clk or negedge reset_n)
	begin
		if (~reset_n)
		  register_data[31:24] <= 0;
		else if ( avalon_slave_chipselect & avalon_slave_write & 
		        ( avalon_slave_address_en ) & avalon_slave_byteenable[3] )
		  register_data[31:24] <= avalon_slave_writedata[31:24];
		else 
		  register_data[31:24] <= register_data[31:24];
	end
	
	// For reading
	assign reg_data_out = register_data[31:0];

endmodule


module avalon_mm_read_write_reg_32
(
  // Avalon Slave
  clk,
  reset_n,
  avalon_slave_address_en,
  avalon_slave_writedata,
  avalon_slave_write,
  avalon_slave_read,
  avalon_slave_chipselect,
  avalon_slave_byteenable,
  
  // Raw data
  reg_data_in,
	reg_data_set_en,
  reg_data_out
);

// Avalon Slave
input clk;
input reset_n;
input avalon_slave_address_en;
input [3:0] avalon_slave_byteenable;
input avalon_slave_chipselect;
input avalon_slave_write;
input [31:0] avalon_slave_writedata;
input avalon_slave_read;

input [31:0]  reg_data_in;
input [31:0]  reg_data_set_en;
output [31:0] reg_data_out;

wire [3:0] byte_set_en;  // This is a temp signal used to set the register seperate from avalon.

reg [31:0] register_data;

integer i;

	assign byte_set_en[0] = reg_data_set_en[0]  | reg_data_set_en[1]  | reg_data_set_en[2]  | reg_data_set_en[3]  | reg_data_set_en[4]  | reg_data_set_en[5]  | reg_data_set_en[6]  | reg_data_set_en[7]; 
	assign byte_set_en[1] = reg_data_set_en[8]  | reg_data_set_en[9]  | reg_data_set_en[10] | reg_data_set_en[11] | reg_data_set_en[12] | reg_data_set_en[13] | reg_data_set_en[14] | reg_data_set_en[15]; 
	assign byte_set_en[2] = reg_data_set_en[16] | reg_data_set_en[17] | reg_data_set_en[18] | reg_data_set_en[19] | reg_data_set_en[20] | reg_data_set_en[21] | reg_data_set_en[22] | reg_data_set_en[23]; 
	assign byte_set_en[3] = reg_data_set_en[24] | reg_data_set_en[25] | reg_data_set_en[26] | reg_data_set_en[27] | reg_data_set_en[28] | reg_data_set_en[29] | reg_data_set_en[30] | reg_data_set_en[31]; 

	// 7:0
	always @(posedge clk or negedge reset_n)
	begin
		if (~reset_n)
		  register_data[7:0] <= 0;
		else if ( avalon_slave_chipselect & avalon_slave_write & 
		        ( avalon_slave_address_en ) & avalon_slave_byteenable[0] )
		  register_data[7:0] <= avalon_slave_writedata[7:0];
		else if ( byte_set_en[0] )
    begin
			for( i = 0; i <= 7; i = i + 1 )
				if( reg_data_set_en[i] )
				  register_data[i] <= reg_data_in[i];
    end
		else 
		  register_data[7:0] <= register_data[7:0];
	end
	
	// 15:8
	always @(posedge clk or negedge reset_n)
	begin
		if (~reset_n)
		  register_data[15:8] <= 0;
		else if ( avalon_slave_chipselect & avalon_slave_write & 
		        ( avalon_slave_address_en ) & avalon_slave_byteenable[1] )
		  register_data[15:8] <= avalon_slave_writedata[15:8];
		else if ( byte_set_en[1] )
		begin
			for( i = 8; i <= 15; i = i + 1 )
				if( reg_data_set_en[i] ) 
				  register_data[i] <= reg_data_in[i];
		end
		else 
		  register_data[15:8] <= register_data[15:8];
	end
	
	// 23:16
	always @(posedge clk or negedge reset_n)
	begin
		if (~reset_n)
		  register_data[23:16] <= 0;
		else if ( avalon_slave_chipselect & avalon_slave_write & 
		        ( avalon_slave_address_en ) & avalon_slave_byteenable[2] )
		  register_data[23:16] <= avalon_slave_writedata[23:16];
		else if ( byte_set_en[2] )
		begin
			for( i = 16; i <= 23; i = i + 1 )
				if( reg_data_set_en[i] ) 
				  register_data[i] <= reg_data_in[i];
		end
		else 
		  register_data[23:16] <= register_data[23:16];
	end
	
	// 31:24
	always @(posedge clk or negedge reset_n)
	begin
		if (~reset_n)
		  register_data[31:24] <= 0;
		else if ( avalon_slave_chipselect & avalon_slave_write & 
		        ( avalon_slave_address_en ) & avalon_slave_byteenable[3] )
		  register_data[31:24] <= avalon_slave_writedata[31:24];
		else if ( byte_set_en[3] )
		begin
			for( i = 24; i <= 31; i = i + 1 )
				if( reg_data_set_en[i] ) 
				  register_data[i] <= reg_data_in[i];
		end
		else 
		  register_data[31:24] <= register_data[31:24];
	end
	
	// For reading
	assign reg_data_out = register_data[31:0];

endmodule
