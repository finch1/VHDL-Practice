library ieee;
use ieee.std_logic_1164.all;

entity fanout is port(
	src_in : in std_logic;
	supply : in std_logic;
	src_out : out std_logic_vector(3 downto 0));
end fanout;

architecture arch of fanout is
--	signal supply : std_logic_vector(3 downto 0) := (others => '1');
begin

	G0: for i in 0 to 3 generate 
		src_out(i) <= src_in and supply;
	end generate;
end arch;	
	