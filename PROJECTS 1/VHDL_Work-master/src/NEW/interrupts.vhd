library ieee;
use ieee.std_logic_1164.all;

entity interrupts is port(
	clk, rst : in std_logic;
	int_in : in std_logic_vector(7 downto 0);
	int_ena: in std_logic;
	int_trig : out std_logic;
	int_mask : in std_logic_vector(7 downto 0);
	int_reg_out: out std_logic_vector(7 downto 0));
end interrupts;

architecture rtl of interrupts is
	signal int_reg : std_logic_vector(7 downto 0);
	signal temp0, temp1, temp2 : std_logic_vector(7 downto 0);
begin
	
	temp0(0) <= int_in(0);
	
	G0: for i in 1 to 7 generate
		temp0(i) <= int_in(i) or temp0(i-1);
	end generate;
	int_trig <= temp0(7) and int_ena;
	
	G1: for i in 0 to 7 generate
		temp1(i) <= int_in(i) and temp2(i);
	end generate;		
	
	process(clk, rst)
   begin
		if rst = '0' then
			int_reg <= (others => '0');
			temp2 <= (others => '1');
		elsif rising_edge(clk) then
			int_reg <= temp1;
			temp2 <= int_mask;
		end if;
	end process;
	
	int_reg_out <= int_reg;
	
end rtl;
		