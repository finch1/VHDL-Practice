
module statem_mifselect(clk, in, reset, busy, reconfig, reset_count, state, next_state, write_from_rom, count, trigger);

input clk, reset;
input busy;
input [1:0] in;

output [1:0] next_state;
output write_from_rom;
output reconfig;
output [2:0] count;
output trigger;
output [1:0] reset_count;
output [1:0] state;


reg [1:0] state;
reg [1:0] next_state;
reg reconfig;
reg trigger_reg;
reg [2:0] count=3'b000;
reg [1:0] reset_count=2'b00;
reg write_from_rom;
reg trigger;

parameter low=0, med=1, high=2;



always @ (posedge clk or posedge reset) 
	begin
		if (reset) 
		begin
			count <= 0;
			reset_count <=0;
		end
		else
		begin
			if (trigger_reg == 1 && count == 0 && busy == 0) 
			begin
				write_from_rom <= 1'b1;
				count <= count + 1;
			end
			if (count == 1) 
			begin
				write_from_rom <= 1'b0;
				count <= count + 1;
			end  
		
			if (count == 2 && busy == 0) 
			begin
				reconfig <= 1'b1;
				count <= count + 1;
			end
			if (count == 3) 
			begin
				reconfig <= 1'b0;
				count <= count + 1;
			end  
			if (count == 4)
			begin
				count <=0;
			end
		end
		
		
		
		
		
	end	


	

always @(posedge clk or posedge reset)
     begin
          if (reset) 
			begin
               state <= low;
			end
          else
			   state <= next_state;
	end
	

always @ (state or next_state or reset) 
	begin
		if (reset) trigger = 0;
		if ((state  != next_state) && busy == 0)
			trigger = 1;
		else
			trigger=0;
	end
	

always @ (posedge clk or posedge reset)
	begin
		if (reset) 
			trigger_reg <= 0;
		else 
			trigger_reg <= trigger; 
			// Registering trigger so we have it available for one full clock cycle
			// happens immediately - non-blockinga ssignment
	end




always @ (in or reset ) // Actual state values don't matter because 'in' decides which ROM is read.
  begin                 // only change in 'in' matters. 
	case (in)
		2'b00:
			next_state = low;
			
		2'b01:
			next_state = med;
			
		2'b11:
			next_state = high;
		
		default:
			next_state = low;
	endcase
	
  end

endmodule


// in - user input indicating input frequency has changed. 
//     00 => output frequency is 100 MHz
//     01 => output frequency is 200 MHz
//     11 => output frequency is 300 MHz
//     system will default to 00 state. 
// Changes to 'in' when 'busy' is asserted will be ignored. 