module top_io (
    output [2:0]    led_0,
    output [2:0]    led_1
);
///////////////////////////////////////////////////////////////////////////////////////////////////


  logic led0,led1,clk100,rst,rstn;
  logic [4:0] led_div1,p0,p1;
  logic [63:0]  git_hash_scripts,git_hash_top,git_hash_common;
  logic [31:0]  timestamp_scripts,timestamp_top,timestamp_common;
  logic [2:0]   gpio,gpio2;
///////////////////////////////////////////////////////////////////////////////////////////////////

  top_bd_wrapper top_bd_wrapper_inst (
    .clk100                 (clk100             ),
    .rst                    (rst                ),
    .periph_rstn            (rstn               ),
    .led_o_0                (led0               ),
    .led_o_1                (led1               )
  );


///////////////////////////////////////////////////////////////////////////////////////////////////


//ila1 ila1 (
//	.clk(clk100), // input wire clk
//	.probe0(gpio_io_o[4:0]),  // input wire [4:0]  probe0  
//	.probe1(gpio2_io_o[4:0])   // input wire [4:0]  probe1
//);


///////////////////////////////////////////////////////////////////////////////////////////////////

//  led_cnt led_cnt_inst (
//    .rst      (~rstn    ),
//    .clk100   (clk100   ),
//    .div_i    (led_div1 ),
//    .wren_i   ('0       ),
//    .led_o    (led1     ) //BLUE
//  );
///////////////////////////////////////////////////////////////////////////////////////////////////
/*
// SCRIPTS
//  user_init_64b git_hash_scripts_inst (
  user_init_64b scripts_git_hash_inst (
    .clk      (1'b0),
    .value_o  (git_hash_scripts)
  );

//  user_init_32b timestamp_scripts_inst (
  user_init_32b scripts_timestamp_inst (
    .clk      (1'b0),
    .value_o  (timestamp_scripts)
  );

// TOP
//  user_init_64b git_hash_top_inst (
  user_init_64b top_git_hash_inst (
    .clk      (1'b0),
    .value_o  (git_hash_top)
  );

//  user_init_32b timestamp_top_inst (
  user_init_32b top_timestamp_inst (
    .clk      (1'b0),
    .value_o  (timestamp_top)
  );

// Common
//  user_init_64b git_hash_common_inst (
  user_init_64b common_git_hash_inst (
    .clk      (1'b0),
    .value_o  (git_hash_common)
  );

//  user_init_32b timestamp_common_inst (
  user_init_32b common_timestamp_inst (
    .clk      (1'b0),
    .value_o  (timestamp_common)
  );
*/
///////////////////////////////////////////////////////////////////////////////////////////////////
  logic [1:0] idx,idx1;
  logic [2:0] ledsr,cnt,ledsr1,cnt1;
  logic ledre,ledre1;

  always_ff @( posedge clk100 ) begin
    if (rst) begin 
      ledre <= 0;
      ledsr <= 1;
      idx   <= 0;
      cnt   <= 0;
      ledre1 <= 0;
      ledsr1 <= 1;
      idx1   <= 0;
      cnt1   <= 0;
    end else begin 
      ledre <= led0;
      if (led0 && !ledre) begin 
        cnt   <= cnt + 1;
        if (ledsr == (1 << (2)))  ledsr <= 1;
        else                      ledsr <= ledsr << 1;
      end

      ledre1 <= led1;
      if (led1 && !ledre1) begin 
        cnt1  <= cnt1 + 1;
        if (ledsr1 == (1 << (2))) ledsr1 <= 1;
        else                      ledsr1 <= ledsr1 << 1;
      end

    end
  end

  assign led_0[2] = cnt[2];
  assign led_0[1] = cnt[1];
  assign led_0[0] = cnt[0];

  assign led_1[2] = cnt1[2];
  assign led_1[1] = cnt1[1];
  assign led_1[0] = cnt1[0];





endmodule
