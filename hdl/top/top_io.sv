module top_io (
    output [2:0]    led_0,
    output [2:0]    led_1
);
///////////////////////////////////////////////////////////////////////////////////////////////////
  logic led0,led1;
  logic [4:0] led_div1;
  logic clk200;
///////////////////////////////////////////////////////////////////////////////////////////////////

  top_bd_wrapper top_bd_wrapper_inst (
    .clk100       (),
    .rst          (),
    .led_div1_o_0 (led_div1),
    .led_o_0      (led0)
  );

//  led_cnt led_cnt_inst (
//    .rst      (~rstn    ),
//    .clk100   (clk100   ),
//    .div_i    (led_div1 ),
//    .wren_i   ('0       ),
//    .led_o    (led1     ) //BLUE
//  );

  assign led_0[2] = led0;
  assign led_0[1] = led0;
  assign led_0[0] = led0;

  assign led_1[2] = led0;
  assign led_1[1] = led0;
  assign led_1[0] = led0;

///////////////////////////////////////////////////////////////////////////////////////////////////



endmodule
