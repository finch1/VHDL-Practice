library ieee;
use ieee.std_logic_1164.all;

entity tb_i2c_master is end entity;

architecture tb of tb_i2c_master is
	component i2c_master is port (
		clk       : in     std_logic;                    --system clock
		reset_n   : in     std_logic;                    --active low reset
		ena       : in     std_logic;                    --latch in command
		addr      : in     std_logic_vector(6 downto 0); --address of target slave
		rw        : in     std_logic;                    --'0' is write, '1' is read
		data_wr   : in     std_logic_vector(7 downto 0); --data to write to slave
		busy      : out    std_logic;                    --indicates transaction in progress
		data_rd   : out    std_logic_vector(7 downto 0); --data read from slave
		ack_error : buffer std_logic;                    --flag if improper acknowledge from slave
		sda       : inout  std_logic;        			         --serial data output of i2c bus 
		scl       : inout  std_logic);      	            --serial clock output of i2c bus
	end component;

  type machine is(start, slv_ack1, rd, stop); --needed states ready, command, wr, slv_ack2, mstr_ack,
  signal state        : machine := start;                        --state machine	
  
 		 signal clk       : std_logic;                    
		 signal reset_n   : std_logic;                    
		 signal ena       : std_logic := '0';                    
		 signal addr      : std_logic_vector(6 downto 0) := "1100101"; 
		 signal rw        : std_logic := '0';                   
		 signal data_wr   : std_logic_vector(7 downto 0) := "11011101"; 
		 signal busy      : std_logic;                    
		 signal data_rd   : std_logic_vector(7 downto 0); 
		 signal ack_error : std_logic;                    
		 signal my_sda    : std_logic;
		 signal sda_wrEn	 : std_logic := '0';
		 signal scl       : std_logic;
		 signal temp      : std_logic_vector(7 downto 0);
		 
		 constant period : time := 50 ns;
		 constant delay  : time := 25 ns;
begin

	my_sda <= '0' when sda_wrEn = '1' else 'Z';
			  --when writing to SDA                 --waiting for SDA data out  
  
	reset_n <= '0', '1' after period *3;

	clk0 : process
	begin
		clk <= '1'; wait for period;
		clk <= '0'; wait for period;
	end process;

--	process
--	  variable cnt : natural range 0 to 8 := 0;
-- 	  variable loop_cnt : natural range 0 to 5;
--	  begin
--	    for j in 0 to 7 loop --counts first five clocks from begining
--	      wait until rising_edge(clk);
--	     end loop;
--	     ena <= '1';
--	     
--	     case state is
--	       when start =>
--	         if my_sda = '0' and scl = '1' then
--	           wait until rising_edge(scl);
--	            state <= rd;
--				end if;
--	        when rd =>	          
--	          temp <= temp(6 downto 0) & my_sda;
--	          wait until rising_edge(scl);
--	          cnt := cnt +1;	          
--	          if cnt = 7 then
--	            wait for 9500 ns;
--	            loop_cnt := loop_cnt +1;
--	            cnt := 0;
--	            sda_wrEn <= '1';
--	            state <= slv_ack1;
--	          end if;
--	          if loop_cnt = 5 then
--	            state <= stop;
--	          end if;
--	          
--	        when slv_ack1 =>	          
--	          wait until rising_edge(scl);
--	          wait until rising_edge(scl);
--	          sda_wrEn <= '0';
--	          state <= rd;
--	          
--	        when stop =>
--	          ena <= '0';
--          end case;
	           
--	end process;
	
	i2c_0 : i2c_master
	port map (clk => clk, reset_n => reset_n, 
					ena => ena, addr => addr, rw => rw, 
					data_wr => data_wr, busy => busy, 
					data_rd => data_rd, ack_error => ack_error,  
					sda => my_sda,          
          scl => scl);
end tb;