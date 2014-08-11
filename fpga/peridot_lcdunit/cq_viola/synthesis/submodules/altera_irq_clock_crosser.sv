// (C) 2001-2013 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/13.1/ip/merlin/altera_irq_clock_crosser/altera_irq_clock_crosser.sv#1 $
// $Revision: #1 $
// $Date: 2013/08/11 $
// $Author: swbranch $

`timescale 1 ns / 1 ns

module altera_irq_clock_crosser
  #(
    parameter IRQ_WIDTH          = 31,
    parameter SYNCHRONIZER_DEPTH = 3
  )
  (

   input                  receiver_clk,
   input                  receiver_reset,
   input                  sender_clk,
   input                  sender_reset,
   input  [IRQ_WIDTH-1:0] receiver_irq,
   output [IRQ_WIDTH-1:0] sender_irq
);

   altera_std_synchronizer_bundle 
     #(
       .depth( SYNCHRONIZER_DEPTH ),
       .width( IRQ_WIDTH ) 
     ) sync (
       .clk( sender_clk ),
       .reset_n( ~sender_reset ),
       .din( receiver_irq ),
       .dout( sender_irq )
     );
   
   
endmodule

