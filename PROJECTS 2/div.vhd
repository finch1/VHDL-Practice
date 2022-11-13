library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity div is port(
	clk, rst : in std_logic;
---quotient	
	quo_out : out std_logic_vector(7 downto 0);
---denomintor
	denomintor : in std_logic_vector(7 downto 0);
	den_pl  : in std_logic;
---numerator
	numerator : in std_logic_vector(7 downto 0));
end div;

architecture rtl of div is
	constant c : integer := 8;
	subtype bit24 is std_logic_vector(2*c -1 downto 0);
	subtype bit12 is std_logic_vector(c -1 downto 0);
	
	signal n, n_reg : bit24;
	signal d_reg : bit24;
	signal q_reg, q_hold : std_logic_vector(c -1 downto 0);
	signal compare : std_logic;
	signal difference : bit24;
	signal cnt_en : std_logic := '0';
	signal sel : std_logic;
	signal cnt: std_logic_vector(3 downto 0);	

begin

  n(2*c -1 downto c) <= (others => '0');			
	---numerator
	process(clk, rst)    
	begin
		if rst = '0' then
			n_reg <= (others => '0');			
    	elsif rising_edge(clk) then
				n_reg <= n;
		end if;
	end process;

	n(c -1 downto 0) <= numerator when den_pl = '1' 
	               else difference(c -1 downto 0) when compare = '1'
	               else n_reg(c -1 downto 0); 

	
---denomintor	
	process(clk, rst)
	begin
		if rst = '0' then
			d_reg <= (others => '0');
		elsif rising_edge(clk) then
			if den_pl = '1' then
				d_reg(2*c -1 downto c) <= denomintor;
			else
				d_reg <= '0' & d_reg(2*c -1 downto 1);
			end if;
		end if;
	end process;	
	
	compare <= '1' when n_reg >= d_reg else '0';			
	difference <= n_reg - d_reg;
	
---counter/compare	
	process(clk, den_pl)
	begin
		if den_pl = '1' then
			cnt <= std_logic_vector(to_unsigned(c +1, 4));
		elsif rising_edge(clk) then
		  if cnt_en = '1' then
    		  cnt <= cnt -1;
		  end if;
    end if;
	end process;	
	
---quotient
	process(clk, den_pl)
	begin
		if den_pl = '1' then
			q_reg <= (others => '0');
		elsif rising_edge(clk) then
		  if cnt_en = '1' then
				q_reg <= q_reg(6 downto 0) & compare;
			end if;
		end if;
		
	end process;
			
	cnt_en <= '0' when cnt = 0 else '1';
  quo_out <= q_reg when cnt_en = '0' else (others => '0');
		
end rtl;