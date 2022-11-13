--signal vs variable test
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tbtrial is
end entity;

architecture beh of tbtrial is
	signal b, c, d : unsigned(3 downto 0) := (others => '0');
	constant time_30 : time := 30 ns;

begin
	p0 : process
	 variable a : unsigned(3 downto 0) := (others => '0');
	begin
		wait for time_30;
		a := a +1;
		case a is 
			when "0001" => 
				b <= b +1;
			when "0010" => 
				c <= c +1;
			when others => null;
		end case;
		if a = "0011" then 
		  d <= d +1;
		 end if;
	end process;	
end beh;