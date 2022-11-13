library ieee;
use ieee.std_logic_1164.all;

entity free_run_shift_reg is port(
	reset, d, clk : in std_logic;
	q : out std_logic);
end free_run_shift_reg;

architecture arch of free_run_shift_reg is
	signal r_reg, r_next : std_logic_vector(7 downto 0);
begin
	process(clk, reset)
	begin
		if (reset = '1') then
			r_reg <= (others => '0');
		elsif rising_edge(clk) then
			r_reg <= r_next;
		end if;
	end process;
	
	r_next <= d & r_reg(7 downto 1);
	q <= r_reg(0);
	
end arch;