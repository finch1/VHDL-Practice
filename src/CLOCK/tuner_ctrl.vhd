library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tuner_ctrl is port(
	clk, rst : in std_logic;
	
	enc_step : in std_logic;
	enc_dir 	: in std_logic;
	enc_ent 	: in std_logic;
	
	options	: in std_logic_vector(1 downto 0);
	
	pre_ld_sv: in std_logic;	-- if rds works
	pre_num  : in std_logic_vector(10 downto 0);
	
	disp_out : out std_logic_vector(10 downto 0);
	word 		: out std_logic_vector(13 downto 0);
	
	sm			: in std_logic;
	stby		: in std_logic;
	bl			: in std_logic;
	
	stereo	: in std_logic;
	lev		: in std_logic_vector(3 downto 0);
	
	tnr_addr	: out std_logic_vector(6 downto 0);
	tnr_wr	: out std_logic;
	tnr_d_r	: out std_logic_vector(7 downto 0);
	tnr_d_w	: out std_logic_vector(7 downto 0);
	
	busy		: out std_logic;
	ena		: out std_logic);
end tuner_ctrl;

architecture rtl of tuner_ctrl is
	signal tune_freq : unsigned(26 downto 0);	
	signal want_freq : unsigned(10 downto 0);
	
	constant data_width :natural := 7;
	constant addr_width :natural := 4;
	
	type ram is array (natural addr_width'range)of std_logic_vector (data_width downto 0);
	signal reg : ram;
	signal data_ff : std_logic_vector(data_width downto 0);
	
begin
	
--control block
	process(clk, rst)
	begin
		if rst = '0' then

		--radio off miktuba fuq il valvi
		--kif tinafas enter mur radio on
		case cb_ps is
			radio_state =>
				if turn_on = '1' and turn_on_prev = '0' then	
				--transmitt address write + all databytes
				--display frequency and mhz
				--display radio on
				else cb_ns <= radio_off;
					--transmitt radio off once
					--display radio off
				end if;	
			man_tune =>
				--diplay frequency and mhz
				--wait for encoder input	
				--if direction up increment frequency counter by the number of steps and wait for enter to diplay and transmitt
				--calculate pll word
				--transmitt address write + 2 databytes once 
			search_mode => 
				if s_m = '1' then					
				--transmitt address wrtie + 2 databytes (search mode and lowest band limit)
				--wait for signal lock on rf pin
				--transmitt address read + 2 databytes
				band_limit_flag =>
					if b_l_f = '1' then
					--band limit reached
				
				--set band limit to us or jap
				--transmitt address wrtie + 4 databytes once
			show_info =>
				if rf_info = '1' then
				--transmitt address + read continuous
				--display stereo / mono and signal level
			others =>
	end process;
	
--I2C interface	
	process(clk, rst, wr_req)
	begin
		if rst = '0' then
			ps <= idle;
			ena <= '0';
			add_ld <= '0';
		elsif rising_edge(clk) then
			ps <= ns;	
		end if;

		case ps is
			when idle =>
				if i2c_int_ena = '1' then
					start;
				else idle;
				end if;
			when start =>
				addr <= reg(0);
				--set read or write
				ena <= '1';				
				ns <= wait_busy;
			when wait_busy => 
				if busy_prev = '0' and busy = '1' then
					tnr_d_w <= reg(data_cnt);				
					if data_cnt = 0 then
						ns <= stop;
					else
						--decrement data counter 
						ns <= wait_busy;
					end if;
				end if;
			when stop =>
				ena <= '0';
				ns <= idle;
		end case;
	end process;	
	
	-- memory write block
-- write operation : when we = 1, cs = 1
	reg_write:process (clk) begin
		if (rising_edge(clk)) then
			if (cs = '1' and we = '1') then
				reg(conv_integer(addr)) <= d_in;
			end if;
		end if;
	end process;

-- memory read block
-- read operation : when we = 0, oe = 1, cs = 1
	reg_read:process (clk) begin
		if (rising_edge(clk)) then
			if (cs = '1' and we = '0') then
				d_out <= reg(conv_integer(addr));
			end if;
		end if;
	end process;
	
--frequency word calculator	
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