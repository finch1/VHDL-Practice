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

-- DATE "04/20/2014 13:45:39"

-- 
-- Device: Altera EP3C16F256C8 Package FBGA256
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY ALTERA;
LIBRARY CYCLONEIII;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE CYCLONEIII.CYCLONEIII_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	pong_top_st IS
    PORT (
	clk : IN std_logic;
	reset : IN std_logic;
	hsync : OUT std_logic;
	vsync : OUT std_logic;
	rgb : OUT std_logic_vector(2 DOWNTO 0)
	);
END pong_top_st;

-- Design Ports Information
-- hsync	=>  Location: PIN_A12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- vsync	=>  Location: PIN_B13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- rgb[0]	=>  Location: PIN_C16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- rgb[1]	=>  Location: PIN_B16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- rgb[2]	=>  Location: PIN_B14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- clk	=>  Location: PIN_F15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- reset	=>  Location: PIN_D16,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF pong_top_st IS
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
SIGNAL ww_reset : std_logic;
SIGNAL ww_hsync : std_logic;
SIGNAL ww_vsync : std_logic;
SIGNAL ww_rgb : std_logic_vector(2 DOWNTO 0);
SIGNAL \hsync~output_o\ : std_logic;
SIGNAL \vsync~output_o\ : std_logic;
SIGNAL \rgb[0]~output_o\ : std_logic;
SIGNAL \rgb[1]~output_o\ : std_logic;
SIGNAL \rgb[2]~output_o\ : std_logic;
SIGNAL \clk~input_o\ : std_logic;
SIGNAL \vga_sync_unit|Add0~0_combout\ : std_logic;
SIGNAL \reset~input_o\ : std_logic;
SIGNAL \vga_sync_unit|mod2_reg~0_combout\ : std_logic;
SIGNAL \vga_sync_unit|mod2_reg~q\ : std_logic;
SIGNAL \vga_sync_unit|Add0~1\ : std_logic;
SIGNAL \vga_sync_unit|Add0~2_combout\ : std_logic;
SIGNAL \vga_sync_unit|Add0~3\ : std_logic;
SIGNAL \vga_sync_unit|Add0~4_combout\ : std_logic;
SIGNAL \vga_sync_unit|Add0~5\ : std_logic;
SIGNAL \vga_sync_unit|Add0~6_combout\ : std_logic;
SIGNAL \vga_sync_unit|Add0~7\ : std_logic;
SIGNAL \vga_sync_unit|Add0~8_combout\ : std_logic;
SIGNAL \vga_sync_unit|Add0~13\ : std_logic;
SIGNAL \vga_sync_unit|Add0~14_combout\ : std_logic;
SIGNAL \vga_sync_unit|Add0~15\ : std_logic;
SIGNAL \vga_sync_unit|Add0~16_combout\ : std_logic;
SIGNAL \vga_sync_unit|h_count_next~2_combout\ : std_logic;
SIGNAL \vga_sync_unit|Add0~17\ : std_logic;
SIGNAL \vga_sync_unit|Add0~18_combout\ : std_logic;
SIGNAL \vga_sync_unit|h_count_next~1_combout\ : std_logic;
SIGNAL \vga_sync_unit|Equal0~0_combout\ : std_logic;
SIGNAL \vga_sync_unit|Equal0~1_combout\ : std_logic;
SIGNAL \vga_sync_unit|Equal0~2_combout\ : std_logic;
SIGNAL \vga_sync_unit|Add0~9\ : std_logic;
SIGNAL \vga_sync_unit|Add0~10_combout\ : std_logic;
SIGNAL \vga_sync_unit|h_count_next~0_combout\ : std_logic;
SIGNAL \vga_sync_unit|Add0~11\ : std_logic;
SIGNAL \vga_sync_unit|Add0~12_combout\ : std_logic;
SIGNAL \vga_sync_unit|h_sync_next~0_combout\ : std_logic;
SIGNAL \vga_sync_unit|h_sync_next~1_combout\ : std_logic;
SIGNAL \vga_sync_unit|h_sync_reg~q\ : std_logic;
SIGNAL \vga_sync_unit|Add1~0_combout\ : std_logic;
SIGNAL \vga_sync_unit|Add1~3\ : std_logic;
SIGNAL \vga_sync_unit|Add1~4_combout\ : std_logic;
SIGNAL \vga_sync_unit|v_count_next~1_combout\ : std_logic;
SIGNAL \vga_sync_unit|process_2~0_combout\ : std_logic;
SIGNAL \vga_sync_unit|Add1~5\ : std_logic;
SIGNAL \vga_sync_unit|Add1~6_combout\ : std_logic;
SIGNAL \vga_sync_unit|v_count_next~2_combout\ : std_logic;
SIGNAL \vga_sync_unit|Add1~7\ : std_logic;
SIGNAL \vga_sync_unit|Add1~8_combout\ : std_logic;
SIGNAL \vga_sync_unit|Add1~9\ : std_logic;
SIGNAL \vga_sync_unit|Add1~10_combout\ : std_logic;
SIGNAL \vga_sync_unit|Add1~11\ : std_logic;
SIGNAL \vga_sync_unit|Add1~12_combout\ : std_logic;
SIGNAL \vga_sync_unit|Add1~13\ : std_logic;
SIGNAL \vga_sync_unit|Add1~14_combout\ : std_logic;
SIGNAL \vga_sync_unit|Add1~15\ : std_logic;
SIGNAL \vga_sync_unit|Add1~16_combout\ : std_logic;
SIGNAL \vga_sync_unit|Equal1~1_combout\ : std_logic;
SIGNAL \vga_sync_unit|Add1~17\ : std_logic;
SIGNAL \vga_sync_unit|Add1~18_combout\ : std_logic;
SIGNAL \vga_sync_unit|v_count_next~0_combout\ : std_logic;
SIGNAL \vga_sync_unit|Equal1~0_combout\ : std_logic;
SIGNAL \vga_sync_unit|Equal1~2_combout\ : std_logic;
SIGNAL \vga_sync_unit|v_count_next~3_combout\ : std_logic;
SIGNAL \vga_sync_unit|Add1~1\ : std_logic;
SIGNAL \vga_sync_unit|Add1~2_combout\ : std_logic;
SIGNAL \vga_sync_unit|v_sync_next~0_combout\ : std_logic;
SIGNAL \vga_sync_unit|v_sync_next~1_combout\ : std_logic;
SIGNAL \vga_sync_unit|v_sync_next~2_combout\ : std_logic;
SIGNAL \vga_sync_unit|v_sync_reg~q\ : std_logic;
SIGNAL \pong_grf_st_unit|wall_on~0_combout\ : std_logic;
SIGNAL \pong_grf_st_unit|wall_on~1_combout\ : std_logic;
SIGNAL \pong_grf_st_unit|wall_on~2_combout\ : std_logic;
SIGNAL \vga_sync_unit|video_on~0_combout\ : std_logic;
SIGNAL \pong_grf_st_unit|graph_rgb[0]~0_combout\ : std_logic;
SIGNAL \pong_grf_st_unit|sq_ball_on~0_combout\ : std_logic;
SIGNAL \pong_grf_st_unit|sq_ball_on~1_combout\ : std_logic;
SIGNAL \pong_grf_st_unit|sq_ball_on~2_combout\ : std_logic;
SIGNAL \pong_grf_st_unit|sq_ball_on~3_combout\ : std_logic;
SIGNAL \pong_grf_st_unit|sq_ball_on~4_combout\ : std_logic;
SIGNAL \pong_grf_st_unit|graph_rgb[1]~1_combout\ : std_logic;
SIGNAL \pong_grf_st_unit|graph_rgb[1]~2_combout\ : std_logic;
SIGNAL \pong_grf_st_unit|bar_on~0_combout\ : std_logic;
SIGNAL \pong_grf_st_unit|graph_rgb[2]~3_combout\ : std_logic;
SIGNAL \pong_grf_st_unit|graph_rgb[2]~4_combout\ : std_logic;
SIGNAL \pong_grf_st_unit|graph_rgb[2]~5_combout\ : std_logic;
SIGNAL \pong_grf_st_unit|graph_rgb[2]~6_combout\ : std_logic;
SIGNAL rgb_reg : std_logic_vector(2 DOWNTO 0);
SIGNAL \vga_sync_unit|h_count_reg\ : std_logic_vector(9 DOWNTO 0);
SIGNAL \vga_sync_unit|v_count_reg\ : std_logic_vector(9 DOWNTO 0);
SIGNAL \ALT_INV_reset~input_o\ : std_logic;
SIGNAL \vga_sync_unit|ALT_INV_v_sync_reg~q\ : std_logic;
SIGNAL \vga_sync_unit|ALT_INV_h_sync_reg~q\ : std_logic;

BEGIN

ww_clk <= clk;
ww_reset <= reset;
hsync <= ww_hsync;
vsync <= ww_vsync;
rgb <= ww_rgb;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\ALT_INV_reset~input_o\ <= NOT \reset~input_o\;
\vga_sync_unit|ALT_INV_v_sync_reg~q\ <= NOT \vga_sync_unit|v_sync_reg~q\;
\vga_sync_unit|ALT_INV_h_sync_reg~q\ <= NOT \vga_sync_unit|h_sync_reg~q\;

-- Location: IOOBUF_X32_Y29_N23
\hsync~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \vga_sync_unit|ALT_INV_h_sync_reg~q\,
	devoe => ww_devoe,
	o => \hsync~output_o\);

-- Location: IOOBUF_X37_Y29_N23
\vsync~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \vga_sync_unit|ALT_INV_v_sync_reg~q\,
	devoe => ww_devoe,
	o => \vsync~output_o\);

-- Location: IOOBUF_X41_Y27_N23
\rgb[0]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => rgb_reg(0),
	devoe => ww_devoe,
	o => \rgb[0]~output_o\);

-- Location: IOOBUF_X41_Y19_N2
\rgb[1]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => rgb_reg(1),
	devoe => ww_devoe,
	o => \rgb[1]~output_o\);

-- Location: IOOBUF_X35_Y29_N9
\rgb[2]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => rgb_reg(2),
	devoe => ww_devoe,
	o => \rgb[2]~output_o\);

-- Location: IOIBUF_X41_Y19_N8
\clk~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clk,
	o => \clk~input_o\);

-- Location: LCCOMB_X40_Y23_N0
\vga_sync_unit|Add0~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Add0~0_combout\ = \vga_sync_unit|h_count_reg\(0) $ (VCC)
-- \vga_sync_unit|Add0~1\ = CARRY(\vga_sync_unit|h_count_reg\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \vga_sync_unit|h_count_reg\(0),
	datad => VCC,
	combout => \vga_sync_unit|Add0~0_combout\,
	cout => \vga_sync_unit|Add0~1\);

-- Location: IOIBUF_X41_Y24_N8
\reset~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_reset,
	o => \reset~input_o\);

-- Location: LCCOMB_X40_Y19_N0
\vga_sync_unit|mod2_reg~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|mod2_reg~0_combout\ = !\vga_sync_unit|mod2_reg~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \vga_sync_unit|mod2_reg~q\,
	combout => \vga_sync_unit|mod2_reg~0_combout\);

-- Location: FF_X40_Y19_N1
\vga_sync_unit|mod2_reg\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \vga_sync_unit|mod2_reg~0_combout\,
	clrn => \ALT_INV_reset~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga_sync_unit|mod2_reg~q\);

-- Location: FF_X40_Y23_N1
\vga_sync_unit|h_count_reg[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \vga_sync_unit|Add0~0_combout\,
	clrn => \ALT_INV_reset~input_o\,
	ena => \vga_sync_unit|mod2_reg~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga_sync_unit|h_count_reg\(0));

-- Location: LCCOMB_X40_Y23_N2
\vga_sync_unit|Add0~2\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Add0~2_combout\ = (\vga_sync_unit|h_count_reg\(1) & (!\vga_sync_unit|Add0~1\)) # (!\vga_sync_unit|h_count_reg\(1) & ((\vga_sync_unit|Add0~1\) # (GND)))
-- \vga_sync_unit|Add0~3\ = CARRY((!\vga_sync_unit|Add0~1\) # (!\vga_sync_unit|h_count_reg\(1)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \vga_sync_unit|h_count_reg\(1),
	datad => VCC,
	cin => \vga_sync_unit|Add0~1\,
	combout => \vga_sync_unit|Add0~2_combout\,
	cout => \vga_sync_unit|Add0~3\);

-- Location: FF_X40_Y23_N3
\vga_sync_unit|h_count_reg[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \vga_sync_unit|Add0~2_combout\,
	clrn => \ALT_INV_reset~input_o\,
	ena => \vga_sync_unit|mod2_reg~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga_sync_unit|h_count_reg\(1));

-- Location: LCCOMB_X40_Y23_N4
\vga_sync_unit|Add0~4\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Add0~4_combout\ = (\vga_sync_unit|h_count_reg\(2) & (\vga_sync_unit|Add0~3\ $ (GND))) # (!\vga_sync_unit|h_count_reg\(2) & (!\vga_sync_unit|Add0~3\ & VCC))
-- \vga_sync_unit|Add0~5\ = CARRY((\vga_sync_unit|h_count_reg\(2) & !\vga_sync_unit|Add0~3\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \vga_sync_unit|h_count_reg\(2),
	datad => VCC,
	cin => \vga_sync_unit|Add0~3\,
	combout => \vga_sync_unit|Add0~4_combout\,
	cout => \vga_sync_unit|Add0~5\);

-- Location: FF_X40_Y23_N5
\vga_sync_unit|h_count_reg[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \vga_sync_unit|Add0~4_combout\,
	clrn => \ALT_INV_reset~input_o\,
	ena => \vga_sync_unit|mod2_reg~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga_sync_unit|h_count_reg\(2));

-- Location: LCCOMB_X40_Y23_N6
\vga_sync_unit|Add0~6\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Add0~6_combout\ = (\vga_sync_unit|h_count_reg\(3) & (!\vga_sync_unit|Add0~5\)) # (!\vga_sync_unit|h_count_reg\(3) & ((\vga_sync_unit|Add0~5\) # (GND)))
-- \vga_sync_unit|Add0~7\ = CARRY((!\vga_sync_unit|Add0~5\) # (!\vga_sync_unit|h_count_reg\(3)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|h_count_reg\(3),
	datad => VCC,
	cin => \vga_sync_unit|Add0~5\,
	combout => \vga_sync_unit|Add0~6_combout\,
	cout => \vga_sync_unit|Add0~7\);

-- Location: FF_X40_Y23_N7
\vga_sync_unit|h_count_reg[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \vga_sync_unit|Add0~6_combout\,
	clrn => \ALT_INV_reset~input_o\,
	ena => \vga_sync_unit|mod2_reg~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga_sync_unit|h_count_reg\(3));

-- Location: LCCOMB_X40_Y23_N8
\vga_sync_unit|Add0~8\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Add0~8_combout\ = (\vga_sync_unit|h_count_reg\(4) & (\vga_sync_unit|Add0~7\ $ (GND))) # (!\vga_sync_unit|h_count_reg\(4) & (!\vga_sync_unit|Add0~7\ & VCC))
-- \vga_sync_unit|Add0~9\ = CARRY((\vga_sync_unit|h_count_reg\(4) & !\vga_sync_unit|Add0~7\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \vga_sync_unit|h_count_reg\(4),
	datad => VCC,
	cin => \vga_sync_unit|Add0~7\,
	combout => \vga_sync_unit|Add0~8_combout\,
	cout => \vga_sync_unit|Add0~9\);

-- Location: FF_X40_Y23_N9
\vga_sync_unit|h_count_reg[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \vga_sync_unit|Add0~8_combout\,
	clrn => \ALT_INV_reset~input_o\,
	ena => \vga_sync_unit|mod2_reg~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga_sync_unit|h_count_reg\(4));

-- Location: LCCOMB_X40_Y23_N12
\vga_sync_unit|Add0~12\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Add0~12_combout\ = (\vga_sync_unit|h_count_reg\(6) & (\vga_sync_unit|Add0~11\ $ (GND))) # (!\vga_sync_unit|h_count_reg\(6) & (!\vga_sync_unit|Add0~11\ & VCC))
-- \vga_sync_unit|Add0~13\ = CARRY((\vga_sync_unit|h_count_reg\(6) & !\vga_sync_unit|Add0~11\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|h_count_reg\(6),
	datad => VCC,
	cin => \vga_sync_unit|Add0~11\,
	combout => \vga_sync_unit|Add0~12_combout\,
	cout => \vga_sync_unit|Add0~13\);

-- Location: LCCOMB_X40_Y23_N14
\vga_sync_unit|Add0~14\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Add0~14_combout\ = (\vga_sync_unit|h_count_reg\(7) & (!\vga_sync_unit|Add0~13\)) # (!\vga_sync_unit|h_count_reg\(7) & ((\vga_sync_unit|Add0~13\) # (GND)))
-- \vga_sync_unit|Add0~15\ = CARRY((!\vga_sync_unit|Add0~13\) # (!\vga_sync_unit|h_count_reg\(7)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \vga_sync_unit|h_count_reg\(7),
	datad => VCC,
	cin => \vga_sync_unit|Add0~13\,
	combout => \vga_sync_unit|Add0~14_combout\,
	cout => \vga_sync_unit|Add0~15\);

-- Location: FF_X40_Y23_N15
\vga_sync_unit|h_count_reg[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \vga_sync_unit|Add0~14_combout\,
	clrn => \ALT_INV_reset~input_o\,
	ena => \vga_sync_unit|mod2_reg~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga_sync_unit|h_count_reg\(7));

-- Location: LCCOMB_X40_Y23_N16
\vga_sync_unit|Add0~16\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Add0~16_combout\ = (\vga_sync_unit|h_count_reg\(8) & (\vga_sync_unit|Add0~15\ $ (GND))) # (!\vga_sync_unit|h_count_reg\(8) & (!\vga_sync_unit|Add0~15\ & VCC))
-- \vga_sync_unit|Add0~17\ = CARRY((\vga_sync_unit|h_count_reg\(8) & !\vga_sync_unit|Add0~15\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \vga_sync_unit|h_count_reg\(8),
	datad => VCC,
	cin => \vga_sync_unit|Add0~15\,
	combout => \vga_sync_unit|Add0~16_combout\,
	cout => \vga_sync_unit|Add0~17\);

-- Location: LCCOMB_X40_Y23_N24
\vga_sync_unit|h_count_next~2\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|h_count_next~2_combout\ = (!\vga_sync_unit|Equal0~2_combout\ & \vga_sync_unit|Add0~16_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \vga_sync_unit|Equal0~2_combout\,
	datad => \vga_sync_unit|Add0~16_combout\,
	combout => \vga_sync_unit|h_count_next~2_combout\);

-- Location: FF_X40_Y23_N25
\vga_sync_unit|h_count_reg[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \vga_sync_unit|h_count_next~2_combout\,
	clrn => \ALT_INV_reset~input_o\,
	ena => \vga_sync_unit|mod2_reg~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga_sync_unit|h_count_reg\(8));

-- Location: LCCOMB_X40_Y23_N18
\vga_sync_unit|Add0~18\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Add0~18_combout\ = \vga_sync_unit|h_count_reg\(9) $ (\vga_sync_unit|Add0~17\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|h_count_reg\(9),
	cin => \vga_sync_unit|Add0~17\,
	combout => \vga_sync_unit|Add0~18_combout\);

-- Location: LCCOMB_X40_Y23_N26
\vga_sync_unit|h_count_next~1\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|h_count_next~1_combout\ = (!\vga_sync_unit|Equal0~2_combout\ & \vga_sync_unit|Add0~18_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \vga_sync_unit|Equal0~2_combout\,
	datad => \vga_sync_unit|Add0~18_combout\,
	combout => \vga_sync_unit|h_count_next~1_combout\);

-- Location: FF_X40_Y23_N27
\vga_sync_unit|h_count_reg[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \vga_sync_unit|h_count_next~1_combout\,
	clrn => \ALT_INV_reset~input_o\,
	ena => \vga_sync_unit|mod2_reg~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga_sync_unit|h_count_reg\(9));

-- Location: LCCOMB_X40_Y23_N30
\vga_sync_unit|Equal0~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Equal0~0_combout\ = (\vga_sync_unit|h_count_reg\(9) & (\vga_sync_unit|h_count_reg\(8) & (!\vga_sync_unit|h_count_reg\(7) & !\vga_sync_unit|h_count_reg\(5))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|h_count_reg\(9),
	datab => \vga_sync_unit|h_count_reg\(8),
	datac => \vga_sync_unit|h_count_reg\(7),
	datad => \vga_sync_unit|h_count_reg\(5),
	combout => \vga_sync_unit|Equal0~0_combout\);

-- Location: LCCOMB_X40_Y23_N28
\vga_sync_unit|Equal0~1\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Equal0~1_combout\ = (\vga_sync_unit|h_count_reg\(3) & (\vga_sync_unit|h_count_reg\(4) & (\vga_sync_unit|h_count_reg\(2) & !\vga_sync_unit|h_count_reg\(6))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|h_count_reg\(3),
	datab => \vga_sync_unit|h_count_reg\(4),
	datac => \vga_sync_unit|h_count_reg\(2),
	datad => \vga_sync_unit|h_count_reg\(6),
	combout => \vga_sync_unit|Equal0~1_combout\);

-- Location: LCCOMB_X40_Y23_N22
\vga_sync_unit|Equal0~2\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Equal0~2_combout\ = (\vga_sync_unit|h_count_reg\(0) & (\vga_sync_unit|h_count_reg\(1) & (\vga_sync_unit|Equal0~0_combout\ & \vga_sync_unit|Equal0~1_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|h_count_reg\(0),
	datab => \vga_sync_unit|h_count_reg\(1),
	datac => \vga_sync_unit|Equal0~0_combout\,
	datad => \vga_sync_unit|Equal0~1_combout\,
	combout => \vga_sync_unit|Equal0~2_combout\);

-- Location: LCCOMB_X40_Y23_N10
\vga_sync_unit|Add0~10\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Add0~10_combout\ = (\vga_sync_unit|h_count_reg\(5) & (!\vga_sync_unit|Add0~9\)) # (!\vga_sync_unit|h_count_reg\(5) & ((\vga_sync_unit|Add0~9\) # (GND)))
-- \vga_sync_unit|Add0~11\ = CARRY((!\vga_sync_unit|Add0~9\) # (!\vga_sync_unit|h_count_reg\(5)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \vga_sync_unit|h_count_reg\(5),
	datad => VCC,
	cin => \vga_sync_unit|Add0~9\,
	combout => \vga_sync_unit|Add0~10_combout\,
	cout => \vga_sync_unit|Add0~11\);

-- Location: LCCOMB_X40_Y23_N20
\vga_sync_unit|h_count_next~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|h_count_next~0_combout\ = (!\vga_sync_unit|Equal0~2_combout\ & \vga_sync_unit|Add0~10_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \vga_sync_unit|Equal0~2_combout\,
	datad => \vga_sync_unit|Add0~10_combout\,
	combout => \vga_sync_unit|h_count_next~0_combout\);

-- Location: FF_X40_Y23_N21
\vga_sync_unit|h_count_reg[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \vga_sync_unit|h_count_next~0_combout\,
	clrn => \ALT_INV_reset~input_o\,
	ena => \vga_sync_unit|mod2_reg~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga_sync_unit|h_count_reg\(5));

-- Location: FF_X40_Y23_N13
\vga_sync_unit|h_count_reg[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \vga_sync_unit|Add0~12_combout\,
	clrn => \ALT_INV_reset~input_o\,
	ena => \vga_sync_unit|mod2_reg~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga_sync_unit|h_count_reg\(6));

-- Location: LCCOMB_X40_Y19_N12
\vga_sync_unit|h_sync_next~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|h_sync_next~0_combout\ = (\vga_sync_unit|h_count_reg\(7) & (\vga_sync_unit|h_count_reg\(9) & !\vga_sync_unit|h_count_reg\(8)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|h_count_reg\(7),
	datab => \vga_sync_unit|h_count_reg\(9),
	datad => \vga_sync_unit|h_count_reg\(8),
	combout => \vga_sync_unit|h_sync_next~0_combout\);

-- Location: LCCOMB_X40_Y19_N20
\vga_sync_unit|h_sync_next~1\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|h_sync_next~1_combout\ = (\vga_sync_unit|h_sync_next~0_combout\ & ((\vga_sync_unit|h_count_reg\(4) & ((!\vga_sync_unit|h_count_reg\(5)) # (!\vga_sync_unit|h_count_reg\(6)))) # (!\vga_sync_unit|h_count_reg\(4) & 
-- ((\vga_sync_unit|h_count_reg\(6)) # (\vga_sync_unit|h_count_reg\(5))))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111111000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|h_count_reg\(4),
	datab => \vga_sync_unit|h_count_reg\(6),
	datac => \vga_sync_unit|h_count_reg\(5),
	datad => \vga_sync_unit|h_sync_next~0_combout\,
	combout => \vga_sync_unit|h_sync_next~1_combout\);

-- Location: FF_X40_Y19_N21
\vga_sync_unit|h_sync_reg\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \vga_sync_unit|h_sync_next~1_combout\,
	clrn => \ALT_INV_reset~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga_sync_unit|h_sync_reg~q\);

-- Location: LCCOMB_X39_Y23_N4
\vga_sync_unit|Add1~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Add1~0_combout\ = \vga_sync_unit|v_count_reg\(0) $ (VCC)
-- \vga_sync_unit|Add1~1\ = CARRY(\vga_sync_unit|v_count_reg\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \vga_sync_unit|v_count_reg\(0),
	datad => VCC,
	combout => \vga_sync_unit|Add1~0_combout\,
	cout => \vga_sync_unit|Add1~1\);

-- Location: LCCOMB_X39_Y23_N6
\vga_sync_unit|Add1~2\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Add1~2_combout\ = (\vga_sync_unit|v_count_reg\(1) & (!\vga_sync_unit|Add1~1\)) # (!\vga_sync_unit|v_count_reg\(1) & ((\vga_sync_unit|Add1~1\) # (GND)))
-- \vga_sync_unit|Add1~3\ = CARRY((!\vga_sync_unit|Add1~1\) # (!\vga_sync_unit|v_count_reg\(1)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|v_count_reg\(1),
	datad => VCC,
	cin => \vga_sync_unit|Add1~1\,
	combout => \vga_sync_unit|Add1~2_combout\,
	cout => \vga_sync_unit|Add1~3\);

-- Location: LCCOMB_X39_Y23_N8
\vga_sync_unit|Add1~4\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Add1~4_combout\ = (\vga_sync_unit|v_count_reg\(2) & (\vga_sync_unit|Add1~3\ $ (GND))) # (!\vga_sync_unit|v_count_reg\(2) & (!\vga_sync_unit|Add1~3\ & VCC))
-- \vga_sync_unit|Add1~5\ = CARRY((\vga_sync_unit|v_count_reg\(2) & !\vga_sync_unit|Add1~3\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \vga_sync_unit|v_count_reg\(2),
	datad => VCC,
	cin => \vga_sync_unit|Add1~3\,
	combout => \vga_sync_unit|Add1~4_combout\,
	cout => \vga_sync_unit|Add1~5\);

-- Location: LCCOMB_X39_Y23_N2
\vga_sync_unit|v_count_next~1\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|v_count_next~1_combout\ = (\vga_sync_unit|Add1~4_combout\ & !\vga_sync_unit|Equal1~2_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \vga_sync_unit|Add1~4_combout\,
	datad => \vga_sync_unit|Equal1~2_combout\,
	combout => \vga_sync_unit|v_count_next~1_combout\);

-- Location: LCCOMB_X39_Y23_N30
\vga_sync_unit|process_2~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|process_2~0_combout\ = (\vga_sync_unit|mod2_reg~q\ & \vga_sync_unit|Equal0~2_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|mod2_reg~q\,
	datad => \vga_sync_unit|Equal0~2_combout\,
	combout => \vga_sync_unit|process_2~0_combout\);

-- Location: FF_X39_Y23_N3
\vga_sync_unit|v_count_reg[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \vga_sync_unit|v_count_next~1_combout\,
	clrn => \ALT_INV_reset~input_o\,
	ena => \vga_sync_unit|process_2~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga_sync_unit|v_count_reg\(2));

-- Location: LCCOMB_X39_Y23_N10
\vga_sync_unit|Add1~6\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Add1~6_combout\ = (\vga_sync_unit|v_count_reg\(3) & (!\vga_sync_unit|Add1~5\)) # (!\vga_sync_unit|v_count_reg\(3) & ((\vga_sync_unit|Add1~5\) # (GND)))
-- \vga_sync_unit|Add1~7\ = CARRY((!\vga_sync_unit|Add1~5\) # (!\vga_sync_unit|v_count_reg\(3)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \vga_sync_unit|v_count_reg\(3),
	datad => VCC,
	cin => \vga_sync_unit|Add1~5\,
	combout => \vga_sync_unit|Add1~6_combout\,
	cout => \vga_sync_unit|Add1~7\);

-- Location: LCCOMB_X39_Y23_N28
\vga_sync_unit|v_count_next~2\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|v_count_next~2_combout\ = (\vga_sync_unit|Add1~6_combout\ & !\vga_sync_unit|Equal1~2_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|Add1~6_combout\,
	datad => \vga_sync_unit|Equal1~2_combout\,
	combout => \vga_sync_unit|v_count_next~2_combout\);

-- Location: FF_X39_Y23_N29
\vga_sync_unit|v_count_reg[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \vga_sync_unit|v_count_next~2_combout\,
	clrn => \ALT_INV_reset~input_o\,
	ena => \vga_sync_unit|process_2~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga_sync_unit|v_count_reg\(3));

-- Location: LCCOMB_X39_Y23_N12
\vga_sync_unit|Add1~8\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Add1~8_combout\ = (\vga_sync_unit|v_count_reg\(4) & (\vga_sync_unit|Add1~7\ $ (GND))) # (!\vga_sync_unit|v_count_reg\(4) & (!\vga_sync_unit|Add1~7\ & VCC))
-- \vga_sync_unit|Add1~9\ = CARRY((\vga_sync_unit|v_count_reg\(4) & !\vga_sync_unit|Add1~7\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|v_count_reg\(4),
	datad => VCC,
	cin => \vga_sync_unit|Add1~7\,
	combout => \vga_sync_unit|Add1~8_combout\,
	cout => \vga_sync_unit|Add1~9\);

-- Location: FF_X39_Y23_N13
\vga_sync_unit|v_count_reg[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \vga_sync_unit|Add1~8_combout\,
	clrn => \ALT_INV_reset~input_o\,
	ena => \vga_sync_unit|process_2~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga_sync_unit|v_count_reg\(4));

-- Location: LCCOMB_X39_Y23_N14
\vga_sync_unit|Add1~10\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Add1~10_combout\ = (\vga_sync_unit|v_count_reg\(5) & (!\vga_sync_unit|Add1~9\)) # (!\vga_sync_unit|v_count_reg\(5) & ((\vga_sync_unit|Add1~9\) # (GND)))
-- \vga_sync_unit|Add1~11\ = CARRY((!\vga_sync_unit|Add1~9\) # (!\vga_sync_unit|v_count_reg\(5)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \vga_sync_unit|v_count_reg\(5),
	datad => VCC,
	cin => \vga_sync_unit|Add1~9\,
	combout => \vga_sync_unit|Add1~10_combout\,
	cout => \vga_sync_unit|Add1~11\);

-- Location: FF_X39_Y23_N15
\vga_sync_unit|v_count_reg[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \vga_sync_unit|Add1~10_combout\,
	clrn => \ALT_INV_reset~input_o\,
	ena => \vga_sync_unit|process_2~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga_sync_unit|v_count_reg\(5));

-- Location: LCCOMB_X39_Y23_N16
\vga_sync_unit|Add1~12\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Add1~12_combout\ = (\vga_sync_unit|v_count_reg\(6) & (\vga_sync_unit|Add1~11\ $ (GND))) # (!\vga_sync_unit|v_count_reg\(6) & (!\vga_sync_unit|Add1~11\ & VCC))
-- \vga_sync_unit|Add1~13\ = CARRY((\vga_sync_unit|v_count_reg\(6) & !\vga_sync_unit|Add1~11\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \vga_sync_unit|v_count_reg\(6),
	datad => VCC,
	cin => \vga_sync_unit|Add1~11\,
	combout => \vga_sync_unit|Add1~12_combout\,
	cout => \vga_sync_unit|Add1~13\);

-- Location: FF_X39_Y23_N17
\vga_sync_unit|v_count_reg[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \vga_sync_unit|Add1~12_combout\,
	clrn => \ALT_INV_reset~input_o\,
	ena => \vga_sync_unit|process_2~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga_sync_unit|v_count_reg\(6));

-- Location: LCCOMB_X39_Y23_N18
\vga_sync_unit|Add1~14\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Add1~14_combout\ = (\vga_sync_unit|v_count_reg\(7) & (!\vga_sync_unit|Add1~13\)) # (!\vga_sync_unit|v_count_reg\(7) & ((\vga_sync_unit|Add1~13\) # (GND)))
-- \vga_sync_unit|Add1~15\ = CARRY((!\vga_sync_unit|Add1~13\) # (!\vga_sync_unit|v_count_reg\(7)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \vga_sync_unit|v_count_reg\(7),
	datad => VCC,
	cin => \vga_sync_unit|Add1~13\,
	combout => \vga_sync_unit|Add1~14_combout\,
	cout => \vga_sync_unit|Add1~15\);

-- Location: FF_X39_Y23_N19
\vga_sync_unit|v_count_reg[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \vga_sync_unit|Add1~14_combout\,
	clrn => \ALT_INV_reset~input_o\,
	ena => \vga_sync_unit|process_2~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga_sync_unit|v_count_reg\(7));

-- Location: LCCOMB_X39_Y23_N20
\vga_sync_unit|Add1~16\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Add1~16_combout\ = (\vga_sync_unit|v_count_reg\(8) & (\vga_sync_unit|Add1~15\ $ (GND))) # (!\vga_sync_unit|v_count_reg\(8) & (!\vga_sync_unit|Add1~15\ & VCC))
-- \vga_sync_unit|Add1~17\ = CARRY((\vga_sync_unit|v_count_reg\(8) & !\vga_sync_unit|Add1~15\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \vga_sync_unit|v_count_reg\(8),
	datad => VCC,
	cin => \vga_sync_unit|Add1~15\,
	combout => \vga_sync_unit|Add1~16_combout\,
	cout => \vga_sync_unit|Add1~17\);

-- Location: FF_X39_Y23_N21
\vga_sync_unit|v_count_reg[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \vga_sync_unit|Add1~16_combout\,
	clrn => \ALT_INV_reset~input_o\,
	ena => \vga_sync_unit|process_2~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga_sync_unit|v_count_reg\(8));

-- Location: LCCOMB_X38_Y23_N8
\vga_sync_unit|Equal1~1\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Equal1~1_combout\ = (!\vga_sync_unit|v_count_reg\(8) & (!\vga_sync_unit|v_count_reg\(6) & (!\vga_sync_unit|v_count_reg\(5) & !\vga_sync_unit|v_count_reg\(7))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|v_count_reg\(8),
	datab => \vga_sync_unit|v_count_reg\(6),
	datac => \vga_sync_unit|v_count_reg\(5),
	datad => \vga_sync_unit|v_count_reg\(7),
	combout => \vga_sync_unit|Equal1~1_combout\);

-- Location: LCCOMB_X39_Y23_N22
\vga_sync_unit|Add1~18\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Add1~18_combout\ = \vga_sync_unit|Add1~17\ $ (\vga_sync_unit|v_count_reg\(9))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datad => \vga_sync_unit|v_count_reg\(9),
	cin => \vga_sync_unit|Add1~17\,
	combout => \vga_sync_unit|Add1~18_combout\);

-- Location: LCCOMB_X39_Y23_N24
\vga_sync_unit|v_count_next~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|v_count_next~0_combout\ = (\vga_sync_unit|Add1~18_combout\ & !\vga_sync_unit|Equal1~2_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \vga_sync_unit|Add1~18_combout\,
	datad => \vga_sync_unit|Equal1~2_combout\,
	combout => \vga_sync_unit|v_count_next~0_combout\);

-- Location: FF_X39_Y23_N25
\vga_sync_unit|v_count_reg[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \vga_sync_unit|v_count_next~0_combout\,
	clrn => \ALT_INV_reset~input_o\,
	ena => \vga_sync_unit|process_2~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga_sync_unit|v_count_reg\(9));

-- Location: LCCOMB_X38_Y23_N18
\vga_sync_unit|Equal1~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Equal1~0_combout\ = (\vga_sync_unit|v_count_reg\(2) & (\vga_sync_unit|v_count_reg\(3) & (!\vga_sync_unit|v_count_reg\(4) & \vga_sync_unit|v_count_reg\(9))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000100000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|v_count_reg\(2),
	datab => \vga_sync_unit|v_count_reg\(3),
	datac => \vga_sync_unit|v_count_reg\(4),
	datad => \vga_sync_unit|v_count_reg\(9),
	combout => \vga_sync_unit|Equal1~0_combout\);

-- Location: LCCOMB_X38_Y23_N14
\vga_sync_unit|Equal1~2\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|Equal1~2_combout\ = (!\vga_sync_unit|v_count_reg\(1) & (!\vga_sync_unit|v_count_reg\(0) & (\vga_sync_unit|Equal1~1_combout\ & \vga_sync_unit|Equal1~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|v_count_reg\(1),
	datab => \vga_sync_unit|v_count_reg\(0),
	datac => \vga_sync_unit|Equal1~1_combout\,
	datad => \vga_sync_unit|Equal1~0_combout\,
	combout => \vga_sync_unit|Equal1~2_combout\);

-- Location: LCCOMB_X39_Y23_N0
\vga_sync_unit|v_count_next~3\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|v_count_next~3_combout\ = (\vga_sync_unit|Add1~0_combout\ & !\vga_sync_unit|Equal1~2_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \vga_sync_unit|Add1~0_combout\,
	datad => \vga_sync_unit|Equal1~2_combout\,
	combout => \vga_sync_unit|v_count_next~3_combout\);

-- Location: FF_X39_Y23_N1
\vga_sync_unit|v_count_reg[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \vga_sync_unit|v_count_next~3_combout\,
	clrn => \ALT_INV_reset~input_o\,
	ena => \vga_sync_unit|process_2~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga_sync_unit|v_count_reg\(0));

-- Location: FF_X39_Y23_N7
\vga_sync_unit|v_count_reg[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \vga_sync_unit|Add1~2_combout\,
	clrn => \ALT_INV_reset~input_o\,
	ena => \vga_sync_unit|process_2~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga_sync_unit|v_count_reg\(1));

-- Location: LCCOMB_X40_Y19_N22
\vga_sync_unit|v_sync_next~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|v_sync_next~0_combout\ = (\vga_sync_unit|v_count_reg\(4)) # ((\vga_sync_unit|v_count_reg\(2)) # ((\vga_sync_unit|v_count_reg\(9)) # (!\vga_sync_unit|v_count_reg\(3))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|v_count_reg\(4),
	datab => \vga_sync_unit|v_count_reg\(2),
	datac => \vga_sync_unit|v_count_reg\(9),
	datad => \vga_sync_unit|v_count_reg\(3),
	combout => \vga_sync_unit|v_sync_next~0_combout\);

-- Location: LCCOMB_X39_Y23_N26
\vga_sync_unit|v_sync_next~1\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|v_sync_next~1_combout\ = (\vga_sync_unit|v_count_reg\(8) & (\vga_sync_unit|v_count_reg\(6) & (\vga_sync_unit|v_count_reg\(5) & \vga_sync_unit|v_count_reg\(7))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|v_count_reg\(8),
	datab => \vga_sync_unit|v_count_reg\(6),
	datac => \vga_sync_unit|v_count_reg\(5),
	datad => \vga_sync_unit|v_count_reg\(7),
	combout => \vga_sync_unit|v_sync_next~1_combout\);

-- Location: LCCOMB_X40_Y19_N14
\vga_sync_unit|v_sync_next~2\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|v_sync_next~2_combout\ = (\vga_sync_unit|v_count_reg\(1) & (!\vga_sync_unit|v_sync_next~0_combout\ & \vga_sync_unit|v_sync_next~1_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000101000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|v_count_reg\(1),
	datac => \vga_sync_unit|v_sync_next~0_combout\,
	datad => \vga_sync_unit|v_sync_next~1_combout\,
	combout => \vga_sync_unit|v_sync_next~2_combout\);

-- Location: FF_X40_Y19_N15
\vga_sync_unit|v_sync_reg\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \vga_sync_unit|v_sync_next~2_combout\,
	clrn => \ALT_INV_reset~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \vga_sync_unit|v_sync_reg~q\);

-- Location: LCCOMB_X39_Y21_N14
\pong_grf_st_unit|wall_on~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \pong_grf_st_unit|wall_on~0_combout\ = (!\vga_sync_unit|h_count_reg\(7) & !\vga_sync_unit|h_count_reg\(8))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000110011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \vga_sync_unit|h_count_reg\(7),
	datad => \vga_sync_unit|h_count_reg\(8),
	combout => \pong_grf_st_unit|wall_on~0_combout\);

-- Location: LCCOMB_X39_Y21_N16
\pong_grf_st_unit|wall_on~1\ : cycloneiii_lcell_comb
-- Equation(s):
-- \pong_grf_st_unit|wall_on~1_combout\ = (\vga_sync_unit|h_count_reg\(5) & (!\vga_sync_unit|h_count_reg\(3) & (!\vga_sync_unit|h_count_reg\(9) & !\vga_sync_unit|h_count_reg\(2))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|h_count_reg\(5),
	datab => \vga_sync_unit|h_count_reg\(3),
	datac => \vga_sync_unit|h_count_reg\(9),
	datad => \vga_sync_unit|h_count_reg\(2),
	combout => \pong_grf_st_unit|wall_on~1_combout\);

-- Location: LCCOMB_X39_Y21_N30
\pong_grf_st_unit|wall_on~2\ : cycloneiii_lcell_comb
-- Equation(s):
-- \pong_grf_st_unit|wall_on~2_combout\ = (!\vga_sync_unit|h_count_reg\(6) & (!\vga_sync_unit|h_count_reg\(4) & (\pong_grf_st_unit|wall_on~0_combout\ & \pong_grf_st_unit|wall_on~1_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|h_count_reg\(6),
	datab => \vga_sync_unit|h_count_reg\(4),
	datac => \pong_grf_st_unit|wall_on~0_combout\,
	datad => \pong_grf_st_unit|wall_on~1_combout\,
	combout => \pong_grf_st_unit|wall_on~2_combout\);

-- Location: LCCOMB_X39_Y21_N20
\vga_sync_unit|video_on~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \vga_sync_unit|video_on~0_combout\ = (!\vga_sync_unit|v_count_reg\(9) & (!\vga_sync_unit|v_sync_next~1_combout\ & ((\pong_grf_st_unit|wall_on~0_combout\) # (!\vga_sync_unit|h_count_reg\(9)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001010001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|v_count_reg\(9),
	datab => \vga_sync_unit|h_count_reg\(9),
	datac => \pong_grf_st_unit|wall_on~0_combout\,
	datad => \vga_sync_unit|v_sync_next~1_combout\,
	combout => \vga_sync_unit|video_on~0_combout\);

-- Location: LCCOMB_X39_Y21_N12
\pong_grf_st_unit|graph_rgb[0]~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \pong_grf_st_unit|graph_rgb[0]~0_combout\ = (\pong_grf_st_unit|wall_on~2_combout\ & \vga_sync_unit|video_on~0_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010000010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \pong_grf_st_unit|wall_on~2_combout\,
	datac => \vga_sync_unit|video_on~0_combout\,
	combout => \pong_grf_st_unit|graph_rgb[0]~0_combout\);

-- Location: FF_X39_Y21_N13
\rgb_reg[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \pong_grf_st_unit|graph_rgb[0]~0_combout\,
	ena => \vga_sync_unit|mod2_reg~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => rgb_reg(0));

-- Location: LCCOMB_X38_Y23_N20
\pong_grf_st_unit|sq_ball_on~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \pong_grf_st_unit|sq_ball_on~0_combout\ = (\vga_sync_unit|v_count_reg\(3) & (\vga_sync_unit|v_count_reg\(1) & (!\vga_sync_unit|v_count_reg\(4) & \vga_sync_unit|v_count_reg\(2)))) # (!\vga_sync_unit|v_count_reg\(3) & (\vga_sync_unit|v_count_reg\(4) & 
-- ((!\vga_sync_unit|v_count_reg\(2)) # (!\vga_sync_unit|v_count_reg\(1)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001100000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|v_count_reg\(1),
	datab => \vga_sync_unit|v_count_reg\(3),
	datac => \vga_sync_unit|v_count_reg\(4),
	datad => \vga_sync_unit|v_count_reg\(2),
	combout => \pong_grf_st_unit|sq_ball_on~0_combout\);

-- Location: LCCOMB_X39_Y21_N6
\pong_grf_st_unit|sq_ball_on~1\ : cycloneiii_lcell_comb
-- Equation(s):
-- \pong_grf_st_unit|sq_ball_on~1_combout\ = (!\vga_sync_unit|h_count_reg\(5) & (!\vga_sync_unit|h_count_reg\(7) & (\vga_sync_unit|h_count_reg\(9) & !\vga_sync_unit|h_count_reg\(8))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|h_count_reg\(5),
	datab => \vga_sync_unit|h_count_reg\(7),
	datac => \vga_sync_unit|h_count_reg\(9),
	datad => \vga_sync_unit|h_count_reg\(8),
	combout => \pong_grf_st_unit|sq_ball_on~1_combout\);

-- Location: LCCOMB_X39_Y21_N24
\pong_grf_st_unit|sq_ball_on~2\ : cycloneiii_lcell_comb
-- Equation(s):
-- \pong_grf_st_unit|sq_ball_on~2_combout\ = (\vga_sync_unit|h_count_reg\(6) & (\pong_grf_st_unit|sq_ball_on~1_combout\ & ((!\vga_sync_unit|h_count_reg\(3)) # (!\vga_sync_unit|h_count_reg\(2)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010101000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|h_count_reg\(6),
	datab => \vga_sync_unit|h_count_reg\(2),
	datac => \vga_sync_unit|h_count_reg\(3),
	datad => \pong_grf_st_unit|sq_ball_on~1_combout\,
	combout => \pong_grf_st_unit|sq_ball_on~2_combout\);

-- Location: LCCOMB_X38_Y23_N2
\pong_grf_st_unit|sq_ball_on~3\ : cycloneiii_lcell_comb
-- Equation(s):
-- \pong_grf_st_unit|sq_ball_on~3_combout\ = (!\vga_sync_unit|v_count_reg\(8) & (\vga_sync_unit|v_count_reg\(7) & (\vga_sync_unit|v_count_reg\(5) & \vga_sync_unit|v_count_reg\(6))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|v_count_reg\(8),
	datab => \vga_sync_unit|v_count_reg\(7),
	datac => \vga_sync_unit|v_count_reg\(5),
	datad => \vga_sync_unit|v_count_reg\(6),
	combout => \pong_grf_st_unit|sq_ball_on~3_combout\);

-- Location: LCCOMB_X39_Y21_N22
\pong_grf_st_unit|sq_ball_on~4\ : cycloneiii_lcell_comb
-- Equation(s):
-- \pong_grf_st_unit|sq_ball_on~4_combout\ = (!\vga_sync_unit|h_count_reg\(4) & (\pong_grf_st_unit|sq_ball_on~3_combout\ & ((\vga_sync_unit|h_count_reg\(2)) # (\vga_sync_unit|h_count_reg\(3)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|h_count_reg\(2),
	datab => \vga_sync_unit|h_count_reg\(4),
	datac => \vga_sync_unit|h_count_reg\(3),
	datad => \pong_grf_st_unit|sq_ball_on~3_combout\,
	combout => \pong_grf_st_unit|sq_ball_on~4_combout\);

-- Location: LCCOMB_X39_Y21_N28
\pong_grf_st_unit|graph_rgb[1]~1\ : cycloneiii_lcell_comb
-- Equation(s):
-- \pong_grf_st_unit|graph_rgb[1]~1_combout\ = (!\pong_grf_st_unit|wall_on~2_combout\ & \vga_sync_unit|video_on~0_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \pong_grf_st_unit|wall_on~2_combout\,
	datad => \vga_sync_unit|video_on~0_combout\,
	combout => \pong_grf_st_unit|graph_rgb[1]~1_combout\);

-- Location: LCCOMB_X39_Y21_N18
\pong_grf_st_unit|graph_rgb[1]~2\ : cycloneiii_lcell_comb
-- Equation(s):
-- \pong_grf_st_unit|graph_rgb[1]~2_combout\ = (\pong_grf_st_unit|graph_rgb[1]~1_combout\ & (((!\pong_grf_st_unit|sq_ball_on~4_combout\) # (!\pong_grf_st_unit|sq_ball_on~2_combout\)) # (!\pong_grf_st_unit|sq_ball_on~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \pong_grf_st_unit|sq_ball_on~0_combout\,
	datab => \pong_grf_st_unit|sq_ball_on~2_combout\,
	datac => \pong_grf_st_unit|sq_ball_on~4_combout\,
	datad => \pong_grf_st_unit|graph_rgb[1]~1_combout\,
	combout => \pong_grf_st_unit|graph_rgb[1]~2_combout\);

-- Location: FF_X39_Y21_N19
\rgb_reg[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \pong_grf_st_unit|graph_rgb[1]~2_combout\,
	ena => \vga_sync_unit|mod2_reg~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => rgb_reg(1));

-- Location: LCCOMB_X39_Y21_N26
\pong_grf_st_unit|bar_on~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \pong_grf_st_unit|bar_on~0_combout\ = (\vga_sync_unit|h_count_reg\(4) & (\vga_sync_unit|h_count_reg\(3) & \pong_grf_st_unit|sq_ball_on~2_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \vga_sync_unit|h_count_reg\(4),
	datac => \vga_sync_unit|h_count_reg\(3),
	datad => \pong_grf_st_unit|sq_ball_on~2_combout\,
	combout => \pong_grf_st_unit|bar_on~0_combout\);

-- Location: LCCOMB_X38_Y23_N16
\pong_grf_st_unit|graph_rgb[2]~3\ : cycloneiii_lcell_comb
-- Equation(s):
-- \pong_grf_st_unit|graph_rgb[2]~3_combout\ = (\vga_sync_unit|v_count_reg\(6) & (!\vga_sync_unit|v_count_reg\(8) & \vga_sync_unit|v_count_reg\(7))) # (!\vga_sync_unit|v_count_reg\(6) & (\vga_sync_unit|v_count_reg\(8) & !\vga_sync_unit|v_count_reg\(7)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000110000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \vga_sync_unit|v_count_reg\(6),
	datac => \vga_sync_unit|v_count_reg\(8),
	datad => \vga_sync_unit|v_count_reg\(7),
	combout => \pong_grf_st_unit|graph_rgb[2]~3_combout\);

-- Location: LCCOMB_X38_Y23_N10
\pong_grf_st_unit|graph_rgb[2]~4\ : cycloneiii_lcell_comb
-- Equation(s):
-- \pong_grf_st_unit|graph_rgb[2]~4_combout\ = (\vga_sync_unit|v_count_reg\(3) & ((\vga_sync_unit|v_count_reg\(4)) # (\vga_sync_unit|v_count_reg\(2)))) # (!\vga_sync_unit|v_count_reg\(3) & (\vga_sync_unit|v_count_reg\(4) & \vga_sync_unit|v_count_reg\(2)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111110011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \vga_sync_unit|v_count_reg\(3),
	datac => \vga_sync_unit|v_count_reg\(4),
	datad => \vga_sync_unit|v_count_reg\(2),
	combout => \pong_grf_st_unit|graph_rgb[2]~4_combout\);

-- Location: LCCOMB_X38_Y23_N4
\pong_grf_st_unit|graph_rgb[2]~5\ : cycloneiii_lcell_comb
-- Equation(s):
-- \pong_grf_st_unit|graph_rgb[2]~5_combout\ = (\vga_sync_unit|v_count_reg\(7) & (!\vga_sync_unit|v_count_reg\(5) & (!\vga_sync_unit|v_count_reg\(4) & !\pong_grf_st_unit|graph_rgb[2]~4_combout\))) # (!\vga_sync_unit|v_count_reg\(7) & 
-- ((\vga_sync_unit|v_count_reg\(5)) # ((\vga_sync_unit|v_count_reg\(4) & \pong_grf_st_unit|graph_rgb[2]~4_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010001000110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \vga_sync_unit|v_count_reg\(7),
	datab => \vga_sync_unit|v_count_reg\(5),
	datac => \vga_sync_unit|v_count_reg\(4),
	datad => \pong_grf_st_unit|graph_rgb[2]~4_combout\,
	combout => \pong_grf_st_unit|graph_rgb[2]~5_combout\);

-- Location: LCCOMB_X39_Y21_N8
\pong_grf_st_unit|graph_rgb[2]~6\ : cycloneiii_lcell_comb
-- Equation(s):
-- \pong_grf_st_unit|graph_rgb[2]~6_combout\ = (\pong_grf_st_unit|graph_rgb[1]~1_combout\ & (((\pong_grf_st_unit|graph_rgb[2]~5_combout\) # (!\pong_grf_st_unit|graph_rgb[2]~3_combout\)) # (!\pong_grf_st_unit|bar_on~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111011100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \pong_grf_st_unit|bar_on~0_combout\,
	datab => \pong_grf_st_unit|graph_rgb[2]~3_combout\,
	datac => \pong_grf_st_unit|graph_rgb[2]~5_combout\,
	datad => \pong_grf_st_unit|graph_rgb[1]~1_combout\,
	combout => \pong_grf_st_unit|graph_rgb[2]~6_combout\);

-- Location: FF_X39_Y21_N9
\rgb_reg[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \pong_grf_st_unit|graph_rgb[2]~6_combout\,
	ena => \vga_sync_unit|mod2_reg~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => rgb_reg(2));

ww_hsync <= \hsync~output_o\;

ww_vsync <= \vsync~output_o\;

ww_rgb(0) <= \rgb[0]~output_o\;

ww_rgb(1) <= \rgb[1]~output_o\;

ww_rgb(2) <= \rgb[2]~output_o\;
END structure;


