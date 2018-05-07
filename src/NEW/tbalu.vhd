-- ----------------------------------------------------------------
-- tbalu.vhd
--
-- 5/20/2017
--
-- alu testbench
--
-- ----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

use work.log_pkg.all;

-- ----------------------------------------------------------------

entity tbalu is 
	generic(	iwidth : natural := 16;
				owidth : natural := 16);
end entity;

architecture tbalu_arch of tbalu is

	-- ------------------------------------------------------------
	-- components
	-- ------------------------------------------------------------
	component alu is
		generic( iwidth : natural;
					owidth : natural);
		 
		 port( opcode : in  std_logic_vector(11 downto 0);
				 
				 a, b   : in  std_logic_vector(iwidth -1 downto 0);	       
				 
				 flags  : out std_logic_vector(3 downto 0);
				 
				 compout: out std_logic_vector(6 downto 0);
				 y      : out std_logic_vector(owidth -1 downto 0));
	end component;

	
	-- ------------------------------------------------------------
	-- parameters
	-- ------------------------------------------------------------
	-- time delay between value change
	constant strobe : time := 5 ns;
	
	-- ------------------------------------------------------------
	-- internal signals
	-- ------------------------------------------------------------
	
	signal opcode : std_logic_vector(11 downto 0);
				 
	signal a, b   : std_logic_vector(iwidth -1 downto 0);	       
				 
	signal flags  : std_logic_vector(3 downto 0);
				 
	signal compout: std_logic_vector(6 downto 0);
	signal y      : std_logic_vector(owidth -1 downto 0);	
	

begin
	-- ------------------------------------------------------------
	-- component under test
	-- ------------------------------------------------------------
	
	cut : alu
		generic map(iwidth => iwidth,
						owidth => owidth)
		
		port map   (opcode => opcode,
						a 		 => a,
						b 		 => b,
						flags  => flags,
						compout => compout,
						y 		 => y);
						
	-- ----------------------------------------------------------
	-- stimulus
	-- ----------------------------------------------------------
	
	process
	
		-- stimulus file details
		constant file_name 	: string := "aluout.txt";	
		variable file_status	: file_open_status;
		file 	   file_handle	: text;
		variable file_line	: line;
		
		-- file read access success
		variable read_ok : boolean;
		
		-- integer value read from the line
		variable val : integer;
		
		-- skip tabs
		variable tab : character;
		
		-- expected alu result
		variable alu_expctd : std_logic_vector(owidth -1 downto 0);
		
		-- expected input compare result
		variable comp_expctd : std_logic_vector(6 downto 0);
				
		-- expected flags result
		variable flgs_expctd : std_logic_vector(3 downto 0);		
	
	begin
		-- ----------------------------------------------------------
		-- testbench message
		-- ----------------------------------------------------------
		
		log_title("ALU testbench");
		
		-- ----------------------------------------------------------
		-- default stimulus
		-- ----------------------------------------------------------		
	
		alu_expctd	:= (others => '0');
		comp_expctd	:= (others => '0');
		flgs_expctd	:= (others => '0');
		
		-- put delay between stimulus
--		wait for strobe;
		
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
			for i in 1 to 8 loop
				read(file_line, val, read_ok);
				assert read_ok
					report "error: read from line"
					severity failure;
				case i is 
					when 1 =>
						opcode(11 downto 8) <= std_logic_vector(to_unsigned(val,iwidth /4));
						
					when 2 =>
						opcode(7 downto 4) <= std_logic_vector(to_unsigned(val,iwidth /4));
						
					when 3 =>
						opcode(3 downto 0) <= std_logic_vector(to_unsigned(val,iwidth /4));	
						
					when 4 => 
						a <= std_logic_vector(to_signed(val,iwidth));
						
					when 5 => 
						b <= std_logic_vector(to_signed(val,iwidth));	
						
					when 6 => 
						alu_expctd := std_logic_vector(to_signed(val,owidth));
						
					when 7 => 
						comp_expctd := std_logic_vector(to_unsigned(val,7));		
						 
					when 8 => 
						flgs_expctd := std_logic_vector(to_unsigned(val,4));	
						
					when others => 
						assert false 
							report "error: invalid input"
							severity failure;
				end case;
			end loop;
			
			-- delay after stable result to check output. 
			wait for strobe;
			
			assert alu_expctd = y
				report "error: ALU doesn't match!"
				severity warning;
				
			assert comp_expctd = compout
				report "error: COMPARE doesn't match!"
				severity warning;
			
			assert flgs_expctd(3) = flags(3)
				report "error: Carry FLAG doesn't match!"
				severity warning;
				
			assert flgs_expctd(2) = flags(2)
				report "error: Overflow FLAG doesn't match!"
				severity warning;

			assert flgs_expctd(0) = flags(0)
				report "error: Zero FLAG doesn't match!"
				severity warning;				
				
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