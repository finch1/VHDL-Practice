// --------------------------------------------------------------------------------
//| Avalon Streaming Timing Adapter
// --------------------------------------------------------------------------------

`timescale 1ns / 100ps
module TA_before_gate (
    
      // Interface: clk
      input              clk,
      input              reset_n,
      // Interface: in
      input      [15: 0] in_data,
      // Interface: out
      output reg [15: 0] out_data,
      output reg         out_valid
);




   // ---------------------------------------------------------------------
   //| Signal Declarations
   // ---------------------------------------------------------------------

   reg  [15: 0] in_payload;
   reg  [15: 0] out_payload;
   reg  [ 0: 0] ready;
   reg          out_ready = 1;
   reg          in_ready;
   // synthesis translate_off
   always @(negedge in_ready) begin
      $display("%m: The downstream component is backpressuring by deasserting ready, but the upstream component can't be backpressured.");
   end
   // synthesis translate_on   
   reg          in_valid = 1;


   // ---------------------------------------------------------------------
   //| Payload Mapping
   // ---------------------------------------------------------------------
   always @* begin
     in_payload = {in_data};
     {out_data} = out_payload;
   end

   // ---------------------------------------------------------------------
   //| Ready & valid signals.
   // ---------------------------------------------------------------------
   always @* begin
     ready[0] = out_ready;
     out_valid = in_valid;
     out_payload = in_payload;
     in_ready = ready[0];
   end



endmodule

