

--full testbench
--testbench for counter
--reads from file "counter.txt"

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
use work.count_types.all;

entity testbench is end;

architecture full of testbench is

	--component declaration for counter
	component count port(
		clk, load, clear : in std_logic;
		din : in bit4;
		dout : out bit4);
	end component;

	signal clk, load, clear : std_logic;
	signal din : bit4;
	signal dout: bit4;
begin		

--provide stimulus and check the result. 
	test: process
		--related to the component
		variable tmpclk, tmpld, tmpup_dwn, tmpclk_en : bit;
		variable tmpqout, tmpdin : integer;
		variable tmpqout_8, tmpdin_8 : bit8;
		
		--related to file I/O
		file vector_file : text open read_mode is "counter.txt";
		variable my_line : line; --holds data from file
		variable my_real : integer; --holds data to be processed transfered from file		
		variable vector_time : time; --holds time from file
		variable good_number, good_val : boolean;
		variable space : character;
	begin
		while not endfile(vector_file) loop
			readline(vector_file, my_line);
			--read the time from the beginning of the line
			--skip the line if it doesn't start with a number
			read(my_line, my_real, good => good_number); --good = former - good_number = actual. to return the value.
			
			-- the next statement is used to prematurely terminate the current iteration of a while, for or infinite loop.
			next when not good_number; --test a boolean condition directly. 
			
			vector_time := my_real * 1 ns; --convert real number to time
			
			if now < vector_time then --wait until the vector time
				wait for vector_time - now;
			end if;
			
			read(my_line, space); -- skip a space and ignore it
			
			--read clk value
			read(my_line, tmpclk, good => good_val);
			assert good_val report "bad clk value";
			
			--read ld value
			read(my_line, tmpld, good => good_val);
			assert good_val report "bad ld value";
			
			--read up_dwn value
			read(my_line, tmpup_dwn, good => good_val);
			assert good_val report "bad up_dwn value";
			
			--read clk_en value
			read(my_line, tmpclk_en, good => good_val);
			assert good_val report "bad clk_en value";
			
			read(my_line, space); -- skip a space
			
			--read din value
			read(my_line, tmpdin, good => good_val);
			tmpdin_8 := std_logic_vector(to_unsigned(tmpdin, bit8'length));
			assert good_val report "bad din value";
			
			
			read(my_line, space); -- skip a space and ignore it
			
			--the difference in the file is below			--read good output value
			read(my_line, tmpqout, good => good_val);
			tmpqout_8 := std_logic_vector(to_unsigned(tmpqout, bit8'length));
			assert good_val report "bad qout value";
			
			--compare outputs
		clk  <= to_stdulogic(tmpclk);
		load <= to_stdulogic(tmpup_dwn);
		clear <= to_stdulogic(tmpclk_en);
		din <= tmpdin_8;
		
		end loop;
		assert false report "test complete";
		wait;
	
	end process;
	
		--instance the component
	uut: count port map( clk => clk,
								load => load,
								clear => clear,
								din => din,
								dout => dout);
	
end full;
	

		