library ieee;
use ieee.std_logic_1164.all;

entity univ_shift_reg is port(
	clk, rst, en : in std_logic;
	ctrl : in std_logic_vector(1 downto 0);
	din : in std_logic_vector(7 downto 0);
	dout : out std_logic_vector(7 downto 0));
end univ_shift_reg;

architecture arch of univ_shift_reg is
	signal r_reg, r_next : std_logic_vector(7 downto 0);
begin
	process(clk, rst)
	begin
		if rst = '1' then
			r_reg <= (others => '0');
		elsif rising_edge (clk) then
			if en = '1' then
				r_reg <= r_next;
			end if;
		end if;
	end process;
	
	with ctrl select
		r_next <=
			r_reg 									when "00", -- no op
			r_reg (6 downto 0) & din(0)	 	when "01", -- shift_left
			din(7) & r_reg(7 downto 1) 		when "10", --shift_right
			din 										when others; -- load

   --output					
	dout <= r_reg;
end arch;

--library ieee;
--use ieee.std_logic_1164.all;
--
--entity univ_shift_reg is port(
--	clk, rst, en1, en2 : in std_logic;
--	ctrl, ctrl1 : in std_logic;
--	sin : in std_logic;
--	din : in std_logic_vector(7 downto 0);
--	sout, sout2 : out std_logic);
--end univ_shift_reg;
--
--architecture arch of univ_shift_reg is
--	signal r_reg, r_next : std_logic_vector(7 downto 0);
--	signal r_reg_1, r_next_1 : std_logic_vector(7 downto 0);
--	signal dout : std_logic_vector(7 downto 0);
--begin
--
--	process(clk, rst)
--	begin
--		if rst = '1' then
--			r_reg <= (others => '0');
--		elsif rising_edge (clk) then
--			if en1 = '1' then
--				r_reg <= r_next;
--			end if;
--		end if;
--	end process;
--	
--	
--	r_next <= 	din when (ctrl = '1') else -- no op
--						sin & r_reg(7 downto 1); --shift_right
--   --output					
--	sout <= r_reg(0);
--	
--	process(clk, rst)
--	begin
--		if rst = '1' then
--			r_reg_1 <= (others => '0');
--		elsif rising_edge (clk) then
--			if en2 = '1' then
--				r_reg_1 <= r_next_1;
--			end if;
--		end if;
--	end process;
--	
--	
--	r_next_1 <= 	r_reg when (ctrl1 = '1') else -- no op
--						'0' & r_reg_1(7 downto 1); --shift_right
--   --output					
--	sout2 <= r_reg_1(0);
--	
--	
--end arch;