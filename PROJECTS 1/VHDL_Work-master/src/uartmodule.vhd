library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uartmodule is port(
	clk, rst : in std_logic;
	rx	: in std_logic;
	tx	: out std_logic);	
end uartmodule;

architecture arch of uartmodule is

	constant ndbits : natural := 7;
	constant divisor : unsigned (7 downto 0) := to_unsigned(162, 8); 

	type staterx is (idle, start_rx, edge_rx, shift_rx, stop_rx);
	signal rxfsm : staterx;
	signal rx_reg : std_logic_vector(7 downto 0); 
	signal rxbitcnt : natural range 0 to ndbits;
	signal rxdiv : unsigned (2 downto 0);
	signal dout : std_logic_vector(7 downto 0);
	signal wait_a_bitrx, rxrdyi : std_logic;
	signal clrdivrx : std_logic;
	
	
	signal top16, toprx, toptx : std_logic;
	signal div16 : unsigned (7 downto 0);

	type statetx is (idletx, start_tx, edge_tx, shift_tx, stop_tx);
	signal txfsm : statetx;
	signal tx_reg : std_logic_vector(7 downto 0); 
	signal txbitcnt : natural range 0 to ndbits;
	signal txdiv : unsigned (2 downto 0);
	signal din : std_logic_vector(7 downto 0);
	signal wait_a_bit_tx : std_logic;
	signal clrdivtx : std_logic;

begin 


--receive state machine
	rx_fsm: process(rst, clk)
	begin
		if rst = '0' then
			rx_reg 	<= (others => '0');
			dout 		<= (others => '0');
			rxbitcnt	<= 0;
			rxfsm 	<= idle;					-- state machine index
			clrdivrx  	<= '0';
			wait_a_bitrx <= '0';
			rxrdyi <= '0';
			
		elsif rising_edge(clk) then
			clrdivrx <= '0';--default value;
			rxrdyi <= '0';
			
			case rxfsm is
				when idle => -- wait on start bit
					rxbitcnt <= 0;
						if rx = '0' then -- wait on start bit
							clrdivrx <= '1'; --synchronize the divisor
							rxfsm <= start_rx;
						end if; 
				
				when start_rx => --wait on first data bit
					if toprx = '1' then
						if wait_a_bitrx = '1' then
							rxfsm <= edge_rx;
							else wait_a_bitrx <= '1';
						end if;
					end if;

				when shift_rx => -- sample data				
					if toprx = '1' then
						rx_reg <= rx & rx_reg(rx_reg'high downto 1);  	--shift right					
							if rxbitcnt = ndbits then
								rxfsm <= stop_rx;
							else	
								rxbitcnt <= rxbitcnt +1;
								rxfsm <= edge_rx;
							end if;
					end if;
					
				when edge_rx => --should be near rx edge
					if toprx = '1' then
						rxfsm <= shift_rx;
					end if;
--					
				when stop_rx => -- during stop bit
					if toprx = '1' then
						wait_a_bitrx <= '0';
						rxrdyi <= '1';
						dout <= rx_reg;
						rxfsm <= idle;
					end if;
			end case;
		end if;
	end process;	
	
--transmitt state machine
	tx_fsm: process(rst, clk)
	begin
		if rst = '0' then
			tx_reg 	<= (others => '0');
--			dout 		<= '0';
			txbitcnt	<= 0;
			txfsm 	<= idletx;					-- state machine index
			clrdivtx  	<= '0';
			wait_a_bit_tx <= '0';

		elsif rising_edge(clk) then
			clrdivtx <= '0';--default value;
			
			case txfsm is
				when idletx => -- wait on start bit
					txbitcnt <= 0;
					tx_reg(0) <= '1';
					if rxrdyi = '1' then -- wait on start bit
							clrdivtx <= '1'; --synchronize the divisor
							txfsm <= start_tx;
							tx_reg(0) <= '0';							
					end if; 
				
				when start_tx => --wait on first data bit
					if toptx = '1' then
						if wait_a_bit_tx = '1' then
							txfsm <= edge_tx;
							tx_reg <= dout;
							else wait_a_bit_tx <= '1';
						end if;
					end if;


				when shift_tx => -- sample data				
					if toptx = '1' then
						tx_reg <= '0' & tx_reg(tx_reg'high downto 1);  	--shift right					
							if txbitcnt = ndbits then
								txfsm <= stop_tx;
							else	
								txbitcnt <= txbitcnt +1;
								txfsm <= edge_tx;
							end if;
					end if;
					
				when edge_tx => --should be near tx edge
					if toptx = '1' then
						txfsm <= shift_tx;
					end if;
--					
				when stop_tx => -- during stop bit
					if toptx = '1' then
						wait_a_bit_tx <= '0';
						txfsm <= idletx;
					end if;
			end case;
		end if;
	end process;
	
	
--clk16 clock generator
	process(rst, clk)
	begin
		if rst = '0' then
			div16 <= (others => '0');
			top16 <= '0';
		elsif rising_edge(clk) then
			top16 <= '0';
			if div16 = divisor or clrdivrx = '1' then -- dividing clock to generate baud
				div16 <= (others => '0');
				top16 <= '1';
			else
				div16 <= div16 +1;
			end if;
		end if;
	end process;
	

	--rx sampleing clock generator
	process(rst, clk)
	begin
		if rst = '0' then
			toprx <= '0';
			rxdiv <=  (others => '0');
		elsif rising_edge(clk) then
			toprx <= '0';
			if clrdivrx = '1' then
				rxdiv <= (others => '0');
			elsif top16 = '1' then
				if rxdiv = 7 then
					rxdiv <=  (others => '0');
					toprx <= '1';
				else
					rxdiv <= rxdiv +1;
				end if;
			end if;
		end if;
	end process;

	
	
	--tx sampleing clock generator
	process(rst, clk)
	begin
		if rst = '0' then
			toptx <= '0';
			txdiv <=  (others => '0');
		elsif rising_edge(clk) then
			toptx <= '0';
			if clrdivtx = '1' then
				txdiv <= (others => '0');
			elsif top16 = '1' then
				if txdiv = 7 then
					txdiv <=  (others => '0');
					toptx <= '1';
				else
					txdiv <= txdiv +1;
				end if;
			end if;
		end if;
	end process;	
	
	tx <= tx_reg(0);		

end arch;		



