
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_add_sub is
    generic(	n : integer := 3); -- number of input bits
    port(		a, b		: in std_logic_vector(n downto 0);
					arith_out: out std_logic_vector(n downto 0);
					cout   	: out std_logic);
end sign_add_sub;

architecture add_sub of sign_add_sub is
    signal a_sig, b_sig	: unsigned(n downto 0);
    signal sub_sig		: unsigned(n downto 0);
begin
    --convert to unsigned
    a_sig <= unsigned(a);
    b_sig <= unsigned(b);

    --add and subtract
    sub_sig <= a_sig - b_sig;

    arith_out <= std_logic_vector(sub_sig(n downto 0));
    cout <= std_logic(sub_sig(n));
end add_sub;


--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--
--entity sign_add_sub is
--    generic(	n : integer := 7); -- number of input bits
--    port(		a, b		: in std_logic_vector(n downto 0);
--					func 		: in std_logic_vector(3 downto 0);
--					cin		: in std_logic := '0';
--					arith_out: out std_logic_vector(n downto 0);
--					cout_sum : out std_logic;
--					cout_sub	: out std_logic);
--end sign_add_sub;
--
--architecture add_sub of sign_add_sub is
--    signal a_sig, b_sig: unsigned(n downto 0);
--    signal sum_sig, sub_sig: unsigned(n +1 downto 0);
--begin
--    --convert to unsigned
--    a_sig <= unsigned(a);
--    b_sig <= unsigned(b);
--    --add and subtract
--    sum_sig <= (a_sig(n) & a_sig) + (b_sig(n) & b_sig) + ('0' & cin); -- add a mux and register to increment 
--    sub_sig <= (a_sig(n) & a_sig) - (b_sig(n) & b_sig) - ('0' & cin); -- same same to decrement
--
--    arith_out <= std_logic_vector(sum_sig(n downto 0)) when func = "1001" else std_logic_vector(sub_sig(n downto 0));
--    cout_sum <= std_logic(sum_sig(n +1));    
--    cout_sub <= std_logic(sub_sig(n +1));
--end add_sub;


----(I've rearranged things as a 2-d array rather than a vector of vectors)
--
--architecture a1 of test is
--    type std_ulogic_2d is array(natural range <>, natural range <>) of std_ulogic;
--    signal td_array : std_ulogic_2d(0 to 3, 0 to 4);
--    signal col_array : std_ulogic_vector(td_array'range(1));
--begin  -- architecture a1
--    iloop : for i in td_array'range(1) generate
--        col_array(i) <= td_array(i,0);
--    end generate;
--end architecture a1;