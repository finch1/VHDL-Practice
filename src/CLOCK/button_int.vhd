
--http://www.labbookpages.co.uk/electronics/debounce.html
--debouncing
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity button_int is port(	
	clk, rst : in std_logic;	
	sw_in  	: in std_logic;
	edge_out : out std_logic);
end button_int;

architecture rtl of button_int is
	constant n : natural := 4;
	
	signal synchro : std_logic_vector(2 downto 0);
	signal lfsr    : unsigned(n -1 downto 0);
	signal lfsr_sum: unsigned(n downto 0);
	
	signal cout_ena: std_logic;	
	signal count   : unsigned(n -1 downto 0);
	signal sum     : unsigned(n -1 downto 0);
	
	signal latch, rise_reg : std_logic;
begin
  
	process(clk, rst)
	begin
		if rst = '0' then 
			lfsr <= (0 => '1', others => '0');
			synchro <= (others => '0');
		elsif rising_edge(clk) then
			lfsr <= lfsr(n-2 downto 0) & (lfsr(n-1) xor lfsr(n-2));
			
			synchro <= sw_in & synchro(2 downto 1);
		end if;
	end process;
  
	lfsr_sum  <= resize(lfsr,n +1) +1;
	cout_ena <= lfsr_sum(n) and synchro(0);

	

	process(clk,rst)
	begin
		if synchro(0) = '0' then
			count <= (others => '0');
		elsif rising_edge(clk) then
			if cout_ena = '1' and count /= X"F" then
					count <= count +1;
			end if;
		end if;
	end process;

	sum <= count xor('0' & count(n -1 downto 1));
	
	latch <= count(0) and count(1) and count(2) and count(3);
	
	process(clk, rst)
    begin
        if rst then
            rise_reg <= '0';
        elsif rising_edge(clk) then
            rise_reg <= latch;
        end if;
    end process;
    edge_out <= (not rise_reg) and latch;
	
end rtl;	