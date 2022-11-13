--parameterized register file
--the write address signal, w_addr, specifies where to store data, 
--and the read address signal, r_addr, specifies where to retrieve data. 
--the register file is generally used ads  fast temporary storage. This 
--code is for 2^w - by b parameterized register file. 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_file is generic(
	b: integer := 8;	--use integer to define generic number of bits
	w: integer := 2);	--use integer to define generic number of address bits
port( clk, reset: in std_logic;
		wr_en: in std_logic;
		w_addr, r_addr, r_addr_2: in std_logic_vector(w-1 downto 0);
		w_data: in std_logic_vector(b-1 downto 0);
		r_data, r_data2: out std_logic_vector(b-1 downto 0));
end reg_file;

architecture arch of reg_file is
	type reg_file_type is array (2**w-1 downto 0) of std_logic_vector(b-1 downto 0);
	signal array_reg: reg_file_type;
begin
	process(clk, reset)
	begin
		if(reset = '1') then
			array_reg <= (others => (others => '0'));
		elsif rising_edge(clk) then
			if wr_en = '1' then
				array_reg(to_integer(unsigned(w_addr))) <= w_data; -- address decoder
			end if;
		end if;
	end process;
		--read port
		r_data <= array_reg(to_integer(unsigned(r_addr))); -- data multiplexing
		r_data2 <= array_reg(to_integer(unsigned(r_addr_2))); -- data multiplexing
end arch;