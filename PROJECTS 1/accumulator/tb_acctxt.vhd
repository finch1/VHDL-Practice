-- ----------------------------------------------------------------
-- tb_acctxt.vhd
-- 12/05/2018
-- simple accumulator with register testbench
-- ----------------------------------------------------------------

library ieee;
library std;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use work.log_pkg.all;

entity tb_acctxt is generic(
	IWIDTH : natural := 3);
end entity;

architecture behavioural of tb_acctxt is

	component acc is generic(
			IWIDTH : natural);
							port(
			clk, rst : in std_logic;
			data_in_a: in std_logic_vector(IWIDTH downto 0); -- input of the design
			data_in_b: in std_logic_vector(IWIDTH downto 0);
			data_out: out std_logic_vector(IWIDTH downto 0)); -- output of the design
	end component;
	
	-- declare inputs and initialize to 0 
	signal clk: std_logic := '0';
	signal reset: std_logic := '0';
	signal data_in_a : std_logic_vector(IWIDTH downto 0);
	signal data_in_b : std_logic_vector(IWIDTH downto 0);
		
	-- declare outputs
	signal data_out : std_logic_vector(IWIDTH downto 0);
	
	-- define the period of clock
	constant CLK_PERIOD : time := 10 ns;
	
	begin
	
		-- instantiate the unit under test
		uut : acc 
					generic map (IWIDTH => IWIDTH)
					port map(
							clk => clk,
							rst => reset,
							data_in_a => data_in_a,
							data_in_b => data_in_b,
							data_out => data_out
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
						constant file_name 	: string := "accwtihregister.txt";
						variable file_status : file_open_status;
						file file_handle 		: text;
						variable file_line 	: line;
						
						-- file read access success
						variable read_ok : boolean;
						
						-- integer value read from the line
						variable val : integer;
						
						-- expected outputs
						variable data_out_exp : std_logic_vector(IWIDTH downto 0);
					begin
						-- testbench message
						log_title("Accumulator with Register Testbench");
						-- open stimulus file
						log("open stimulus file '" & file_name & "'");
						-- file open
						file_open(file_status, file_handle, file_name, read_mode);
						assert file_status = open_ok
							report "error: failed to open the input data file " & file_name severity failure;

						-- initial stimulus
						data_in_a <= (others => '0');
						data_in_b <= (others => '0');
	
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
						
						-- loop through all entries in stim file
						while not endfile(file_handle) loop
							-- read a line
							readline(file_handle, file_line);							
							--parse stim entries
							for i in 1 to 3 loop
								read(file_line, val, read_ok);
								assert read_ok report "Failed to read data!" severity failure;
								case i is 
									when 1 =>
										data_in_a <= std_logic_vector(to_unsigned(val, IWIDTH +1));
									
									when 2 =>
										data_in_b <= std_logic_vector(to_unsigned(val, IWIDTH +1));
										
									when 3 =>
										wait for CLK_PERIOD; -- wait for result from register
										data_out_exp := std_logic_vector(to_unsigned(val, IWIDTH +1));
									
									when others =>
										assert false report "invalid stimulus column!" severity failure;
								end case;
							end loop;
							
							--wait until falling_edge(clk); -- wait for falling edge for data to stablize

							-- check results
							assert(data_out = data_out_exp)
								report "Error: output mismatch! Expected 0x" &
										 to_hstring(std_logic_vector(data_out_exp)) & ", but got 0x" &
										 to_hstring(std_logic_vector(data_out)) severity warning;
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
							
end behavioural;