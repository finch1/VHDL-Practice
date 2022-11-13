-- ----------------------------------------------------------------
-- myalu.vhd
--
-- 4/16/2017
--
-- Simple ALU.
--
-- Supports add/subtract.
--
-- ----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ----------------------------------------------------------------

entity myalu is
	generic (
		-- Input/output data widths
		WIDTH : integer
	);
	port (
		a    : in  std_logic_vector(WIDTH-1 downto 0);
		b    : in  std_logic_vector(WIDTH-1 downto 0);
		cin  : in  std_logic;
		sel  : in  std_logic;
		cout : out std_logic;
		y    : out std_logic_vector(WIDTH-1 downto 0)
	);
end entity;

-- ----------------------------------------------------------------

architecture beh of myalu is

	-- ------------------------------------------------------------
	-- Internal signals
	-- ------------------------------------------------------------
	--
	-- Signed versions of the inputs
	signal a_sig, b_sig: signed(WIDTH-1 downto 0);
	--
	-- Sign-extended results
	signal result : signed(WIDTH downto 0);

begin

	-- ------------------------------------------------------------
	-- Inputs
	-- ------------------------------------------------------------
	--
	-- Convert to signed
	a_sig <= signed(a);
	b_sig <= signed(b);

	-- ------------------------------------------------------------
	-- Combinatorial add/sub
	-- ------------------------------------------------------------
	--
	process(a_sig, b_sig, sel)
	begin
		if (sel = '0') then
			-- VHDL-2008 is ok with this
			--	result <= resize(a_sig, WIDTH+1) + resize(b_sig, WIDTH+1) + cin;
			-- Old syntax needs to convert cin to a multi-bit
			-- signal, first need to make it an unsigned 1.
			result <= resize(a_sig, WIDTH+1) + resize(b_sig, WIDTH+1) + resize('0' & cin, WIDTH+1);
		else
			result <= resize(a_sig, WIDTH+1) - resize(b_sig, WIDTH+1) - resize('0' & cin, WIDTH+1);
		end if;
	end process;

	-- ------------------------------------------------------------
	-- Outputs
	-- ------------------------------------------------------------
	--
	y    <= std_logic_vector(result(WIDTH-1 downto 0));
	cout <= std_logic(result(WIDTH));

end architecture;

