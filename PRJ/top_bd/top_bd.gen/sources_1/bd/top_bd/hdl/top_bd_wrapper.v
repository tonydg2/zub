//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2023.2 (lin64) Build 4029153 Fri Oct 13 20:13:54 MDT 2023
//Date        : Thu Mar  6 13:34:03 2025
//Host        : tony-MS-7693 running 64-bit Ubuntu 22.04.5 LTS
//Command     : generate_target top_bd_wrapper.bd
//Design      : top_bd_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module top_bd_wrapper
   (clk100,
    led_div1_o_0,
    led_o_0,
    rst);
  output clk100;
  output [4:0]led_div1_o_0;
  output led_o_0;
  output [0:0]rst;

  wire clk100;
  wire [4:0]led_div1_o_0;
  wire led_o_0;
  wire [0:0]rst;

  top_bd top_bd_i
       (.clk100(clk100),
        .led_div1_o_0(led_div1_o_0),
        .led_o_0(led_o_0),
        .rst(rst));
endmodule
