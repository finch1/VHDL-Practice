-- ----------------------------------------------------------------
-- coRE.vhd
-- 3/06/2018
-- two's complement with resize
-- ----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity coRE is 
	generic( nbits: positive := 7);
	port( a: in unsigned(nbits -1 downto 0);
			b: in unsigned(nbits -1 downto 0);
			y: out std_logic_vector(nbits downto 0));
end coRE;

architecture arch of coRE is
	signal comp_temp : unsigned(nbits -1 downto 0);
	constant inc : unsigned(nbits -1 downto 0) := "0000001";
begin
	comp_temp <= (not a) + inc;
	y <= std_logic_vector(resize(signed(b), nbits+1) + resize(signed(comp_temp), nbits+1));
end arch;