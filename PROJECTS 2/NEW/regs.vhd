library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regs is 
	generic( data_width : natural := 15;
				addr_width : natural := 4);
	port(
		clk, rst : in  std_logic;
		
		wen		: in  std_logic;
		dest_adds: in  std_logic_vector(addr_width -1 downto 0);		
		src1_adds: in  std_logic_vector(addr_width -1 downto 0);
		src2_adds: in  std_logic_vector(addr_width -1 downto 0);
		
		reg_in   : in  std_logic_vector(data_width downto 0);
		
		sp			: out std_logic_vector(data_width downto 0);
		int		: out std_logic_vector(data_width downto 0);
		
		reg_a    : out std_logic_vector(data_width downto 0);
		reg_b    : out std_logic_vector(data_width downto 0));
end regs;

architecture arch of regs is
	type mem is array(0 to 2**addr_width -1) of std_logic_vector(data_width downto 0);	
	signal reg : mem;
begin
	
	process(clk, rst)
	begin
		if rst = '0' then
			reg <= (others =>(others => '0'));
		elsif rising_edge(clk) then
			if wen = '1' then
				reg (to_integer(unsigned(dest_adds))) <= reg_in;
			end if;			
		end if;
	end process;
	
	reg_a <= reg(to_integer(unsigned(src1_adds)));
	reg_b <= reg(to_integer(unsigned(src2_adds)));
	
end arch;