--A signed magnitude adder performs an addition operation in this format:
--	-	if the two operands have the same signs, add the magnitudes and keep the sign.
--	-  if the two operands have different signs, subtract the smaller magnitude from
--		the large one and keep the sign of the numner that has the larger magnitude.
--One way of doing it is in two stages: First stage sorts the two inputs according to 
--their magnitudes and routes them to the max and min signals. The second stage examines 
--the signs and performs addition or subtraction on the magnitude accordingly. Note that 
--since the two numbers have been sorted, the magnituse of max is always larger then that 
--of min and the final sign is the sign max. Also note that the relevant magnituse signals 
--are declared as unsigned to facilitate the arithmetic operation, and type conversions 
--are performed at the beginning and end of the code.
		
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package define is
	constant n : integer := 4;
	subtype digit is std_logic_vector(n-1 downto 0);
	subtype size is unsigned(n-2 downto 0);
end define;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.define.all;

entity sign_mag_add is port(
	a, b: in digit;
	sum: out digit);
end entity;

architecture arch of sign_mag_add is
	signal mag_a, mag_b: size;
	signal mag_sum, max, min : size;
	signal sign_a, sign_b, sign_sum: std_logic;	
begin
	mag_a <= unsigned(a(n-2 downto 0));
	mag_b <= unsigned(b(n-2 downto 0));
	sign_a <= a(n-1);
	sign_b <= b(n-1);
	--sort according to magnitude
	process(mag_a, mag_b, sign_a, sign_b)
	begin
		if mag_a > mag_b then
			max <= mag_a;
			min <= mag_b;
			sign_sum <= sign_a;
		else	
			max <= mag_b;
			min <= mag_a;
			sign_sum <= sign_b;
		end if;
	end process;
	-- add/sub magnitude
	mag_sum <= max + min when sign_a = sign_b else
				  max - min;
	--form output
	sum <= std_logic_vector(sign_sum & mag_sum);
end arch;
