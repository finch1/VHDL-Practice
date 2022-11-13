-- ----------------------------------------------------------------
-- forGen.vhd
-- 3/06/2018
-- for loop generate example. generate multiple blocks. 
-- ----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity forGen is port(
	a, b: in bit_vector(3 downto 0);
	x: out bit_vector(3 downto 0));
end forGen;

architecture arch of forGen is
begin
	gen: for i in a'reverse_range generate
		x(i) <= a(i) xor b(3-i);
	end generate;
end arch;
