-- ----------------------------------------------------------------
-- tbmymult.vhd
--
-- 4/17/2017
--
-- simple multiplier testbench
--
-- ----------------------------------------------------------------

library ieee;
library std;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;

use work.log_pkg.all;
-- ----------------------------------------------------------------

entity tbmymult is generic(
	IWIDTH : natural := 4;
	OWIDTH : natural := IWIDTH *2);
end entity;
-- ----------------------------------------------------------------

architecture tbsimple of tbmymult is

	-- ----------------------------------------------------------------
	-- components
	-- ----------------------------------------------------------------
	
	component mymult is
		generic( IWIDTH : natural;
					OWIDTH : natural);
		
		port( a, b : in  std_logic_vector(IWIDTH -1 downto 0);
				y    : out std_logic_vector(OWIDTH -1 downto 0));
	end component;
	
	-- ----------------------------------------------------------------
	-- parameters
	-- ----------------------------------------------------------------
	--
	-- time delays
	constant strobe : time := 100 ns;
	
	-- ----------------------------------------------------------------
	-- internal signals
	-- ----------------------------------------------------------------
	--
	signal a, b : std_logic_vector(IWIDTH -1 downto 0);
	signal y    : std_logic_vector(OWIDTH -1 downto 0);
	
	-- ----------------------------------------------------------------
	-- stimulus
	-- ----------------------------------------------------------------
	--
	-- read inputs and expected outputs from file
	-- drive the inputs and compare the outputs
begin	
	process
		-- stimulus file 
		constant file_name 	: string := "multinout.txt";
		variable file_status : file_open_status;
		file file_handle 		: text;
		variable file_line 	: line;
		
		-- file read access success
		variable read_ok : boolean;
		
		-- integer value read from the line
		variable val : integer;
		
		-- expected outputs
		variable y_exp	: std_logic_vector(OWIDTH -1 downto 0);
	begin
		-- ----------------------------------------------------------------
		-- testbench message
		-- ----------------------------------------------------------------
		--
		log_title("MULT testbench");
		
		-- ----------------------------------------------------------------
		-- initial stimulus
		-- ----------------------------------------------------------------
		--
		a <= (others => '0');
		b <= (others => '0');
		
		-- delay to start with
		wait for strobe;
		
		-- ----------------------------------------------------------------
		-- open stimulus file
		-- ----------------------------------------------------------------
		--
		log("open stimulus file '" & file_name & "'");
		
		--file open
		file_open(file_status, file_handle, file_name, read_mode);
		assert file_status = open_ok
			report "error: failed to open the input data file " &
					 file_name severity failure;
					 
		-- skip empty lines and ones that start with #
		while not endfile(file_handle) loop
			readline(file_handle, file_line);
			if ( (file_line'length = 0) or 
				((file_line'length > 0) and (file_line(file_line'left) /= '#')) ) then
				exit;
			end if;
		end loop;
		
		-- ----------------------------------------------------------------
		-- apply stimulus
		-- ----------------------------------------------------------------
		--
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
						a <= std_logic_vector(to_signed(val, IWIDTH));
					
					when 2 =>
						b <= std_logic_vector(to_signed(val, IWIDTH));
						
					when 3 =>
						y_exp <= std_logic_vector(to_signed(val, OWIDTH));
					
					when others =>
						assert false report "invalid stimulus column!" severity failure;
				end case;
			end loop;
			
			-- wait half way for stable data
			wait for strobe /2;
			
			-- ----------------------------------------------------------------
			-- check results
			-- ----------------------------------------------------------------
			--
			assert (y = y_exp)
				report "Error: y output mismatch! Expected " &
					to_hstring(y_exp) & "h, but the output was " &
					to_hstring(y) & "h"
				severity warning;

			wait for strobe;
	
		end loop;
		
		log("all stimulus checks passed!");
		
		-- cloase the file 
		file_close(file_handle);
		
		-- simulation complete
		log_title("simulation complete");
		
		--end simulation
		wait;
	
	end process;
end architecture;
	
		
				