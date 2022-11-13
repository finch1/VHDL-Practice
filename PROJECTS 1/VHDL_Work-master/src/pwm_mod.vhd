library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_mod is port(
	clk, rst : std_logic;
	led0, led1 : out std_logic);
end entity;

architecture arch of pwm_mod is
	signal clk_div_reg, clk_div_next : unsigned (13 downto 0);
	signal pwm0_reg, pwm0_next, pwm1_reg, pwm1_next : unsigned (7 downto 0);
	signal led_inv_0, led_inv_1, clk_div : std_logic;
begin

	process(clk, rst)
	begin
		if rst = '0' then
			clk_div_reg <= (others => '0');
		elsif rising_edge(clk) then
			clk_div_reg <= clk_div_next;
		end if;
	end process;
	
	clk_div_next <= (others => '0') when clk_div_reg = 5000 else clk_div_reg + 1;
	
	clk_div <= '1' when clk_div_reg = 5000 else '0';
	
		
	process(clk_div, rst)
	begin
		if rst = '0' then
			pwm0_reg <= (others => '0');
			pwm1_reg <= (others => '0');
		elsif rising_edge(clk_div) then
			pwm0_reg <= pwm0_next;
			pwm1_reg <= pwm1_next;
		end if;
	end process;
	
	pwm0_next <= (others => '0') when pwm0_reg = 254 else pwm0_reg + 1;
	pwm1_next <= (others => '0') when pwm1_reg = 252 else pwm1_reg + 1;
	
	led_inv_0 <= '1' when pwm0_reg > 127 else '0';
	led_inv_1 <= '1' when pwm1_reg > 126 else '0';
	led0 <= led_inv_0 xor led_inv_1;	

end arch;