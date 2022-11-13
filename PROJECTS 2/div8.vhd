library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity div8 is port(
	diva : in std_logic_vector(7 downto 0);
	divb : in std_logic_vector(7	downto 0);
	div0 : out std_logic;
	divq : out std_logic_vector(7 downto 0));
end div8;

architecture rtl of div8 is
	constant n : integer := 8;
	subtype bit16 is std_logic_vector(2*n -1 downto 0);
	type vect8 is array (n downto 0) of bit16;
	signal r, l : vect8;
	signal q, z0 : std_logic_vector(n -1 downto 0);
	signal z : std_logic;
begin
	z0 <= (others => '0');
	l(0) <= z0 & divb; 
	r(n) <= z0 & diva;
	
	sh0 : for j in 1 to n generate
		l(j) <= l(j - 1)(2*n -2 downto 0) & '0';
	end generate;
	
	st0 : for j in n-1 downto 0 generate
		q(j) <= '1' when (r(j +1) >= l(j)) else '0';
		r(j) <= r(j +1) - l(j) when q(j) = '1' else r(j +1);
	end generate;
	
	z <= '1' when divb = z0 else '0';
	div0 <= '1' when z = '1' else '0';
	divq <= (others => '0') when z = '1' else q;
end rtl;