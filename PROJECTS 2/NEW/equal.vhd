library ieee;
use ieee.std_logic_1164.all;

entity equal is 
    generic(n : in integer := 8);
    port(
        a, b : in std_logic_vector(n-1 downto 0);
        same : out std_logic);
end equal;

architecture rtl1 of equal is
begin
    p0 : process(a,b)
        variable same_so_far : std_logic;
begin
    same_so_far := '1';
    for i in a'range loop --with range attribute, code is flexi to change width
        if(a(i) /= b(i))then
            same_so_far := '0';
            exit;
        end if;
    end loop;
    same <= same_so_far;
end process;
end rtl1;

architecture rtl2 of equal is
    signal eachbit : std_logic_vector(a'length-1 downto 0);
begin
    xnor_gen : for i in a'range generate
        eachbit(i) <= not (a(i) xor b(i));
    end generate;

    p0:process(eachbit)
        variable bitsame : std_logic;
	 begin
		 bitsame := eachbit(0);
		 for i in 1 to a'length-1 loop
			  bitsame := bitsame and eachbit(i);
		 end loop;
		 same <= bitsame;
	end process;
end rtl2;

architecture rtl3 of equal is
begin
    same <= '1' when a = b else '0';
end rtl3;