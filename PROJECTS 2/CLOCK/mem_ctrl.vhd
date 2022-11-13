library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_ctrl is 
generic( n : natural := 4);
port(
	clk, rst : in  std_logic;
	count_ld	: in  std_logic;
	cout_ena : in  std_logic;
	index 	: in  std_logic_vector(n downto 0);
	add_out	: out std_logic_vector(n downto 0));	
end mem_ctrl;

architecture arch of mem_ctrl is
	signal count, gray : unsigned(n downto 0);
begin
	process(clk,rst)
	begin
		if rst = '0' then
			count <= (others => '0');
		elsif rising_edge(clk) then
			if cout_ena = '1' then
				count <= gray +1;
				if count_ld = '1' then
					count <= unsigned(index);
				end if;
			end if;
		end if;
	end process;
	gray <= count xor('0' & count(n -1 downto 1));
	add_out <= std_logic_vector(count);
end arch;	