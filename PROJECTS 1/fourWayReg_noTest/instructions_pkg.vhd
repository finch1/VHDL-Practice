library ieee;
library std;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


package instructions_pkg is

	type instructions is(load, s_right, s_left);
	constant TYPE_WIDTH : natural := 3;

	-- use a function like this to convert between enumerated type and std_logic_vector
	function encode ( instruction : in instructions ) return std_logic_vector;

	function decode ( instruction : in integer ) return instructions;
end package;

package body instructions_pkg is

	-- use a function like this to convert between enumerated type and std_logic_vector
	function encode ( instruction : in instructions ) return std_logic_vector is
	begin
	  return std_logic_vector(to_unsigned(instructions'pos(instruction), TYPE_WIDTH));
	end encode;

	function decode ( instruction : in integer ) return instructions is
	begin
	  if instruction < TYPE_WIDTH then
		 return instructions'val(instruction);
	  else
			-- throw an error instead 
			assert false report "rating out of bounds in conversion to instructions" severity ERROR;
			return load;
	  end if;
	end decode;
end package body;