library ieee;
use ieee.std_logic_1164.all;

entity tb_i2c_ctrl is
end tb_i2c_ctrl;

architecture beh of tb_i2c_ctrl is

----------
	--I2C controller
----------	
	component i2c_ctrl is port(

		data_cnt : in natural range 0 to 10;

		clk, rst  : in std_logic;	
		ena       : out std_logic;                    --latch in command
		addr      : out std_logic_vector(7 downto 0); --address of target slave
		data_wr   : out std_logic_vector(7 downto 0); --data to write to slave
		add_inc	 : out std_logic;
		busy      : in  std_logic;                    --indicates transaction in progress
		data_rd   : in  std_logic_vector(7 downto 0); --data read from slave    
		ack_error : in  std_logic;                    --flag if improper acknowledge from slave	
		wr_req      : in  std_logic; 
		rd_req	   : in  std_logic;
		data_wr_req : in  std_logic_vector(7 downto 0);
		data_rd_req : out std_logic_vector(7 downto 0));
	end component;
	
	signal data_cnt `  :  natural range 0 to 10;
	signal clk, rst  	 :  std_logic;	
	signal ena       	 :  std_logic;                    --latch in command
	signal addr      	 :  std_logic_vector(7 downto 0); --address of target slave
	signal data_wr   	 :  std_logic_vector(7 downto 0); --data to write to slave
	signal add_inc	 	 :  std_logic;
	signal busy      	 :   std_logic;                    --indicates transaction in progress
	signal data_rd   	 :   std_logic_vector(7 downto 0); --data read from slave    
	signal ack_error 	 :   std_logic;                    --flag if improper acknowledge from slave	
	signal wr_req      :   std_logic := '0'; 
	signal rd_req	    :   std_logic;
	signal data_wr_req :   std_logic_vector(7 downto 0);
	signal data_rd_req :  std_logic_vector(7 downto 0);

----------
	--memory controller
----------		
	component mem_ctrl is port(
		clk, rst : in  std_logic;
		count_ld	: in  std_logic;
		cout_ena : in  std_logic;
		index 	: in  std_logic_vector(n downto 0);
		add_out	: out std_logic_vector(n downto 0));	
	end component;

	signal clk, rst : std_logic;
	signal count_ld	: std_logic;
	signal cout_ena : std_logic;
	signal index 	: std_logic_vector(n downto 0);
	signal add_out	: std_logic_vector(n downto 0));	

----------
	--register memory
----------	
	component reg_mem is
		generic (
			data_width :integer := 8;
			addr_width :integer := 5);
		port (
			clk   : in std_logic; -- clock input
			addr  : in std_logic_vector (addr_width-1 downto 0); -- address input
			d_in  : in std_logic_vector (data_width-1 downto 0); --
			d_out : out std_logic_vector (data_width-1 downto 0); --
			cs    : in std_logic; -- chip select
			we    : in std_logic; -- write enable/read enable
			oe    : in std_logic);  -- output enable 
	end component;

	signal clk   : in std_logic; -- clock input
	signal addr  : in std_logic_vector (addr_width-1 downto 0); -- address input
	signal d_in  : in std_logic_vector (data_width-1 downto 0); --
	signal d_out : out std_logic_vector (data_width-1 downto 0); --
	signal cs    : in std_logic; -- chip select
	signal we    : in std_logic; -- write enable/read enable
	signal oe    : in std_logic);  -- output enable 

----------
	--I2C master
----------	
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

	constant period : time := 50 ps;
	constant strobe : time := 25 ps;
	
begin

	rst <= '0', '1' after period *3;
	
	process
	begin
		clk <= '1'; wait for period;
		clk <= '0'; wait for period;
	end process;
	
	wr_req <= '1' after period *5;


	process
	  begin 
	  wait;  
	end process;
	    
	
	
		
	
	
	i2c_ctrl_0 : i2c_ctrl
	port map(data_cnt => data_cnt,
				clk => clk,
				rst => rst,
				ena => ena,
				addr => index,
				data_wr => data_wr,
				add_inc => add_inc,
				busy => busy,
				data_rd => data_rd,
				ack_error => ack_error,
				wr_req => wr_req,
				rd_req => rd_req,
				data_wr_req => data_wr_req,
				data_rd_req => data_rd_req);
	

----------
	--memory controller
----------		
	mem_ctrl_0 : mem_ctrl
	port map(clk => clk,
				rst => rst,
				count_ld	count_ld
				cout_ena	cout_ena
				index	
				add_out	add_out


----------
	--register memory
----------	
	reg_mem_0 : reg_mem
	generic map(data_width => 8;
					addr_width => 5);
	
	port map(clk => clk,
				addr
				d_in
				d_out
				cs
				we
				oe

----------
	--I2C master
----------	
	i2c_master_0 : i2c_master
	port map(clk => clk, 
				reset_n => rst,
				ena
				addr
				rw
				data_wr
				busy
				data_rd
				ack_error
				sda
				scl

		 
end beh;