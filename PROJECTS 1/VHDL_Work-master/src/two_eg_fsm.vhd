library ieee;
use ieee.std_logic_1164.all;

entity two_eg_fsm is port(
	a, b: in std_logic;
	clk, rst: in std_logic;
	y0, y1: out std_logic);
end two_eg_fsm;

architecture arch of two_eg_fsm is
	type fsm is (s0, s1, s2);
	signal state_reg, state_next: fsm;
begin
	--state register
	process(clk,rst)
	begin
		if rst = '1' then
			state_reg <= s0;
		elsif rising_edge(clk) then
			state_reg <= state_next;
		end if;
	end process;
	
	--next-state / output logic
	process(state_reg, a, b)
	begin
		state_next <= state_reg; -- default back to same state;
		y0 <= '0'; -- defailts 0
		y1 <= '0';
		
		case state_reg is
			when s0 => 
				if a = '1' then
					if b = '1' then
						state_next <= s2;
						y0 <= '1';
					else state_next <= s1;
					end if;
					--no else branch
				end if;
			when s1 => y1 <= '1';
				if a = '1' then 
					state_next <= s0;
					-- no else branch
				end if;
			when s2 => state_next <= s0;
		end case;
	end process;
end arch;