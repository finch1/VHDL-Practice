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
-- CREATED		"Sun Mar 26 18:50:20 2017"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY cpu IS 
	PORT
	(
		CLK_IN :  IN  STD_LOGIC;
		RST_IN :  IN  STD_LOGIC;
		pin_name1 :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END cpu;

ARCHITECTURE bdf_type OF cpu IS 

ATTRIBUTE black_box : BOOLEAN;
ATTRIBUTE noopt : BOOLEAN;

COMPONENT busmux_0
	PORT(sel : IN STD_LOGIC;
		 dataa : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 datab : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END COMPONENT;
ATTRIBUTE black_box OF busmux_0: COMPONENT IS true;
ATTRIBUTE noopt OF busmux_0: COMPONENT IS true;

COMPONENT pc
GENERIC (n : INTEGER
			);
	PORT(clk : IN STD_LOGIC;
		 rst : IN STD_LOGIC;
		 pc_ld : IN STD_LOGIC;
		 pc_en : IN STD_LOGIC;
		 pc_new : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 pc_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT bus_mux
	PORT(data0x : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 data1x : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 data2x : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 data3x : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT decoder
	PORT(clk : IN STD_LOGIC;
		 rst : IN STD_LOGIC;
		 instr : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		 cin : OUT STD_LOGIC;
		 reg_wren : OUT STD_LOGIC;
		 pc_en : OUT STD_LOGIC;
		 pc_ld : OUT STD_LOGIC;
		 ram_wren_a : OUT STD_LOGIC;
		 a_mux_sel : OUT STD_LOGIC_VECTOR(0 TO 0);
		 b_mux_sel : OUT STD_LOGIC_VECTOR(0 TO 0);
		 ram_addr_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 ram_data_mux : OUT STD_LOGIC_VECTOR(0 TO 0);
		 reg_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END COMPONENT;

COMPONENT alu
GENERIC (n : INTEGER
			);
	PORT(cin : IN STD_LOGIC;
		 a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 b : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 opcode : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 s : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 cout : OUT STD_LOGIC;
		 y : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT regs
GENERIC (addr_width : INTEGER;
			data_width : INTEGER
			);
	PORT(clk : IN STD_LOGIC;
		 rst : IN STD_LOGIC;
		 wen : IN STD_LOGIC;
		 dest_adds : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 reg_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 src1_adds : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 src2_adds : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 int : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 reg_a : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 reg_b : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 sp : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT fanout
	PORT(src_in : IN STD_LOGIC;
		 supply : IN STD_LOGIC;
		 src_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT bus_mux_2
	PORT(sel : IN STD_LOGIC;
		 data0x : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 data1x : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT ramdual
	PORT(wren_a : IN STD_LOGIC;
		 wren_b : IN STD_LOGIC;
		 clock : IN STD_LOGIC;
		 address_a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 address_b : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		 data_a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data_b : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 q_a : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 q_b : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	a_mux_sel :  STD_LOGIC_VECTOR(0 TO 0);
SIGNAL	add_a :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	add_b :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	alu_a :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	alu_b :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	b_mux_sel :  STD_LOGIC_VECTOR(0 TO 0);
SIGNAL	cin :  STD_LOGIC;
SIGNAL	clk_src :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	data_a :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	data_b :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	GND :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	int :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	pc_en :  STD_LOGIC;
SIGNAL	pc_ld :  STD_LOGIC;
SIGNAL	pc_out :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	ram_a :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	ram_add_mux :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	ram_b :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	ram_data_mux :  STD_LOGIC_VECTOR(0 TO 0);
SIGNAL	ram_wren_a :  STD_LOGIC;
SIGNAL	reg_a :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	reg_b :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	reg_in :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	reg_mux :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	reg_wren :  STD_LOGIC;
SIGNAL	rst_src :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	sp :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	src1 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	y :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC_VECTOR(0 TO 15);
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC_VECTOR(0 TO 31);
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC_VECTOR(0 TO 15);

SIGNAL	GDFX_TEMP_SIGNAL_0 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	GDFX_TEMP_SIGNAL_1 :  STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN 
SYNTHESIZED_WIRE_0 <= "0000000000000000";
SYNTHESIZED_WIRE_3 <= '1';
SYNTHESIZED_WIRE_4 <= '1';
SYNTHESIZED_WIRE_5 <= '0';
SYNTHESIZED_WIRE_6 <= "00000000000000000000000000000000";
SYNTHESIZED_WIRE_7 <= '0';
SYNTHESIZED_WIRE_8 <= '0';
SYNTHESIZED_WIRE_9 <= "0000000000000000";

GDFX_TEMP_SIGNAL_0 <= (GND(15 DOWNTO 8) & pc_out(7 DOWNTO 0));
GDFX_TEMP_SIGNAL_1 <= (GND(15 DOWNTO 8) & pc_out(7 DOWNTO 0));


b2v_inst : pc
GENERIC MAP(n => 7
			)
PORT MAP(clk => clk_src(0),
		 rst => rst_src(0),
		 pc_ld => pc_ld,
		 pc_en => pc_en,
		 pc_new => ram_a(7 DOWNTO 0),
		 pc_out => pc_out);



SYNTHESIZED_WIRE_1 <= ram_a(31) AND ram_a(30) AND ram_a(29);


b2v_inst12 : bus_mux
PORT MAP(data0x => ram_b,
		 data1x => ram_a(15 DOWNTO 0),
		 data2x => y,
		 data3x => SYNTHESIZED_WIRE_0,
		 sel => reg_mux,
		 result => reg_in);


b2v_inst13 : decoder
PORT MAP(clk => clk_src(3),
		 rst => rst_src(2),
		 instr => ram_a(31 DOWNTO 8),
		 cin => cin,
		 reg_wren => reg_wren,
		 pc_en => pc_en,
		 pc_ld => pc_ld,
		 ram_wren_a => ram_wren_a,
		 a_mux_sel(0) => a_mux_sel(0),
		 b_mux_sel(0) => b_mux_sel(0),
		 ram_addr_mux => ram_add_mux,
		 ram_data_mux(0) => ram_data_mux(0),
		 reg_mux => reg_mux);


b2v_inst14 : alu
GENERIC MAP(n => 15
			)
PORT MAP(cin => cin,
		 a => alu_a,
		 b => alu_b,
		 opcode => ram_a(27 DOWNTO 24),
		 s => ram_a(23 DOWNTO 20),
		 y => y);


SYNTHESIZED_WIRE_2 <= NOT(SYNTHESIZED_WIRE_1);




b2v_inst18 : busmux_0
PORT MAP(sel => SYNTHESIZED_WIRE_2,
		 dataa => ram_a(15 DOWNTO 12),
		 datab => ram_a(19 DOWNTO 16),
		 result => src1);


b2v_inst19 : regs
GENERIC MAP(addr_width => 4,
			data_width => 15
			)
PORT MAP(clk => clk_src(2),
		 rst => rst_src(1),
		 wen => reg_wren,
		 dest_adds => ram_a(19 DOWNTO 16),
		 reg_in => reg_in,
		 src1_adds => src1,
		 src2_adds => ram_a(11 DOWNTO 8),
		 int => int,
		 reg_a => reg_a,
		 reg_b => reg_b,
		 sp => sp);


b2v_inst22 : bus_mux
PORT MAP(data0x => GDFX_TEMP_SIGNAL_0,
		 data1x => reg_a,
		 data2x => sp,
		 data3x => int,
		 sel => ram_add_mux,
		 result => add_a);


b2v_inst24 : fanout
PORT MAP(src_in => CLK_IN,
		 supply => SYNTHESIZED_WIRE_3,
		 src_out => clk_src);



b2v_inst26 : fanout
PORT MAP(src_in => RST_IN,
		 supply => SYNTHESIZED_WIRE_4,
		 src_out => rst_src);





b2v_inst3 : bus_mux_2
PORT MAP(sel => a_mux_sel(0),
		 data0x => ram_b,
		 data1x => reg_a,
		 result => alu_a);






b2v_inst4 : bus_mux_2
PORT MAP(sel => b_mux_sel(0),
		 data0x => reg_b,
		 data1x => ram_a(15 DOWNTO 0),
		 result => alu_b);


b2v_inst5 : bus_mux_2
PORT MAP(sel => ram_data_mux(0),
		 data0x => y,
		 data1x => reg_a);


b2v_inst6 : ramdual
PORT MAP(wren_a => ram_wren_a,
		 wren_b => SYNTHESIZED_WIRE_5,
		 clock => clk_src(1),
		 address_a => add_a(7 DOWNTO 0),
		 address_b => add_b(8 DOWNTO 0),
		 data_a => SYNTHESIZED_WIRE_6,
		 data_b => data_b,
		 q_a => ram_a,
		 q_b => ram_b);


b2v_inst7 : bus_mux_2
PORT MAP(sel => SYNTHESIZED_WIRE_7,
		 data0x => ram_a(15 DOWNTO 0),
		 data1x => reg_a,
		 result => add_b);


b2v_inst8 : bus_mux_2
PORT MAP(sel => SYNTHESIZED_WIRE_8,
		 data0x => GDFX_TEMP_SIGNAL_1,
		 data1x => SYNTHESIZED_WIRE_9,
		 result => data_b);


pin_name1 <= y;

END bdf_type;