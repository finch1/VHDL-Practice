-- ----------------------------------------------------------------
-- scalar.vhd
-- 3/06/2018
-- scalar attributes, with select example
-- ----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity scalar is port(
	control: in integer range 0 to 6;
	dout: out std_logic_vector(2 downto 0);
	x: in integer range 0 to 3;		
	y1, y2, y3, y4, y5: out bit);
end scalar;

architecture arch of scalar is
	type color is (red, green, blue); -- enum
	signal z: color;
begin
	z <= red when x = 0 else green when x = 1 else blue;
	y1 <= '1' when color'val(x)= blue else '0'; 		-- T'Val(s) Base type of T value at position x in T (x is integer)
	y2 <= '1' when color'pos(blue)=x else '0'; 		-- T'Pos(s) Universal integer Position number of s in T
	y3 <= '1' when color'rightof(z)= blue else '0';	-- T'Rightof(s) Base type of T Value at position one to the right of s in T
	y4 <= '1' when color'pred(z)=green else '0';		-- T'Pred(s) Base type of T Value at position one less than s in T
	y5 <= '1' when color'pred(green)=z else '0';
	
	with control select
	dout <= 	"000" when 0 | 1,
				"010" when 2 to 4,
				"Z--" when others;
end arch;

