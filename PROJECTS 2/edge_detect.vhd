library ieee;
use ieee.std_logic_1164.all;

entity edge_detect is port(
	clk, rst: in std_logic;
	level: in std_logic;
	tick: out std_logic);
end edge_detect;

--moore architecture
--architecture moore_arch of edge_detect is
--	type fsm is (zero, edge, one);
--	signal state_reg, state_next: fsm;

--mealy architecture
architecture moore_arch of edge_detect is
	type fsm is (zero, one);
	signal state_reg, state_next: fsm;
	signal q, z: std_logic;
begin
	process(clk, rst)
	begin
		if rst = '1' then
			state_reg <= zero;
		elsif rising_edge(clk) then
			state_reg <= state_next;
		end if;
	end process;
	
--	--moore machine	
--	process(state_reg, level)
--	begin
--	--	state_next <= state_reg; --stay in the current state until utherwise told
--		tick <= '0';
--		-- tick goes one when level is one and clock is rising edge
--	case state_reg is
--		when zero => 
--			if level = '1' then
--				state_next <= edge;
--			end if;
--		when edge => tick <= '1';
--			if level = '1' then 
--				state_next <= one;
--			else state_next <= zero;
--			end if;
--		when one =>
--			if level = '0' then
--				state_next <= zero;
--			end if;
--	end case;
--	end process;

	--mealy machine
--	process(state_reg, level)
--	begin
--		state_next <= state_reg;
--		tick <= '0';
--		
--		case state_reg is
--			when zero => 
--				if level = '1' then
--					state_next <= one;
--					tick <= '1';
--				end if;
--			when one => 
--				if level = '0' then
--					state_next <= zero;
--				end if;
--		end case;
--	end process;
	
	-- gate level implementaion of an edge detector
	process(clk)
	begin
		if rising_edge(clk) then
			q <= level;
			z <= (not q) and level;
		end if;
		
	end process;
		
		tick <= z;
end moore_arch;
				
		
