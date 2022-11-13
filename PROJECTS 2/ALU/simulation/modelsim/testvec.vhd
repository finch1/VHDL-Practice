library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

entity testvec is 
end entity;

architecture stimulus of testvec is
	function str_to_stdvec(inp: string) return std_logic_vector is
		variable temp : std_logic_vector(inp'range) := (others => 'X');
	begin
		for i in inp'range loop
			if inp(i) = '1' then
				temp(i) := '1';
			elsif inp(i) = '0' then
				temp(i) := '0';
			end if;
		end loop;
		return temp;
	end function str_to_stdvec;
	
	function stdvec_to_str(inp: std_logic_vector) return string is
		variable temp : string(inp'left +1 downto 1) := (others => 'X');
	begin
		for i in inp'reverse_range loop
			if inp(i) = '1' then
				temp(i +1) := '1';
			elsif inp(i) = '0' then
				temp(i +1) := '0';
			end if;
		end loop;
		return temp;
	end function stdvec_to_str;
	
	constant period : time := 50 ns;
	
	signal clr : std_logic;
	signal clk : std_logic;
	signal load : std_logic;
	signal data_in : std_logic_vector(15 downto 0);
	signal done : std_logic := '0';
	
begin

	clock : process
		variable c : std_logic := '0';
	begin
		while done = '0' loop
			wait for period /2;
			c := not c;
			clk <= c;
		end loop;
	end process;
	
	read_input : process
		file vector_file : text;
		
		variable stimulus_in : std_logic_vector(33 downto 0);
		variable s_expected  : std_logic_vector(15 downto 0);
		variable str_stimulus_in : string(34 downto 1);
		variable err_cnt : integer := 0;
		variable file_line : line;
		
	begin
		file_open(vector_file, "tfib93.vec", read_mode);
		wait until rising_edge(clk);
		while not endfile(vector_file) loop
			readline(vector_file, file_line);
			read(file_line, str_stimulus_in);
			assert(false) report "vector:" & str_stimulus_in severity note;
			stimulus_in := str_to_stdvec(str_stimulus_in);
			
			wait for 1 ns;
			
			--get input side of vector
			clr <= stimulus_in(33);
			load <= stimulus_in(32);
			data_in <= stimulus_in(31 downto 16);
			
			--put output side (expected values) into a variable...
			s_expected := stimulus_in(15 downto 0);
			
			wait until falling_edge(clk);
		end loop;
		
		file_close(vector_file);
		done <= '1';
	end process;
end stimulus;
			
		