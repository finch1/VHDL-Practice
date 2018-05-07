library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart is 
	generic(
		--default setting:
		--19200 baud, 8 data bits, 1 stop bit, 2^2 FIFO
		dbit: integer := 8; 		--# data bits
		sb_tick: integer := 16;	--# ticks for stop bits, 16/24/32
										--for 1/1.5/2 stop bits
		dvsr: integer := 163; 	--baud rate divisor
										--dvsr = 50M/(16*baud rate)
		dvsr_bit: integer := 8; --#bits of dvsr
		fifo_w: integer := 2);	--#addr bits of FIFO
										--#words in FIFO = 2^fifo_w
	port(
		clk, rst: in std_logic;
		rx: in std_logic;
		r_d_t, mod_tick : out std_logic;
		stateview : out unsigned(3 downto 0);		
		r_data: out std_logic_vector(7 downto 0));
end uart;

architecture str_arch of uart is
	signal tick: std_logic;
	signal rx_done_tick: std_logic;
	signal tx_fifo_out: std_logic_vector(7 downto 0);
	signal rx_data_out: std_logic_vector(7 downto 0);
	signal tx_empty, tx_fifo_not_empty: std_logic;
	signal tx_done_tick: std_logic;
	
begin
	baud_gen_unit: entity work.mod_m_counter(arch)
		generic map(m => dvsr, n => dvsr_bit)
		port map(clk => clk, rst => rst, q => open, max_tick => tick);
		
	uart_rx_unit: entity work.uart_rx(arch)
		generic map(dbit => dbit, sb_tick => sb_tick)
		port map(clk => clk, rst => rst, rx => rx, s_tick => tick,
					rx_done_tick => r_d_t, data_out => r_data, state_view => stateview);
	
--	fifo_rx_unit: entity work.fifo(arch)
--		generic map(b => dbit, w => fifo_w)
--		port map(clk => clk, rst => rst, rd => rd_uart, wr => rx_done_tick,
--					w_data => rx_data_out, empty => rx_empty, full => open, r_data => r_data);
--	
--	fifo_tx_unit: entity work.fifo(arch)
--		generic map(b => dbit, w => fifo_w)
--		port map(clk => clk, rst => rst, rd => tx_done_tick, wr => wr_uart, w_data => w_data,
--					empty => tx_empty, full => tx_full, r_data => tx_fifo_out);
--	
--	uart_tx_unit: entity work.uart_tx(arch)
--		generic map(dbit => dbit, sb_tick => sb_tick)
--		port map(clk => clk, rst => rst, tx_start => tx_fifo_not_empty, s_tick => tick,
--					din => tx_fifo_out, tx_done_tick => tx_done_tick, tx => tx);
--	
--	tx_fifo_not_empty <= not tx_empty;	

	mod_tick <= tick;
end str_arch;