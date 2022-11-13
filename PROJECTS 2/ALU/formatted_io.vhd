library ieee;
library std;

use ieee.std_logic_1164.all;
use std.textio.all;

entity formatted_io is
end entity;

architecture beh of formated_io is
begin

	process is
		file outfile : text;
		variable f_status : file_open_status;
		variable count : integer := 5;
		variable value : bit_vector(3 downto 0) := x"6";
		variable buf : line; --buffer between the program and file
	begin
		file_open(fstatus, outfile, "myfile.txt", write_mode);
		L1 : write(buf, string'("This is an ex of formatted IO"));
		L2 : writeline(outfile, buf);
		L11: file_close(outfile);
		wait;
	end process;
end architecture beh;