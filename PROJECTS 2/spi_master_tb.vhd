library ieee;
use ieee.std_logic_1164.all;

entity spi_master_tb is
  GENERIC(
    slaves  : INTEGER := 4;  --number of spi slaves
    d_width : INTEGER := 8); --data bus width
end spi_master_tb;

architecture arch_tb of spi_master_tb is
	 signal clock   : STD_LOGIC;                             --system clock
    signal reset_n : STD_LOGIC;                             --asynchronous reset
    signal enable  : STD_LOGIC;                             --initiate transaction
    signal cpol    : STD_LOGIC;                             --spi clock polarity
    signal cpha    : STD_LOGIC;                             --spi clock phase
    signal cont    : STD_LOGIC;                             --continuous mode command
    signal clk_div : INTEGER;                               --system clock cycles per 1/2 period of sclk
    signal addr    : INTEGER;                               --address of slave
    signal tx_data : STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --data to transmit
    signal miso    : STD_LOGIC;                             --master in, slave out
    signal sclk    : STD_LOGIC;                             --spi clock
    signal ss_n    : STD_LOGIC_VECTOR(slaves-1 DOWNTO 0);   --slave select
    signal mosi    : STD_LOGIC;                             --master out, slave in
    signal busy    : STD_LOGIC;                             --busy / data ready signal
    signal rx_data : STD_LOGIC_VECTOR(d_width-1 DOWNTO 0); --data received
	 
	 constant t : time := 100 ps;
begin

	spi_master_uut : entity work.spi_master
		port map( clock => clock, reset_n => reset_n, enable => enable, 
					 cpol => cpol, cpha => cpha, cont => cont, clk_div => clk_div,
					 addr => addr, tx_data => tx_data, miso => miso, sclk => sclk, 
					 ss_n => ss_n, mosi => mosi, busy => busy, rx_data => rx_data);
					 
	process
	begin
		clock <= '1';
		wait for t/2;
		clock <= '0';
		wait for t/2;
	end process;
	
	process
	begin
		cpol <= '0';
		cpha <= '0';	
		addr <= 2;
		clk_div <= 0;
		cont <= '1';
		tx_data <= "10100101";
		enable <= '1';
		reset_n <= '0'; wait for 400 ps;
		reset_n <= '1'; 
		
		wait until busy = '0';		
		
	end process;
end arch_tb;