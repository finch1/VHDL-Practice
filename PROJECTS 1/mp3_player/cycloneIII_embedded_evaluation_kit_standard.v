//Legal Notice: (C)2007 Altera Corporation. All rights reserved.  Your
//use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cycloneIII_embedded_evaluation_kit_standard (
                                                     // inputs:
                                                      HC_ADC_DOUT,
                                                      HC_ADC_PENIRQ_N,
                                                      HC_RX_CLK,
                                                      HC_RX_COL,
                                                      HC_RX_CRS,
                                                      HC_RX_D,
                                                      HC_RX_DV,
                                                      HC_RX_ERR,
                                                      HC_SD_DAT,
                                                      HC_TX_CLK,
                                                      button,
                                                      osc_clk,
                                                      reset_n,

                                                     // outputs:
                                                      HC_ADC_CS_N,
                                                      HC_ADC_DCLK,
                                                      HC_ADC_DIN,
                                                      HC_DEN,
//                                                      HC_ETH_RESET_N,
                                                      HC_HD,
                                                      HC_ID_I2CDAT,
                                                      HC_ID_I2CSCL,
                                                      HC_LCD_DATA,
                                                      HC_MDC,
                                                      HC_MDIO,
                                                      HC_SCEN,
                                                      HC_SDA,
                                                      HC_SD_CLK,
                                                      HC_SD_CMD,
                                                      HC_SD_DAT3,
                                                      HC_TX_D,
                                                      HC_TX_EN,
                                                      HC_VD,
                                                      cpu_clk,
                                                      flash_cs_n,
                                                      flash_oe_n,
                                                      flash_reset_n,
                                                      flash_ssram_a,
                                                      flash_ssram_d,
                                                      flash_wr_n,
                                                      led,
                                                      mem_addr,
                                                      mem_ba,
                                                      mem_cas_n,
                                                      mem_cke,
                                                      mem_clk,
                                                      mem_clk_n,
                                                      mem_cs_n,
                                                      mem_dm,
                                                      mem_dq,
                                                      mem_dqs,
                                                      mem_ras_n,
                                                      mem_we_n,
                                                      ssram_adsc_n,
                                                      ssram_bw_n,
                                                      ssram_bwe_n,
                                                      ssram_ce_n,
                                                      ssram_clk,
                                                      ssram_oe_n,

									                                    HC_AUD_ADCDAT ,
									                                    HC_AUD_ADCLRCK ,
									                                    HC_AUD_BCLK ,
									                                    HC_AUD_DACDAT ,
									                                    HC_AUD_DACLRCK ,
									                                    HC_I2C_SCLK ,
									                                    HC_I2C_SDAT ,
									                                    HC_AUD_XCK
                                                   )
;

  output           HC_ADC_CS_N;
  output           HC_ADC_DCLK;
  output           HC_ADC_DIN;
  output           HC_DEN;
//  output           HC_ETH_RESET_N;
  output           HC_HD;
  inout            HC_ID_I2CDAT;
  output           HC_ID_I2CSCL;
  output  [  7: 0] HC_LCD_DATA;
  output           HC_MDC;
  inout            HC_MDIO;
  output           HC_SCEN;
  inout            HC_SDA;
  output           HC_SD_CLK;
  output           HC_SD_CMD;
  output           HC_SD_DAT3;
  output  [  3: 0] HC_TX_D;
  output           HC_TX_EN;
  output           HC_VD;
  output           cpu_clk;
  output           flash_cs_n;
  output           flash_oe_n;
  output           flash_reset_n;
  output  [ 23: 0] flash_ssram_a;
  inout   [ 31: 0] flash_ssram_d;
  output           flash_wr_n;
  output  [  1: 0] led;
  output  [ 12: 0] mem_addr;
  output  [  1: 0] mem_ba;
  output           mem_cas_n;
  output           mem_cke;
  inout            mem_clk;
  inout            mem_clk_n;
  output           mem_cs_n;
  output  [  1: 0] mem_dm;
  inout   [ 15: 0] mem_dq;
  inout   [  1: 0] mem_dqs;
  output           mem_ras_n;
  output           mem_we_n;
  output           ssram_adsc_n;
  output  [  3: 0] ssram_bw_n;
  output           ssram_bwe_n;
  output           ssram_ce_n;
  output           ssram_clk;
  output           ssram_oe_n;
  input            HC_ADC_DOUT;
  input            HC_ADC_PENIRQ_N;
  input            HC_RX_CLK;
  input            HC_RX_COL;
  input            HC_RX_CRS;
  input   [  3: 0] HC_RX_D;
  input            HC_RX_DV;
  input            HC_RX_ERR;
  input            HC_SD_DAT;
  input            HC_TX_CLK;
  input   [  3: 0] button;
  input            osc_clk;
  input            reset_n;

	input            HC_AUD_ADCDAT;
  output           HC_AUD_ADCLRCK;
  output           HC_AUD_BCLK;
  output           HC_AUD_DACDAT;
  output           HC_AUD_DACLRCK;
  output           HC_I2C_SCLK;
  inout            HC_I2C_SDAT;
  output           HC_AUD_XCK;

//  wire             CDn_to_the_el_camino_sd_card_controller;
  wire             HC_ADC_CS_N;
  wire             HC_ADC_DCLK;
  wire             HC_ADC_DIN;
  wire             HC_DEN;
//  wire             HC_ETH_RESET_N;
  wire             HC_HD;
  wire             HC_ID_I2CDAT;
  wire             HC_ID_I2CSCL;
  wire    [  7: 0] HC_LCD_DATA;
  wire             HC_MDC;
  wire             HC_MDIO;
  wire             HC_SCEN;
  wire             HC_SDA;
  wire             HC_SD_CLK;
  wire             HC_SD_CMD;
  wire             HC_SD_DAT3;
  wire    [  3: 0] HC_TX_D;
  wire             HC_TX_EN;
  wire             HC_VD;
  wire             SCLK_from_the_touch_panel_spi;
  wire             SS_n_from_the_touch_panel_spi;
//  wire             WP_to_the_el_camino_sd_card_controller;
  wire             cpu_clk;
  wire             ddr_sdram_phy_clk_out;
//  wire             ena_10_from_the_tse_mac;
//  wire             eth_mode_from_the_tse_mac;
  wire             flash_cs_n;
  wire             flash_oe_n;
  wire             flash_reset_n;
  wire    [ 23: 0] flash_ssram_a;
  wire    [ 31: 0] flash_ssram_d;
  wire             flash_wr_n;
//  wire    [  7: 0] gm_rx_d_to_the_tse_mac;
//  wire             gm_rx_dv_to_the_tse_mac;
//  wire             gm_rx_err_to_the_tse_mac;
//  wire    [  7: 0] gm_tx_d_from_the_tse_mac;
//  wire             gm_tx_en_from_the_tse_mac;
//  wire             gm_tx_err_from_the_tse_mac;
  wire    [  1: 0] led;
  wire             local_init_done_from_the_ddr_sdram;
  wire             local_refresh_ack_from_the_ddr_sdram;
  wire             local_wdata_req_from_the_ddr_sdram;
//  wire             m_rx_col_to_the_tse_mac;
//  wire             m_rx_crs_to_the_tse_mac;
//  wire    [  3: 0] m_rx_d_to_the_tse_mac;
//  wire             m_rx_en_to_the_tse_mac;
//  wire             m_rx_err_to_the_tse_mac;
//  wire    [  3: 0] m_tx_d_from_the_tse_mac;
//  wire             m_tx_en_from_the_tse_mac;
//  wire             m_tx_err_from_the_tse_mac;
//  wire             mdc_from_the_tse_mac;
//  wire             mdio_in;
//  wire             mdio_in_to_the_tse_mac;
//  wire             mdio_oen;
//  wire             mdio_oen_from_the_tse_mac;
//  wire             mdio_out;
//  wire             mdio_out_from_the_tse_mac;
  wire    [ 12: 0] mem_addr;
  wire    [  1: 0] mem_ba;
  wire             mem_cas_n;
  wire             mem_cke;
  wire             mem_clk;
  wire             mem_clk_n;
  wire             mem_cs_n;
  wire    [  1: 0] mem_dm;
  wire    [ 15: 0] mem_dq;
  wire    [  1: 0] mem_dqs;
  wire             mem_ras_n;
  wire             mem_we_n;
  wire             out_port_from_the_lcd_i2c_en;
  wire             out_port_from_the_lcd_i2c_scl;
  wire             peripheral_clk;
  wire             remote_update_clk;
  wire             reset_phy_clk_n_from_the_ddr_sdram;
//  wire             rx_clk_to_the_tse_mac;
//  wire             set_1000_to_the_tse_mac;
//  wire             set_10_to_the_tse_mac;
  wire             ssram_adsc_n;
  wire    [  3: 0] ssram_bw_n;
  wire             ssram_bwe_n;
  wire             ssram_ce_n;
  wire             ssram_clk;
  wire             ssram_oe_n;
//  wire             tx_clk_to_the_tse_mac;
  cycloneIII_embedded_evaluation_kit_standard_sopc cycloneIII_embedded_evaluation_kit_standard_sopc_instance
    (
//      .CDn_to_the_el_camino_sd_card_controller (CDn_to_the_el_camino_sd_card_controller),

//      .DI_from_the_el_camino_sd_card_controller (HC_SD_CMD),
//      .DO_to_the_el_camino_sd_card_controller (HC_SD_DAT),
//      .CSn_from_the_el_camino_sd_card_controller (HC_SD_DAT3),
//      .SCLK_from_the_el_camino_sd_card_controller (HC_SD_CLK),
//      .WP_to_the_el_camino_sd_card_controller (WP_to_the_el_camino_sd_card_controller),
      .spi_data_out_from_the_sd_card_controller (HC_SD_CMD),
      .spi_data_in_to_the_sd_card_controller (HC_SD_DAT),
      .spi_cs_n_from_the_sd_card_controller (HC_SD_DAT3),
      .spi_clk_from_the_sd_card_controller (HC_SD_CLK),

//      .HD_from_the_lcd_sync_generator (HC_HD),
//      .RGB_OUT_from_the_lcd_sync_generator (HC_LCD_DATA),
//      .VD_from_the_lcd_sync_generator (HC_VD),
//      .DEN_from_the_lcd_sync_generator (HC_DEN),
      .HD_from_the_lcd_controller (HC_HD),
      .RGB_from_the_lcd_controller (HC_LCD_DATA),
      .VD_from_the_lcd_controller (HC_VD),
      .DEN_from_the_lcd_controller (HC_DEN),
      .lcd_clk_in_to_the_lcd_controller (cpu_clk),

//      .out_port_from_the_lcd_i2c_en (out_port_from_the_lcd_i2c_en),
//      .out_port_from_the_lcd_i2c_scl (out_port_from_the_lcd_i2c_scl),
//      .bidir_port_to_and_from_the_lcd_i2c_sdat (HC_SDA),
      .SERIAL_SCEN_from_the_lcd_controller (out_port_from_the_lcd_i2c_en),
      .SERIAL_SCL_from_the_lcd_controller (out_port_from_the_lcd_i2c_scl),
      .SERIAL_SDA_to_and_from_the_lcd_controller (HC_SDA),

			.adcdat_to_the_audio_controller ( HC_AUD_ADCDAT ),
			.adclrck_from_the_audio_controller ( HC_AUD_ADCLRCK ),
			.bclk_from_the_audio_controller ( HC_AUD_BCLK ),
			.dacdat_from_the_audio_controller ( HC_AUD_DACDAT ),
			.daclrck_from_the_audio_controller ( HC_AUD_DACLRCK ),
			.xck_from_the_audio_controller ( HC_AUD_XCK ),

			.scl_pad_io_from_the_i2c_master ( HC_I2C_SCLK ),
			.sda_pad_io_to_and_from_the_i2c_master ( HC_I2C_SDAT ),

      .MISO_to_the_touch_panel_spi (HC_ADC_DOUT),
      .MOSI_from_the_touch_panel_spi (HC_ADC_DIN),
      .SCLK_from_the_touch_panel_spi (SCLK_from_the_touch_panel_spi),
      .SS_n_from_the_touch_panel_spi (SS_n_from_the_touch_panel_spi),
      .adsc_n_to_the_ssram (ssram_adsc_n),
      .bidir_port_to_and_from_the_pio_id_eeprom_dat (HC_ID_I2CDAT),
      .bw_n_to_the_ssram (ssram_bw_n),
      .bwe_n_to_the_ssram (ssram_bwe_n),
      .chipenable1_n_to_the_ssram (ssram_ce_n),
      .cpu_clk (cpu_clk),
      .ddr_sdram_phy_clk_out (ddr_sdram_phy_clk_out),
//      .ena_10_from_the_tse_mac (ena_10_from_the_tse_mac),
//      .eth_mode_from_the_tse_mac (eth_mode_from_the_tse_mac),
      .flash_ssram_tristate_bridge_address (flash_ssram_a),
      .flash_ssram_tristate_bridge_data (flash_ssram_d),
      .global_reset_n_to_the_ddr_sdram (reset_n),
//      .gm_rx_d_to_the_tse_mac (gm_rx_d_to_the_tse_mac),
//      .gm_rx_dv_to_the_tse_mac (gm_rx_dv_to_the_tse_mac),
//      .gm_rx_err_to_the_tse_mac (gm_rx_err_to_the_tse_mac),
//      .gm_tx_d_from_the_tse_mac (gm_tx_d_from_the_tse_mac),
//      .gm_tx_en_from_the_tse_mac (gm_tx_en_from_the_tse_mac),
//      .gm_tx_err_from_the_tse_mac (gm_tx_err_from_the_tse_mac),
      .in_port_to_the_button_pio (button),
      .in_port_to_the_touch_panel_pen_irq_n (HC_ADC_PENIRQ_N),
      .local_init_done_from_the_ddr_sdram (local_init_done_from_the_ddr_sdram),
      .local_refresh_ack_from_the_ddr_sdram (local_refresh_ack_from_the_ddr_sdram),
      .local_wdata_req_from_the_ddr_sdram (local_wdata_req_from_the_ddr_sdram),
//      .m_rx_col_to_the_tse_mac (m_rx_col_to_the_tse_mac),
//      .m_rx_crs_to_the_tse_mac (m_rx_crs_to_the_tse_mac),
//      .m_rx_d_to_the_tse_mac (m_rx_d_to_the_tse_mac),
//      .m_rx_en_to_the_tse_mac (m_rx_en_to_the_tse_mac),
//      .m_rx_err_to_the_tse_mac (m_rx_err_to_the_tse_mac),
//      .m_tx_d_from_the_tse_mac (m_tx_d_from_the_tse_mac),
//      .m_tx_en_from_the_tse_mac (m_tx_en_from_the_tse_mac),
//      .m_tx_err_from_the_tse_mac (m_tx_err_from_the_tse_mac),
//      .mdc_from_the_tse_mac (mdc_from_the_tse_mac),
//      .mdio_in_to_the_tse_mac (mdio_in_to_the_tse_mac),
//      .mdio_oen_from_the_tse_mac (mdio_oen_from_the_tse_mac),
//      .mdio_out_from_the_tse_mac (mdio_out_from_the_tse_mac),
      .mem_addr_from_the_ddr_sdram (mem_addr),
      .mem_ba_from_the_ddr_sdram (mem_ba),
      .mem_cas_n_from_the_ddr_sdram (mem_cas_n),
      .mem_cke_from_the_ddr_sdram (mem_cke),
      .mem_clk_n_to_and_from_the_ddr_sdram (mem_clk_n),
      .mem_clk_to_and_from_the_ddr_sdram (mem_clk),
      .mem_cs_n_from_the_ddr_sdram (mem_cs_n),
      .mem_dm_from_the_ddr_sdram (mem_dm),
      .mem_dq_to_and_from_the_ddr_sdram (mem_dq),
      .mem_dqs_to_and_from_the_ddr_sdram (mem_dqs),
      .mem_ras_n_from_the_ddr_sdram (mem_ras_n),
      .mem_we_n_from_the_ddr_sdram (mem_we_n),
      .osc_clk (osc_clk),

      .out_port_from_the_led_pio (led),
      .out_port_from_the_pio_id_eeprom_scl (HC_ID_I2CSCL),
      .outputenable_n_to_the_ssram (ssram_oe_n),
      .peripheral_clk (peripheral_clk),
      .read_n_to_the_ext_flash (flash_oe_n),
      .remote_update_clk (remote_update_clk),
      .reset_n (reset_n),
      .reset_phy_clk_n_from_the_ddr_sdram (reset_phy_clk_n_from_the_ddr_sdram),
//      .rx_clk_to_the_tse_mac (rx_clk_to_the_tse_mac),
      .select_n_to_the_ext_flash (flash_cs_n),
//      .set_1000_to_the_tse_mac (set_1000_to_the_tse_mac),
//      .set_10_to_the_tse_mac (set_10_to_the_tse_mac),
      .ssram_clk (ssram_clk),
//      .tx_clk_to_the_tse_mac (tx_clk_to_the_tse_mac),
      .write_n_to_the_ext_flash (flash_wr_n)
    );


  assign HC_SCEN = out_port_from_the_lcd_i2c_en;
  assign HC_ADC_CS_N = SS_n_from_the_touch_panel_spi;
  assign flash_reset_n = reset_n;
//  assign CDn_to_the_el_camino_sd_card_controller = 1'b0;
//  assign WP_to_the_el_camino_sd_card_controller = 1'b0;
  assign HC_ADC_DCLK = ~SS_n_from_the_touch_panel_spi ? SCLK_from_the_touch_panel_spi: (~out_port_from_the_lcd_i2c_en ? out_port_from_the_lcd_i2c_scl: 0);
//  gmii_mii_mux gmii_mii_mux_instance
//    (
//      .eth_mode (1'b0),
//      .mdio (HC_MDIO),
//      .mdio_in (mdio_in),
//      .mdio_oen (mdio_oen),
//      .mdio_out (mdio_out)
//    );


//  assign m_rx_col_to_the_tse_mac = HC_RX_COL;
//  assign m_rx_crs_to_the_tse_mac = HC_RX_CRS;
//  assign m_rx_d_to_the_tse_mac = HC_RX_D;
//  assign m_rx_en_to_the_tse_mac = HC_RX_DV;
//  assign m_rx_err_to_the_tse_mac = HC_RX_ERR;
//  assign mdio_in_to_the_tse_mac = mdio_in;
//  assign rx_clk_to_the_tse_mac = HC_RX_CLK;
//  assign set_1000_to_the_tse_mac = 1'b0;
//  assign set_10_to_the_tse_mac = 1'b0;
//  assign tx_clk_to_the_tse_mac = HC_TX_CLK;
//  assign HC_TX_D = m_tx_d_from_the_tse_mac;
//  assign HC_TX_EN = m_tx_en_from_the_tse_mac;
//  assign HC_MDC = mdc_from_the_tse_mac;
//  assign mdio_oen = mdio_oen_from_the_tse_mac;
//  assign mdio_out = mdio_out_from_the_tse_mac;
//  assign HC_ETH_RESET_N = 1'b1;

endmodule

