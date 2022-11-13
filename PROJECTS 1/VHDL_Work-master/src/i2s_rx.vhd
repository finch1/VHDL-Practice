library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2s_rx is 
	generic( n: natural := 8 );
	port( clk, ir_sd: in std_logic;
			rst: in boolean;
			data: out std_logic_vector(n-1 downto 0);
			ir_ws, ir_sclk: in std_logic);
end entity;

architecture arch of i2s_rx is
	signal rx_shift: std_logic_vector(n-1 downto 0);
	signal rise_edge, fall_edge, wsd, wsp, pl, ssclk, ena_reg: std_logic;
	signal bit_count: unsigned(2 downto 0);
begin
	
	process(clk, rst)
	begin
		if rst then
			ena_reg <= '0';
		elsif rising_edge(clk) then
			ena_reg <= ssclk;			
		end if;	
	end process;
	rise_edge <= (not ena_reg) and ssclk;
	fall_edge <= (not ena_reg) nor ssclk;
	
	
	process(clk, rst, fall_edge, wsp)
	begin
		if rst or (fall_edge = '1' and wsp = '1') then
			bit_count <= (others => '0');
			
		elsif	rising_edge(clk) then
			if fall_edge = '1' then
				bit_count <= bit_count +1;
			end if;			
		end if;
	end process;
	
	process(clk, rst)
	begin
		if rst then
			wsd <= '0';
			wsp <= '0';
		elsif rising_edge(clk) then
			if fall_edge = '1' then
				wsd <= ir_ws;
				wsp <= wsd;
			end if;
		end if;
	end process;
	
	pl <= wsp xor wsd;
	
	process(clk, rst)
	begin
		if rst then 
			rx_shift <= (others => '0');
			data <= (others => '0');
		elsif rising_edge(clk) then
			if rise_edge = '1' then
				rx_shift <= rx_shift(n-2 downto 0) & ir_sd;
			
				if (pl = '1' and ir_ws = '1') then 
						data <= rx_shift;
				end if;
				
				if (pl = '1' and ir_ws = '0') then 
						data <= rx_shift;
				end if;
				
			
			end if;
		end if;
	end process;
	
			
	ssclk <= ir_sclk;

end arch;