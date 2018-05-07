library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity accumulator is port (
	clk, rst : in std_logic;
	data_in_a : in std_logic_vector(3 downto 0);
	data_in_b : in std_logic_vector(3 downto 0);
	data_out : out std_logic_vector(3 downto 0));
end entity;

architecture arch of accumulator is
	signal reg : unsigned(3 downto 0);
begin

	process(clk,rst)
	begin
		if rst = '1' then
			reg <= (others => '0');
		elsif rising_edge(clk) then
			reg <= unsigned(data_in_a) + unsigned(data_in_b);
		end if;
	end process;
	
	data_out <= std_logic_vector(reg);
end arch;
	