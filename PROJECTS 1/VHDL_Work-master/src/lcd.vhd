--library ieee;
--use ieee.std_logic_1164.all;
--package lcd_defs is
--	constant db_bits							: 	natural := 8;
--
--	constant cmd_power_up					:  natural := 0;
--	constant cmd_function_set				:  natural := 1;
--	constant cmd_display_on_off_control	:	natural := 2;
--	constant cmd_clear_display				: 	natural := 3;
--	constant cmd_entry_mode_set			: 	natural := 4;
--	constant cmd_return_home				: 	natural := 5;
--	constant cmd_cursor_or_display_shift:  natural := 6;
--	constant cmd_set_cgram_addr			:  natural := 7;
--	constant cmd_set_ddram_addr			:  natural := 8;
--	
--	type cmd is array (0 to 8) of std_logic_vector(10 downto 0);			-- 7-0 holds command, 8 holds RS, 10-9 hold delay length
--	constant lcd_cmd : cmd := ("00000000000",--power up delay
--										"10000111000",--function set
--										"10000001110",--display on/off control
--										"01000000001",--clear display
--										"10000000110",--entry mode set
--										"01000000010",--return home		
--										"10000010000",--cursor or display shift
--										"10001000000",--set cggram addr
--										"10010000000");--set ddram addr
--										
----	type ddata is array (0 to 8) of std_logic_vector(10 downto 0);			-- 7-0 holds command, 8 holds RS, 10-9 hold delay length
----	constant lcd_data : ddata := ("10101000001",--A
----											"10101000010",--B
----											"10101000011",--C
----											"10101000100",--D
----											"10101000101",--E
----											"10101000110",--F
----											"10101000111",--G
----											"10101001000",--H
----											"10101001001");--I
--										
--	
--end package lcd_defs;
--
--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--use work.lcd_defs.all;
--
--entity lcd is 
--generic(	constant width : 	natural := 16;
--			constant db_bits: natural := 11);
--
--port(
--	clk, rst: in std_logic;
--	lcd_write: in std_logic_vector(1 downto 0);
--	lcd_data: in std_logic_vector(db_bits-1 downto 0);
--	lcd_busy : out std_logic;
--
--	lcd_en: out std_logic;
--	lcd_rs 	: out std_logic;	
--	lcd_bus	: out std_logic_vector(db_bits -4 downto 0)); --data out signals
--end entity;
--
--architecture arch of lcd is
--	
--	type c_state is(load_count, ena_count, start_count);
--	signal count_state: c_state;
--	
--	type delay is array (0 to 3) of natural range 0 to 81997;
--	constant time_delay : delay := (	197, 		--4 us ,
--												81997, 	--1.64ms,
--												1995,  	--40  us,
--												19); 		--460 ns
--												
--	type l_state is(idle, initialize, en_dly, proc_dly, data, address, command);
--	signal lcd_state: l_state; 
--												
--   signal count: unsigned (width -1 downto 0);
--	signal sum: unsigned (width downto 0);
--	signal cout, c_en, c_load, count_start: std_logic;
--	signal c_sel_dly: unsigned(1 downto 0);
--
--	
--begin
--	process(clk, rst)
--		variable init_count: natural range 0 to 9;
--		variable data_count: natural range 0 to 10;
--	begin
--		if rst = '0' then											
--			lcd_state <= initialize; 			
--			init_count := 0;
--			data_count := 0;
--			count_start <= '0';
--			
--			c_load <= '0';
--			c_en <= '0';
--			count_state <= load_count;		
--		elsif rising_edge(clk) then
--			case lcd_state is
--				when initialize =>
--					lcd_bus <= lcd_cmd(init_count)(db_bits -1 downto 0);
--					lcd_rs  <= lcd_cmd(init_count)(8);
--					lcd_en <= '1';
--					lcd_state <= en_dly;
--	
--				when data =>
--					if write_en = '1' then 
--					lcd_bus <= lcd_data(db_bits -4 downto 0);
--					lcd_rs  <= lcd_data(data_count)(8);
--					lcd_en <= '1';
--					lcd_state <= en_dly;					
--									
--				when en_dly =>
--					c_sel_dly <= "11";
--					count_start <= '1';
--					if cout = '1' then
--						lcd_en <= '0';
--						lcd_state <= proc_dly;
--					end if;
--				
--				when proc_dly =>
--					c_sel_dly <= unsigned(lcd_cmd(init_count)(10 downto 9));
--					count_start <= '1';
--					if cout = '1' then
--						if init_count < 4 then
--							init_count := init_count +1;
--							lcd_state <= initialize;
--						else
--							lcd_state <= data; 						
--						end if;
--					end if;	
--			
--				when others =>
--			end case;
--
--			case count_state is
--				when load_count =>
--					if count_start = '1' then
--						c_load <= '1';	
--						count_state <= ena_count;
--					end if;
--				
--				when ena_count =>
--					c_load <= '0';
--					c_en <= '1';										
--					count_state <= start_count;						
--					
--				when start_count =>
--					if cout = '1' then									
--						c_en <= '0';
--						count_state <= load_count;
--						count_start <= '0';	
--					end if;
--			end case;
--			
--		end if;
--
--	end process;
--
--	
--
--	
--	
--	sum <= resize(count,width +1) -1;
--	
--	process(clk,rst)
--	begin
--		if rst = '0' then
--			count <= (others => '1');
--		elsif rising_edge(clk) then
--			if c_load = '1' then
--				count <= to_unsigned(time_delay(to_integer(c_sel_dly)),16);
--			elsif c_en = '1' then
--				count <= sum(width -1 downto 0);
--			end if;
--		end if;
--	end process;
--	
--	cout <= sum(width);
--		
--end arch;