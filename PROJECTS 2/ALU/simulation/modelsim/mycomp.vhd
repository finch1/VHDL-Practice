-- ----------------------------------------------------------------
-- mycomp.vhd
--
-- 4/22/2016
--
-- simple compare
--
-- supports : 	equal to zero, equal, greater then, greater then or equal
--					less then, less then or equal, signed
-- ----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ----------------------------------------------------------------

entity mycomp is 
	generic(	iwidth : natural);
	port( a, b : in  std_logic_vector(iwidth -1 downto 0);
			y    : out std_logic_vector(6 downto 0));
end entity;

-- ----------------------------------------------------------------

architecture simple of mycomp is

	-- ----------------------------------------------------------------
	-- internal variables
	-- ----------------------------------------------------------------
	signal a_sig, b_sig : signed (iwidth -1 downto 0);
	signal comp :std_logic_vector(6 downto 0);
	
	-- ----------------------------------------------------------------
	-- enumerate selection
	-- ----------------------------------------------------------------
	
	type enumsel is (eqz, eql, grt, gre, lss, lse, sgn);
	
	-- ----------------------------------------------------------------
	-- all zeros function
	-- ----------------------------------------------------------------
	
	function allzero(input : signed(iwidth -1 downto 0)) return std_logic is
		variable temp   : signed(iwidth -1 downto 0);
	begin
		temp(0) := input(0);
		for i in 1 to input'high loop
			temp(i) := temp(i -1) or input(i);
		end loop;
		return not temp(temp'high);
	end function allzero;	

	
	
begin

	-- ----------------------------------------------------------------
	-- signal assignment
	-- ----------------------------------------------------------------
	a_sig <= signed(a);
	b_sig <= signed(b);
	
	-- ----------------------------------------------------------------
	-- combinatorial compare
	-- ----------------------------------------------------------------	

	comp(enumsel'pos(eqz)) <= '1' when allzero(a_sig) = '1' else '0';	
	comp(enumsel'pos(eql)) <= '1' when a_sig = b_sig else '0';
	
	comp(enumsel'pos(grt)) <= '1' when a_sig > b_sig else '0';	
	comp(enumsel'pos(gre)) <= comp(enumsel'pos(grt)) or comp(enumsel'pos(eql));
	
	comp(enumsel'pos(lss)) <= '1' when a_sig < b_sig else '0';
	comp(enumsel'pos(lse)) <= comp(enumsel'pos(lss)) or comp(enumsel'pos(eql));
		
	comp(enumsel'pos(sgn)) <= '1' when a_sig(iwidth -1) = '1' else '0';
		
	-- ------------------------------------------------------------
	-- Outputs
	-- ------------------------------------------------------------
	
	y <= comp;
		

end architecture;