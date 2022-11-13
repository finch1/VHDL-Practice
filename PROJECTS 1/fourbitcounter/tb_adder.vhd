-- ----------------------------------------------------------------
-- tb_adder.vhd
-- 12/05/2018
-- simple up counter testbench
-- ----------------------------------------------------------------

library ieee;
library std;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity tb_adder is 
end entity;

architecture behavioural of tb_adder is

	-- component declaration for the unit under testbench
	component adder is port(
		clk : in std_logic;
		reset : in std_logic;
		count : out unsigned(3 downto 0)
	);
	end component;
	
	-- declare inputs and initialize to 0
	signal clk : std_logic := '0';
	signal reset : std_logic := '0';
	
	-- declare outputs
	signal count : unsigned(3 downto 0);
	
	-- define the period of clock
	constant CLK_PERIOD : time := 10 ns;
	
	begin
	
		-- instantiate the unit under test
		uut : adder port map(
							clk => clk,
							reset => reset,
							count => count
						);
		
		-- clock process definitions(clock with 50% duty cycle)
		clk_process: 	process
							begin
								clk <= '0';
								wait for CLK_PERIOD /2; -- for half of clock period stay at 0
								clk <= '1';
								wait for CLK_PERIOD /2; -- for next half of clock period stay at 1
							end process;
							
		-- stimulus process, apply inputs here
		stim_proc: 	process
						begin
							wait for CLK_PERIOD *10; -- wait for 10 clock cycles
							reset <= '1'; -- apply reset for 2 clock cycles
							wait for CLK_PERIOD *2;
							reset <= '0'; -- pull down reset and let counter run
							wait for CLK_PERIOD *20;
							assert false
							report "simulation ended"
							severity failure; -- end simulation
						end process;
end;
						
			