// --------------------------------------------------------------------
// Copyright (c) 2007 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altrea Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL or Verilog source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions: HMB systhesizer 
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver   :| Author            :| Mod. Date :| Changes Made:
//   V1.0  :| Johnny Fan        :| 07/06/11  :|      Initial Revision
// --------------------------------------------------------------------
module MTDB_Synthesizer
 	(
		////////////////////	Clock Input	 	////////////////////
		CLK50,
		CLK50_2,									//	50 MHz       
		////////////////////	DDR Memory		////////////////////
		DDR_A,                         
		//DDR_DQ,                           
		DDR_BA0,         
		DDR_BA1,         
		DDR_CKE,         
		DDR_RAS_N,       
		DDR_WE_N,        
		DDR_CAS_N,       
		DDR_CLK_N,      
		DDR_CLK_P,       
		DDR_CS_N,        
		DDR_DM0,         
		DDR_DM1,         
		DDR_DQS0,        
		DDR_DQS1,     
		/*   
		////////////////  Flash and SRAM Share Bus  /////////////////		
		FLASH_SRAM_A,               
		FLASH_SRAM_DQ,            
		*/
		////////////////////	Flash Memory		////////////////
		FLASH_CLK,       
		FLASH_ADV_N,     
		FLASH_CE_N,      
		FLASH_OE_N,      
		FLASH_RESET_N,   
		FLASH_WAIT,      
		FLASH_WE_N,
		////////////////////	SRAM Memory		////////////////////
		SRAM_ADSC_N,     
		SRAM_CE1_N,      
		SRAM_CLK,        
		SRAM_OE_N,       
		SRAM_WE_N,                      
		SRAM_BE_N,    
		////////////////////	Push Button		////////////////////
		BUTTON, 
		//////////////////////		LED			////////////////////
		LED, 
		/////////////////// 	JTAG UART Chain	 ///////////////////
		LINK_D0,         
		LINK_D1,         
		LINK_D2, 
        
		////////////// 	HSMC  Connector Interface  //////////////////////        
		//VGA
		HC_VGA_DATA,
		HC_VGA_CLOCK,
		HC_VGA_VS,
		HC_VGA_HS,
		HC_VGA_BLANK,
		HC_VGA_SYNC,
		//TV Decoder
		HC_TD_D,
		HC_TD_HS,
		HC_TD_VS,
		HC_TD_27MHZ,
		HC_TD_RESET,
		//Audio CODEC
		HC_AUD_ADCLRCK,					
		HC_AUD_ADCDAT,					
		HC_AUD_DACLRCK,					
		HC_AUD_DACDAT,					
		HC_AUD_BCLK,					
		HC_AUD_XCK,						
		//UART
		HC_UART_TXD,						
		HC_UART_RXD,						
		//SD_Card Interface
		HC_SD_DAT,							
		HC_SD_DAT3,						
		HC_SD_CMD,							
		HC_SD_CLK,							
		//I2C
		HC_I2C_SDAT,						
		HC_I2C_SCLK,
        //ID_I2C
		HC_ID_I2CSCL,
		HC_ID_I2CDAT,
		//PS2
		HC_PS2_DAT, 								
        HC_PS2_CLK,
        //Ethernet Interface
		HC_TXD,	
        HC_RXD,	
        HC_TX_CLK,
        HC_RX_CLK,
        HC_TX_EN,	
        HC_RX_DV,	
        HC_RX_CRS,
        HC_RX_ERR,
        HC_RX_COL, 
        HC_MDIO,   
        HC_MDC,    
        HC_ETH_RESET_N,
		//LCD Touch Panel Interface
		HC_LCD_DATA,
		HC_NCLK,	
        HC_DEN,	
        HC_HD,		
        HC_VD,		
        HC_GREST,	
        HC_SCEN,	
        HC_SDA,	
        HC_ADC_PENIRQ_N,	
        HC_ADC_DOUT,	
        HC_ADC_BUSY,	
        HC_ADC_DIN,	
        HC_ADC_DCLK,	
        HC_ADC_CS_N,

				);
//===========================================================================
// PORT declarations
//===========================================================================				
				
////////////////////	Clock Input	 	////////////////////
input			CLK50;
input			CLK50_2;
////////////////////	DDR Memory		////////////////////
output	[12:0]	DDR_A;
//inout 	[15:0]	DDR_DQ;                         
output			DDR_BA0;         
output			DDR_BA1;         
output			DDR_CKE;         
output			DDR_RAS_N;       
output			DDR_WE_N;        
output			DDR_CAS_N;       
output			DDR_CLK_N;      
output			DDR_CLK_P;       
output			DDR_CS_N;        
output			DDR_DM0;         
output			DDR_DM1;         
inout			DDR_DQS0;        
inout			DDR_DQS1;  
/*      
////////////////  Flash and SRAM Share Bus  /////////////////
output	[25:1]	FLASH_SRAM_A;               
inout	[31:0]	FLASH_SRAM_DQ;       
*/     
////////////////////	Flash Memory		////////////////
output			FLASH_CLK;       
output			FLASH_ADV_N;     
output			FLASH_CE_N;      
output			FLASH_OE_N;      
output			FLASH_RESET_N;   
input			FLASH_WAIT;      
output			FLASH_WE_N;      
////////////////////	SRAM Memory		////////////////////
output			SRAM_ADSC_N;     
output			SRAM_CE1_N;      
output			SRAM_CLK;        
output			SRAM_OE_N;       
output			SRAM_WE_N;                      
output			SRAM_BE_N;    
////////////////////	Push Button		////////////////////
input	[4:1]	BUTTON;      
//////////////////////		LED			////////////////////
output	[4:1]	LED;       
/////////////////// 	JTAG UART Chain	 ///////////////////
input			LINK_D0;         
input			LINK_D1;         
input			LINK_D2;                        
////////////// 	HSMC  Connector Interface  //////////////////////
//VGA
output	[9:0]   HC_VGA_DATA;
output			HC_VGA_CLOCK;		
output			HC_VGA_HS;			
output			HC_VGA_VS;			
output			HC_VGA_BLANK;	    
output			HC_VGA_SYNC;		
//TV Decoder
input	[7:0]	HC_TD_D;			  
input			HC_TD_HS;
input			HC_TD_VS;
input			HC_TD_27MHZ;
output			HC_TD_RESET;
//Audio CODEC
output			HC_AUD_ADCLRCK;				
input			HC_AUD_ADCDAT;				
output			HC_AUD_DACLRCK;				
output			HC_AUD_DACDAT;				
output			HC_AUD_BCLK;				
output			HC_AUD_XCK;					
//UART
output			HC_UART_TXD;				
input			HC_UART_RXD;				
//SD_Card Interface
inout			HC_SD_DAT;					
inout			HC_SD_DAT3;					
inout			HC_SD_CMD;					
output			HC_SD_CLK;					
//I2C
inout			HC_I2C_SDAT;				
output			HC_I2C_SCLK;
//ID_I2C
output			HC_ID_I2CSCL;
inout			HC_ID_I2CDAT;
//PS2
inout			HC_PS2_DAT; 				
inout			HC_PS2_CLK;
//Ethernet Interface
output	[3:0]	HC_TXD;	
input	[3:0]	HC_RXD;	
input			HC_TX_CLK;
input			HC_RX_CLK;
input			HC_TX_EN;	
input			HC_RX_DV;	
input			HC_RX_CRS;
input			HC_RX_ERR;
input			HC_RX_COL; 
inout			HC_MDIO;   
output			HC_MDC;    
output			HC_ETH_RESET_N;
//LCD Touch Panel Interface
output	[7:0]	HC_LCD_DATA;
output			HC_NCLK;	
output			HC_DEN;	
output			HC_HD;		
output			HC_VD;		
output			HC_GREST;	
output			HC_SCEN;	
inout			HC_SDA;	
input			HC_ADC_PENIRQ_N;		
input			HC_ADC_DOUT;	
input			HC_ADC_BUSY;	
output			HC_ADC_DIN;	
output			HC_ADC_DCLK;	
output			HC_ADC_CS_N;
					
//=============================================================================
// REG/WIRE declarations
//=============================================================================
wire 		SN_VGA_HS;
wire 		SN_VGA_VS;
wire 		SN_VGA_CLK;
wire [9:0]	SN_VGA_R;
wire [9:0]	SN_VGA_G;
wire [9:0]	SN_VGA_B;
wire 		CLK25;
wire 		VGA_HS;   
wire 		VGA_VS;   
wire 		VGA_SYNC; 
wire 		VGA_BLANK;
wire [9:0]	VGA_R;
wire [9:0]	VGA_G;   
wire [9:0]	VGA_B; 
wire		HC_VGA_CLOCK;
reg [7:0]	delay_1;
//=============================================================================
// Structural coding
//=============================================================================
assign  HC_GREST        = 1'b1;


synthesizer  u1(
	.CLOCK_50(CLK50),					
	.BUTTON( BUTTON[4:1]   ),			//	Button[4:1]
	.LED(LED),							//	LED [4:1]

	.PS2_DAT(HC_PS2_DAT),				//	PS2 Data
	.PS2_CLK(HC_PS2_CLK ),				//	PS2 Clock
            
	.VGA_CLK  (SN_VGA_CLK  ),   		//	VGA Clock
	.VGA_HS   (SN_VGA_HS   ),			//	VGA H_SYNC
	.VGA_VS   (SN_VGA_VS   ),			//	VGA V_SYNC
	.VGA_BLANK(SN_VGA_BLANK),			//	VGA BLANK
	.VGA_SYNC (SN_VGA_SYNC ),			//	VGA SYNC
	.VGA_R(SN_VGA_R),   				//	VGA Red[9:0]
	.VGA_G(SN_VGA_G),	 				//	VGA Green[9:0]
	.VGA_B(SN_VGA_B),   				//	VGA Blue[9:0]
    .HC_VGA_CLOCK(HC_VGA_CLOCK),
      
	.AUD_ADCLRCK(HC_AUD_ADCLRCK),		//	Audio CODEC ADC LR Clock
	.AUD_DACLRCK(HC_AUD_DACLRCK),		//	Audio CODEC DAC LR Clock
	.AUD_ADCDAT (HC_AUD_ADCDAT ),		//	Audio CODEC ADC Data
	.AUD_DACDAT (HC_AUD_DACDAT ),		//	Audio CODEC DAC Data
	.AUD_BCLK   (HC_AUD_BCLK   ),		//	Audio CODEC Bit-Stream Clock
	.AUD_XCK    (HC_AUD_XCK    ),		//	Audio CODEC Chip Clock
     
	);


VGA_DATA_ENCODE	u2  ( // input
				.iCLK(SN_VGA_CLK),
				.Muti_CLK(HC_VGA_CLOCK),
				.iVGA_R(SN_VGA_R),
				.iVGA_G(SN_VGA_G),			
				.iVGA_B(SN_VGA_B),
				.iRST_N(BUTTON[1]),
				.iVGA_HS(SN_VGA_HS),		
				.iVGA_VS(SN_VGA_VS),		
				.iVGA_BLANK(SN_VGA_BLANK),
				.iVGA_SYNC(SN_VGA_SYNC),	
				// output
				.oHC_VGA_DATA(HC_VGA_DATA),
				.oHC_VGA_HS(HC_VGA_HS),
				.oHC_VGA_VS(HC_VGA_VS),
				.oHC_VGA_BLANK(HC_VGA_BLANK),
				.oHC_VGA_SYNC(HC_VGA_SYNC)
					);

/////////////////////////////////////////////////////////////////////
// I2C //



always @(negedge BUTTON[1] or posedge CLK50) 
	begin
		if ( !BUTTON[1])
			delay_1 <=0 ;
		else if ( !delay_1 [7] )
			delay_1 <= delay_1 + 1;
	end

I2C_AV_Config 		u3	(	//	Host Side
							.iCLK  ( CLK50    ),
							.iRST_N( delay_1[7] ),
							//	I2C Side
							.I2C_SCLK(HC_I2C_SCLK),
							.I2C_SDAT(HC_I2C_SDAT)	
							
							);


endmodule




