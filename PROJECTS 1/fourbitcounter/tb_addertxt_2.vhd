-- 12/05/2018
-- simple up counter testbench
-- https://alteraforum.com/forum/showthread.php?t=1769
-- ----------------------------------------------------------------

library ieee;
library std;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use work.log_pkg.all;

entity tb_addertxt_2 is 
end entity;

architecture behavioural of tb_addertxt_2 is

	-- component declaration for the unit under testbench
	component adder is port(
		clk : in std_logic;
		reset : in std_logic;
		count : out unsigned(3 downto 0));
	end component;
	
	-- declare inputs and initialize to 0
	signal clk : std_logic := '0';
	signal reset : std_logic := '0';
	
	-- declare outputs
	signal count : unsigned(3 downto 0);
	
	-- define the period of clock
	constant CLK_PERIOD : time := 10 ns;
	
	begin
	
		-- instantiate the unit under test
		uut : adder port map(
							clk => clk,
							reset => reset,
							count => count
						);
						
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
						constant file_name 	: string := "fourbitcountertest.txt";
						variable file_status : file_open_status;
						file file_handle 		: text;
						variable file_line 	: line;
						
						-- file read access success
						variable read_ok : boolean;
						
						-- integer value read from the line
						variable val : integer;
						
						-- expected outputs
						variable count_exp : unsigned(3 downto 0);
					begin
						-- testbench message
						log_title("Four Bit Counter Testbench");
						-- open stimulus file
						log("open stimulus file '" & file_name & "'");
						-- file open
						file_open(file_status, file_handle, file_name, read_mode);
						assert file_status = open_ok
							report "error: failed to open the input data file " & file_name severity failure;
							
						wait for CLK_PERIOD; -- wait for 10 clock cycles
						reset <= '1'; -- apply reset for 2 clock cycles
						wait for CLK_PERIOD *2;
						reset <= '0'; -- pull down reset and let counter run
							
						-- skip empty lines and ones that start with #
						while not endfile(file_handle) loop
							readline(file_handle, file_line);
							if((file_line'length = 0) or ((file_line'length > 0) and (file_line(file_line'left) /= '#'))) then
								exit;
							end if;
						end loop;
						
						-- apply stimulus
						log("apply stimulus");						
						wait until rising_edge(clk); -- wait for counter output on rising edge
						
						-- loop through all entries in stim file
						while not endfile(file_handle) loop
							-- read a line
							readline(file_handle, file_line);							
							--parse stim entries
							read(file_line, val, read_ok);
							wait until falling_edge(clk); -- wait for falling edge for data to stablize
							assert read_ok report "Failed to read data!" severity failure;
							count_exp := to_unsigned(val, 4);
							-- check results
							assert(count = count_exp)
								report "Error: output mismatch! Expected 0x" &
										 to_hstring(std_logic_vector(count_exp)) & ", but got 0x" &
										 to_hstring(std_logic_vector(count)) severity warning;
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