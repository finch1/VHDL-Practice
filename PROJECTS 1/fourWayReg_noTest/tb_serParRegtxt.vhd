-- ----------------------------------------------------------------
-- tb_serParRegtxt.vhd
-- 3/06/2018
-- shift left - shift right - parallel in - parallel out
-- ----------------------------------------------------------------

library ieee;
library std;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use work.instructions_pkg.all;
use work.log_pkg.all;

entity tb_addertxt is 
end entity;

architecture behavioural of tb_addertxt is

	-- component declaration for the unit under testbench
	component serParReg is port(
		clk: in std_logic;
		shsel: in instructions;
		serial_in: in std_logic;
		din : in std_logic_vector(7 downto 0);
		serial_out: out std_logic;
		dout : out std_logic_vector(7 downto 0));
	end component;
	
	-- declare inputs and initialize to 0
	signal clk : std_logic := '0';
	signal shsel : instructions := load;
	signal serial_in: std_logic := '0';
	signal din : std_logic_vector(7 downto 0) := (others => '0');
	
	-- declare outputs
	signal serial_out: std_logic;
	signal dout : std_logic_vector(7 downto 0);
	
	-- define the period of clock
	constant CLK_PERIOD : time := 10 ns;
	
	begin
	
		-- instantiate the unit under test
		uut : serParReg port map(
							clk 			=> clk,
							shsel 		=> shsel,
							serial_in 	=> serial_in,
							din 			=> din,
							serial_out 	=> serial_out,
							dout 			=> dout);
						
		-- clock process definitions(clock with 50% duty cycle)
		clk_process: 	process
							begin
								clk <= '0';
								wait for CLK_PERIOD /2; -- for half of clock period stay at 0
								clk <= '1';
								wait for CLK_PERIOD /2; -- for next half of clock period stay at 1
							end process;
												
		-- stimulus process
		stim_proc: process
						-- stimulus file
						constant file_name 	: string := "fourWayReg.txt";
						variable file_status : file_open_status;
						file file_handle 		: text;
						variable file_line 	: line;
						
						-- file read access success
						variable read_ok : boolean;
						
						-- integer value read from the line
						variable val : integer;
						
						-- expected outputs
						variable serial_out_exp: std_logic;
						variable dout_exp : std_logic_vector(7 downto 0);
					begin
						-- testbench message
						log_title("Four Bit Counter Testbench");
						
						-- open stimulus file
						log("open stimulus file '" & file_name & "'");
						
						-- file open
						file_open(file_status, file_handle, file_name, read_mode);
						assert file_status = open_ok
							report "error: failed to open the input data file " & file_name severity failure;
							
						wait for CLK_PERIOD; -- wait for data to stabilize
							
						-- skip empty lines and ones that start with #
						while not endfile(file_handle) loop
							readline(file_handle, file_line);
							if((file_line'length = 0) or ((file_line'length > 0) and (file_line(file_line'left) /= '#'))) then
								exit;
							end if;
						end loop;
						
						-- apply stimulus
						log("apply stimulus");						
						
						-- loop through all entries in stim file
						while not endfile(file_handle) loop
							-- read a line
							readline(file_handle, file_line);							
							
							-- Parse the stimulus entries
							for i in 1 to 5 loop
								read(file_line, val, read_ok);
								assert read_ok
									report "Error: number of packets read failed!"
								severity failure;
								case i is
									when 1 =>
										shsel <= decode(val);
									when 2 =>
										serial_in <= to_stdlogic(val);
									when 3 =>
										din <= std_logic_vector(to_unsigned(val, 8));
									when 4 =>
										serial_out_exp := to_stdlogic(val);
									when 5 =>
										dout_exp  := std_logic_vector(to_unsigned(val, 8));
									when others =>
										assert false
											report "Error: invalid stimulus column!"
											severity failure;
								end case;
							end loop;			
							wait until falling_edge(clk); -- wait for falling edge for data to stablize
							-- Check the output vs expected
							assert (serial_out = serial_out_exp)
								report "Error: serial_out output mismatch! Expected " &
									to_hchar(serial_out_exp) & " h, but the output was " &
									to_hchar(serial_out) & " h"
								severity warning;
								
							assert (dout = dout_exp)
								report "Error: dout output mismatch! Expected " &
									to_hstring(dout_exp) & " h, but the output was " &
									to_hstring(dout) & " h"
								severity warning;
						end loop;
						
						log("all stimulus checks passed!");
						
						-- close the file
						file_close(file_handle);
						
						-- simulation complete
						log_title("simulation complete");
						
						-- end simulation
						assert false
						report "simulation ended"
						severity failure; -- end simulation
						
					end process;
end architecture;			