library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity disp_mux_tb is
end entity;

architecture arch of disp_mux_tb is

	constant t : time := 1302.083333 ns;
	signal clk, reset:  std_logic;
	signal in3, in2, in1, in0: std_logic_vector(7 downto 0);
	signal an : std_logic_vector(3 downto 0);
	signal  sseg: std_logic_vector(7 downto 0);
begin

	uut: entity work.disp_mux(arch)
		port map (	clk => clk, reset => reset, in3 => in3, 
						in2 => in2, in1 => in1, in0 => in0, an => an, sseg => sseg);
						
	process
	begin
		clk <= '0';
		wait for t/2;
		clk <= '1';
		wait for t/2;
	end process;
	
	process
	begin
		reset <= '1';
		wait for t *2;
		wait for t *2;
		reset <= '0';
		
		wait until an = "0111";
		wait for t *2;
		wait for t *2;
		wait until an = "0111";
		wait for t *2;
		wait for t *2;
		
		assert false
			report "Simulation Completed"
		severity failure;
		
	end process;
		
end arch;
	