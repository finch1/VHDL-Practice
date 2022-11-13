
// --------------------------------------------------------------------
// Copyright (c) 2005 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
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
// Major Functions:	 Music Synthesizer
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date   :| Changes Made:
//   V1.0 :| Joe Yang          :| 10/25/2006  :| Initial Revision
//   V1.1 :| Joe Yang          :| 04/25/2007  :| PS2_CLK --> ps_clk
// --------------------------------------------------------------------

/////////////////////////////////////////////
////     2Channel-Music-Synthesizer     /////
/////////////////////////////////////////////
/*****************************************************/
/*             KEY & SW List               			 */
/* BUTTON[1]: I2C reset                       		 */
/* BUTTON[2]: Demo Sound and Keyboard mode selection */
/* BUTTON[3]: Keyboard code Reset             		 */
/* BUTTON[4]: Keyboard system Reset                  */
/*****************************************************/


module synthesizer (
	input			CLOCK_50,				
	input	[4:1]	BUTTON,					//	Button[4:1]
	output	[4:1]	LED,					//	LED[4:1] 

	inout		 	PS2_DAT,				//	PS2 Data
	input			PS2_CLK,				//	PS2 Clock

	output			VGA_CLK,   				//	VGA Clock
	output			VGA_HS,					//	VGA H_SYNC
	output			VGA_VS,					//	VGA V_SYNC
	output			VGA_BLANK,				//	VGA BLANK
	output			VGA_SYNC,				//	VGA SYNC
	output	[9:0]	VGA_R,   				//	VGA Red[9:0]
	output	[9:0]	VGA_G,	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B,   				//	VGA Blue[9:0]
    output          HC_VGA_CLOCK,			//  VGA encodr clock     

	inout			AUD_ADCLRCK,			//	Audio CODEC ADC LR Clock
	inout			AUD_DACLRCK,			//	Audio CODEC DAC LR Clock
	input			AUD_ADCDAT,			    //	Audio CODEC ADC Data
	output			AUD_DACDAT,				//	Audio CODEC DAC Data
	inout			AUD_BCLK,				//	Audio CODEC Bit-Stream Clock
	output			AUD_XCK					//	Audio CODEC Chip Clock


	);



	

//	AUDIO SOUND

	wire    AUD_CTRL_CLK;
	
	assign	AUD_ADCLRCK	=	AUD_DACLRCK;

	assign	AUD_XCK		=	AUD_CTRL_CLK;			


//  AUDIO PLL

	VGA_Audio_PLL 		u1	(	
								.areset ( 1'b0 ),
								
								.inclk0 ( CLOCK_50 ),

								.c0		( AUD_CTRL_CLK ),	
								
								.c1		( HC_VGA_CLOCK ),
								
								.c2		(CLOCK_25) 
								);


// Music Synthesizer Block //

// TIME & CLOCK Generater //

	reg    [31:0]VGA_CLK_o;

	wire   keyboard_sysclk = VGA_CLK_o[10];

	wire   demo_clock      = VGA_CLK_o[17]; 

	assign VGA_CLK         = CLOCK_25 ;

	always @( posedge CLOCK_25) VGA_CLK_o = VGA_CLK_o + 1;
		

// DEMO SOUND //

// DEMO Sound (CH1) //

	wire [7:0]demo_code1;

	demo_sound1	dd1(
		.clock   ( demo_clock ),
		.key_code( demo_code1 ),
		.k_tr    ( BUTTON[2] )
	);

// DEMO Sound (CH2) //

	wire [7:0]demo_code2;

	demo_sound2	dd2(
		.clock   ( demo_clock ),
		.key_code( demo_code2 ),
		.k_tr    ( BUTTON[2] )
	);

///// PS2_CLK --> ps_clk ////<<<
	reg  [9:0] 	ps_cnt;
	reg  		ps_clk;
	
	always @(posedge PS2_CLK or posedge CLOCK_25) begin
	if (PS2_CLK) begin 
		ps_cnt=0; 
		ps_clk = 1; 
	end
	else if ( ps_cnt < 400) begin 
			ps_cnt = ps_cnt + 1;
			if (ps_cnt==200) ps_clk = 0;
	end
	end
//<<<


// KeyBoard Scan //

	wire [7:0]scan_code;

	wire get_gate;

	wire key1_on;

	wire key2_on;

	wire [7:0]key1_code;

	wire [7:0]key2_code;

	PS2_KEYBOARD keyboard(
	
		.ps2_dat  ( PS2_DAT ),		    //ps2bus data  		
		.ps2_clk  ( ps_clk ),		    //ps2bus clk      	
		.sys_clk  ( keyboard_sysclk ),  //system clock		
		.reset    ( BUTTON[4] ), 		    //system reset		
    	.reset1   ( BUTTON[3] ),			//keyboard reset	
    	.scandata ( scan_code ),		//scan code    		
    	.key1_on  ( key1_on ),			//key1 triger
    	.key2_on  ( key2_on ),			//key2 triger
    	.key1_code( key1_code ),		//key1 code
    	.key2_code( key2_code ) 		//key2 code
	);
	
////////////Sound Select/////////////	

	wire [15:0]sound1;

	wire [15:0]sound2;

	wire [15:0]sound3;

	wire [15:0]sound4;

	wire sound_off1;

	wire sound_off2;

	wire sound_off3;

	wire sound_off4;

	wire [7:0]sound_code1 = ( !BUTTON[2] )? demo_code1 : key1_code ; //BUTTON[2]=0 is DEMO SOUND,otherwise key

	wire [7:0]sound_code2 = ( !BUTTON[2] )? demo_code2 : key2_code ; //BUTTON[2]=0 is DEMO SOUND,otherwise key

	wire [7:0]sound_code3 = 8'hf0;

	wire [7:0]sound_code4 = 8'hf0;

// Staff Display & Sound Output //

	wire   VGA_R1,VGA_G1,VGA_B1;

	wire   VGA_R2,VGA_G2,VGA_B2;
	
	assign VGA_R=( VGA_R1 )? 10'h3f0 : 0 ;
	
	assign VGA_G=( VGA_G1 )? 10'h3f0 : 0 ;
	
	assign VGA_B=( VGA_B1 )? 10'h3f0 : 0 ;

	staff st1(
		
		// VGA output //
		
		.VGA_CLK   		( VGA_CLK ),   
		.vga_h_sync		( VGA_HS ), 
		.vga_v_sync		( VGA_VS ), 
		.vga_sync  		( VGA_SYNC ),	
	    .inDisplayArea	( VGA_BLANK ),
		.vga_R			( VGA_R1 ), 
		.vga_G			( VGA_G1 ), 
		.vga_B			( VGA_B1 ),
		
		// Key code-in //
		
		.scan_code1( sound_code1 ),
		.scan_code2( sound_code2 ),
		.scan_code3( sound_code3 ), // OFF
		.scan_code4( sound_code4 ), // OFF
		
		//Sound Output to Audio Generater//
		
		.sound1( sound1 ),
		.sound2( sound2 ),
		.sound3( sound3 ), // OFF
		.sound4( sound4 ), // OFF
		
		.sound_off1( sound_off1 ),
		.sound_off2( sound_off2 ),
		.sound_off3( sound_off3 ), //OFF
		.sound_off4( sound_off4 )	 //OFF
		
	);

///////LED Display////////
	
	assign LED[4:1] = { sound_off4,sound_off3,sound_off2,sound_off1 };
						
// 2CH Audio Sound output -- Audio Generater //

	adio_codec ad1	(	
	        
		// AUDIO CODEC //
		
		.oAUD_BCK ( AUD_BCLK ),
		.oAUD_DATA( AUD_DACDAT ),
		.oAUD_LRCK( AUD_DACLRCK ),																
		.iCLK_18_4( AUD_CTRL_CLK ),
		
		// KEY //
		
		.iRST_N( BUTTON[1] ),							
		.iSrc_Select( 2'b00 ),

		// Sound Control //

		.key1_on( sound_off1 ),		
		.key2_on( sound_off2 ),
		.key3_on( 1'b0 ), // OFF
    	.key4_on( 1'b0 ), // OFF							
		.sound1( sound1 ),// CH1 Freq
		.sound2( sound2 ),// CH2 Freq
		.sound3( sound3 ),// OFF,CH3 Freq
		.sound4( sound4 ),// OFF,CH4 Freq							
		.instru( 1'b0 )  // Instruction Select
	);


endmodule
