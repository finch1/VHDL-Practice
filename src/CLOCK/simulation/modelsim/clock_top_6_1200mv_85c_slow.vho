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

-- VENDOR "Altera"
-- PROGRAM "Quartus II 32-bit"
-- VERSION "Version 13.1.0 Build 162 10/23/2013 SJ Web Edition"

-- DATE "10/29/2016 14:39:57"

-- 
-- Device: Altera EP3C5F256C6 Package FBGA256
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY ALTERA;
LIBRARY CYCLONEIII;
LIBRARY IEEE;
LIBRARY STD;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE CYCLONEIII.CYCLONEIII_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE STD.STANDARD.ALL;

ENTITY 	time_keep IS
    PORT (
	clk : IN std_logic;
	lfsr_tick : IN std_logic;
	menu : IN std_logic;
	user_in_sec : IN STD.STANDARD.natural range 0 TO 1;
	user_in_min : IN STD.STANDARD.natural range 0 TO 1;
	user_in_hr : IN STD.STANDARD.natural range 0 TO 1;
	user_change : IN std_logic;
	time_out : OUT std_logic_vector(19 DOWNTO 0)
	);
END time_keep;

-- Design Ports Information
-- time_out[0]	=>  Location: PIN_F13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- time_out[1]	=>  Location: PIN_B14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- time_out[2]	=>  Location: PIN_D12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- time_out[3]	=>  Location: PIN_A14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- time_out[4]	=>  Location: PIN_K15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- time_out[5]	=>  Location: PIN_B16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- time_out[6]	=>  Location: PIN_B13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- time_out[7]	=>  Location: PIN_J15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- time_out[8]	=>  Location: PIN_C15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- time_out[9]	=>  Location: PIN_K16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- time_out[10]	=>  Location: PIN_J13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- time_out[11]	=>  Location: PIN_G15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- time_out[12]	=>  Location: PIN_C16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- time_out[13]	=>  Location: PIN_J16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- time_out[14]	=>  Location: PIN_F15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- time_out[15]	=>  Location: PIN_D15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- time_out[16]	=>  Location: PIN_F14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- time_out[17]	=>  Location: PIN_D16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- time_out[18]	=>  Location: PIN_J14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- time_out[19]	=>  Location: PIN_J12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- menu	=>  Location: PIN_H15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- user_change	=>  Location: PIN_H16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- lfsr_tick	=>  Location: PIN_J11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- clk	=>  Location: PIN_E2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- user_in_sec	=>  Location: PIN_D11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- user_in_min	=>  Location: PIN_G11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- user_in_hr	=>  Location: PIN_G16,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF time_keep IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_clk : std_logic;
SIGNAL ww_lfsr_tick : std_logic;
SIGNAL ww_menu : std_logic;
SIGNAL ww_user_in_sec : std_logic;
SIGNAL ww_user_in_min : std_logic;
SIGNAL ww_user_in_hr : std_logic;
SIGNAL ww_user_change : std_logic;
SIGNAL ww_time_out : std_logic_vector(19 DOWNTO 0);
SIGNAL \clk~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \time_out[0]~output_o\ : std_logic;
SIGNAL \time_out[1]~output_o\ : std_logic;
SIGNAL \time_out[2]~output_o\ : std_logic;
SIGNAL \time_out[3]~output_o\ : std_logic;
SIGNAL \time_out[4]~output_o\ : std_logic;
SIGNAL \time_out[5]~output_o\ : std_logic;
SIGNAL \time_out[6]~output_o\ : std_logic;
SIGNAL \time_out[7]~output_o\ : std_logic;
SIGNAL \time_out[8]~output_o\ : std_logic;
SIGNAL \time_out[9]~output_o\ : std_logic;
SIGNAL \time_out[10]~output_o\ : std_logic;
SIGNAL \time_out[11]~output_o\ : std_logic;
SIGNAL \time_out[12]~output_o\ : std_logic;
SIGNAL \time_out[13]~output_o\ : std_logic;
SIGNAL \time_out[14]~output_o\ : std_logic;
SIGNAL \time_out[15]~output_o\ : std_logic;
SIGNAL \time_out[16]~output_o\ : std_logic;
SIGNAL \time_out[17]~output_o\ : std_logic;
SIGNAL \time_out[18]~output_o\ : std_logic;
SIGNAL \time_out[19]~output_o\ : std_logic;
SIGNAL \clk~input_o\ : std_logic;
SIGNAL \clk~inputclkctrl_outclk\ : std_logic;
SIGNAL \menu~input_o\ : std_logic;
SIGNAL \lfsr_tick~input_o\ : std_logic;
SIGNAL \user_change~input_o\ : std_logic;
SIGNAL \sec_unit[0]~3_combout\ : std_logic;
SIGNAL \user_in_sec~input_o\ : std_logic;
SIGNAL \sel_sec~0_combout\ : std_logic;
SIGNAL \sec_unit[1]~5_cout\ : std_logic;
SIGNAL \sec_unit[1]~6_combout\ : std_logic;
SIGNAL \sec_ena~0_combout\ : std_logic;
SIGNAL \sec_unit[1]~7\ : std_logic;
SIGNAL \sec_unit[2]~8_combout\ : std_logic;
SIGNAL \sec_unit[2]~9\ : std_logic;
SIGNAL \sec_unit[3]~10_combout\ : std_logic;
SIGNAL \Equal1~0_combout\ : std_logic;
SIGNAL \sec_ten[0]~0_combout\ : std_logic;
SIGNAL \Add2~0_combout\ : std_logic;
SIGNAL \Add2~1_combout\ : std_logic;
SIGNAL \Equal2~0_combout\ : std_logic;
SIGNAL \min_unit[0]~3_combout\ : std_logic;
SIGNAL \user_in_min~input_o\ : std_logic;
SIGNAL \sel_min~0_combout\ : std_logic;
SIGNAL \min_unit[1]~5_cout\ : std_logic;
SIGNAL \min_unit[1]~6_combout\ : std_logic;
SIGNAL \min_ena~0_combout\ : std_logic;
SIGNAL \min_ena~1_combout\ : std_logic;
SIGNAL \min_unit[1]~7\ : std_logic;
SIGNAL \min_unit[2]~8_combout\ : std_logic;
SIGNAL \min_unit[2]~9\ : std_logic;
SIGNAL \min_unit[3]~10_combout\ : std_logic;
SIGNAL \Equal3~0_combout\ : std_logic;
SIGNAL \min_ten[0]~0_combout\ : std_logic;
SIGNAL \Add6~0_combout\ : std_logic;
SIGNAL \Add6~1_combout\ : std_logic;
SIGNAL \Equal4~0_combout\ : std_logic;
SIGNAL \hr_unit[0]~3_combout\ : std_logic;
SIGNAL \user_in_hr~input_o\ : std_logic;
SIGNAL \sel_hr~0_combout\ : std_logic;
SIGNAL \hr_unit[1]~5_cout\ : std_logic;
SIGNAL \hr_unit[1]~6_combout\ : std_logic;
SIGNAL \hr_ena~0_combout\ : std_logic;
SIGNAL \hr_unit[1]~7\ : std_logic;
SIGNAL \hr_unit[2]~8_combout\ : std_logic;
SIGNAL \hr_unit[2]~9\ : std_logic;
SIGNAL \hr_unit[3]~10_combout\ : std_logic;
SIGNAL \Equal5~0_combout\ : std_logic;
SIGNAL \hr_ten[0]~0_combout\ : std_logic;
SIGNAL \Add10~0_combout\ : std_logic;
SIGNAL \Equal0~0_combout\ : std_logic;
SIGNAL hr_ten : std_logic_vector(1 DOWNTO 0);
SIGNAL sec_ten : std_logic_vector(2 DOWNTO 0);
SIGNAL sec_unit : std_logic_vector(3 DOWNTO 0);
SIGNAL hr_unit : std_logic_vector(3 DOWNTO 0);
SIGNAL min_ten : std_logic_vector(2 DOWNTO 0);
SIGNAL min_unit : std_logic_vector(3 DOWNTO 0);
SIGNAL \ALT_INV_Equal0~0_combout\ : std_logic;
SIGNAL \ALT_INV_Equal5~0_combout\ : std_logic;
SIGNAL \ALT_INV_Equal4~0_combout\ : std_logic;
SIGNAL \ALT_INV_Equal3~0_combout\ : std_logic;
SIGNAL \ALT_INV_Equal2~0_combout\ : std_logic;
SIGNAL \ALT_INV_Equal1~0_combout\ : std_logic;

BEGIN

ww_clk <= clk;
ww_lfsr_tick <= lfsr_tick;
ww_menu <= menu;
