package instructions is
	type instructions is(load, s_right, s_left);
end instructions;

library ieee;
use ieee.std_logic_1164.all;
use work.instructions.all;

entity shifty is port(
	clock		: in std_logic;
	shsel : in instructions;
	serial_in	: in std_logic;
	d		: in std_logic_vector(7 downto 0);
   serial_out	: out std_logic;
   q		: out std_logic_vector(7 downto 0));
end entity;

architecture arch of shifty is
	signal content: std_logic_vector(7 downto 0);
begin
	process(clock)
	begin
		if(rising_edge(clock))then
			case shsel is
			when load => content <= d; --load
			when s_right => content <= serial_in & content(7 downto 1); --shift right, pad with bit from serial_in
			when s_left => content <= content(6 downto 0) & serial_in;  --shift left, pad with bit from serial_in
			when others => null;
			end case;
		end if;
	end process;
	
   q <= content; -- parallel out data extraction when shift reg is full 
	
	
	serial_out <= content(0) when shsel = s_right else
					  content(7) when shsel = s_left else 'Z';
	
end arch;
