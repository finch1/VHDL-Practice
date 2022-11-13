library ieee;
use ieee.std_logic_1164.all;

entity bin_counter_tb is
end bin_counter_tb;

architecture arch of bin_counter_tb is
	constant three : integer := 3;
	
	--since the operation of a synchronous system is synced by a clock signal, 
	--we define a constant with a built in data type time for the clock period:
	constant t: time := 20 ns; -- clk period
	
	signal clk, rst : std_logic;
	signal syn_clr, load, en, up: std_logic;
	signal d: std_logic_vector(three -1 downto 0);
	signal max_tick, min_tick: std_logic;
	signal q: std_logic_vector(three -1 downto 0);
begin
	--instatiation
	--the code consists of a component instatiation statement, which creates an 
	--instance of a 3-bit counter and three segments which generate a stimulus for a 
	--clock, reset, and regular inputs.
	
	counter_unit: entity work.univ_bit_counter(arch)
		generic map( n => three)
		port map(clk => clk, rst => rst, syn_clr => syn_clr,
					load => load, en => en, up => up, d => d, 
					max_tick => max_tick, min_tick => min_tick,
					q => q);
					
	--clock
	--20 ns clock running forever
	--the clock generation is specified by a process:
	--the clk signal is assigned between '0' and '1' alternativley, 
	--and each value lasts for half a period. note that the process has no 
	--sensitivity list and repeats itself forever.
	process
	begin
		clk <= '0';		
		wait for t/2;
		clk <= '1';
		wait for t/2;		
	end process;
	
	--reset
	--reset assert for t/2
	rst <= '1', '0' after t/2;
	
	--other stimulus
	process
	begin
		--initial input
		syn_clr <= '0';
		load <= '0';
		en <= '0';
		up <= '1'; --count up
		d <= (others => '0');
		
	--DIN WASALT GHALIJA WAHDI GHAX BIL BAJT. For a synchronous system with positive 
	--	edge triggered FFs an input signal must be stable around the rising_edge to satisfy
	--	the setup and hold time constraints. onc way is to change an input signal during
	--	the falling edge.
		wait until falling_edge(clk);
		wait until falling_edge(clk);
		--test load
		load <= '1';
		d <= "011";
		wait until falling_edge(clk);
		load <= '0';
		--pause 2 clocks
		wait until falling_edge(clk);
		wait until falling_edge(clk);
		--test syn_clr
		syn_clr <= '1'; -- clear
		wait until falling_edge(clk);
		syn_clr <= '0';
		--test up counter and pause
		en <= '1'; -- count
		up <= '1';
		for i in 1 to 10 loop -- count 10 clocks
			wait until falling_edge(clk);
		end loop;
		en <= '0';
		wait until falling_edge(clk);
		wait until falling_edge(clk);
		en <= '1';
		wait until falling_edge(clk);
		wait until falling_edge(clk);
		--test down counter
		up <= '0';
		for i in 1 to 10 loop -- run 10 clocks
			wait until falling_edge(clk);
		end loop;
		--other wait conditions
		--continue until q=2
		
		-- wait until a special condition
		wait until q = "010";
		wait until falling_edge(clk);
		up <= '1';
		--continue until min_tick changes value
		
		--wait until a signal changes
		wait on min_tick;
		wait until falling_edge(clk);
		up <= '0';
		wait for 4*t; --wait for 80ns
		en <= '0';
		wait for 4*t;
		--terminate simulation
		--an additional assertion statement is added to the end of the process. 
		--It generates an " artificial failure" and stops the simulation
		assert false
			report "Simulation Completed"
		severity failure;
		
		end process;
end arch;
		
		
		