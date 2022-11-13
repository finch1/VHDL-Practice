--example  of pwm
--a mod-m counter counts from 0 to m-1 and wraps around. generic m specifies the 
--limit and n specifies the number of bits needed and should be equal to [log2 m]

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mod_m_counter is 
	generic( m : integer := 10;	--number of bits
				n : integer := 4);	--mod-m
	port(		clk, rst : in std_logic;
				max_tick : out std_logic;
				q : out std_logic_vector(n-1 downto 0));
end mod_m_counter;

architecture arch of mod_m_counter is
	signal r_reg, r_next : unsigned(n-1 downto 0);
begin
	
	process(clk, rst)
	begin
		if rst = '0' then
			r_reg <= (others => '0');
		elsif rising_edge(clk) then
			r_reg <= r_next;
		end if;
	end process;
--next state logic
-- the next state logic is constructed by a conditional signal assignment statement.
-- If the counter reaches m-1 the new value is cleared to 0. otherwise it is incremented by 1.		
	r_next <= (others => '0') when r_reg = m-1 else r_reg +1;
	
--output logic
	q <= std_logic_vector(r_reg);
	max_tick <= '1' when r_reg = m-1 else '0';

end arch;	