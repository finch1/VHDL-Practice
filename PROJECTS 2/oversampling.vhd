library ieee;
use ieee.std_logic_1164.all;

entity oversampling is port(
	clk, sclk : in std_logic;
	sout : out std_logic);
end oversampling;

architecture arch of oversampling is
	signal ff_1_reg, ff_1_next, ff_2_reg, ff_2_next : std_logic;
begin
	process(clk)
	begin
		if rising_edge(clk) then
			ff_1_reg <= ff_1_next;
			--ff_2_reg <= ff_2_next;
		end if;
	end process;
	
	ff_1_next <= sclk;
	ff_2_next <= sclk xor ff_1_reg;
	sout <= sclk and ff_2_next;
end arch;
	