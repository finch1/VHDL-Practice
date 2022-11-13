-- ----------------------------------------------------------------
-- acc.vhd
-- 12/05/2018
-- simple accumulator with register
-- ----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity acc is generic(
	IWIDTH : natural := 3);
					port(
	clk, rst : in std_logic;
	data_in_a: in std_logic_vector(IWIDTH downto 0); -- input of the design
	data_in_b: in std_logic_vector(IWIDTH downto 0);
	data_out: out std_logic_vector(IWIDTH downto 0)); -- output of the design
end entity;

architecture behavioural of acc is
	-- internal signals
	signal reg : unsigned(IWIDTH downto 0);
begin

	-- logic
	process(clk, rst)
	begin
		if rst = '1' then -- active high reset for the counter
			reg <= (others => '0');
		elsif rising_edge(clk) then -- add inputs and store
			reg <= unsigned(data_in_a) + unsigned(data_in_b);
		end if;
	end process;
	
	-- output
	data_out <= std_logic_vector(reg);
end behavioural;