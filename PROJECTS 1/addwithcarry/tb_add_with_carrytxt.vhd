-- ----------------------------------------------------------------
-- tb_add_with_carrytxt.vhd
-- 13/05/2018
-- simple up counter testbench
-- https://alteraforum.com/forum/showthread.php?t=1769
-- ----------------------------------------------------------------

library ieee;
library std;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use work.log_pkg.all;

entity tb_addertxt is 
end entity;

architecture behavioural of tb_addertxt is

	-- component declaration for the unit under testbench
	component add_with_carry is port(
		a, b : in std_logic_vector(3 downto 0); -- input of the design 
		sum : out std_logic_vector(3 downto 0); -- output of the design 
		cout : out std_logic);
	end component;
	
	-- declare inputs and initialize to 0
	signal a : std_logic_vector(3 downto 0) := (others => '0');
	signal b : std_logic_vector(3 downto 0) := (others => '0');
	
	-- declare outputs
	signal sum : std_logic_vector(3 downto 0);
	signal cout : std_logic;
	
	-- define the period of clock
	constant CLK_PERIOD : time := 10 ns;
	
	begin
	
		-- instantiate the unit under test
		uut : add_with_carry port map(
							a => a,
							b => b,
							sum => sum,
							cout => cout
						);
																	
		-- stimulus process
		stim_proc: process
							-- stimulus file
							constant IWIDTH		: integer := 4;
							constant file_name 	: string := "accwtihcarry.txt";
							variable file_status : file_open_status;
							file file_handle 		: text;
							variable file_line 	: line;
							
							-- file read access success
							variable read_ok : boolean;
							
							-- integer value read from the line
							variable val : integer;
							
							-- expected outputs
							variable sum_exp : std_logic_vector(3 downto 0);
							variable cout_exp : std_logic;
						begin
							-- testbench message
							log_title("Add with Carry Testbench");
							-- open stimulus file
							log("open stimulus file '" & file_name & "'");
							-- file open
							file_open(file_status, file_handle, file_name, read_mode);
							assert file_status = open_ok
								report "error: failed to open the input data file " & file_name severity failure;
								
							-- skip empty lines and ones that start with #
							while not endfile(file_handle) loop
								readline(file_handle, file_line);
								if((file_line'length = 0) or ((file_line'length > 0) and (file_line(file_line'left) /= '#'))) then
									exit;
								end if;
							end loop;
							
							-- apply stimulus
							log("apply stimulus");	
							-- wait for stable data
							wait for CLK_PERIOD;					
						
							-- loop through all entries in stim file
							while not endfile(file_handle) loop
								-- read a line
								readline(file_handle, file_line);							
								--parse stim entries
								for i in 1 to 4 loop
									read(file_line, val, read_ok);
									assert read_ok report "Failed to read data!" severity failure;
									case i is 
										when 1 =>
											a <= std_logic_vector(to_unsigned(val, IWIDTH));
										
										when 2 =>
											b <= std_logic_vector(to_unsigned(val, IWIDTH));
											
										when 3 =>
											sum_exp := std_logic_vector(to_unsigned(val, IWIDTH));
											
										when 4 =>
											cout_exp := to_stdlogic(val);
										
										when others =>
											assert false report "invalid stimulus column!" severity failure;
									end case;
								end loop;
								
								-- wait for stable data
								wait for CLK_PERIOD;

								-- check results
								assert(sum = sum_exp)
									report "Error: output mismatch! Expected 0x" &
											 to_hstring(sum_exp) & ", but got 0x" &
											 to_hstring(sum) severity warning;
											 
								assert(cout = cout_exp)
									report "Error: carry mismatch!" severity warning;
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
			