-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 32-bit"
-- VERSION		"Version 13.1.0 Build 162 10/23/2013 SJ Web Edition"
-- CREATED		"Tue Apr 11 20:42:14 2017"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY alu IS 
	PORT
	(
		add_sub :  IN  STD_LOGIC;
		cin :  IN  STD_LOGIC;
		data_a :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		data_b :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		cout :  OUT  STD_LOGIC;
		res :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END alu;

ARCHITECTURE bdf_type OF alu IS 

COMPONENT myalu
GENERIC (n : INTEGER
			);
	PORT(cin : IN STD_LOGIC;
		 sel : IN STD_LOGIC;
		 a : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 b : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 cout : OUT STD_LOGIC;
		 y : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;



BEGIN 



b2v_inst : myalu
GENERIC MAP(n => 3
			)
PORT MAP(cin => cin,
		 sel => add_sub,
		 a => data_a,
		 b => data_b,
		 cout => cout,
		 y => res);


END bdf_type;