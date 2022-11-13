library ieee;
use ieee.std_logic_1164.all;
library floatfixlib;
use floatfixlib.fixed_pkg.all;

entity uns_sub is port(
	data_in_a, data_in_b : in ufixed(3 downto -3);
	data_out : out ufixed(3 downto -4));
end uns_sub;

architecture arch of uns_sub is
begin
	data_out <= data_in_a + data_in_b;
end arch;