--syn_clr	 load	  en	  up		   q*			    operation
----	1			-		-		-		00...00		synchronous clear sampled at rising_edge
----	0			1		-		-			d			parallel load
----	0			0		1		1		  q+1			count up
----	0			0		1		0		  q-1		   count down
----	0  		0		0		-			q			pause

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity univ_bit_counter is
	generic ( n : integer := 8);
	port( clk, rst : in std_logic;
			syn_clr, load, en, up : in std_logic;
			d : in std_logic_vector(n-1 downto 0);
			max_tick, min_tick : out std_logic;
			q : out std_logic_vector(n-1 downto 0));
end univ_bit_counter;

architecture arch of univ_bit_counter is
	signal r_reg, r_next : unsigned(n-1 downto 0);
	signal comb : std_logic_vector(2 downto 0);
begin
	
	process(rst, clk)
	begin
		if rst = '1' then
			r_reg <= (others => '0');
		elsif rising_edge(clk)then
			if syn_clr = '1' then 
				r_reg <= (others => '0');
			else r_reg <= r_next;
			end if;
		end if;
	end process;
	
	comb <= load & en & up;
	with (comb) select
	r_next <=
				 unsigned(d) when "100",
				 r_reg + 1 when "011",
				 r_reg - 1 when "010",
				 r_reg when others;


--	r_next <= unsigned(d) when (load = '1') else
--				 r_reg + 1 when (en = '1' and up = '1') else
--				 r_reg - 1 when (en = '1' and up = '0') else
--				 r_reg;
				 
	q <= std_logic_vector(r_reg);
	max_tick <= '1' when r_reg = 2**n - 1 else '0'; 
	min_tick <= '1' when r_reg = 0 else '0';
end arch;