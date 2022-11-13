--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--
--
--entity hex_to_sseg is port(
--	clk, rst : in std_logic;
----	hex : in std_logic_vector(3 downto 0);
----	hex : in natural (0 to 15);
--	dp  : in std_logic;
--	seg_sel : out unsigned(3 downto 0);
--	sseg: out std_logic_vector(7 downto 0));
--end hex_to_sseg;
--
--architecture arch of hex_to_sseg is
--
--	type oned is array (0 to 15) of std_logic_vector(6 downto 0);
--	constant seg_data : oned := (	"0000001", "1001111", "0010010", "0000110",
--											"0000110", "1001100", "0100100", "0100000",
--											"0001111", "0000000", "0000100", "0001000",
--											"1100000", "0110001", "0110000", "0111000");
--	
--	signal seg_inc: unsigned(3 downto 0) := "0001" ;
--	signal hex : unsigned(15 downto 0) := (others => '0');
--	signal en : bit;
--	
--	subtype digit is unsigned(12 downto 0);
--	constant zero : digit := (others => '0');
--	
--	
--begin
--
----	gen: for i in hex'range generate
----				sseg(i) <= seg_data(i) when hex = i;
----		  end generate;
--					
--
--	process(clk, rst)
--	variable inc : digit;
--	begin
--		if rst = '1' then
--			inc := (others => '0');	
--		elsif rising_edge(clk) then
--			inc := inc +1;
--			seg_inc <= seg_inc(0) & seg_inc(3 downto 1);
--			
--			if inc = zero then
--				hex <= hex +1;		
--			end if;
--		end if;
--	end process;
--	
--	seg_sel <= seg_inc;
--	
--	-- hex qed juri listes numru. irid jigi unsigned
--	
--	with seg_inc select
--	sseg(6 downto 0) <= 	seg_data(to_integer(hex(3 downto 0))) 	 when "0001",
--								seg_data(to_integer(hex(7 downto 4))) 	 when "0010",
--								seg_data(to_integer(hex(11 downto 8)))  when "0100",
--								seg_data(to_integer(hex(15 downto 12))) when "1000",
--								"1111111" when others;
--	sseg(7) <= dp;
--	
--end arch;
				
				
library ieee;
use ieee.std_logic_1164.all;

entity hex_to_sseg is port(
	hex : in std_logic_vector(3 downto 0);
	dp  : in std_logic;
	sseg: out std_logic_vector(7 downto 0));
end hex_to_sseg;

architecture arch of hex_to_sseg is
begin


	with hex select
		sseg(6 downto 0) <= 
			"0000001" when "0000",
			"1001111" when "0001",
			"0010010" when "0010",
			"0000110" when "0011",
			"0000110" when "0100",
			"1001100" when "0101",
			"0100100" when "0110",
			"0100000" when "0111",
			"0001111" when "1000",
			"0000000" when "1001",
			"0000100" when "1010",
			"0001000" when "1011",
			"1100000" when "1100",
			"0110001" when "1101",
			"0110000" when "1110",
			"0111000" when others;

	sseg(7) <= dp;
	
end arch;				