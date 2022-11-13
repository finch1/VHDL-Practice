library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adc_ctrl is 
generic(c_width: natural := 3;
		  a_width: natural := 7);
port(
	clk, rst: in std_logic;

	adc_cs: out std_logic;
	adc_sclk: out std_logic;
	adc_din: out std_logic;
	adc_shdn: out std_logic;
	
	adc_dout: in std_logic;
	adc_sstrb: in std_logic;
--	ctrl_data: in std_logic_vector(a_width downto 0);
	aqu_data: out std_logic_vector(a_width downto 0);
	
	ram_ctrl_din: in std_logic_vector(a_width downto 0);
	ram_ctrl_dout: in std_logic_vector(a_width downto 0);
	ram_ctrl_radd: in std_logic_vector(2 downto 0);
	ram_ctrl_we: in std_logic;
	ram_ctrl_re: in std_logic;
	
	ram_data_dout: out std_logic_vector(a_width downto 0);
	ram_data_re: in std_logic);
	

--	ram_ctrl_re
--	ram_ctrl_add
--	ram_ctrl_din
--	ram_ctrl_dout
	
end adc_ctrl;

architecture arch of adc_ctrl is

	type ram is array (0 to 7) of std_logic_vector(7 downto 0);
	signal adc_data_ram, adc_ctrl_ram : ram;
	
	signal sum: unsigned(c_width+1 downto 0);
	signal count: unsigned(c_width downto 0);
	
	signal sclk: std_logic;
	
	signal fall_edge: std_logic;
	signal shift_count: unsigned(3 downto 0);
	signal ctrl_byte_count: unsigned(2 downto 0);
	signal data_byte_count: unsigned(2 downto 0);
	
	signal shift: std_logic_vector(a_width downto 0);
	
	signal adc_ctrl_we, adc_data_we: std_logic;	
	signal adc_ctrl_add: std_logic_vector(2 downto 0);
	signal adc_data_din: std_logic_vector(7 downto 0);
	signal adc_ctrl_dout: std_logic_vector(7 downto 0);
	
	signal ctrl_data: std_logic_vector(a_width downto 0);
	
begin

	sum <= resize(count,c_width +2) -1;
	
	process(clk, rst)
	begin
		if rst = '0' then
			count <= (others => '0');
			sclk <= '0';
		elsif rising_edge (clk) then
			if sum(c_width +1) = '1' then
				count <= "1100";
				sclk <= not sclk;
			else count <= sum(c_width downto 0);
			end if;
		end if; 
	end process;
	
	fall_edge <= sclk and sum(c_width +1);
	
	process(clk, rst)
	begin
		if rst = '0' then
			shift_count <= (others => '0');
			ctrl_byte_count <= (others => '0');
			data_byte_count <= (others => '1');
		elsif rising_edge(clk) then
			if fall_edge = '1' then
				shift_count <= shift_count -1;
				if shift_count = 0 then
					shift_count <= "1001";
					ctrl_byte_count <= ctrl_byte_count +1;
					data_byte_count <= data_byte_count +1;
				end if;
			end if;
		end if;
	end process;
	
	process(clk, rst)
	begin
		if rst = '0' then
			shift <= (others => '0');
		elsif rising_edge(clk) then
			if fall_edge = '1' then 
				case shift_count is
					when "1001" => 
						adc_data_ram(to_integer(data_byte_count)) <= shift(a_width downto 0);
					when "1000" =>
						shift(a_width downto 0) <= adc_ctrl_ram(to_integer(ctrl_byte_count));
					when others =>
						shift <= shift(a_width-1 downto 0) & adc_dout;
				end case;
			end if;
		end if;
	end process;
	
	process(clk)
	begin
		if rising_edge(clk) then
			if ram_ctrl_we = '1' then
				adc_ctrl_ram(to_integer(ctrl_byte_count)) <= ram_ctrl_din;
			end if;
		end if;
	end process;
	
	process(clk)
	begin
		if rising_edge(clk) then
			if ram_data_re = '1' then
				aqu_data <= adc_data_ram(to_integer(data_byte_count));
			end if;
		end if;
	end process;
		
	
	
	
	adc_sclk <= sclk;
	adc_din <= '0' when adc_sstrb = '1' else shift(a_width);
	
end arch;
		





--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--
--entity adc_ctrl is 
--generic(c_width: natural := 3;
--		  a_width: natural := 8);
--port(
--	clk, rst: in std_logic;
--
--	adc_cs: out std_logic;
--	adc_sclk: out std_logic;
--	adc_din: out std_logic;
--	adc_shdn: out std_logic;
--	
--	adc_dout: in std_logic;
--	adc_sstrb: in std_logic;
--	ctrl_data: in std_logic_vector(a_width-1 downto 0);
--	aqu_data: out std_logic_vector(a_width-1 downto 0));
--end adc_ctrl;
--
--architecture arch of adc_ctrl is
--	type reg is array (0 to 7) of std_logic_vector(7 downto 0);
--	signal adc_reg: reg;
--	
--	signal sum: unsigned(c_width+1 downto 0);
--	signal count: unsigned(c_width downto 0);
--	signal sclk: std_logic;
--	
--	signal shift, shift_hold: std_logic_vector(a_width downto 0);
--	signal shift_ld_un, shift_en: std_logic;
--	
--	signal shift_count: unsigned(3 downto 0);
--	signal shift_edge: std_logic;
--	
--	signal aquire_data_ready: std_logic;
--	
--	signal shift_load, shift_unload: std_logic;
--begin
--
--	sum <= resize(count,c_width +2) -1;
--	
--	process(clk, rst)
--	begin
--		if rst = '0' then
--			count <= (others => '0');
--			sclk <= '0';
--		elsif rising_edge (clk) then
--			if sum(c_width +1) = '1' then
--				count <= "1100";
--				sclk <= not sclk;
--			else count <= sum(c_width downto 0);
--			end if;
--		end if; 
--	end process;
--	
--
--	process(clk, rst)
--	begin
--		if rst = '0' then
--			shift <= (others => '0');
--			shift_count <= (others => '0');
--		elsif rising_edge(clk) then
--			if sclk = '0' and sum(c_width +1) = '1' then		
--			
--				if shift_count = 9 then
--				aqu_data <= shift(a_width-1 downto 0);	
--					
--				
--				elsif shift_count = 8 then
--					shift(a_width -1 downto 0) <= ctrl_data;
--				
--				
--				else shift <= shift(a_width -1 downto 0) & adc_dout;
--				end if;
--				
--				shift_count <= shift_count -1;
--			
--				if shift_count = 0 then 
--					shift_count <= "1001";
--				end if;				
--
--			end if;
--		end if;
--	end process;
--	
--	adc_sclk <= sclk;
--	adc_din 	<= shift(a_width);
--end arch;
--		