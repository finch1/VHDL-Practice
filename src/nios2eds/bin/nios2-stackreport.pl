use sh_launch;
use strict;

# -------------------------------
# nios2-stackreport
#
#  Reads the output of GNU nm (e.g. nios2-elf-nm) and 
#  tries to figure-out how much stack/heap space you have.
#

my $stack_symbol    = "__alt_data_end";
my $nm_program      = "nios2-elf-nm";
my $elfsize_program = "nios2-elf-size";


# Per Michael Fairman, this is just a silly info-utility.  If
# something goes horribly wrong, this isn't a reason to stop the
# entire build process. So...even when we fail, we succeed.
#
my $ERROR_CODE = 0;

sub main 
{
   my $infile_name = shift (@ARGV);


   # Run "nios2-elf-size" and it makes a stupid report that 
   # looks like this:
   #
   #     text    data     bss     dec     hex filename
   #     3614     296       4    3914     f4a hello_world_0.elf
   # 
   # We want the FOURTH number on the SECOND line ("3914", in this case).
   # 
   #
   my $size_result = `$elfsize_program $infile_name`;
   my @size_lines = split (/\s*\n\s*/, $size_result);
   shift (@size_lines); #throw-away first useless line.
   my $size_line = shift (@size_lines);
   
   my $program_size = "";
   if ($size_line =~ /^\s*(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/) {
      $program_size = $4;
   }

   if ($program_size eq "") {
      print STDERR "Unable to determine program-size.\n";
      exit $ERROR_CODE;   
   }
   
   &print_kbyte_size_with_description 
       ("Info: ($infile_name)",
        $program_size,
        "program size (code + initialized data).");

   # Dump out symbol table (one symbol per line).
   # The format is:
   #    <hex address> <symbol type> <symbol name>
   #
   # Note that the hex address isn't prefixed with 0x.
   my $nm_result = `$nm_program --reverse-sort --numeric-sort $infile_name`;
   my @nm_lines = split (/\s*\n\s*/, $nm_result);

   # Go through all the lines until you see the magic stack-symbol:
   #
   my $stacktop_address = "";
   while ($stacktop_address eq "") {
      if (scalar (@nm_lines) == 0) {
         # Never found symbol..out of lines.
         print STDERR "Symbol '$stack_symbol' not found in nm-output.\n";
         exit $ERROR_CODE;
      }
      my $line = shift (@nm_lines);
      if ($line =~ /([0-9a-fA-F]+)\s+.\s+$stack_symbol/) {
          $stacktop_address = hex($1);
       }
   }

   # OK.  We now know the stacktop.  Get the address on the 
   # next line (UNLESS it's _gp, which shows-up unbidden and isn't 
   # really "taking up any space" for the purposes of this analysis).
   my $stack_limit = "";
   while ($stack_limit eq "") {
      if (scalar (@nm_lines) == 0) {
         # No valid symbol below stack top
         print STDERR "No symbols below '$stack_symbol' in nm-output.\n";
         exit $ERROR_CODE;
      }
      my $line = shift (@nm_lines);

      # skip "_gp" symbol.
      next if $line =~ /([0-9a-fA-F]+)\s+.\s+_gp\s*$/;
      if ($line =~ /([0-9a-fA-F]+)\s+.*/) {
         $stack_limit = hex($1);
      }
   }

   if ($stack_limit eq "") {
      print STDERR "Unable to determine stack-size from nm-output.\n";
      exit $ERROR_CODE;
   }

   my $stacksize = $stacktop_address - $stack_limit;
   my $cute_little_spacer = " " x length($infile_name);

   &print_kbyte_size_with_description ("Info:  $cute_little_spacer ",
                                       $stacksize,
                                       "free for stack + heap.");
}

sub print_kbyte_size_with_description
{
   my ($intro, $bytesize, $description) = (@_);

   if ($bytesize > 10 * 1024) {
      my $ksize = int ($bytesize / 1024);
      print STDOUT "$intro $ksize KBytes $description\n";
   } else {
      print STDOUT "$intro $bytesize Bytes $description\n";
   }
   
}


sub usage 
{
   print STDERR "usage: nios2-stackreport [elf-file-name]\n";
   exit $ERROR_CODE;
}

usage() if !@ARGV;
main(@ARGV);
exit 0;

# end of file
