library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity reg_mem is
		generic (
			data_width :integer := 8;
			addr_width :integer := 5);
		port (
			clk   : in std_logic; -- clock input
			addr  : in std_logic_vector (addr_width-1 downto 0); -- address input
			d_in  : in std_logic_vector (data_width-1 downto 0); --
			d_out : out std_logic_vector (data_width-1 downto 0); --
			cs    : in std_logic; -- chip select
			we    : in std_logic; -- write enable/read enable
			oe    : in std_logic);  -- output enable 
end reg_mem;
		
architecture rtl of reg_mem is
----------------internal variables----------------
	constant ram_depth :integer := 2**addr_width;
--	signal d_in, d_out :std_logic_vector (data_width-1 downto 0);

	type ram is array (integer range <>)of std_logic_vector (data_width-1 downto 0);
	signal mem : ram (0 to 255);
begin

----------------code starts here------------------
-- output : when we = 0, oe = 1, cs = 1
--	data <= to_x01(data_out) when (cs = '1' and oe = '1' and we = '0') else (others => 'z');
							   --ram is outputting data			                    --wait for data in 
-- memory write block
-- write operation : when we = 1, cs = 1
	mem_write:process (clk) begin
		if (rising_edge(clk)) then
			if (cs = '1' and we = '1') then
				mem(conv_integer(addr)) <= d_in;
			end if;
		end if;
	end process;

-- memory read block
-- read operation : when we = 0, oe = 1, cs = 1
	mem_read:process (clk) begin
		if (rising_edge(clk)) then
			if (cs = '1'  and oe = '1' and we = '0') then
				d_out <= mem(conv_integer(addr));
			end if;
		end if;
	end process;

end architecture;