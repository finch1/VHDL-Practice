library ieee;
use ieee.std_logic_1164.all;
entity sec_gen is
	generic(constant n: integer := 14);
 	port (
		clk			:in  std_logic;                    
		reset			:in  std_logic;
		test : out std_logic;                    
		lfsr_out		:out std_logic);
end entity;
architecture behavioral of sec_gen is
 	signal lfsr_tmp      :std_logic_vector (n downto 0):= (0=>'1', others=>'0');
	signal and_tmp 		:std_logic_vector(n downto 0);
	signal cleaner       :std_logic;
 	constant polynome		:std_logic_vector (n downto 0):= "111010000000000";
begin
 	process (clk, reset) 
		variable lsb		:std_logic;	 
 		variable ext_inbit:std_logic_vector (n downto 0);
	begin 
		lsb := lfsr_tmp(0);
		for i in 0 to n loop	 
		    ext_inbit(i):= lsb;	 
		end loop;
	if (reset = '1') then
		lfsr_tmp <= (0=>'1', others=>'0');
	elsif (rising_edge(clk)) then
		lfsr_tmp <= ( '0' & lfsr_tmp(n downto 1) ) xor ( ext_inbit and polynome );
		cleaner <= and_tmp(n);
	end if;
	end process;
	
	and_tmp(0) <= lfsr_tmp(0);
	gen_and : for i in 1 to n generate
		and_tmp(i) <= and_tmp(i -1) and lfsr_tmp(i);
	end generate;
   	lfsr_out <= cleaner;
end architecture;