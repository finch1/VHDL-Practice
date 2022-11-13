-- ----------------------------------------------------------------
-- adder.vhd
-- 12/05/2018
-- simple up counter
-- ----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is port(
	clk: in std_logic;
	reset: in std_logic;
	count: out unsigned(3 downto 0) -- output of the design 
);
end entity;

architecture behavioral of adder is 

		-- internal signals
		-- initialize the count to zero
		signal c : unsigned(3 downto 0) := (others => '0');
	
	begin
	
		-- logic
		process(clk, reset)
		begin
			if(reset = '1') then -- active high reset for the counter
				c <= (others => '0'); -- when count reaches its maximum, reset to 0
			elsif(rising_edge(clk)) then
				c <= c + 1; -- increment count at every positive edge of clk
			end if;
		end process;
		
		-- output
		count <= c;
	
end behavioral;
	
	

