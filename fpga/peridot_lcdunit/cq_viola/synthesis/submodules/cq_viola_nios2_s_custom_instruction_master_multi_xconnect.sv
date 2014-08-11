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


// $Id: //acds/rel/13.1/ip/merlin/altera_customins_xconnect/altera_customins_xconnect.sv.terp#1 $
// $Revision: #1 $
// $Date: 2013/08/11 $
// $Author: swbranch $

// -------------------------------------------------------
// Custom Instruction Interconnect
//
// -------------------------------------------------------

`timescale 1 ns / 1 ns


module cq_viola_nios2_s_custom_instruction_master_multi_xconnect
(
    // -------------------
    // Custom instruction masters
    // -------------------
    output [31 : 0] ci_master0_dataa,
    output [31 : 0] ci_master0_datab,
    input  [31 : 0] ci_master0_result,
    output [ 7 : 0] ci_master0_n,
    output          ci_master0_readra,
    output          ci_master0_readrb,
    output          ci_master0_writerc,
    output [ 4 : 0] ci_master0_a,
    output [ 4 : 0] ci_master0_b,
    output [ 4 : 0] ci_master0_c,
    output [31 : 0] ci_master0_ipending,
    output          ci_master0_estatus,
    output          ci_master0_clk,   
    output          ci_master0_clken,
    output          ci_master0_reset, 
    output          ci_master0_reset_req,
    output          ci_master0_start,
    input           ci_master0_done,


    // -------------------
    // Custom instruction slave
    // -------------------
    input           ci_slave_clk,   
    input           ci_slave_clken,
    input           ci_slave_reset, 
    input           ci_slave_reset_req,
    input           ci_slave_start,
    output          ci_slave_done,
    input  [31 : 0] ci_slave_dataa,
    input  [31 : 0] ci_slave_datab,
    output [31 : 0] ci_slave_result,
    input  [ 7 : 0] ci_slave_n,
    input           ci_slave_readra,
    input           ci_slave_readrb,
    input           ci_slave_writerc,
    input  [ 4 : 0] ci_slave_a,
    input  [ 4 : 0] ci_slave_b,
    input  [ 4 : 0] ci_slave_c,
    input  [31 : 0] ci_slave_ipending,
    input           ci_slave_estatus

);

    wire select0;

    // -------------------------------------------------------
    // Wire non-control signals through to each master
    // -------------------------------------------------------
    assign  ci_master0_dataa    = ci_slave_dataa;
    assign  ci_master0_datab    = ci_slave_datab;
    assign  ci_master0_n        = ci_slave_n;
    assign  ci_master0_a        = ci_slave_a;
    assign  ci_master0_b        = ci_slave_b;
    assign  ci_master0_c        = ci_slave_c;
    assign  ci_master0_ipending = ci_slave_ipending;
    assign  ci_master0_estatus  = ci_slave_estatus;
    assign  ci_master0_clk      = ci_slave_clk;
    assign  ci_master0_clken    = ci_slave_clken;
    assign  ci_master0_reset_req = ci_slave_reset_req;
    assign  ci_master0_reset    = ci_slave_reset;


    // -------------------------------------------------------
    // Figure out which output is selected, and use that to
    // gate control signals
    // -------------------------------------------------------
    assign select0 = ci_slave_n >= 0 && ci_slave_n < 8;

    assign ci_master0_readra  = (select0 && ci_slave_readra);
    assign ci_master0_readrb  = (select0 && ci_slave_readrb);
    assign ci_master0_writerc = (select0 && ci_slave_writerc);
    assign ci_master0_start   = (select0 && ci_slave_start);


    // -------------------------------------------------------
    // Use the select signal to figure out which result to mux
    // back
    // -------------------------------------------------------
    assign ci_slave_result = {32{ select0 }} & ci_master0_result
    ;

    assign ci_slave_done = select0 & ci_master0_done
    ;

endmodule


