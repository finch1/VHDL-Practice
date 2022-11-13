 library ieee;
 use ieee.std_logic_1164.all;

 entity  altasmi_int is port ( 
		 addr			:	out  std_logic_vector (23 downto 0);
		 busy			:	in  std_logic;
		 clk			:	in  std_logic;
		 reset		:	in  std_logic;
		 data_valid	:	in  std_logic;
		 datain		:	in  std_logic_vector (7 downto 0);
		 dataout		:	out  std_logic_vector (7 downto 0);
		 ill_write	:	in  std_logic;
		 rden			:	out  std_logic;
		 read			:	out  std_logic;
		 wren			:	out  std_logic;
		 write		:	out  std_logic); 
end altasmi_int;

architecture rtl of altasmi_int is
begin
	
	case read_request is
		when tun_setti =>
		when last_freq =>
		when freq_pres =>
		when als_setti	=>
		
	case write_request is
		when tun_setti =>
		when last_freq =>
		when freq_pres =>
		when als_setti	=>		