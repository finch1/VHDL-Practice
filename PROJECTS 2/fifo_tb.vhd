library ieee;
use ieee. std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo_tb is
	generic( b: natural := 8; -- number of bits
				w: natural := 4); -- number of address bits
end entity;

architecture arch_tb of fifo_tb is
	signal clk, rst: std_logic;
	signal rd, wr: std_logic;
	signal w_data: std_logic_vector(b-1 downto 0);
	signal r_data: std_logic_vector(b-1 downto 0);
	signal empty, full: std_logic;
	constant t : time := 100 ps;
begin
	fifo_unit: entity work.fifo(arch)
		port map( clk => clk, rst => rst, rd => rd, wr => wr, 
				w_data => w_data, r_data => r_data, empty => empty,
				full => full);
	process 
	begin
		clk <= '1';
		wait for t/2;
		clk <= '0';
		wait for t/2;
	end process;

	process
	begin
		
		rst <= '1';
		wait until falling_edge(clk);
		rst <= '0';

		wr <= '1';
		rd <= '0';
		w_data <= "00010010"; --18
		wait until falling_edge(clk);
		w_data <= "00010100"; --20
		wait until falling_edge(clk);
		w_data <= "00000100"; --4
		wait until falling_edge(clk);
--		wr <= '0';
--		rd <= '1';
--		wait until falling_edge(clk);
--		wait until falling_edge(clk);
--		rd <= '0';
--		wr <= '1';
		w_data <= "00001100"; --12
		wait until falling_edge(clk);
		w_data <= "00010011"; --19
		wait until falling_edge(clk);
		w_data <= "00010110"; --22
		wait until falling_edge(clk);
		w_data <= "00100011"; --35
		wait until falling_edge(clk);
		w_data <= "00111111"; --63
--		rd <= '1';
		wait until falling_edge(clk);
		w_data <= "01001110"; --78
		wait until falling_edge(clk);
		w_data <= "01010001"; --81
		wait until falling_edge(clk);
		w_data <= "00000101"; --5
		wait until falling_edge(clk);
		w_data <= "01011101"; --93
		wait until falling_edge(clk);
		w_data <= "01100011"; --99
		wait until falling_edge(clk);
		w_data <= "01101110"; --110
		wait until falling_edge(clk);
		w_data <= "01010101"; --84
		wait until falling_edge(clk);
		w_data <= "10000101"; --133
		wait until falling_edge(clk);
		w_data <= "11011101"; --221
		wait until falling_edge(clk);
		w_data <= "01101011"; --107
		wait until falling_edge(clk);
		
		assert false
			report "simulation completed"
		severity failure;
		end process;
end arch_tb;