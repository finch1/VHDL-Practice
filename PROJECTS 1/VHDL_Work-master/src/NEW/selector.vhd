--priority encoder

library ieee;
use ieee.std_logic_1164.all;
 use ieee.numeric_std.all;

entity selector is port(
    a: in std_logic_vector(15 downto 0);
    sel: in unsigned(3 downto 0);
	 x : out std_logic_vector(15 downto 0);
    y : out std_logic);
end selector;

architecture rtl of selector is
begin
    y <= a(to_integer(sel));
	 
	 process(sel)
		begin
			x <= (others => '0');
			x(to_integer(sel)) <= '1';
	 end process;
	 
end rtl;