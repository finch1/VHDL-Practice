library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
 
entity signed_unsigned is
  port (
    i_rst_l : in std_logic;
    i_clk   : in std_logic;
    i_a     : in std_logic_vector(4 downto 0);
    i_b     : in std_logic_vector(4 downto 0)
    );
end signed_unsigned;
 
architecture behave of signed_unsigned is
  signal rs_SUM_RESULT : signed(4 downto 0)   := (others => '0');
  signal ru_SUM_RESULT : unsigned(4 downto 0) := (others => '0');
  signal rs_SUB_RESULT : signed(4 downto 0)   := (others => '0');
  signal ru_SUB_RESULT : unsigned(4 downto 0) := (others => '0');
         
begin
 
  -- Purpose: Add two numbers.  Does both the signed and unsigned
  -- addition for demonstration.  This process is synthesizable.
  p_SUM : process (i_clk, i_rst_l)
  begin
    if i_rst_l = '0' then             -- asynchronous reset (active low)
      rs_SUM_RESULT <= (others => '0');
      ru_SUM_RESULT <= (others => '0');
    elsif rising_edge(i_clk) then
       
      ru_SUM_RESULT <= unsigned(i_a) + unsigned(i_b);
      rs_SUM_RESULT <= signed(i_a) + signed(i_b);
     
    end if;
       
  end process p_SUM;
 
   
  -- Purpose: Subtract two numbers.  Does both the signed and unsigned
  -- subtraction for demonstration.  This process is synthesizable.
  p_SUB : process (i_clk, i_rst_l)
  begin
    if i_rst_l = '0' then             -- asynchronous reset (active low)
      rs_SUB_RESULT <= (others => '0');
      ru_SUB_RESULT <= (others => '0');
    elsif rising_edge(i_clk) then
           
      ru_SUB_RESULT <= unsigned(i_a) - unsigned(i_b);
      rs_SUB_RESULT <= signed(i_a) - signed(i_b);
     
    end if;
       
  end process p_SUB;
 
end behave;

--
--library ieee;
--use ieee.std_logic_1164.all;
----use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
--
--entity tbtrial is
--end entity;
--
--architecture beh of tbtrial is
--	signal b, c, d : unsigned(3 downto 0) := (others => '0');
--	signal usig_a, usig_b : unsigned(3 downto 0) := (others => '0');
--	signal sig_a, sig_b : signed(3 downto 0) := (others => '0');
--	signal temp : std_logic_vector(3 downto 0) := (others => '0');	
--	constant time_30 : time := 30 ns;
--
--begin
--	p0 : process
--	 variable a : unsigned(3 downto 0) := (others => '0');
--	begin
--		wait for time_30;
--		a := a +1;
--		case a is 
--			when "0001" => 
--				b <= b +1;
--			when "0010" => 
--				c <= c +1;
--			when others => null;
--		end case;
--		if a = "0011" then 
--		  d <= d +1;
--		 end if;
--	end process;
--
--	usig_a <= "1000"; -- 8
--	usig_b <= "1001"; -- 9
--	sig_a  <= "1000"; -- -8
--	sig_b  <= "1001"; -- -7
--	
--process
--begin
--wait for time_30;
--  if usig_a = "1000" then
--   temp <=	"0001";
--     end if;
--wait for time_30;     
--  if usig_a > "1000" then
--   temp <= "0010";
--     end if;
--  wait for time_30;   
--  if usig_a < "1000" then
--   temp <= "0100";
--  end if;
--  
--  
--wait for time_30;
--temp <= "0000";
--wait for time_30;
--  if usig_b = "1001" then
--   temp <=	"0001";
--   end if;
-- wait for time_30;  
--  if usig_b > "1001" then
--   temp <= "0010";
--   end if;
--  wait for time_30; 
--  if usig_b < "1001" then
--   temp <= "0100";
-- end if;  
--end process;	
--	
--end beh;
