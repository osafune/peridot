//Legal Notice: (C)2014 Altera Corporation. All rights reserved.  Your
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

module cq_viola_gpio_0 (
                         // inputs:
                          address,
                          chipselect,
                          clk,
                          reset_n,
                          write_n,
                          writedata,

                         // outputs:
                          bidir_port,
                          readdata
                       )
;

  inout   [ 27: 0] bidir_port;
  output  [ 31: 0] readdata;
  input   [  1: 0] address;
  input            chipselect;
  input            clk;
  input            reset_n;
  input            write_n;
  input   [ 31: 0] writedata;

  wire    [ 27: 0] bidir_port;
  wire             clk_en;
  reg     [ 27: 0] data_dir;
  wire    [ 27: 0] data_in;
  reg     [ 27: 0] data_out;
  wire    [ 27: 0] read_mux_out;
  reg     [ 31: 0] readdata;
  assign clk_en = 1;
  //s1, which is an e_avalon_slave
  assign read_mux_out = ({28 {(address == 0)}} & data_in) |
    ({28 {(address == 1)}} & data_dir);

  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          readdata <= 0;
      else if (clk_en)
          readdata <= {32'b0 | read_mux_out};
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else if (chipselect && ~write_n && (address == 0))
          data_out <= writedata[27 : 0];
    end


  assign bidir_port[0] = data_dir[0] ? data_out[0] : 1'bZ;
  assign bidir_port[1] = data_dir[1] ? data_out[1] : 1'bZ;
  assign bidir_port[2] = data_dir[2] ? data_out[2] : 1'bZ;
  assign bidir_port[3] = data_dir[3] ? data_out[3] : 1'bZ;
  assign bidir_port[4] = data_dir[4] ? data_out[4] : 1'bZ;
  assign bidir_port[5] = data_dir[5] ? data_out[5] : 1'bZ;
  assign bidir_port[6] = data_dir[6] ? data_out[6] : 1'bZ;
  assign bidir_port[7] = data_dir[7] ? data_out[7] : 1'bZ;
  assign bidir_port[8] = data_dir[8] ? data_out[8] : 1'bZ;
  assign bidir_port[9] = data_dir[9] ? data_out[9] : 1'bZ;
  assign bidir_port[10] = data_dir[10] ? data_out[10] : 1'bZ;
  assign bidir_port[11] = data_dir[11] ? data_out[11] : 1'bZ;
  assign bidir_port[12] = data_dir[12] ? data_out[12] : 1'bZ;
  assign bidir_port[13] = data_dir[13] ? data_out[13] : 1'bZ;
  assign bidir_port[14] = data_dir[14] ? data_out[14] : 1'bZ;
  assign bidir_port[15] = data_dir[15] ? data_out[15] : 1'bZ;
  assign bidir_port[16] = data_dir[16] ? data_out[16] : 1'bZ;
  assign bidir_port[17] = data_dir[17] ? data_out[17] : 1'bZ;
  assign bidir_port[18] = data_dir[18] ? data_out[18] : 1'bZ;
  assign bidir_port[19] = data_dir[19] ? data_out[19] : 1'bZ;
  assign bidir_port[20] = data_dir[20] ? data_out[20] : 1'bZ;
  assign bidir_port[21] = data_dir[21] ? data_out[21] : 1'bZ;
  assign bidir_port[22] = data_dir[22] ? data_out[22] : 1'bZ;
  assign bidir_port[23] = data_dir[23] ? data_out[23] : 1'bZ;
  assign bidir_port[24] = data_dir[24] ? data_out[24] : 1'bZ;
  assign bidir_port[25] = data_dir[25] ? data_out[25] : 1'bZ;
  assign bidir_port[26] = data_dir[26] ? data_out[26] : 1'bZ;
  assign bidir_port[27] = data_dir[27] ? data_out[27] : 1'bZ;
  assign data_in = bidir_port;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_dir <= 0;
      else if (chipselect && ~write_n && (address == 1))
          data_dir <= writedata[27 : 0];
    end



endmodule

