library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity myalu is
    generic( n : integer);
    port( a, b   : in std_logic_vector (n downto 0);
			 cin    : in std_logic;
    		 sel 	  : in std_logic;
			 cout   : out std_logic;			 
	       y      : out std_logic_vector (n downto 0));
end myalu;

architecture beh of myalu is

	signal a_sig, b_sig: unsigned(n downto 0);
	signal sum_sig, sub_sig: unsigned(n +1 downto 0);
	 
begin

		
    --convert to unsigned
   a_sig <= unsigned(a);	 
	b_sig <= unsigned(b);
	
   sum_sig <= resize(a_sig, n +2) + resize(b_sig, n +2) + ('0' & cin); --for some weird reson the '0'& allows arithmetic ops on std_logic
   sub_sig <= resize(a_sig, n +2) - resize(b_sig, n +2) - ('0' & cin);
	 
	
	y	<= std_logic_vector(sum_sig(n downto 0)) 	when sel = '0' else
			std_logic_vector(sub_sig(n downto 0));
		
	cout <= std_logic(sum_sig(n +1)) when sel = '0' else
			  std_logic(sub_sig(n +1));

end beh;

