altera_jtag_to_avalon_analysis.zip readme.txt
---------------------------------------------

3/12/2012 D. W. Hawkins (dwh@ovro.caltech.edu)

This zip file was created using the Cygwin shell

http://www.cygwin.com/

and the zip utility.

The zip file contains three directories; doc, hdl, and tcl.

There are slight differences in how zip extraction tools work
under Windows and under the bash shell (Cygwin or Linux).

1) Windows Extraction

   Under Windows Explorer, select the zip file, and then
   right click and select "Extract all ..."
   
   This will unzip the tutorial into a directory named
   altera_jtag_to_avalon_analysis

2) Bash command line extraction

   To list the contents of the zip file, use

   unzip -l altera_jtag_to_avalon_analysis.zip

   To unzip into the directory altera_jtag_to_avalon_analysis use

   unzip -d altera_jtag_to_avalon_analysis altera_jtag_to_avalon_analysis.zip

   Without the -d option, the directories are unzipped into the
   current directory, i.e., the folders doc, dhl, and tcl are created.
      
