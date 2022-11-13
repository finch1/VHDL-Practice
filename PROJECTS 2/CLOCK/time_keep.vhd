library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity time_keep is port(
	clk		 				: in std_logic;
	lfsr_tick, menu		: in std_logic;
	user_in_sec				: in natural range 0 to 1;
	user_in_min				: in natural range 0 to 1;
	user_in_hr				: in natural range 0 to 1;	
	user_change				: in std_logic;
	hour_ovf					: out std_logic;
	time_out					: out std_logic_vector(19 downto 0));	
end time_keep;

architecture rtl of time_keep is
	type inc_dec is (dec, inc);	
	signal sel_sec, sel_min, sel_hr : inc_dec;
	
	signal sec_unit, min_unit, hr_unit : unsigned(3 downto 0);
	signal sec_ten, min_ten				  : unsigned(2 downto 0);
	signal hr_ten 							  : unsigned(1 downto 0);
	signal sec_u_ovf, sec_t_ovf		  : std_logic;
	signal min_u_ovf, min_t_ovf		  : std_logic;
	signal hr_u_ovf, hr_t_ovf			  : std_logic;
	signal sec_ena, min_ena, hr_ena	  : std_logic;	

begin
	process(clk)	
	begin
		if rising_edge(clk) then
			if sec_ena = '1' then
				if sel_sec = inc then
					sec_unit <= sec_unit +1;			
				else sec_unit <= sec_unit -1;
				end if;
			end if;
			
				if sec_u_ovf = '1' then
					if sel_sec = inc then
						sec_ten <= sec_ten +1;
					else sec_ten <= sec_ten -1;
					end if;
				end if;
			
					if min_ena = '1' then
						if sel_min = inc then
							min_unit <= min_unit +1;
						else min_unit <= min_unit -1;
						end if;
					end if;
						
					if min_u_ovf = '1' then
						if sel_min = inc then
							min_ten <= min_ten +1;
						else min_ten <= min_ten -1;
						end if;
					end if;
				
						if hr_ena = '1' then
							if sel_hr = inc then
								hr_unit <= hr_unit +1;
							else hr_unit <= hr_unit -1;
							end if;
						end if;
						
						if hr_u_ovf = '1' then
							if sel_hr = inc then
								hr_ten <= hr_ten +1;
							else hr_ten <= hr_ten -1;
							end if;
						end if;
		end if;		
		
		if sec_unit = "1010" then
			sec_unit <= (others => '0');
		end if;
		
		if sec_ten = "110" then
			sec_ten <= (others => '0');
		end if;
		
		if min_unit = "1010" then
			min_unit <= (others => '0');
		end if;
		
		if min_ten = "110" then
			min_ten <= (others => '0');
		end if;
		
		if hr_unit = "1010" then
			hr_unit <= (others => '0');
		end if;
		
		if hr_ten = "11" then
			hr_ten <= (others => '0');
		end if;
		
end process;
	
	sec_u_ovf <= '1' when sec_unit = "1010" else '0';
	sec_t_ovf <= '1' when sec_ten  = "110"  else '0';
	min_u_ovf <= '1' when min_unit = "1010" else '0';
	min_t_ovf <= '1' when min_ten  = "110"  else '0';
	hr_u_ovf  <= '1' when hr_unit  = "1010" else '0';
	hr_t_ovf  <= '1' when hr_ten   = "11" 	 else '0';
	
	sel_sec 	 <= sel_sec'val(user_in_sec) when menu = '1' else inc;
	sec_ena 	 <= lfsr_tick when menu = '1' else user_change;
	
	sel_min 	 <= sel_min'val(user_in_min) when menu = '1' else inc;
	min_ena	 <= sec_t_ovf when menu = '1' else user_change;
	
	sel_hr 	 <= sel_hr'val(user_in_hr) when menu = '1' else inc;
	hr_ena	 <= min_t_ovf when menu = '1' else user_change;
	
	time_out	 <= std_logic_vector(hr_ten) & std_logic_vector(hr_unit) & 
					 std_logic_vector(min_ten) & std_logic_vector(min_unit) & 
					 std_logic_vector(sec_ten) & std_logic_vector(sec_unit);


end rtl;
