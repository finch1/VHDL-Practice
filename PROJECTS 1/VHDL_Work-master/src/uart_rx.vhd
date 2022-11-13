--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--use ieee.math_real.all;
--
--package defines is
--	constant dbit: natural := 8;
--	constant sb_tick: natural := 16;
--	constant gesu: natural := natural(log2(real(dbit)));
--	
--	type data_size is array (dbit-1 downto 0) of std_logic;
----	type data_width is array (gesu-1 downto 0) of unsigned;
--end defines;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use work.defines.all;

entity uart_rx is 
	generic(
		dbit: integer := 8; --# data bits
		sb_tick: integer := 16); -- # ticks for stop bits
		
	port(
		clk, rst: in std_logic;
		s_tick, rx: in std_logic; --s_tick is the enable tick from the baud rate gen and there are 16 ticks in a bit interval
		data_out: out std_logic_vector(7 downto 0); --data_size;
		state_view: out unsigned(3 downto 0);
		rx_done_tick: out std_logic);
end uart_rx;

architecture arch of uart_rx is
	type state_type is(idle, start, data, stop);
	signal state_reg, state_next: state_type;
	signal s_reg, s_next: unsigned(3 downto 0); --(sb_tick-1 downto 0); --tracks # of sampling ticks: 7 start state, 15 data state, sb_tick stop state
	signal n_reg, n_next: unsigned(2 downto 0);--(gesu-1 downto 0);-- data_width; --tracks # of data bits received in the data state.
	signal b_reg, b_next: std_logic_vector(7 downto 0); --data_size; --serial shift register
	signal piece_of_shit: std_logic_vector(3 downto 0);
begin
	--FSMD state & data registers
	process(clk, rst)
	begin
		if rst = '0' then 
			state_reg <= idle;
			s_reg <= (others => '0');
			n_reg <= (others => '0');
			b_reg <= (others => '0');
		elsif rising_edge(clk) then
			state_reg <= state_next;
			s_reg <= s_next;
			n_reg <= n_next;
			b_reg <= b_next;
		end if;
	end process;
	--next state logic & data path functional units/routing
	process(state_reg, s_reg, n_reg, b_reg, rx, s_tick, b_next)	
	begin
		state_next <= state_reg;
		s_next <= s_reg;
		n_next <= n_reg;
		b_next <= b_reg;
		rx_done_tick <= '0';
	
		case state_reg is 
			when idle => --start bit '0', stop bit '1'
				if rx = '0' then
					state_next <= start;					
					s_next <= (others => '0');					
				end if;			
			
			when start =>
				if s_tick = '1' then
					if s_reg = 7 then
						state_next <= data;						
						s_next <= (others => '0');
						n_next <= (others => '0');						
					else
						s_next <= s_reg +1;
					end if;
				end if;			
			
			when data => 
				if (s_tick = '1') then
					if s_reg = 15 then 
						b_next <= rx & b_next(7 downto 1);
						s_next <= (others => '0');
					
						if n_reg = dbit-1 then
							state_next <= stop;							
						else
							n_next <= n_reg +1;
						end if;
					else 
						s_next <= s_reg +1;
					end if;
				end if;
			
			when stop => 
				if s_tick = '1' then
					if s_reg = sb_tick -1 then
						rx_done_tick <= '1';
						state_next <= idle;						
					else 
						s_next <= s_reg +1;
					end if;
				end if;
		end case;
	end process;
	data_out <= b_reg;
	state_view <= s_reg;		
end arch;
