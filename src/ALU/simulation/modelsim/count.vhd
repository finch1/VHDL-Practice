library ieee;
use ieee.std_logic_1164.all;

package count_types is
	subtype bit4 is std_logic_vector(7 downto 0);
	subtype bit8 is std_logic_vector(7 downto 0);
end count_types;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.count_types.all;

entity count is port(
	clk, load, clear : in std_logic;
	din : in bit4;
	dout : out bit4);
end count;

architecture synth of count is
	
begin
	process(load, clear, clk, din)
		variable count_val : natural;
	begin
		if load = '1' then
			count_val := to_integer(unsigned(din));
		elsif clear = '1' then
			count_val := 0;
		elsif rising_edge(clk) then
			count_val := count_val + 1;
		end if;
		dout <= std_logic_vector(to_unsigned(count_val, bit4'length));
	end process;
end synth;
			