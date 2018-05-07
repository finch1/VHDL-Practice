library ieee; 
library std;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use std.textio.all; 

entity tbmyalu  is 
  generic ( n  : integer   := 3 ); 
end ; 
 
architecture tbmyalu_arch of tbmyalu is
  signal sel :  std_logic; 
  signal y   :  std_logic_vector (n downto 0); 
  signal a   :  std_logic_vector (n downto 0); 
  signal cin :  std_logic; 
  signal b   :  std_logic_vector (n downto 0); 
  signal cout:  std_logic; 
  
  component myalu  
    generic ( n : integer);  
    port ( 
      sel: in std_logic ; 
      y  : out std_logic_vector (n downto 0) ; 
      a  : in std_logic_vector (n downto 0) ; 
      cin: in std_logic ; 
      b  : in std_logic_vector (n downto 0) ; 
      cout: out std_logic ); 
  end component ; 
  
begin

--provide stimulus and check the result
  add_stimulus : process
	--temporary variables from component
	variable tmpsel, tmpcin : bit;
	
	--file I/O related
	file integer_file : text open read_mode is "aluinout.txt";
	variable my_line  : line; --holds data read from file
	variable my_a		: integer; --holds alu input data
	variable my_b		: integer; --holds alu input data
	variable my_expected	: integer range -20 to 30; --holds alu expected output data
	
	--error check
	variable good_val : boolean;
	
	--tab ignore
	variable tab : character;
	
  begin
		
		while not endfile(integer_file) loop						--loop till end of data from file
			readline(integer_file, my_line); 						--read line till carriage return, move to next line
			
			read(my_line, tmpsel, good => good_val); 				--process first value read
				sel <= to_stdulogic(tmpsel);
					assert good_val report "bad input";				--advice if input data failed
						next when not good_val; 						--skip and read again
		
			read(my_line, tab); 											-- skip a tab and ignore it						
			
			read(my_line, tmpcin, good => good_val); 				--process first value read
				cin <= to_stdulogic(tmpcin);
					assert good_val report "bad input";				--advice if input data failed
						next when not good_val; 						--skip and read again
			
			read(my_line, tab); 											-- skip a tab and ignore it
			
			read(my_line, my_a, good => good_val); 				--process first value read
				a <= std_logic_vector(to_unsigned(my_a, n +1));
					assert good_val report "bad input";				--advice if input data failed
						next when not good_val; 						--skip and read again
			
			read(my_line, tab); 											-- skip a tab and ignore it
			
			read(my_line, my_b, good => good_val); 				--process first value read
				b <= std_logic_vector(to_unsigned(my_b, n +1));
					assert good_val report "bad input";				--advice if input data failed
						next when not good_val; 						--skip and read again
			
			read(my_line, tab); 											-- skip a tab and ignore it
			
			read(my_line, my_expected, good => good_val); 		--process first value read
				assert good_val report "bad input";					--advice if input data failed
					next when not good_val; 							--skip and read again
			
			wait for 5 ns;													--check after result is stable
			if (to_integer(unsigned(cout & y)) /= my_expected) then 	--type cast for arithmetic comparison
				assert false report "wrong computation" severity error;
			end if;
						
			wait for 5 ns;
		end loop;
		wait;
  end process;
  
  
  
	 dut  : myalu  
	 generic map ( n  	=> n)
	 port map 	 ( sel   => sel,
						y   	=> y,
						a   	=> a,
						cin   => cin,
						b   	=> b,
						cout	=> cout); 	
 
 
end;