library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity db_fsm is port(
	sw, clk, rst: in std_logic;
	db: out std_logic);
end db_fsm;

architecture arch of db_fsm is
	type fsm is (zero, one, wait0_1, wait0_2, wait0_3, wait1_1, wait1_2, wait1_3);
	signal state_reg, state_next: fsm;
	signal m_tick: std_logic;
	signal count_reg, count_next: unsigned(18 downto 0);
begin
	
	process(clk)
	begin
		if rst = '1' then
			state_reg <= zero;
		elsif rising_edge(clk) then
			state_reg <= state_next;
			count_reg <= count_next;
		end if;
	end process;
	
	count_next <= count_reg +1;
	m_tick <= '1' when count_reg = 0 else '0';
	
	process(state_reg, sw, m_tick)
	begin
		state_next <= state_reg;
		db <= '0';
		
		case state_reg is
			when zero => 
				if sw = '1' then
					state_next <= wait1_1;
				end if;
				
			when wait1_1 => 
				if sw = '1' then
					if m_tick = '1' then
						state_next <= wait1_2;
					else state_next <= wait1_1;
					end if;
				else state_next <= zero;
				end if;
				
			when wait1_2 => 
				if sw = '1' then
					if m_tick = '1' then
						state_next <= wait1_3;
					else state_next <= wait1_2;
					end if;
				else state_next <= zero;
				end if;	
				
			when wait1_3 => 
				if sw = '1' then
					if m_tick = '1' then
						state_next <= one;
					else state_next <= wait1_3;
					end if;
				else state_next <= zero;
				end if;
					
			when one => db <= '1';
				if sw = '0' then
					state_next <= wait0_1;
				end if;
				
			when wait0_1 => db <= '1';
				if sw = '0' then
					if m_tick = '1' then
						state_next <= wait0_2;
					else state_next <= wait0_1;
					end if;
				else state_next <= one;
				end if;
				
			when wait0_2 => db <= '1';
				if sw = '0' then
					if m_tick = '1' then
						state_next <= wait0_3;
					else state_next <= wait0_2;
					end if;
				else state_next <= one;				
				end if;
			
			when wait0_3 => db <= '1';
				if sw = '0' then
					if m_tick = '1' then
						state_next <= zero;
					else state_next <= wait0_3;
					end if;
				else state_next <= one;
				end if;
			
		end case;
	end process;
end arch;	
			
		