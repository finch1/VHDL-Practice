-- ----------------------------------------------------------------
-- tbmyclshift.vhd
--
-- 4/30/2016
--
-- simple compare testbench
--
-- ----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

library lpm;
use lpm.all;

use work.log_pkg.all;

-- ----------------------------------------------------------------

entity tbmyclshift is 
end entity;

architecture tbmycomp_arch of tbmyclshift is

	-- ------------------------------------------------------------
	-- components
	-- ------------------------------------------------------------

	component lpm_clshift is
	generic( lpm_width		: natural;
				lpm_widthdist	: natural);
				
	port(	data		: in std_logic_vector (3 downto 0);
			direction: in std_logic ;
			distance	: in std_logic_vector (1 downto 0);
			result	: out std_logic_vector (3 downto 0));
	end component;
	
	-- ------------------------------------------------------------
	-- parameters
	-- ------------------------------------------------------------
	-- time delay between value change
	constant strobe : time := 5 ns;
	
	-- ------------------------------------------------------------
	-- internal signals
	-- ------------------------------------------------------------
	
	signal data		 : std_logic_vector (3 downto 0);
	signal direction: std_logic;
	signal distance : std_logic_vector (1 downto 0);
	signal result	 : std_logic_vector (3 downto 0);
	signal my_expec : std_logic_vector (3 downto 0);

begin
	-- ------------------------------------------------------------
	-- component under test
	-- ------------------------------------------------------------
	
	lpm_clshift_component : lpm_clshift
	generic map (lpm_width => 4,
					 lpm_widthdist => 2)
	
	port map (data => data,
				 direction => direction,
		       distance => distance,
		       result => result);
						
	-- ----------------------------------------------------------
	-- stimulus
	-- ----------------------------------------------------------
	
	process
	
		-- stimulus file details
		constant file_name 	: string := "shftout.txt";	
		variable file_status	: file_open_status;
		file 	   file_handle	: text;
		variable file_line	: line;
		
		-- file read access success
		variable read_ok : boolean;
		
		-- integer value read from the line
		variable val : integer;
		
		-- expected output
		variable out_exp : std_logic_vector(3 downto 0);
		
		-- skip tabs
		variable tab : character;
	
	begin
		-- ----------------------------------------------------------
		-- testbench message
		-- ----------------------------------------------------------
		
		log_title("Logic Shift Register Testbench");
		
		-- ----------------------------------------------------------
		-- default stimulus
		-- ----------------------------------------------------------
		
		data 		 <= (others => '0');
		distance  <= (others => '0');
		direction <= '0';
		
		-- put delay between stimulus
		wait for strobe;
		
		-- ----------------------------------------------------------
		-- open stimulus file
		-- ----------------------------------------------------------
		
		log("open stimulus file'" & file_name & "'");
		
		-- open the file
		file_open(file_status, file_handle, file_name, read_mode);
		assert file_status = open_ok
			report "error: failed to open the " &
				"input data file " & file_name
			severity failure;
			
		-- skip empty lines and lines that start with #
		while not endfile(file_handle) loop
			readline(file_handle, file_line);
			if ( (file_line'length = 0) or
			    ((file_line'length > 0) and
			     (file_line(file_line'left) /= '#')) ) then
				exit;
			end if;
		end loop;

		-- ----------------------------------------------------------
		-- open stimulus file
		-- ----------------------------------------------------------
		
		log("apply stimulus");
		
		-- loop through all the entries in the stimulus file
		while not endfile(file_handle) loop
			--read a line
			readline(file_handle, file_line);
			
			--parse the stimulus packet
			for i in 1 to 4 loop
				read(file_line, val, read_ok);
				assert read_ok
					report "error: number if packets read failed!"
					severity failure;
				case i is 
					when 1 =>
						data <= std_logic_vector(to_signed(val,4));
					when 2 => 
						distance <= std_logic_vector(to_unsigned(val,2));
					when 3 => 
						direction <= to_stdlogic(val);
					when 4 =>
						out_exp := std_logic_vector(to_unsigned(val,4));
					
					when others => 
						assert false 
							report "error: invalid input"
							severity failure;
				end case;
			end loop;
			my_expec <= out_exp;
			-- delay after stable result to check output. 
			wait for strobe;
			
			assert out_exp = result
				report "error: result don't match!" severity warning;		
			
			wait for strobe;
		end loop;
		
		log("all stimulus checks passed!");
		
		-- close file
		file_close(file_handle);
		
		-- ----------------------------------------------------------
		-- stimulus complete
		-- ----------------------------------------------------------
		
		log_title("simulation complete");
		
		-- ----------------------------------------------------------
		-- end simulation
		-- ----------------------------------------------------------
		
		wait;
	end process;
end architecture;