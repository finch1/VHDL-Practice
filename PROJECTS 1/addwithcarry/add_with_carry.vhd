-- ----------------------------------------------------------------
-- add_with_carry.vhd
-- 13/05/2018
-- simple adder with carry
-- ----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_with_carry is port(
	a, b : in std_logic_vector(3 downto 0); -- input of the design 
	sum : out std_logic_vector(3 downto 0); -- output of the design 
	cout : out std_logic);
end add_with_carry;

architecture const_arch of add_with_carry is
	-- internal signals
	constant N : integer := 4;
	signal a_ext, b_ext, sum_ext : unsigned(N downto 0);

begin
	-- logic
	a_ext <= unsigned ('0' & a);
	b_ext <= unsigned ('0' & b);
	sum_ext <= a_ext + b_ext;
	-- outputs
	sum <= std_logic_vector(sum_ext(N - 1 downto 0));
	cout <= sum_ext(N);
end const_arch;
	