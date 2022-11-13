-- ----------------------------------------------------------------
-- mymult.vhd
--
-- 4/17/2017
--
-- simple multiplier
--
-- ----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ----------------------------------------------------------------

entity mymult is 
	generic( IWIDTH : natural;
				OWIDTH : natural);
	
	port( a, b : in  std_logic_vector(IWIDTH -1 downto 0);
			y    : out std_logic_vector(OWIDTH -1 downto 0));
end entity;

-- ----------------------------------------------------------------

architecture simple of mymult is

	-- ----------------------------------------------------------------
	-- internal signals
	-- ----------------------------------------------------------------
	--
	-- signed versions of inputs
	signal a_sig, b_sig: signed(IWIDTH -1 downto 0);
	--
	-- signed version of output sign extended
	signal y_sig : signed(OWIDTH -1 downto 0);
	
begin

	-- ----------------------------------------------------------------
	-- inputs
	-- ----------------------------------------------------------------
	--
	-- converted to signed
	a_sig <= signed(a);
	b_sig <= signed(b);
	
	-- ----------------------------------------------------------------
	-- combinatorial multiplication
	-- ----------------------------------------------------------------
	
	y_sig <= resize(a_sig, IWIDTH) * resize(b_sig, IWIDTH);
	
	-- ----------------------------------------------------------------
	-- output
	-- ----------------------------------------------------------------
	
	y <= std_logic_vector(y_sig);

end simple;
	
	