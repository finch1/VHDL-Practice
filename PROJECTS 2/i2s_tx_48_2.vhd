library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2s_tx_48_2 is 
	port( clk: in std_logic;
			fall_edge, rise_edge: in std_logic;
			rst: in boolean;
			it_sel, clk_sel: in std_logic_vector(1 downto 0);
			it_data: in std_logic_vector(7 downto 0);
			it_ws, it_sclk, it_sd: out std_logic);
end entity;

architecture arch of i2s_tx_48_2 is

	signal ssclk, s_ws, sel, lr_edge, sel_rise: std_logic;
	signal count_reg: unsigned(1 downto 0);
	signal bit_count: unsigned(3 downto 0);
	
	signal shift,  shift_nxt, shift_lft, shift_rht: std_logic_vector(7 downto 0);
	signal int_rise_e, int_fall_e, int_edge_reg: std_logic;
	
begin

	sel <= it_sel(0) and it_sel(1);
	
 	process(clk, rst)
	begin
		if rst then
			lr_edge <= '0';
		elsif rising_edge(clk) then
			lr_edge <= sel;
		end if;
	end process;
	

	sel_rise <= sel and (not lr_edge);



	process(clk, rst, sel_rise)
	begin
		if rst or sel_rise = '1' then
			count_reg <= (others => '0');
			ssclk <= '0';
		elsif rising_edge(clk) then
			if rise_edge = '1' then
				count_reg <= count_reg +1;
			
				if count_reg = 3 then
					ssclk <= not ssclk;
				end if;
			end if;
		end if;	
	end process;
	
	process(clk, rst)
	begin
		if rst then
			int_edge_reg <= '0';
		elsif rising_edge(clk) then
			int_edge_reg <= ssclk;
		end if;
	end process;
	
	int_fall_e <= (not int_edge_reg) nor ssclk;
	int_rise_e <= (not int_edge_reg) and ssclk;
	
	process(clk, rst, it_sel, clk_sel)
	begin
		if rst or (it_sel = "11" and clk_sel = "10") then
			bit_count <= (others => '0');
			s_ws <= '0';
		elsif	rising_edge(clk) then
			if int_fall_e = '1' then
				bit_count <= bit_count +1;
					
				if bit_count = 6 or bit_count = 14 then
					s_ws <= not s_ws;
				end if;
			end if;
		end if;
	end process;
	

	it_sclk <= ssclk;
	it_ws <= s_ws;
	

	--main shift register
	process(clk)
	begin
		if rising_edge(clk) then			
			shift <= shift_nxt;			
		end if;
	end process;
	
	shift_nxt <= shift(6 downto 0) & '0' when int_fall_e = '1' else 
					 shift_lft when bit_count = 0 and int_rise_e = '1' else 
					 shift_rht when bit_count = 8 and int_rise_e = '1' else  -- change to bit_count 7 and int fall
					 shift;
	
	process(clk, rst)
	begin
		if rst then 
			shift_lft <= (others => '0');
			shift_rht <= (others => '0');
		elsif rising_edge(clk) then
			if it_sel = "11" and clk_sel = "10" then
					shift_lft <= it_data;
				end if;
				
			if it_sel = "11" and clk_sel = "11" then
				shift_rht <= it_data;
			end if;
		end if;
	end process;
			

	it_sd <= shift(7);
	
end arch;
	
	
	