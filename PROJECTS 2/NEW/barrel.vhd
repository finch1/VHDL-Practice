--library ieee;
--    use ieee.std_logic_1164.all;
--    use ieee.numeric_std.all;
--
--entity barrel is
--    generic(
--        dist_width : natural := 4;
--        num_stages : natural := 16);
--    port(
--        clk            : in std_logic;
--        enable        : in std_logic;
--        is_left        : in std_logic;
--        data        : in std_logic_vector((num_stages-1) downto 0);
--        distance    : in unsigned((dist_width-1) downto 0);
--        sr_out        : out std_logic_vector((num_stages-1) downto 0));
--end entity;
--
--architecture rtl of barrel is
--    -- declare the shift register signal
--    signal sr : unsigned ((num_stages-1) downto 0);
--begin
--    process (clk)
--    begin
--        if (rising_edge(clk)) then
--            if (enable = '1') then
--
--                -- perform rotation with functions rol and ror
--                if (is_left = '1') then
--                    sr <= unsigned(data) rol to_integer(distance);
--                else
--                    sr <= unsigned(data) ror to_integer(distance);
--                end if;
--
--            end if;
--        end if;
--    end process;
--    sr_out <= std_logic_vector(sr);
--end rtl;


library ieee;
use ieee.std_logic_1164.all;

entity barrel is port(
	in0 : in std_logic_vector(3 downto 0);
	s : in std_logic_vector(1 downto 0);
	y : out std_logic_vector(3 downto 0));
end barrel;

architecture rtl1 of barrel is
	constant n : integer := 4;
	constant m : integer := 2;
	type arytype is array(m downto 0) of std_logic_vector (n-1 downto 0);
	signal intsig, left, pass : arytype;
	signal zeros : std_logic_vector(n -1 downto 0);
begin
	zeros <= (others => '0');
	intsig(0) <= in0;
	
	muxgen : for j in 1 to m generate
		pass(j) <= intsig(j-1);
		left(j) <= intsig(j-1)((n-2**(j-1))-1 downto 0) & zeros((2**(j-1))-1 downto 0);
		intsig(j)<= pass(j) when s(j-1) = '0' else left(j);
	end generate;
		y <= intsig(m);
end rtl1;
		
--architecture rtl2 of barrel is
--	constant n : integer := 16;
--	constant m : integer := 4;
--begin
--	po : process(in0, s)
--		type arytype is array(m downto 0) of std_logic_vector (n-1 downto 0);
--		variable intsig, left, pass : arytype;
--		variable zeros : std_logic_vector(n -1 downto 0);
--	begin
--		zeros := (others => '0');
--		intsig(0) := in0;
--		for j in 1 to m loop
--			pass(j) := intsig(j-1);
--			left(j) := intsig(j-1)(n-2**(j-1)-1 downto 0) & zeros(2**(j-1)-1 downto 0);
--			if(s(j-1) = '0') then
--				intsig(j) := pass(j);
--			else
--				intsig(j) := pass(j);
--			end if;
--		end loop;
--		y <= intsig(m);
--	end process;
--end rtl2;
		

--library ieee;
--	use ieee.std_logic_1164.all;
--	use ieee.std_logic_arith.all;
--
--entity barrel is port( 
--	datain: in std_logic_vector(15 downto 0);
--	direction: in std_logic;
--	rotation : in std_logic;
--	count: in std_logic_vector(4 downto 0);
--	dataout: out std_logic_vector(15 downto 0));
--end barrel;
--
--architecture behv of barrel is
---- shift left/right function
--	function barrel_shift(din: in std_logic_vector(15 downto 0);
--		dir: in std_logic;
--		cnt: in std_logic_vector(4 downto 0)) return std_logic_vector is
--	begin
--		if (dir = '1') then
--			return std_logic_vector((shr(unsigned(din), unsigned(cnt))));
--		else
--			return std_logic_vector((shl(unsigned(din), unsigned(cnt))));
--		end if;
--	end barrel_shift;
---- rotate left/right function
--
--	function barrel_rotate(din: in std_logic_vector(31 downto 0);
--		dir: in std_logic;
--		cnt: in std_logic_vector(4 downto 0)) return std_logic_vector is
--		variable temp1, temp2: std_logic_vector(31 downto 0);
--	begin
--		case dir is
--			when '1' => -- rotate right cnt times
--				temp1 := din & din;
--				temp2 := std_logic_vector(shr(unsigned(temp1),unsigned(cnt)));
--				return temp2(15 downto 0);
--			when others => -- rotate left cnt times
--				temp1 := din & din;
--				temp2 := std_logic_vector(shl(unsigned(temp1),unsigned(cnt)));
--				return temp2(31 downto 16);
--		end case;
--	end barrel_rotate;
--
--begin
--	p1: process (datain, direction, rotation, count)
--	begin
--		if (rotation = '0') then -- shift only
--			dataout <= barrel_shift(datain, direction, count);
--		else -- rotate only
--			dataout <= barrel_rotate(datain, direction, count);
--		end if;
--	end process;
--end behv;