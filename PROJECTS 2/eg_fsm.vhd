library ieee;
use ieee.std_logic_1164.all;

entity eg_fsm is port(
	a, b: in std_logic;
	clk, rst: in std_logic;
	y0, y1: out std_logic);
end eg_fsm;

architecture arch of eg_fsm is
	type fsm is (s0, s1, s2);
	signal state_reg, state_next: fsm;
begin
--state register	
	process(clk, rst)
	begin
		if rst = '1' then
			state_reg <= s0;
		elsif rising_edge(clk) then
			state_reg <= state_next;
		end if;
	end process;
	
--next state logic
	process(state_reg, a, b)
	begin
		case state_reg is
			when s0 => 
				if a = '1' then 
					if b = '1' then
						state_next <= s2;
					else state_next <= s1;
					end if;
				else state_next <= s0;
				end if;
			when s1 =>
				if a = '1' then
					state_next <= s0;
				else 
					state_next <= s1;
				end if;
			when s2 => 
				state_next <= s0;
		end case;
	end process;
				
--moore output logic
	process(state_reg)
	begin
		case state_reg is
			when s0 | s2  => 	y1 <= '0';
			when s1 => y1 <= '1';
		end case;
	end process;
	
--mealy output logic
	process(state_reg, a, b)
	begin
		case state_reg is
			when s0 => 
				if (a = '1') and (b = '1') then
					y0 <= '1';
				else y0 <= '0';
				end if;				
			when s1 | s2 => y0 <= '0';			
		end case;
	end process;
end arch;
--The key part is the next-state logic. it uses a case statement with 
--the state_reg signal as the selection expressiom. The next state signal 
--is determined by the current state and external input. 