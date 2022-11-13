-- ----------------------------------------------------------------
-- array2D.vhd
-- 3/06/2018
-- 2d array with direct output
-- ----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity array2D is port(
	row: in integer range 0 to 3;  
	col: in integer range 0 to 4; 
	slice1: out bit;
	slice2: out bit_vector(1 to 4));
end array2D;

architecture array_slice of array2D is
	type twod is array(1 to 3, 1 to 4) of bit;
	constant table: twod:= (	("0001"),
											("1101"),
											('1','0','1','0'));
											
begin
	slice1 <= table(row,col);
	gen: for i in 1 to 4 generate
		slice2(i) <= table(row, i);
	end generate;
end array_slice;