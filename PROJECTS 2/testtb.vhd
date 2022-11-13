library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity testtb is 
end testtb;

architecture arch_tb of testtb is

	constant max_frames 	: natural := 5;
	constant max_slot 	: natural := 15;
	constant max_bits 	: natural := 7;
	
	type my_data is array (0 to max_slot) of std_logic_vector(max_bits downto 0);
	signal my_data_bit : my_data;
	
	signal clk: std_logic;
	signal rst: boolean;
	signal a, b, sdo, sclk, sdi, ws: std_logic;
	
	signal rand_num : natural := 0;

	constant t_clk : time := 2 ps;
	constant t_tdm : time := 3072	ps;
begin
	
	tdm_uut: entity work.tdm
		port map (clk => clk, rst => rst, a => a, b => b, sdi => sdi, sdo => sdo, sclk => sclk, ws => ws);

		
	clk <= '1' after t_clk/2 when clk = '0' else '0' after t_clk/2;
	sclk  <= not sclk after t_tdm/2 when rst = FALSE else '0';
	

	process
		variable seed1, seed2: positive;          -- seed values for random generator
		variable rand: real;  							 -- random real-number value in range 0 to 1.0  
		variable range_of_rand : real := 250.0;   -- the range of random values created will be 0 to +1000.
	begin
	
		for i in 0 to max_slot loop
			uniform(seed1, seed2, rand);   				-- generate random number
			rand_num <= integer(rand*range_of_rand);  -- rescale to 0..250, convert integer part 
			my_data_bit(i) <= std_logic_vector(to_unsigned(rand_num, max_bits+1));
			wait for t_tdm * (max_bits+1) ;
		end loop;
	end process;
	
	
	
	--main process
	process
		variable j : natural range 0 to max_slot := 0;
		variable bit_cnt : natural range 0 to max_bits := max_bits;
	begin
		
		rst <= TRUE; ws <= '0'; sdi <= '0'; wait for 5 ps;
		rst <= FALSE; 
		

		wait until rising_edge(sclk); ws <= '1';
		wait until rising_edge(sclk);
		ws <= '0';
		
		
	for j in 0 to max_slot loop
		for k in max_bits downto 0 loop	--bit loop
			sdi <= my_data_bit(j)(k);
			a <= not(my_data_bit(j)(k));
			wait until rising_edge(sclk);
				
				if bit_cnt = 0 then
					bit_cnt := max_bits;
				else
					bit_cnt := bit_cnt -1;
				end if;	
		end loop;
	end loop;	
		
				
	
		wait until rising_edge(sclk);
		wait until rising_edge(sclk);
		wait until rising_edge(sclk);
		wait until rising_edge(sclk);
		
		assert false
			report "ostja"
		severity failure;
		
	end process;	
		
end arch_tb;
