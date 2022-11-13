LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY DFFAR IS
PORT ( rst,clk: IN std_logic;
		 a,b: IN std_logic;
		 q: OUT std_logic);
END DFFAR;

ARCHITECTURE behaviour OF DFFAR IS
SIGNAL temp : std_logic;
BEGIN	
	temp <= a NAND b;
	PROCESS(rst,clk)
	BEGIN	
		IF(rst = '1') THEN
			q <= '0';
		ELSIF(rising_edge(clk)) THEN
			q <= temp;
		END IF;
	END PROCESS;	
END behaviour;
		
			
