-- ----------------------------------------------------------------
-- serParReg.vhd
-- 3/06/2018
-- shift left - shift right - parallel in - parallel out
-- ----------------------------------------------------------------
library ieee;
	use ieee.std_logic_1164.all;
	use work.instructions_pkg.all;

entity serParReg is port(
	clk: in std_logic;
	shsel: in instructions;
	serial_in: in std_logic;
	din : in std_logic_vector(7 downto 0);
	serial_out: out std_logic;
	dout : out std_logic_vector(7 downto 0));
end serParReg;

architecture arch of serParReg is
	signal content: std_logic_vector(7 downto 0);
begin
	process(clk)
	begin
		if rising_edge(clk) then
			case shsel is
				when load => content <= din; -- load values
				when s_right => content <= serial_in & content(7 downto 1);	-- lsb out first. pad with bits from serial in
				when s_left => content <= content(6 downto 0) & serial_in;	-- msb out first. pad with bits from serial in
				when others => null;
			end case;
		end if;
	end process;
	
	dout <= content; 
	
	serial_out <= 	content(0) when shsel = s_right else
						content(7) when shsel = s_left else
						'Z';
						
end arch;