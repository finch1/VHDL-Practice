library ieee;
use ieee.std_logic_1164.all;

entity i2c_ctrl is port(

	data_cnt 	: in natural range 0 to 10;

	clk, rst  	: in std_logic;	
	ena       	: out std_logic;                    --latch in command
	addr      	: out std_logic_vector(7 downto 0); --address of target slave
	add_inc	 	: out std_logic;
	busy      	: in  std_logic;                    --indicates transaction in progress
	ack_error 	: in  std_logic;                    --flag if improper acknowledge from slave	
	add_lut		: in std_logic(1 downto 0);
	add_ld		: in std_logic;
	add_inc		: in std_logic;
	wr_req      : in  std_logic; 
	rd_req	   : in  std_logic);
end i2c_ctrl;

architecture rtl of i2c_ctrl is
	type ctrl_state is(idle, start, wait_busy, stop);
	signal ps, ns : ctrl_state;
	-- Attribute to declare a specific encoding for the states
	attribute syn_encoding				    : string;
	attribute syn_encoding of ctrl_state : type is "11 01 10 00";

	signal busy_prev : std_logic;
	signal device_addr : std_logic_vector(7 downto 0);

begin
	
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
				if wr_req = '1' or rd_req = '1' then
					ns <= start;
				else ns <= idle;
				end if;
			when start =>
				addr <= device_addr;
				add_ld <= '1';
				ena <= '1';				
				ns <= wait_busy;
			when wait_busy => 
				if busy_prev = '0' and busy = '1' then
					add_inc <= '1';
				end if;
				if data_cnt = 0 then
					ns <= stop;
				else
					ns <= wait_busy;
				end if;
			when stop =>
				ena <= '0';
				ns <= idle;
		end case;
	end process;
	
	device_addr <= "00000000" when add_lut = "00",
						"00000010" when add_lut = "01",
						"00000100" when add_lut = "10",
						"00001000" when add_lut = "11";
end rtl;
	
		