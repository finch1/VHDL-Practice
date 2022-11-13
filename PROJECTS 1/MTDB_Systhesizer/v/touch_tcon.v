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
// Major Functions:	DE2 LTM module Timing control and color pattern 
//					generator
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            		:| Mod. Date :| Changes Made:
//   V1.0 :| Johnny Fan				:| 07/06/30  :| Initial Revision
// --------------------------------------------------------------------
module touch_tcon		(
						iCLK, 				// LCD display clock
						iRST_n, 			// systen reset
						//LCD SIDE
						oHD,				// LCD Horizontal sync 
						oVD,				// LCD Vertical sync 	
						oDEN,				// LCD Data Enable
						oLCD_R,				// LCD Red color data 
						oLCD_G,             // LCD Green color data  
						oLCD_B,             // LCD Blue color data  
						iDISPLAY_MODE,
						oX_CNT,
						oY_CNT
						);
//============================================================================
// PARAMETER declarations
//============================================================================
parameter H_LINE = 1056;
parameter V_LINE = 525;
parameter Hsync_Blank = 216;
parameter Hsync_Front_Porch = 40;
parameter Vertical_Back_Porch = 35;
parameter Vertical_Front_Porch = 10;
//===========================================================================
// PORT declarations
//===========================================================================
input			iCLK;   
input			iRST_n;
output	[7:0]	oLCD_R;		
output  [7:0]	oLCD_G;
output  [7:0]	oLCD_B;
output			oHD;
output			oVD;
output			oDEN;
input	[1:0]	iDISPLAY_MODE;	
output	[10:0]  oX_CNT;  
output	[10:0]	oY_CNT; 

//=============================================================================
// REG/WIRE declarations
//=============================================================================
reg		[11:0]  oX_CNT;  
reg		[11:0]	oY_CNT; 
wire	[7:0]	mred;
wire	[7:0]	mgreen;
wire	[7:0]	mblue; 
wire			display_area;
reg				mhd;
reg				mvd;
reg				mden;
reg				oHD;
reg				oVD;
reg				oDEN;
reg		[7:0]	oLCD_R;
reg		[7:0]	oLCD_G;	
reg		[7:0]	oLCD_B;	
wire	[1:0]	msel;	
reg		[7:0]	red_1;
reg 	[7:0]	green_1;
reg 	[7:0]	blue_1;
reg 	[7:0]	graycnt;
reg		[7:0]	pattern_data;

//=============================================================================
// Structural coding
//=============================================================================

					
// This signal indicate the lcd display area .
assign	display_area = ((oX_CNT>(Hsync_Blank-1)&& //>215
						(oX_CNT<(H_LINE-Hsync_Front_Porch))&& //< 1016
						(oY_CNT>(Vertical_Back_Porch-1))&& 
						(oY_CNT<(V_LINE - Vertical_Front_Porch))
						))  ? 1'b1 : 1'b0;


///////////////////////// x  y counter  and lcd hd generator //////////////////
always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
		begin
			oX_CNT <= 12'd0;	
			mhd  <= 1'd0;  	
		end	
		else if (oX_CNT == (H_LINE-1))
		begin
			oX_CNT <= 12'd0;
			mhd  <= 1'd0;
		end	   
		else
		begin
			oX_CNT <= oX_CNT + 12'd1;
			mhd  <= 1'd1;
		end	
	end

always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			oY_CNT <= 12'd0;
		else if (oX_CNT == (H_LINE-1))
		begin
			if (oY_CNT == (V_LINE-1))
				oY_CNT <= 12'd0;
			else
				oY_CNT <= oY_CNT + 12'd1;	
		end
	end
////////////////////////////// touch panel timing //////////////////

always@(posedge iCLK  or negedge iRST_n)
	begin
		if (!iRST_n)
			mvd  <= 1'b1;
		else if (oY_CNT == 10'd0)
			mvd  <= 1'b0;
		else
			mvd  <= 1'b1;
	end			

always@(posedge iCLK  or negedge iRST_n)
	begin
		if (!iRST_n)
			mden  <= 1'b0;
		else if (display_area)
			mden  <= 1'b1;
		else
			mden  <= 1'b0;
	end			




always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			begin
				oHD	<= 1'd0;
				oVD	<= 1'd0;
				oDEN <= 1'd0;
				oLCD_R <= 8'd0;
				oLCD_G <= 8'd0;
				oLCD_B <= 8'd0;
			end
		else
			begin
				oHD	<= mhd;
				oVD	<= mvd;
				oDEN <= mden;
				oLCD_R <= mred;
				oLCD_G <= mgreen;
				oLCD_B <= mblue;
			end		
	end
						
endmodule











