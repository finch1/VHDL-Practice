library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--freq limit 8192-13
entity freq_calc is port(
	clk, rst : in std_logic;
	enc_step : in std_logic;
	enc_dir 	: in std_logic;
	enc_ent 	: in std_logic;
	menu 		: in std_logic;
	pre_ld 	: in std_logic;
	preset_ld: in std_logic_vector(10 downto 0);
	disp_freq: out std_logic_vector(10 downto 0);
	word 		: out std_logic_vector(13 downto 0));
end freq_calc;

architecture rtl of freq_calc is	
	signal tune_freq : unsigned(26 downto 0);	
	signal want_freq : unsigned(10 downto 0);
begin
	process(clk)		
	begin	
		if rising_edge(clk) then
			if pre_ld = '1' then
				want_freq <= unsigned(preset_ld);
			else 
				if enc_step = '1' then
					if enc_dir = '1' then
						want_freq <= want_freq +1;
					else want_freq <= want_freq -1;
					end if;
				end if;
			end if;
			if enc_ent = '1' then
				word <= std_logic_vector(tune_freq(26 downto 13));
			end if;
		end if;
		disp_freq <= std_logic_vector(want_freq);
	end process;
	
	tune_freq <= (want_freq & "0000000000000000") + X"36EE8";
	
end rtl;

--set frequency to lowest
--tell i2c when data ready in memory