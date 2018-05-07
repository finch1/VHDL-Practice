-- A free running binary counter circulates through a binary sequence repeatedly. 
--For example, a 4-bit binary counter counts from "0000" to "1111" and wraps around. 
--The next state logic is an incrementor which adds 1 to the register's current vlaue.
--By definition of the + operator in the numeric_std package, the operation 
--implicitly wraps around after the r_reg reaches "1111". The circuit also outputs 
--status - max_tick - which is asserted when the counter reaches the maximal value 
--which is equal to 2^n-1 and deaserrted when value is "0000". The max_tick signal 
--represents a special type of signal that is asserted from a single clock cycle. 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity free_run_bin_counter is 
	generic( n: integer := 7);
	port( clk, rst: in std_logic;
			max_tick: out std_logic;
			q: out std_logic_vector(n downto 0));
end free_run_bin_counter;

architecture arch of free_run_bin_counter is
	signal r_reg, r_next : unsigned(7 downto 0);
begin
	
	process(clk, rst)
	begin
		if rst = '1' then
			r_reg <= (others => '0');
		elsif rising_edge (clk) then
			r_reg <= r_next;
		end if;
	end process;
	
	r_next <= r_reg + 1;
	
	max_tick <= '1' when r_reg = (2**8 -1) else '0';
	q <= std_logic_vector(r_reg);
end arch;
	
