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

-- DATE "04/04/2014 19:24:49"

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

ENTITY 	usart IS
    PORT (
	clk : IN std_logic;
	reset : IN std_logic;
	rx : IN std_logic;
	s_tick : IN std_logic;
	rx_done_tick : OUT std_logic;
	dout : OUT std_logic_vector(7 DOWNTO 0)
	);
END usart;

-- Design Ports Information
-- rx_done_tick	=>  Location: PIN_D11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- dout[0]	=>  Location: PIN_D14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- dout[1]	=>  Location: PIN_C15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- dout[2]	=>  Location: PIN_C16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- dout[3]	=>  Location: PIN_F14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- dout[4]	=>  Location: PIN_D16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- dout[5]	=>  Location: PIN_D15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- dout[6]	=>  Location: PIN_C14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- dout[7]	=>  Location: PIN_G11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- s_tick	=>  Location: PIN_E16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- rx	=>  Location: PIN_E15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- clk	=>  Location: PIN_E2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- reset	=>  Location: PIN_E1,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF usart IS
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
SIGNAL ww_rx : std_logic;
SIGNAL ww_s_tick : std_logic;
SIGNAL ww_rx_done_tick : std_logic;
SIGNAL ww_dout : std_logic_vector(7 DOWNTO 0);
SIGNAL \clk~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \reset~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \rx_done_tick~output_o\ : std_logic;
SIGNAL \dout[0]~output_o\ : std_logic;
SIGNAL \dout[1]~output_o\ : std_logic;
SIGNAL \dout[2]~output_o\ : std_logic;
SIGNAL \dout[3]~output_o\ : std_logic;
SIGNAL \dout[4]~output_o\ : std_logic;
SIGNAL \dout[5]~output_o\ : std_logic;
SIGNAL \dout[6]~output_o\ : std_logic;
SIGNAL \dout[7]~output_o\ : std_logic;
SIGNAL \s_tick~input_o\ : std_logic;
SIGNAL \clk~input_o\ : std_logic;
SIGNAL \clk~inputclkctrl_outclk\ : std_logic;
SIGNAL \rx~input_o\ : std_logic;
SIGNAL \s_reg[3]~0_combout\ : std_logic;
SIGNAL \s_reg[0]~3_combout\ : std_logic;
SIGNAL \s_reg[3]~1_combout\ : std_logic;
SIGNAL \s_reg[3]~2_combout\ : std_logic;
SIGNAL \s_reg[0]~8_combout\ : std_logic;
SIGNAL \reset~input_o\ : std_logic;
SIGNAL \reset~inputclkctrl_outclk\ : std_logic;
SIGNAL \s_reg[0]~4_combout\ : std_logic;
SIGNAL \s_reg[1]~7_combout\ : std_logic;
SIGNAL \Add0~0_combout\ : std_logic;
SIGNAL \s_reg[2]~6_combout\ : std_logic;
SIGNAL \Equal2~1_combout\ : std_logic;
SIGNAL \s_reg[3]~5_combout\ : std_logic;
SIGNAL \Equal2~0_combout\ : std_logic;
SIGNAL \Selector0~6_combout\ : std_logic;
SIGNAL \state_reg.idle~q\ : std_logic;
SIGNAL \Selector0~7_combout\ : std_logic;
SIGNAL \Selector0~5_combout\ : std_logic;
SIGNAL \Selector1~0_combout\ : std_logic;
SIGNAL \Selector1~1_combout\ : std_logic;
SIGNAL \state_reg.start~q\ : std_logic;
SIGNAL \Selector0~4_combout\ : std_logic;
SIGNAL \Selector2~0_combout\ : std_logic;
SIGNAL \state_reg.data~q\ : std_logic;
SIGNAL \b_reg[0]~0_combout\ : std_logic;
SIGNAL \n_reg[2]~0_combout\ : std_logic;
SIGNAL \n_reg[0]~3_combout\ : std_logic;
SIGNAL \n_reg[1]~2_combout\ : std_logic;
SIGNAL \Add1~0_combout\ : std_logic;
SIGNAL \n_reg[2]~1_combout\ : std_logic;
SIGNAL \Selector0~2_combout\ : std_logic;
SIGNAL \Selector0~3_combout\ : std_logic;
SIGNAL \Selector3~0_combout\ : std_logic;
SIGNAL \state_reg.stop~q\ : std_logic;
SIGNAL \rx_done_tick~0_combout\ : std_logic;
SIGNAL \b_reg[4]~feeder_combout\ : std_logic;
SIGNAL \b_reg[3]~feeder_combout\ : std_logic;
SIGNAL \b_reg[2]~feeder_combout\ : std_logic;
SIGNAL b_reg : std_logic_vector(7 DOWNTO 0);
SIGNAL n_reg : std_logic_vector(2 DOWNTO 0);
SIGNAL s_reg : std_logic_vector(3 DOWNTO 0);
SIGNAL \ALT_INV_reset~inputclkctrl_outclk\ : std_logic;

BEGIN

ww_clk <= clk;
ww_reset <= reset;
ww_rx <= rx;
ww_s_tick <= s_tick;
rx_done_tick <= ww_rx_done_tick;
dout <= ww_dout;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\clk~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \clk~input_o\);

\reset~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \reset~input_o\);
\ALT_INV_reset~inputclkctrl_outclk\ <= NOT \reset~inputclkctrl_outclk\;

-- Location: IOOBUF_X39_Y29_N30
\rx_done_tick~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \rx_done_tick~0_combout\,
	devoe => ww_devoe,
	o => \rx_done_tick~output_o\);

-- Location: IOOBUF_X39_Y29_N9
\dout[0]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => b_reg(0),
	devoe => ww_devoe,
	o => \dout[0]~output_o\);

-- Location: IOOBUF_X41_Y27_N16
\dout[1]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => b_reg(1),
	devoe => ww_devoe,
	o => \dout[1]~output_o\);

-- Location: IOOBUF_X41_Y27_N23
\dout[2]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => b_reg(2),
	devoe => ww_devoe,
	o => \dout[2]~output_o\);

-- Location: IOOBUF_X41_Y23_N2
\dout[3]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => b_reg(3),
	devoe => ww_devoe,
	o => \dout[3]~output_o\);

-- Location: IOOBUF_X41_Y24_N9
\dout[4]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => b_reg(4),
	devoe => ww_devoe,
	o => \dout[4]~output_o\);

-- Location: IOOBUF_X41_Y24_N2
\dout[5]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => b_reg(5),
	devoe => ww_devoe,
	o => \dout[5]~output_o\);

-- Location: IOOBUF_X39_Y29_N2
\dout[6]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => b_reg(6),
	devoe => ww_devoe,
	o => \dout[6]~output_o\);

-- Location: IOOBUF_X41_Y26_N2
\dout[7]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => b_reg(7),
	devoe => ww_devoe,
	o => \dout[7]~output_o\);

-- Location: IOIBUF_X41_Y15_N8
\s_tick~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_s_tick,
	o => \s_tick~input_o\);

-- Location: IOIBUF_X0_Y14_N1
\clk~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clk,
	o => \clk~input_o\);

-- Location: CLKCTRL_G4
\clk~inputclkctrl\ : cycloneiii_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \clk~inputclkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \clk~inputclkctrl_outclk\);

-- Location: IOIBUF_X41_Y15_N1
\rx~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_rx,
	o => \rx~input_o\);

-- Location: LCCOMB_X40_Y26_N8
\s_reg[3]~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \s_reg[3]~0_combout\ = (\rx~input_o\ & !\state_reg.idle~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \rx~input_o\,
	datad => \state_reg.idle~q\,
	combout => \s_reg[3]~0_combout\);

-- Location: LCCOMB_X40_Y26_N0
\s_reg[0]~3\ : cycloneiii_lcell_comb
-- Equation(s):
-- \s_reg[0]~3_combout\ = ((s_reg(3) & ((!\state_reg.data~q\))) # (!s_reg(3) & ((\state_reg.data~q\) # (!\state_reg.start~q\)))) # (!\Equal2~1_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101111111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => s_reg(3),
	datab => \state_reg.start~q\,
	datac => \state_reg.data~q\,
	datad => \Equal2~1_combout\,
	combout => \s_reg[0]~3_combout\);

-- Location: LCCOMB_X39_Y26_N10
\s_reg[3]~1\ : cycloneiii_lcell_comb
-- Equation(s):
-- \s_reg[3]~1_combout\ = (!\s_tick~input_o\ & ((\state_reg.stop~q\) # ((\state_reg.start~q\) # (\state_reg.data~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010101010100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \s_tick~input_o\,
	datab => \state_reg.stop~q\,
	datac => \state_reg.start~q\,
	datad => \state_reg.data~q\,
	combout => \s_reg[3]~1_combout\);

-- Location: LCCOMB_X40_Y26_N24
\s_reg[3]~2\ : cycloneiii_lcell_comb
-- Equation(s):
-- \s_reg[3]~2_combout\ = (\s_reg[3]~0_combout\) # ((\s_reg[3]~1_combout\) # ((\Equal2~0_combout\ & \state_reg.stop~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111111000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Equal2~0_combout\,
	datab => \state_reg.stop~q\,
	datac => \s_reg[3]~0_combout\,
	datad => \s_reg[3]~1_combout\,
	combout => \s_reg[3]~2_combout\);

-- Location: LCCOMB_X40_Y26_N16
\s_reg[0]~8\ : cycloneiii_lcell_comb
-- Equation(s):
-- \s_reg[0]~8_combout\ = (s_reg(0) & (((\s_reg[3]~2_combout\)))) # (!s_reg(0) & (\state_reg.idle~q\ & (\s_reg[0]~3_combout\ & !\s_reg[3]~2_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state_reg.idle~q\,
	datab => \s_reg[0]~3_combout\,
	datac => s_reg(0),
	datad => \s_reg[3]~2_combout\,
	combout => \s_reg[0]~8_combout\);

-- Location: IOIBUF_X0_Y14_N8
\reset~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_reset,
	o => \reset~input_o\);

-- Location: CLKCTRL_G2
\reset~inputclkctrl\ : cycloneiii_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \reset~inputclkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \reset~inputclkctrl_outclk\);

-- Location: FF_X40_Y26_N17
\s_reg[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \s_reg[0]~8_combout\,
	clrn => \ALT_INV_reset~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => s_reg(0));

-- Location: LCCOMB_X40_Y26_N20
\s_reg[0]~4\ : cycloneiii_lcell_comb
-- Equation(s):
-- \s_reg[0]~4_combout\ = (\state_reg.idle~q\ & (\s_reg[0]~3_combout\ & !\s_reg[3]~2_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state_reg.idle~q\,
	datab => \s_reg[0]~3_combout\,
	datad => \s_reg[3]~2_combout\,
	combout => \s_reg[0]~4_combout\);

-- Location: LCCOMB_X40_Y26_N30
\s_reg[1]~7\ : cycloneiii_lcell_comb
-- Equation(s):
-- \s_reg[1]~7_combout\ = (s_reg(1) & ((\s_reg[3]~2_combout\) # ((!s_reg(0) & \s_reg[0]~4_combout\)))) # (!s_reg(1) & (s_reg(0) & ((\s_reg[0]~4_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101101011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => s_reg(0),
	datab => \s_reg[3]~2_combout\,
	datac => s_reg(1),
	datad => \s_reg[0]~4_combout\,
	combout => \s_reg[1]~7_combout\);

-- Location: FF_X40_Y26_N31
\s_reg[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \s_reg[1]~7_combout\,
	clrn => \ALT_INV_reset~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => s_reg(1));

-- Location: LCCOMB_X40_Y26_N26
\Add0~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \Add0~0_combout\ = s_reg(2) $ (((s_reg(0) & s_reg(1))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111011110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => s_reg(0),
	datab => s_reg(1),
	datad => s_reg(2),
	combout => \Add0~0_combout\);

-- Location: LCCOMB_X40_Y26_N4
\s_reg[2]~6\ : cycloneiii_lcell_comb
-- Equation(s):
-- \s_reg[2]~6_combout\ = (\Add0~0_combout\ & ((\s_reg[0]~4_combout\) # ((\s_reg[3]~2_combout\ & s_reg(2))))) # (!\Add0~0_combout\ & (\s_reg[3]~2_combout\ & (s_reg(2))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110101011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Add0~0_combout\,
	datab => \s_reg[3]~2_combout\,
	datac => s_reg(2),
	datad => \s_reg[0]~4_combout\,
	combout => \s_reg[2]~6_combout\);

-- Location: FF_X40_Y26_N5
\s_reg[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \s_reg[2]~6_combout\,
	clrn => \ALT_INV_reset~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => s_reg(2));

-- Location: LCCOMB_X40_Y26_N18
\Equal2~1\ : cycloneiii_lcell_comb
-- Equation(s):
-- \Equal2~1_combout\ = (s_reg(1) & (s_reg(2) & s_reg(0)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000100000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => s_reg(1),
	datab => s_reg(2),
	datad => s_reg(0),
	combout => \Equal2~1_combout\);

-- Location: LCCOMB_X40_Y26_N22
\s_reg[3]~5\ : cycloneiii_lcell_comb
-- Equation(s):
-- \s_reg[3]~5_combout\ = (s_reg(3) & ((\s_reg[3]~2_combout\) # ((!\Equal2~1_combout\ & \s_reg[0]~4_combout\)))) # (!s_reg(3) & (\Equal2~1_combout\ & ((\s_reg[0]~4_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101101011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Equal2~1_combout\,
	datab => \s_reg[3]~2_combout\,
	datac => s_reg(3),
	datad => \s_reg[0]~4_combout\,
	combout => \s_reg[3]~5_combout\);

-- Location: FF_X40_Y26_N23
\s_reg[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \s_reg[3]~5_combout\,
	clrn => \ALT_INV_reset~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => s_reg(3));

-- Location: LCCOMB_X40_Y26_N6
\Equal2~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \Equal2~0_combout\ = (s_reg(3) & (s_reg(2) & (s_reg(1) & s_reg(0))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => s_reg(3),
	datab => s_reg(2),
	datac => s_reg(1),
	datad => s_reg(0),
	combout => \Equal2~0_combout\);

-- Location: LCCOMB_X40_Y26_N14
\Selector0~6\ : cycloneiii_lcell_comb
-- Equation(s):
-- \Selector0~6_combout\ = (!\s_reg[3]~0_combout\ & (((!\state_reg.stop~q\) # (!\Equal2~0_combout\)) # (!\s_tick~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001001100110011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \s_tick~input_o\,
	datab => \s_reg[3]~0_combout\,
	datac => \Equal2~0_combout\,
	datad => \state_reg.stop~q\,
	combout => \Selector0~6_combout\);

-- Location: FF_X40_Y26_N15
\state_reg.idle\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \Selector0~6_combout\,
	clrn => \ALT_INV_reset~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \state_reg.idle~q\);

-- Location: LCCOMB_X39_Y26_N6
\Selector0~7\ : cycloneiii_lcell_comb
-- Equation(s):
-- \Selector0~7_combout\ = (\Selector0~4_combout\ & (!\Selector0~3_combout\ & ((\rx~input_o\) # (\state_reg.idle~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \rx~input_o\,
	datab => \state_reg.idle~q\,
	datac => \Selector0~4_combout\,
	datad => \Selector0~3_combout\,
	combout => \Selector0~7_combout\);

-- Location: LCCOMB_X39_Y26_N12
\Selector0~5\ : cycloneiii_lcell_comb
-- Equation(s):
-- \Selector0~5_combout\ = (!\rx~input_o\ & !\state_reg.idle~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010100000101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \rx~input_o\,
	datac => \state_reg.idle~q\,
	combout => \Selector0~5_combout\);

-- Location: LCCOMB_X39_Y26_N0
\Selector1~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \Selector1~0_combout\ = (!\Selector0~3_combout\ & (\Selector0~5_combout\ & (\Selector0~4_combout\ & !\rx_done_tick~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000001000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Selector0~3_combout\,
	datab => \Selector0~5_combout\,
	datac => \Selector0~4_combout\,
	datad => \rx_done_tick~0_combout\,
	combout => \Selector1~0_combout\);

-- Location: LCCOMB_X39_Y26_N8
\Selector1~1\ : cycloneiii_lcell_comb
-- Equation(s):
-- \Selector1~1_combout\ = (\Selector1~0_combout\) # ((\Selector0~7_combout\ & (!\rx_done_tick~0_combout\ & \state_reg.start~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Selector0~7_combout\,
	datab => \rx_done_tick~0_combout\,
	datac => \state_reg.start~q\,
	datad => \Selector1~0_combout\,
	combout => \Selector1~1_combout\);

-- Location: FF_X39_Y26_N9
\state_reg.start\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \Selector1~1_combout\,
	clrn => \ALT_INV_reset~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \state_reg.start~q\);

-- Location: LCCOMB_X39_Y26_N14
\Selector0~4\ : cycloneiii_lcell_comb
-- Equation(s):
-- \Selector0~4_combout\ = ((s_reg(3)) # ((!\Equal2~1_combout\) # (!\s_tick~input_o\))) # (!\state_reg.start~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101111111111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state_reg.start~q\,
	datab => s_reg(3),
	datac => \s_tick~input_o\,
	datad => \Equal2~1_combout\,
	combout => \Selector0~4_combout\);

-- Location: LCCOMB_X39_Y26_N16
\Selector2~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \Selector2~0_combout\ = (!\rx_done_tick~0_combout\ & ((\Selector0~7_combout\ & ((\state_reg.data~q\))) # (!\Selector0~7_combout\ & (!\Selector0~4_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011000000010001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Selector0~4_combout\,
	datab => \rx_done_tick~0_combout\,
	datac => \state_reg.data~q\,
	datad => \Selector0~7_combout\,
	combout => \Selector2~0_combout\);

-- Location: FF_X39_Y26_N17
\state_reg.data\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \Selector2~0_combout\,
	clrn => \ALT_INV_reset~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \state_reg.data~q\);

-- Location: LCCOMB_X40_Y26_N2
\b_reg[0]~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \b_reg[0]~0_combout\ = (\state_reg.data~q\ & (\s_tick~input_o\ & \Equal2~0_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000100000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state_reg.data~q\,
	datab => \s_tick~input_o\,
	datad => \Equal2~0_combout\,
	combout => \b_reg[0]~0_combout\);

-- Location: LCCOMB_X39_Y26_N18
\n_reg[2]~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \n_reg[2]~0_combout\ = (\Selector0~4_combout\ & ((\Selector0~2_combout\) # (!\b_reg[0]~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \Selector0~2_combout\,
	datac => \Selector0~4_combout\,
	datad => \b_reg[0]~0_combout\,
	combout => \n_reg[2]~0_combout\);

-- Location: LCCOMB_X39_Y26_N30
\n_reg[0]~3\ : cycloneiii_lcell_comb
-- Equation(s):
-- \n_reg[0]~3_combout\ = (n_reg(0) & ((\n_reg[2]~0_combout\))) # (!n_reg(0) & (\state_reg.data~q\ & !\n_reg[2]~0_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \state_reg.data~q\,
	datac => n_reg(0),
	datad => \n_reg[2]~0_combout\,
	combout => \n_reg[0]~3_combout\);

-- Location: FF_X39_Y26_N31
\n_reg[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \n_reg[0]~3_combout\,
	clrn => \ALT_INV_reset~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => n_reg(0));

-- Location: LCCOMB_X39_Y26_N20
\n_reg[1]~2\ : cycloneiii_lcell_comb
-- Equation(s):
-- \n_reg[1]~2_combout\ = (\n_reg[2]~0_combout\ & (((n_reg(1))))) # (!\n_reg[2]~0_combout\ & (\state_reg.data~q\ & (n_reg(0) $ (n_reg(1)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000101000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state_reg.data~q\,
	datab => n_reg(0),
	datac => n_reg(1),
	datad => \n_reg[2]~0_combout\,
	combout => \n_reg[1]~2_combout\);

-- Location: FF_X39_Y26_N21
\n_reg[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \n_reg[1]~2_combout\,
	clrn => \ALT_INV_reset~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => n_reg(1));

-- Location: LCCOMB_X39_Y26_N28
\Add1~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \Add1~0_combout\ = n_reg(2) $ (((n_reg(0) & n_reg(1))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => n_reg(0),
	datac => n_reg(2),
	datad => n_reg(1),
	combout => \Add1~0_combout\);

-- Location: LCCOMB_X39_Y26_N22
\n_reg[2]~1\ : cycloneiii_lcell_comb
-- Equation(s):
-- \n_reg[2]~1_combout\ = (\n_reg[2]~0_combout\ & (((n_reg(2))))) # (!\n_reg[2]~0_combout\ & (\state_reg.data~q\ & (\Add1~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state_reg.data~q\,
	datab => \Add1~0_combout\,
	datac => n_reg(2),
	datad => \n_reg[2]~0_combout\,
	combout => \n_reg[2]~1_combout\);

-- Location: FF_X39_Y26_N23
\n_reg[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \n_reg[2]~1_combout\,
	clrn => \ALT_INV_reset~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => n_reg(2));

-- Location: LCCOMB_X39_Y26_N4
\Selector0~2\ : cycloneiii_lcell_comb
-- Equation(s):
-- \Selector0~2_combout\ = (n_reg(2) & (n_reg(0) & n_reg(1)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => n_reg(2),
	datac => n_reg(0),
	datad => n_reg(1),
	combout => \Selector0~2_combout\);

-- Location: LCCOMB_X39_Y26_N26
\Selector0~3\ : cycloneiii_lcell_comb
-- Equation(s):
-- \Selector0~3_combout\ = (\s_tick~input_o\ & (\state_reg.data~q\ & (\Selector0~2_combout\ & \Equal2~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \s_tick~input_o\,
	datab => \state_reg.data~q\,
	datac => \Selector0~2_combout\,
	datad => \Equal2~0_combout\,
	combout => \Selector0~3_combout\);

-- Location: LCCOMB_X39_Y26_N24
\Selector3~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \Selector3~0_combout\ = (!\rx_done_tick~0_combout\ & ((\Selector0~7_combout\ & ((\state_reg.stop~q\))) # (!\Selector0~7_combout\ & (\Selector0~3_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011000000100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Selector0~3_combout\,
	datab => \rx_done_tick~0_combout\,
	datac => \state_reg.stop~q\,
	datad => \Selector0~7_combout\,
	combout => \Selector3~0_combout\);

-- Location: FF_X39_Y26_N25
\state_reg.stop\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \Selector3~0_combout\,
	clrn => \ALT_INV_reset~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \state_reg.stop~q\);

-- Location: LCCOMB_X39_Y26_N2
\rx_done_tick~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \rx_done_tick~0_combout\ = (\s_tick~input_o\ & (\state_reg.stop~q\ & \Equal2~0_combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \s_tick~input_o\,
	datac => \state_reg.stop~q\,
	datad => \Equal2~0_combout\,
	combout => \rx_done_tick~0_combout\);

-- Location: FF_X40_Y26_N21
\b_reg[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \rx~input_o\,
	clrn => \ALT_INV_reset~inputclkctrl_outclk\,
	sload => VCC,
	ena => \b_reg[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => b_reg(7));

-- Location: FF_X40_Y26_N27
\b_reg[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => b_reg(7),
	clrn => \ALT_INV_reset~inputclkctrl_outclk\,
	sload => VCC,
	ena => \b_reg[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => b_reg(6));

-- Location: FF_X40_Y26_N9
\b_reg[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => b_reg(6),
	clrn => \ALT_INV_reset~inputclkctrl_outclk\,
	sload => VCC,
	ena => \b_reg[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => b_reg(5));

-- Location: LCCOMB_X40_Y26_N12
\b_reg[4]~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \b_reg[4]~feeder_combout\ = b_reg(5)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => b_reg(5),
	combout => \b_reg[4]~feeder_combout\);

-- Location: FF_X40_Y26_N13
\b_reg[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \b_reg[4]~feeder_combout\,
	clrn => \ALT_INV_reset~inputclkctrl_outclk\,
	ena => \b_reg[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => b_reg(4));

-- Location: LCCOMB_X40_Y26_N28
\b_reg[3]~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \b_reg[3]~feeder_combout\ = b_reg(4)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => b_reg(4),
	combout => \b_reg[3]~feeder_combout\);

-- Location: FF_X40_Y26_N29
\b_reg[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \b_reg[3]~feeder_combout\,
	clrn => \ALT_INV_reset~inputclkctrl_outclk\,
	ena => \b_reg[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => b_reg(3));

-- Location: LCCOMB_X40_Y26_N10
\b_reg[2]~feeder\ : cycloneiii_lcell_comb
-- Equation(s):
-- \b_reg[2]~feeder_combout\ = b_reg(3)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => b_reg(3),
	combout => \b_reg[2]~feeder_combout\);

-- Location: FF_X40_Y26_N11
\b_reg[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \b_reg[2]~feeder_combout\,
	clrn => \ALT_INV_reset~inputclkctrl_outclk\,
	ena => \b_reg[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => b_reg(2));

-- Location: FF_X40_Y26_N19
\b_reg[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => b_reg(2),
	clrn => \ALT_INV_reset~inputclkctrl_outclk\,
	sload => VCC,
	ena => \b_reg[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => b_reg(1));

-- Location: FF_X40_Y26_N3
\b_reg[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => b_reg(1),
	clrn => \ALT_INV_reset~inputclkctrl_outclk\,
	sload => VCC,
	ena => \b_reg[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => b_reg(0));

ww_rx_done_tick <= \rx_done_tick~output_o\;

ww_dout(0) <= \dout[0]~output_o\;

ww_dout(1) <= \dout[1]~output_o\;

ww_dout(2) <= \dout[2]~output_o\;

ww_dout(3) <= \dout[3]~output_o\;

ww_dout(4) <= \dout[4]~output_o\;

ww_dout(5) <= \dout[5]~output_o\;

ww_dout(6) <= \dout[6]~output_o\;

ww_dout(7) <= \dout[7]~output_o\;
END structure;


