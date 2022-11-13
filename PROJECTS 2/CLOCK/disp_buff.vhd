disp_buff
--binary increment
b1 <= std_logic_vector((unsigned(b)) +1);
--binary to gray
g1 <= b1 xor('0' & b1(width -1 downto 1));

shift bits out