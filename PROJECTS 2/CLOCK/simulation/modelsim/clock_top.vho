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

-- DATE "10/29/2016 14:39:05"

-- 
-- Device: Altera EP3C5F256C6 Package FBGA256
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

ENTITY 	freq_calc IS
    PORT (
	clk : IN std_logic;
	rst : IN std_logic;
	enc_step : IN std_logic;
	enc_dir : IN std_logic;
	enc_ent : IN std_logic;
	menu : IN std_logic;
	pre_ld : IN std_logic;
	preset_ld : IN std_logic_vector(10 DOWNTO 0);
	disp_freq : BUFFER std_logic_vector(10 DOWNTO 0);
	word : BUFFER std_logic_vector(13 DOWNTO 0)
	);
END freq_calc;

-- Design Ports Information
-- rst	=>  Location: PIN_M2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- menu	=>  Location: PIN_M1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- disp_freq[0]	=>  Location: PIN_C11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- disp_freq[1]	=>  Location: PIN_A15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- disp_freq[2]	=>  Location: PIN_E11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- disp_freq[3]	=>  Location: PIN_D8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- disp_freq[4]	=>  Location: PIN_D12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- disp_freq[5]	=>  Location: PIN_A13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- disp_freq[6]	=>  Location: PIN_E8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- disp_freq[7]	=>  Location: PIN_E10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- disp_freq[8]	=>  Location: PIN_B11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- disp_freq[9]	=>  Location: PIN_F10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- disp_freq[10]	=>  Location: PIN_A11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- word[0]	=>  Location: PIN_B4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- word[1]	=>  Location: PIN_T8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- word[2]	=>  Location: PIN_J14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- word[3]	=>  Location: PIN_B14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- word[4]	=>  Location: PIN_C9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- word[5]	=>  Location: PIN_D11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- word[6]	=>  Location: PIN_G11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- word[7]	=>  Location: PIN_C8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- word[8]	=>  Location: PIN_F14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- word[9]	=>  Location: PIN_D14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- word[10]	=>  Location: PIN_A12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- word[11]	=>  Location: PIN_A10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- word[12]	=>  Location: PIN_A7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- word[13]	=>  Location: PIN_B13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- clk	=>  Location: PIN_E2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- preset_ld[0]	=>  Location: PIN_B8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- pre_ld	=>  Location: PIN_E9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- enc_step	=>  Location: PIN_A8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- enc_dir	=>  Location: PIN_F11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- preset_ld[1]	=>  Location: PIN_F9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- preset_ld[2]	=>  Location: PIN_B10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- preset_ld[3]	=>  Location: PIN_B9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- preset_ld[4]	=>  Location: PIN_C15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- preset_ld[5]	=>  Location: PIN_B12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- preset_ld[6]	=>  Location: PIN_A14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- preset_ld[7]	=>  Location: PIN_A9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- preset_ld[8]	=>  Location: PIN_F8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- preset_ld[9]	=>  Location: PIN_D9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- preset_ld[10]	=>  Location: PIN_C14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- enc_ent	=>  Location: PIN_C16,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF freq_calc IS
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
SIGNAL ww_rst : std_logic;
SIGNAL ww_enc_step : std_logic;
SIGNAL ww_enc_dir : std_logic;
SIGNAL ww_enc_ent : std_logic;
SIGNAL ww_menu : std_logic;
SIGNAL ww_pre_ld : std_logic;
SIGNAL ww_preset_ld : std_logic_vector(10 DOWNTO 0);
SIGNAL ww_disp_freq : std_logic_vector(10 DOWNTO 0);
SIGNAL ww_word : std_logic_vector(13 DOWNTO 0);
SIGNAL \clk~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \rst~input_o\ : std_logic;
SIGNAL \menu~input_o\ : std_logic;
SIGNAL \disp_freq[0]~output_o\ : std_logic;
SIGNAL \disp_freq[1]~output_o\ : std_logic;
SIGNAL \disp_freq[2]~output_o\ : std_logic;
SIGNAL \disp_freq[3]~output_o\ : std_logic;
SIGNAL \disp_freq[4]~output_o\ : std_logic;
SIGNAL \disp_freq[5]~output_o\ : std_logic;
SIGNAL \disp_freq[6]~output_o\ : std_logic;
SIGNAL \disp_freq[7]~output_o\ : std_logic;
SIGNAL \disp_freq[8]~output_o\ : std_logic;
SIGNAL \disp_freq[9]~output_o\ : std_logic;
SIGNAL \disp_freq[10]~output_o\ : std_logic;
SIGNAL \word[0]~output_o\ : std_logic;
SIGNAL \word[1]~output_o\ : std_logic;
SIGNAL \word[2]~output_o\ : std_logic;
SIGNAL \word[3]~output_o\ : std_logic;
SIGNAL \word[4]~output_o\ : std_logic;
SIGNAL \word[5]~output_o\ : std_logic;
SIGNAL \word[6]~output_o\ : std_logic;
SIGNAL \word[7]~output_o\ : std_logic;
SIGNAL \word[8]~output_o\ : std_logic;
SIGNAL \word[9]~output_o\ : std_logic;
SIGNAL \word[10]~output_o\ : std_logic;
SIGNAL \word[11]~output_o\ : std_logic;
SIGNAL \word[12]~output_o\ : std_logic;
SIGNAL \word[13]~output_o\ : std_logic;
SIGNAL \clk~input_o\ : std_logic;
SIGNAL \clk~inputclkctrl_outclk\ : std_logic;
SIGNAL \want_freq[0]~11_combout\ : std_logic;
SIGNAL \preset_ld[0]~input_o\ : std_logic;
SIGNAL \pre_ld~input_o\ : std_logic;
SIGNAL \enc_step~input_o\ : std_logic;
SIGNAL \want_freq[0]~13_combout\ : std_logic;
SIGNAL \enc_dir~input_o\ : std_logic;
SIGNAL \want_freq[0]~12\ : std_logic;
SIGNAL \want_freq[1]~14_combout\ : std_logic;
SIGNAL \preset_ld[1]~input_o\ : std_logic;
SIGNAL \want_freq[1]~15\ : std_logic;
SIGNAL \want_freq[2]~16_combout\ : std_logic;
SIGNAL \preset_ld[2]~input_o\ : std_logic;
SIGNAL \want_freq[2]~17\ : std_logic;
SIGNAL \want_freq[3]~18_combout\ : std_logic;
SIGNAL \preset_ld[3]~input_o\ : std_logic;
SIGNAL \want_freq[3]~19\ : std_logic;
SIGNAL \want_freq[4]~20_combout\ : std_logic;
SIGNAL \preset_ld[4]~input_o\ : std_logic;
SIGNAL \want_freq[4]~21\ : std_logic;
SIGNAL \want_freq[5]~22_combout\ : std_logic;
SIGNAL \preset_ld[5]~input_o\ : std_logic;
SIGNAL \want_freq[5]~23\ : std_logic;
SIGNAL \want_freq[6]~24_combout\ : std_logic;
SIGNAL \preset_ld[6]~input_o\ : std_logic;
SIGNAL \want_freq[6]~25\ : std_logic;
SIGNAL \want_freq[7]~26_combout\ : std_logic;
SIGNAL \preset_ld[7]~input_o\ : std_logic;
SIGNAL \want_freq[7]~27\ : std_logic;
SIGNAL \want_freq[8]~28_combout\ : std_logic;
SIGNAL \preset_ld[8]~input_o\ : std_logic;
SIGNAL \want_freq[8]~29\ : std_logic;
SIGNAL \want_freq[9]~30_combout\ : std_logic;
SIGNAL \preset_ld[9]~input_o\ : std_logic;
SIGNAL \want_freq[9]~31\ : std_logic;
SIGNAL \want_freq[10]~32_combout\ : std_logic;
SIGNAL \preset_ld[10]~input_o\ : std_logic;
SIGNAL \enc_ent~input_o\ : std_logic;
SIGNAL \word[3]~10_combout\ : std_logic;
SIGNAL \word[3]~reg0_q\ : std_logic;
SIGNAL \word[4]~12_cout\ : std_logic;
SIGNAL \word[4]~13_combout\ : std_logic;
SIGNAL \word[4]~reg0_q\ : std_logic;
SIGNAL \word[4]~14\ : std_logic;
SIGNAL \word[5]~15_combout\ : std_logic;
SIGNAL \word[5]~reg0_q\ : std_logic;
SIGNAL \word[5]~16\ : std_logic;
SIGNAL \word[6]~17_combout\ : std_logic;
SIGNAL \word[6]~reg0_q\ : std_logic;
SIGNAL \word[6]~18\ : std_logic;
SIGNAL \word[7]~19_combout\ : std_logic;
SIGNAL \word[7]~reg0_q\ : std_logic;
SIGNAL \word[7]~20\ : std_logic;
SIGNAL \word[8]~21_combout\ : std_logic;
SIGNAL \word[8]~reg0_q\ : std_logic;
SIGNAL \word[8]~22\ : std_logic;
SIGNAL \word[9]~23_combout\ : std_logic;
SIGNAL \word[9]~reg0_q\ : std_logic;
SIGNAL \word[9]~24\ : std_logic;
SIGNAL \word[10]~25_combout\ : std_logic;
SIGNAL \word[10]~reg0_q\ : std_logic;
SIGNAL \word[10]~26\ : std_logic;
SIGNAL \word[11]~27_combout\ : std_logic;
SIGNAL \word[11]~reg0_q\ : std_logic;
SIGNAL \word[11]~28\ : std_logic;
SIGNAL \word[12]~29_combout\ : std_logic;
SIGNAL \word[12]~reg0_q\ : std_logic;
SIGNAL \word[12]~30\ : std_logic;
SIGNAL \word[13]~31_combout\ : std_logic;
SIGNAL \word[13]~reg0_q\ : std_logic;
SIGNAL want_freq : std_logic_vector(10 DOWNTO 0);

BEGIN

ww_clk <= clk;
ww_rst <= rst;
ww_enc_step <= enc_step;
ww_enc_dir <= enc_dir;
ww_enc_ent <= enc_ent;
ww_menu <= menu;
ww_pre_ld <= pre_ld;
ww_preset_ld <= preset_ld;
disp_freq <= ww_disp_freq;
word <= ww_word;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\clk~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \clk~input_o\);

-- Location: IOOBUF_X23_Y24_N2
\disp_freq[0]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => want_freq(0),
	devoe => ww_devoe,
	o => \disp_freq[0]~output_o\);

-- Location: IOOBUF_X21_Y24_N2
\disp_freq[1]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => want_freq(1),
	devoe => ww_devoe,
	o => \disp_freq[1]~output_o\);

-- Location: IOOBUF_X28_Y24_N16
\disp_freq[2]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => want_freq(2),
	devoe => ww_devoe,
	o => \disp_freq[2]~output_o\);

-- Location: IOOBUF_X13_Y24_N9
\disp_freq[3]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => want_freq(3),
	devoe => ww_devoe,
	o => \disp_freq[3]~output_o\);

-- Location: IOOBUF_X30_Y24_N2
\disp_freq[4]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => want_freq(4),
	devoe => ww_devoe,
	o => \disp_freq[4]~output_o\);

-- Location: IOOBUF_X30_Y24_N9
\disp_freq[5]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => want_freq(5),
	devoe => ww_devoe,
	o => \disp_freq[5]~output_o\);

-- Location: IOOBUF_X13_Y24_N16
\disp_freq[6]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => want_freq(6),
	devoe => ww_devoe,
	o => \disp_freq[6]~output_o\);

-- Location: IOOBUF_X28_Y24_N23
\disp_freq[7]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => want_freq(7),
	devoe => ww_devoe,
	o => \disp_freq[7]~output_o\);

-- Location: IOOBUF_X25_Y24_N23
\disp_freq[8]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => want_freq(8),
	devoe => ww_devoe,
	o => \disp_freq[8]~output_o\);

-- Location: IOOBUF_X23_Y24_N9
\disp_freq[9]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => want_freq(9),
	devoe => ww_devoe,
	o => \disp_freq[9]~output_o\);

-- Location: IOOBUF_X25_Y24_N16
\disp_freq[10]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => want_freq(10),
	devoe => ww_devoe,
	o => \disp_freq[10]~output_o\);

-- Location: IOOBUF_X5_Y24_N23
\word[0]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => \word[0]~output_o\);

-- Location: IOOBUF_X16_Y0_N2
\word[1]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => \word[1]~output_o\);

-- Location: IOOBUF_X34_Y10_N2
\word[2]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \word[2]~output_o\);

-- Location: IOOBUF_X28_Y24_N9
\word[3]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \word[3]~reg0_q\,
	devoe => ww_devoe,
	o => \word[3]~output_o\);

-- Location: IOOBUF_X18_Y24_N9
\word[4]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \word[4]~reg0_q\,
	devoe => ww_devoe,
	o => \word[4]~output_o\);

-- Location: IOOBUF_X32_Y24_N23
\word[5]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \word[5]~reg0_q\,
	devoe => ww_devoe,
	o => \word[5]~output_o\);

-- Location: IOOBUF_X34_Y20_N16
\word[6]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \word[6]~reg0_q\,
	devoe => ww_devoe,
	o => \word[6]~output_o\);

-- Location: IOOBUF_X13_Y24_N2
\word[7]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \word[7]~reg0_q\,
	devoe => ww_devoe,
	o => \word[7]~output_o\);

-- Location: IOOBUF_X34_Y19_N16
\word[8]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \word[8]~reg0_q\,
	devoe => ww_devoe,
	o => \word[8]~output_o\);

-- Location: IOOBUF_X32_Y24_N16
\word[9]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \word[9]~reg0_q\,
	devoe => ww_devoe,
	o => \word[9]~output_o\);

-- Location: IOOBUF_X25_Y24_N2
\word[10]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \word[10]~reg0_q\,
	devoe => ww_devoe,
	o => \word[10]~output_o\);

-- Location: IOOBUF_X21_Y24_N9
\word[11]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \word[11]~reg0_q\,
	devoe => ww_devoe,
	o => \word[11]~output_o\);

-- Location: IOOBUF_X11_Y24_N2
\word[12]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \word[12]~reg0_q\,
	devoe => ww_devoe,
	o => \word[12]~output_o\);

-- Location: IOOBUF_X30_Y24_N23
\word[13]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \word[13]~reg0_q\,
	devoe => ww_devoe,
	o => \word[13]~output_o\);

-- Location: IOIBUF_X0_Y11_N1
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

-- Location: LCCOMB_X24_Y23_N0
\want_freq[0]~11\ : cycloneiii_lcell_comb
-- Equation(s):
-- \want_freq[0]~11_combout\ = want_freq(0) $ (VCC)
-- \want_freq[0]~12\ = CARRY(want_freq(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => want_freq(0),
	datad => VCC,
	combout => \want_freq[0]~11_combout\,
	cout => \want_freq[0]~12\);

-- Location: IOIBUF_X16_Y24_N22
\preset_ld[0]~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_preset_ld(0),
	o => \preset_ld[0]~input_o\);

-- Location: IOIBUF_X18_Y24_N22
\pre_ld~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_pre_ld,
	o => \pre_ld~input_o\);

-- Location: IOIBUF_X16_Y24_N15
\enc_step~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_enc_step,
	o => \enc_step~input_o\);

-- Location: LCCOMB_X24_Y23_N30
\want_freq[0]~13\ : cycloneiii_lcell_comb
-- Equation(s):
-- \want_freq[0]~13_combout\ = (\enc_step~input_o\) # (\pre_ld~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \enc_step~input_o\,
	datad => \pre_ld~input_o\,
	combout => \want_freq[0]~13_combout\);

-- Location: FF_X24_Y23_N1
\want_freq[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \want_freq[0]~11_combout\,
	asdata => \preset_ld[0]~input_o\,
	sload => \pre_ld~input_o\,
	ena => \want_freq[0]~13_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => want_freq(0));

-- Location: IOIBUF_X23_Y24_N22
\enc_dir~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_enc_dir,
	o => \enc_dir~input_o\);

-- Location: LCCOMB_X24_Y23_N2
\want_freq[1]~14\ : cycloneiii_lcell_comb
-- Equation(s):
-- \want_freq[1]~14_combout\ = (\enc_dir~input_o\ & ((want_freq(1) & (!\want_freq[0]~12\)) # (!want_freq(1) & ((\want_freq[0]~12\) # (GND))))) # (!\enc_dir~input_o\ & ((want_freq(1) & (\want_freq[0]~12\ & VCC)) # (!want_freq(1) & (!\want_freq[0]~12\))))
-- \want_freq[1]~15\ = CARRY((\enc_dir~input_o\ & ((!\want_freq[0]~12\) # (!want_freq(1)))) # (!\enc_dir~input_o\ & (!want_freq(1) & !\want_freq[0]~12\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100100101011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \enc_dir~input_o\,
	datab => want_freq(1),
	datad => VCC,
	cin => \want_freq[0]~12\,
	combout => \want_freq[1]~14_combout\,
	cout => \want_freq[1]~15\);

-- Location: IOIBUF_X23_Y24_N15
\preset_ld[1]~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_preset_ld(1),
	o => \preset_ld[1]~input_o\);

-- Location: FF_X24_Y23_N3
\want_freq[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \want_freq[1]~14_combout\,
	asdata => \preset_ld[1]~input_o\,
	sload => \pre_ld~input_o\,
	ena => \want_freq[0]~13_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => want_freq(1));

-- Location: LCCOMB_X24_Y23_N4
\want_freq[2]~16\ : cycloneiii_lcell_comb
-- Equation(s):
-- \want_freq[2]~16_combout\ = ((\enc_dir~input_o\ $ (want_freq(2) $ (\want_freq[1]~15\)))) # (GND)
-- \want_freq[2]~17\ = CARRY((\enc_dir~input_o\ & (want_freq(2) & !\want_freq[1]~15\)) # (!\enc_dir~input_o\ & ((want_freq(2)) # (!\want_freq[1]~15\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011001001101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \enc_dir~input_o\,
	datab => want_freq(2),
	datad => VCC,
	cin => \want_freq[1]~15\,
	combout => \want_freq[2]~16_combout\,
	cout => \want_freq[2]~17\);

-- Location: IOIBUF_X21_Y24_N15
\preset_ld[2]~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_preset_ld(2),
	o => \preset_ld[2]~input_o\);

-- Location: FF_X24_Y23_N5
\want_freq[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \want_freq[2]~16_combout\,
	asdata => \preset_ld[2]~input_o\,
	sload => \pre_ld~input_o\,
	ena => \want_freq[0]~13_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => want_freq(2));

-- Location: LCCOMB_X24_Y23_N6
\want_freq[3]~18\ : cycloneiii_lcell_comb
-- Equation(s):
-- \want_freq[3]~18_combout\ = (want_freq(3) & ((\enc_dir~input_o\ & (!\want_freq[2]~17\)) # (!\enc_dir~input_o\ & (\want_freq[2]~17\ & VCC)))) # (!want_freq(3) & ((\enc_dir~input_o\ & ((\want_freq[2]~17\) # (GND))) # (!\enc_dir~input_o\ & 
-- (!\want_freq[2]~17\))))
-- \want_freq[3]~19\ = CARRY((want_freq(3) & (\enc_dir~input_o\ & !\want_freq[2]~17\)) # (!want_freq(3) & ((\enc_dir~input_o\) # (!\want_freq[2]~17\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100101001101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => want_freq(3),
	datab => \enc_dir~input_o\,
	datad => VCC,
	cin => \want_freq[2]~17\,
	combout => \want_freq[3]~18_combout\,
	cout => \want_freq[3]~19\);

-- Location: IOIBUF_X16_Y24_N8
\preset_ld[3]~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_preset_ld(3),
	o => \preset_ld[3]~input_o\);

-- Location: FF_X24_Y23_N7
\want_freq[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \want_freq[3]~18_combout\,
	asdata => \preset_ld[3]~input_o\,
	sload => \pre_ld~input_o\,
	ena => \want_freq[0]~13_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => want_freq(3));

-- Location: LCCOMB_X24_Y23_N8
\want_freq[4]~20\ : cycloneiii_lcell_comb
-- Equation(s):
-- \want_freq[4]~20_combout\ = ((\enc_dir~input_o\ $ (want_freq(4) $ (\want_freq[3]~19\)))) # (GND)
-- \want_freq[4]~21\ = CARRY((\enc_dir~input_o\ & (want_freq(4) & !\want_freq[3]~19\)) # (!\enc_dir~input_o\ & ((want_freq(4)) # (!\want_freq[3]~19\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011001001101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \enc_dir~input_o\,
	datab => want_freq(4),
	datad => VCC,
	cin => \want_freq[3]~19\,
	combout => \want_freq[4]~20_combout\,
	cout => \want_freq[4]~21\);

-- Location: IOIBUF_X34_Y20_N1
\preset_ld[4]~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_preset_ld(4),
	o => \preset_ld[4]~input_o\);

-- Location: FF_X24_Y23_N9
\want_freq[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \want_freq[4]~20_combout\,
	asdata => \preset_ld[4]~input_o\,
	sload => \pre_ld~input_o\,
	ena => \want_freq[0]~13_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => want_freq(4));

-- Location: LCCOMB_X24_Y23_N10
\want_freq[5]~22\ : cycloneiii_lcell_comb
-- Equation(s):
-- \want_freq[5]~22_combout\ = (want_freq(5) & ((\enc_dir~input_o\ & (!\want_freq[4]~21\)) # (!\enc_dir~input_o\ & (\want_freq[4]~21\ & VCC)))) # (!want_freq(5) & ((\enc_dir~input_o\ & ((\want_freq[4]~21\) # (GND))) # (!\enc_dir~input_o\ & 
-- (!\want_freq[4]~21\))))
-- \want_freq[5]~23\ = CARRY((want_freq(5) & (\enc_dir~input_o\ & !\want_freq[4]~21\)) # (!want_freq(5) & ((\enc_dir~input_o\) # (!\want_freq[4]~21\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100101001101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => want_freq(5),
	datab => \enc_dir~input_o\,
	datad => VCC,
	cin => \want_freq[4]~21\,
	combout => \want_freq[5]~22_combout\,
	cout => \want_freq[5]~23\);

-- Location: IOIBUF_X25_Y24_N8
\preset_ld[5]~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_preset_ld(5),
	o => \preset_ld[5]~input_o\);

-- Location: FF_X24_Y23_N11
\want_freq[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \want_freq[5]~22_combout\,
	asdata => \preset_ld[5]~input_o\,
	sload => \pre_ld~input_o\,
	ena => \want_freq[0]~13_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => want_freq(5));

-- Location: LCCOMB_X24_Y23_N12
\want_freq[6]~24\ : cycloneiii_lcell_comb
-- Equation(s):
-- \want_freq[6]~24_combout\ = ((want_freq(6) $ (\enc_dir~input_o\ $ (\want_freq[5]~23\)))) # (GND)
-- \want_freq[6]~25\ = CARRY((want_freq(6) & ((!\want_freq[5]~23\) # (!\enc_dir~input_o\))) # (!want_freq(6) & (!\enc_dir~input_o\ & !\want_freq[5]~23\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011000101011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => want_freq(6),
	datab => \enc_dir~input_o\,
	datad => VCC,
	cin => \want_freq[5]~23\,
	combout => \want_freq[6]~24_combout\,
	cout => \want_freq[6]~25\);

-- Location: IOIBUF_X28_Y24_N1
\preset_ld[6]~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_preset_ld(6),
	o => \preset_ld[6]~input_o\);

-- Location: FF_X24_Y23_N13
\want_freq[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \want_freq[6]~24_combout\,
	asdata => \preset_ld[6]~input_o\,
	sload => \pre_ld~input_o\,
	ena => \want_freq[0]~13_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => want_freq(6));

-- Location: LCCOMB_X24_Y23_N14
\want_freq[7]~26\ : cycloneiii_lcell_comb
-- Equation(s):
-- \want_freq[7]~26_combout\ = (\enc_dir~input_o\ & ((want_freq(7) & (!\want_freq[6]~25\)) # (!want_freq(7) & ((\want_freq[6]~25\) # (GND))))) # (!\enc_dir~input_o\ & ((want_freq(7) & (\want_freq[6]~25\ & VCC)) # (!want_freq(7) & (!\want_freq[6]~25\))))
-- \want_freq[7]~27\ = CARRY((\enc_dir~input_o\ & ((!\want_freq[6]~25\) # (!want_freq(7)))) # (!\enc_dir~input_o\ & (!want_freq(7) & !\want_freq[6]~25\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100100101011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \enc_dir~input_o\,
	datab => want_freq(7),
	datad => VCC,
	cin => \want_freq[6]~25\,
	combout => \want_freq[7]~26_combout\,
	cout => \want_freq[7]~27\);

-- Location: IOIBUF_X16_Y24_N1
\preset_ld[7]~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_preset_ld(7),
	o => \preset_ld[7]~input_o\);

-- Location: FF_X24_Y23_N15
\want_freq[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \want_freq[7]~26_combout\,
	asdata => \preset_ld[7]~input_o\,
	sload => \pre_ld~input_o\,
	ena => \want_freq[0]~13_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => want_freq(7));

-- Location: LCCOMB_X24_Y23_N16
\want_freq[8]~28\ : cycloneiii_lcell_comb
-- Equation(s):
-- \want_freq[8]~28_combout\ = ((\enc_dir~input_o\ $ (want_freq(8) $ (\want_freq[7]~27\)))) # (GND)
-- \want_freq[8]~29\ = CARRY((\enc_dir~input_o\ & (want_freq(8) & !\want_freq[7]~27\)) # (!\enc_dir~input_o\ & ((want_freq(8)) # (!\want_freq[7]~27\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001011001001101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \enc_dir~input_o\,
	datab => want_freq(8),
	datad => VCC,
	cin => \want_freq[7]~27\,
	combout => \want_freq[8]~28_combout\,
	cout => \want_freq[8]~29\);

-- Location: IOIBUF_X13_Y24_N22
\preset_ld[8]~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_preset_ld(8),
	o => \preset_ld[8]~input_o\);

-- Location: FF_X24_Y23_N17
\want_freq[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \want_freq[8]~28_combout\,
	asdata => \preset_ld[8]~input_o\,
	sload => \pre_ld~input_o\,
	ena => \want_freq[0]~13_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => want_freq(8));

-- Location: LCCOMB_X24_Y23_N18
\want_freq[9]~30\ : cycloneiii_lcell_comb
-- Equation(s):
-- \want_freq[9]~30_combout\ = (\enc_dir~input_o\ & ((want_freq(9) & (!\want_freq[8]~29\)) # (!want_freq(9) & ((\want_freq[8]~29\) # (GND))))) # (!\enc_dir~input_o\ & ((want_freq(9) & (\want_freq[8]~29\ & VCC)) # (!want_freq(9) & (!\want_freq[8]~29\))))
-- \want_freq[9]~31\ = CARRY((\enc_dir~input_o\ & ((!\want_freq[8]~29\) # (!want_freq(9)))) # (!\enc_dir~input_o\ & (!want_freq(9) & !\want_freq[8]~29\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100100101011",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \enc_dir~input_o\,
	datab => want_freq(9),
	datad => VCC,
	cin => \want_freq[8]~29\,
	combout => \want_freq[9]~30_combout\,
	cout => \want_freq[9]~31\);

-- Location: IOIBUF_X18_Y24_N15
\preset_ld[9]~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_preset_ld(9),
	o => \preset_ld[9]~input_o\);

-- Location: FF_X24_Y23_N19
\want_freq[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \want_freq[9]~30_combout\,
	asdata => \preset_ld[9]~input_o\,
	sload => \pre_ld~input_o\,
	ena => \want_freq[0]~13_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => want_freq(9));

-- Location: LCCOMB_X24_Y23_N20
\want_freq[10]~32\ : cycloneiii_lcell_comb
-- Equation(s):
-- \want_freq[10]~32_combout\ = \enc_dir~input_o\ $ (\want_freq[9]~31\ $ (want_freq(10)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100111100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \enc_dir~input_o\,
	datad => want_freq(10),
	cin => \want_freq[9]~31\,
	combout => \want_freq[10]~32_combout\);

-- Location: IOIBUF_X32_Y24_N8
\preset_ld[10]~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_preset_ld(10),
	o => \preset_ld[10]~input_o\);

-- Location: FF_X24_Y23_N21
\want_freq[10]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \want_freq[10]~32_combout\,
	asdata => \preset_ld[10]~input_o\,
	sload => \pre_ld~input_o\,
	ena => \want_freq[0]~13_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => want_freq(10));

-- Location: IOIBUF_X34_Y20_N8
\enc_ent~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_enc_ent,
	o => \enc_ent~input_o\);

-- Location: LCCOMB_X25_Y23_N26
\word[3]~10\ : cycloneiii_lcell_comb
-- Equation(s):
-- \word[3]~10_combout\ = (\enc_ent~input_o\ & (!want_freq(0))) # (!\enc_ent~input_o\ & ((\word[3]~reg0_q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => want_freq(0),
	datac => \word[3]~reg0_q\,
	datad => \enc_ent~input_o\,
	combout => \word[3]~10_combout\);

-- Location: FF_X25_Y23_N27
\word[3]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \word[3]~10_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \word[3]~reg0_q\);

-- Location: LCCOMB_X25_Y23_N0
\word[4]~12\ : cycloneiii_lcell_comb
-- Equation(s):
-- \word[4]~12_cout\ = CARRY(want_freq(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => want_freq(0),
	datad => VCC,
	cout => \word[4]~12_cout\);

-- Location: LCCOMB_X25_Y23_N2
\word[4]~13\ : cycloneiii_lcell_comb
-- Equation(s):
-- \word[4]~13_combout\ = (want_freq(1) & (\word[4]~12_cout\ & VCC)) # (!want_freq(1) & (!\word[4]~12_cout\))
-- \word[4]~14\ = CARRY((!want_freq(1) & !\word[4]~12_cout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100000101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => want_freq(1),
	datad => VCC,
	cin => \word[4]~12_cout\,
	combout => \word[4]~13_combout\,
	cout => \word[4]~14\);

-- Location: FF_X25_Y23_N3
\word[4]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \word[4]~13_combout\,
	ena => \enc_ent~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \word[4]~reg0_q\);

-- Location: LCCOMB_X25_Y23_N4
\word[5]~15\ : cycloneiii_lcell_comb
-- Equation(s):
-- \word[5]~15_combout\ = (want_freq(2) & (\word[4]~14\ $ (GND))) # (!want_freq(2) & (!\word[4]~14\ & VCC))
-- \word[5]~16\ = CARRY((want_freq(2) & !\word[4]~14\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => want_freq(2),
	datad => VCC,
	cin => \word[4]~14\,
	combout => \word[5]~15_combout\,
	cout => \word[5]~16\);

-- Location: FF_X25_Y23_N5
\word[5]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \word[5]~15_combout\,
	ena => \enc_ent~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \word[5]~reg0_q\);

-- Location: LCCOMB_X25_Y23_N6
\word[6]~17\ : cycloneiii_lcell_comb
-- Equation(s):
-- \word[6]~17_combout\ = (want_freq(3) & (!\word[5]~16\)) # (!want_freq(3) & ((\word[5]~16\) # (GND)))
-- \word[6]~18\ = CARRY((!\word[5]~16\) # (!want_freq(3)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => want_freq(3),
	datad => VCC,
	cin => \word[5]~16\,
	combout => \word[6]~17_combout\,
	cout => \word[6]~18\);

-- Location: FF_X25_Y23_N7
\word[6]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \word[6]~17_combout\,
	ena => \enc_ent~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \word[6]~reg0_q\);

-- Location: LCCOMB_X25_Y23_N8
\word[7]~19\ : cycloneiii_lcell_comb
-- Equation(s):
-- \word[7]~19_combout\ = (want_freq(4) & (\word[6]~18\ $ (GND))) # (!want_freq(4) & (!\word[6]~18\ & VCC))
-- \word[7]~20\ = CARRY((want_freq(4) & !\word[6]~18\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => want_freq(4),
	datad => VCC,
	cin => \word[6]~18\,
	combout => \word[7]~19_combout\,
	cout => \word[7]~20\);

-- Location: FF_X25_Y23_N9
\word[7]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \word[7]~19_combout\,
	ena => \enc_ent~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \word[7]~reg0_q\);

-- Location: LCCOMB_X25_Y23_N10
\word[8]~21\ : cycloneiii_lcell_comb
-- Equation(s):
-- \word[8]~21_combout\ = (want_freq(5) & (!\word[7]~20\)) # (!want_freq(5) & ((\word[7]~20\) # (GND)))
-- \word[8]~22\ = CARRY((!\word[7]~20\) # (!want_freq(5)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => want_freq(5),
	datad => VCC,
	cin => \word[7]~20\,
	combout => \word[8]~21_combout\,
	cout => \word[8]~22\);

-- Location: FF_X25_Y23_N11
\word[8]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \word[8]~21_combout\,
	ena => \enc_ent~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \word[8]~reg0_q\);

-- Location: LCCOMB_X25_Y23_N12
\word[9]~23\ : cycloneiii_lcell_comb
-- Equation(s):
-- \word[9]~23_combout\ = (want_freq(6) & (\word[8]~22\ $ (GND))) # (!want_freq(6) & (!\word[8]~22\ & VCC))
-- \word[9]~24\ = CARRY((want_freq(6) & !\word[8]~22\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => want_freq(6),
	datad => VCC,
	cin => \word[8]~22\,
	combout => \word[9]~23_combout\,
	cout => \word[9]~24\);

-- Location: FF_X25_Y23_N13
\word[9]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \word[9]~23_combout\,
	ena => \enc_ent~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \word[9]~reg0_q\);

-- Location: LCCOMB_X25_Y23_N14
\word[10]~25\ : cycloneiii_lcell_comb
-- Equation(s):
-- \word[10]~25_combout\ = (want_freq(7) & (!\word[9]~24\)) # (!want_freq(7) & ((\word[9]~24\) # (GND)))
-- \word[10]~26\ = CARRY((!\word[9]~24\) # (!want_freq(7)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => want_freq(7),
	datad => VCC,
	cin => \word[9]~24\,
	combout => \word[10]~25_combout\,
	cout => \word[10]~26\);

-- Location: FF_X25_Y23_N15
\word[10]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \word[10]~25_combout\,
	ena => \enc_ent~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \word[10]~reg0_q\);

-- Location: LCCOMB_X25_Y23_N16
\word[11]~27\ : cycloneiii_lcell_comb
-- Equation(s):
-- \word[11]~27_combout\ = (want_freq(8) & (\word[10]~26\ $ (GND))) # (!want_freq(8) & (!\word[10]~26\ & VCC))
-- \word[11]~28\ = CARRY((want_freq(8) & !\word[10]~26\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => want_freq(8),
	datad => VCC,
	cin => \word[10]~26\,
	combout => \word[11]~27_combout\,
	cout => \word[11]~28\);

-- Location: FF_X25_Y23_N17
\word[11]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \word[11]~27_combout\,
	ena => \enc_ent~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \word[11]~reg0_q\);

-- Location: LCCOMB_X25_Y23_N18
\word[12]~29\ : cycloneiii_lcell_comb
-- Equation(s):
-- \word[12]~29_combout\ = (want_freq(9) & (!\word[11]~28\)) # (!want_freq(9) & ((\word[11]~28\) # (GND)))
-- \word[12]~30\ = CARRY((!\word[11]~28\) # (!want_freq(9)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => want_freq(9),
	datad => VCC,
	cin => \word[11]~28\,
	combout => \word[12]~29_combout\,
	cout => \word[12]~30\);

-- Location: FF_X25_Y23_N19
\word[12]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \word[12]~29_combout\,
	ena => \enc_ent~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \word[12]~reg0_q\);

-- Location: LCCOMB_X25_Y23_N20
\word[13]~31\ : cycloneiii_lcell_comb
-- Equation(s):
-- \word[13]~31_combout\ = \word[12]~30\ $ (!want_freq(10))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datad => want_freq(10),
	cin => \word[12]~30\,
	combout => \word[13]~31_combout\);

-- Location: FF_X25_Y23_N21
\word[13]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \word[13]~31_combout\,
	ena => \enc_ent~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \word[13]~reg0_q\);

-- Location: IOIBUF_X0_Y11_N15
\rst~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_rst,
	o => \rst~input_o\);

-- Location: IOIBUF_X0_Y11_N22
\menu~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_menu,
	o => \menu~input_o\);

ww_disp_freq(0) <= \disp_freq[0]~output_o\;

ww_disp_freq(1) <= \disp_freq[1]~output_o\;

ww_disp_freq(2) <= \disp_freq[2]~output_o\;

ww_disp_freq(3) <= \disp_freq[3]~output_o\;

ww_disp_freq(4) <= \disp_freq[4]~output_o\;

ww_disp_freq(5) <= \disp_freq[5]~output_o\;

ww_disp_freq(6) <= \disp_freq[6]~output_o\;

ww_disp_freq(7) <= \disp_freq[7]~output_o\;

ww_disp_freq(8) <= \disp_freq[8]~output_o\;

ww_disp_freq(9) <= \disp_freq[9]~output_o\;

ww_disp_freq(10) <= \disp_freq[10]~output_o\;

ww_word(0) <= \word[0]~output_o\;

ww_word(1) <= \word[1]~output_o\;

ww_word(2) <= \word[2]~output_o\;

ww_word(3) <= \word[3]~output_o\;

ww_word(4) <= \word[4]~output_o\;

ww_word(5) <= \word[5]~output_o\;

ww_word(6) <= \word[6]~output_o\;

ww_word(7) <= \word[7]~output_o\;

ww_word(8) <= \word[8]~output_o\;

ww_word(9) <= \word[9]~output_o\;

ww_word(10) <= \word[10]~output_o\;

ww_word(11) <= \word[11]~output_o\;

ww_word(12) <= \word[12]~output_o\;

ww_word(13) <= \word[13]~output_o\;
END structure;


