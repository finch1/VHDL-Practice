-- ----------------------------------------------------------------
-- array1D.vhd
-- 3/06/2018
-- 1d by 1d array with direct output
-- ----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity array1D is port(
	row: in integer range 1 to 3;  
	col: in integer range 0 to 3; 
	slice1: out bit;
	slice2: out bit_vector(1 to 2);
	slice3: out bit_vector(0 to 3);
	slice4: out bit_vector(1 to 3));
end array1D;

architecture array_slice of array1D is
	type onedoned is array(1 to 3) of bit_vector(0 to 3);
	constant table: onedoned:= (	("0001"),
											("1101"),
											('1','0','1','0'));
											
begin
	slice1 <= table(row)(col);
	slice2 <= table(row)(1 to 2);
	slice3 <= table(row)(0 to 3);
	gen: for i in 1 to 3 generate
		slice4(i) <= table(i)(col);
	end generate;
end array_slice;