library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is 
	generic(n : natural := 7);
	port(
		clk, rst : in std_logic;
		pc_ld		: in std_logic;
		pc_new	: in std_logic_vector(n downto 0);
		pc_en		: in std_logic;
		pc_out   : out std_logic_vector(n downto 0));
end pc;

architecture arch of pc is
begin
	
	process(clk, rst)
		variable sig_pc : unsigned(n downto 0);
	begin
		if rst = '0' then
			sig_pc := (others => '1');
		elsif falling_edge(clk) then
			if pc_en = '1' then
				sig_pc := sig_pc +1;
				if pc_ld = '1' then
					sig_pc := unsigned(pc_new);
				end if;				
			end if;
		end if;
		pc_out <= std_logic_vector(sig_pc);
	end process;
	
	
end arch;