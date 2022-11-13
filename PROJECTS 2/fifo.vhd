--A FIFO buffer is an elastic storage between two subsystems. It has two control 
--signals, wr and rd for write and read operations. When wr is asserted, the input
--data is written into the buffer. The head of the FIFO buffer is normally always
--available to read at any time. The rd signal actually acts a remove signal. When
--it is asserted the first item is removed of the buffer and the next item becomes
--available. 
-- 
--The registers in the register file are arranges as a circular queue with two pointers. 
--The write pointer points to the head of the queue, and the read pointer points to the 
--tail of the queue. The pointer advances one position for each write or read operation. 
--Two status signals, full and empty, are used to indicate the buffer is full and cant be
--written or empty and cant be read. One of the two conditions occurs when both signals 
--are equal. 
-- 
--One scheme to distinguish between conditions is to use two ffs to keep track of the empty 
--and full statuses. These ffs are set to '1' and '0' during system initialization and  then 
--modified in each clock cycle according to the values of the wr and rd signals. 
--
--The code is divided into a register file and a fifo controller. Considering the “10” case, 
--which implies that only a write operation occurs. The status ff is checked first to ensure 
--that the buffer is not full. If the condition is met, we advance the write pointer by one 
--position and clear the empty status ff. Storing one extra word to the buffer may make it full. 
--This happens if the new write pointer “catches” the read pointer, which is expressed by the 
--w_ptr_succ = r_ptr_reg expression. 


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo is 
	generic( b: natural := 8; -- number of bits
				w: natural := 4); -- number of address bits
   port( clk, rst: in std_logic;
			rd, wr: in std_logic;
			w_data: in std_logic_vector(b-1 downto 0);
			r_data: out std_logic_vector(b-1 downto 0);
			empty, full: out std_logic);
end fifo;

architecture arch of fifo is 
	type reg_file_type is array (2**w -1 downto 0) of std_logic_vector(b-1 downto 0);
	signal array_reg : reg_file_type;
	signal w_ptr_reg, w_ptr_next, w_ptr_succ : std_logic_vector (w-1 downto 0);
	signal r_ptr_reg, r_ptr_next, r_ptr_succ : std_logic_vector (w-1 downto 0);
	signal full_reg, empty_reg, full_next, empty_next, wr_en : std_logic;
	signal wr_op: std_logic_vector(1 downto 0);
begin
	--register file
	process(clk, rst)
	begin
		if(rst = '1') then
			array_reg <= (others => (others => '0'));
		elsif rising_edge(clk) then
			if wr_en = '1' then
				array_reg(to_integer(unsigned(w_ptr_reg))) <= w_data;
			end if;
		end if;
	end process;
	
	--read port
	r_data <= array_reg(to_integer(unsigned(r_ptr_reg)));
	--write enabled only when fifo is not full
	wr_en <= wr and (not full_reg);
	
	--fifo control logic
	--register for read and write pointers
	process(clk, rst)
	begin
		if(rst = '1')then
			w_ptr_reg <= (others => '0');
			r_ptr_reg <= (others => '0');
			full_reg <= '0';
			empty_reg <= '1';
			
		elsif rising_edge(clk)then
			w_ptr_reg <= w_ptr_next;
			r_ptr_reg <= r_ptr_next;
			full_reg <= full_next;
			empty_reg <= empty_next;
		end if;
	end process;
	
	--successive pointer values
	w_ptr_succ <= std_logic_vector(unsigned(w_ptr_reg) + 1);
	r_ptr_succ <= std_logic_vector(unsigned(r_ptr_reg) + 1);
	
	--next state logic for read and write pointers
	wr_op <= wr & rd;
	process(w_ptr_reg, w_ptr_succ, r_ptr_reg, r_ptr_succ, wr_op, empty_reg, full_reg)
	begin
		w_ptr_next <= w_ptr_reg;
		r_ptr_next <= r_ptr_reg;
		full_next <= full_reg;
		empty_next <= empty_reg;
		
		case wr_op is
			when "00" => --no op
			when "01" => --read
							 if(empty_reg /= '1') then --not empty
									r_ptr_next <= r_ptr_succ;
									full_next <= '0';
									if(r_ptr_succ = w_ptr_succ) then
											empty_next <= '1';
									end if;
							 end if;
			when "10" => -- write
							if(full_reg /= '1') then --not full
								w_ptr_next <= w_ptr_succ;
								empty_next <= '0';
								if (w_ptr_succ = r_ptr_reg) then
										full_next <= '1';
								end if;
							end if;
			when others => -- write/read
				w_ptr_next <= w_ptr_succ;
				r_ptr_next <= r_ptr_succ;
			end case;
	end process;
	--output
	full <= full_reg;
	empty <= empty_reg;
end arch;
		
			
	
	
	