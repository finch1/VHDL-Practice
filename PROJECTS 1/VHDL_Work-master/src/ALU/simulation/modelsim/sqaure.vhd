-----------------------------------------------------------------------
--this example shows how to read a single integer value from a line,
--square the value, and write the square value to another file.
-----------------------------------------------------------------------
library ieee;
library std;
use std.textio.all;
use ieee.std_logic_1164.all;

entity sqaure is port(
	go : in std_logic);
end entity;

architecture simple of sqaure is
begin
	process(go) --the process executes whenever signal go has an event
		file infile : text open read_mode is "infile1.txt";
		file outfile: text open write_mode is "outfile1.txt";
		
		variable out_line, my_line : line; --used to hold a line to write to a file or a line that 
													  --has just been read from the file. The line structure is
													  --the basic unit upon which all textio operations are performed.
													  --When reading from a file, the first step is to read in a line 
													  --from the file into a structure of type line. Then the line 
													  --structure is processed field by field.  
		variable int_val : integer;
	begin
		while not endfile(infile) loop --Loops until an end-of-file condition occurs on the input file infile.
			--read a line from the input file
			readline(infile, my_line); --The readline statement reads a line from the file and places the line 
												--in variable my_line.
			
			--read a value from the line
			read(my_line, int_val); --The read procedure call that reads a single integer value from my_line
											--into variable int_val. Procedure read is an overloaded procedure that reads
											--different type values from the line, depending on the type of the argument 
											--passed to it.
			
			--square the value
			int_val := int_val **2;
			
			--write the squared value to the line
			write(out_line, int_val); --The computed answer is written to another variable of type line, called
											  --out_line. Procedure write is also an overloaded procedure that writes a 
											  --number of differnt value types, depending on the type of the argument passed to it. 
			
			--write the line to the output file
			writeline(outfile, out_line); --This procedure writes out the line variable out_line to the output file
													--outfile1.
		end loop;
	end process;
end simple;