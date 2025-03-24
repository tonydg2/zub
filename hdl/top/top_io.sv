module top_io (
    output [2:0]    led_0,
    output [2:0]    led_1
);
///////////////////////////////////////////////////////////////////////////////////////////////////
  logic led0,led1,clk100,rst;
  logic [4:0] led_div1,p0,p1;
  logic [63:0]  git_hash_scripts,git_hash_top,git_hash_common;
  logic [31:0]  timestamp_scripts,timestamp_top,timestamp_common;

///////////////////////////////////////////////////////////////////////////////////////////////////

  top_bd_wrapper top_bd_wrapper_inst (
    .clk100           (clk100             ),
    .rst              (rst                ),
    .git_hash_top     (git_hash_top       ),
    .timstamp_top     (timestamp_top      ),
    .git_hash_scripts (git_hash_scripts   ),
    .timstamp_scripts (timestamp_scripts  ),
    .git_hash_common  (git_hash_common    ),
    .timstamp_common  (timestamp_common   ),
    .led_div1_o_0     (led_div1           ),
    .led_o_0          (led0               )
  );

//  led_cnt led_cnt_inst (
//    .rst      (~rstn    ),
//    .clk100   (clk100   ),
//    .div_i    (led_div1 ),
//    .wren_i   ('0       ),
//    .led_o    (led1     ) //BLUE
//  );
///////////////////////////////////////////////////////////////////////////////////////////////////
// SCRIPTS
  user_init_64b git_hash_scripts_inst (
    .clk      (1'b0),
    .value_o  (git_hash_scripts)
  );

  user_init_32b timestamp_scripts_inst (
    .clk      (1'b0),
    .value_o  (timestamp_scripts)
  );

// TOP
  user_init_64b git_hash_top_inst (
    .clk      (1'b0),
    .value_o  (git_hash_top)
  );

  user_init_32b timestamp_top_inst (
    .clk      (1'b0),
    .value_o  (timestamp_top)
  );

// Common
  user_init_64b git_hash_common_inst (
    .clk      (1'b0),
    .value_o  (git_hash_common)
  );

  user_init_32b timestamp_common_inst (
    .clk      (1'b0),
    .value_o  (timestamp_common)
  );


///////////////////////////////////////////////////////////////////////////////////////////////////
  logic [1:0] idx;
  logic [2:0] ledsr,cnt;
  logic ledre;

  always_ff @( posedge clk100 ) begin
    if (rst) begin 
      ledre <= 0;
      ledsr <= 1;
      idx   <= 0;
      cnt   <= 0;
    end else begin 
      ledre <= led0;
      if (led0 && !ledre) begin 
        cnt   <= cnt + 1;
        if (ledsr == (1 << (2)))  ledsr <= 1;
        else                      ledsr <= ledsr << 1;
      end
    end
  end

  assign led_0[2] = ledsr[2];
  assign led_0[1] = ledsr[1];
  assign led_0[0] = ledsr[0];

  assign led_1[2] = cnt[0];
  assign led_1[1] = cnt[1];
  assign led_1[0] = cnt[2];



//ila1 ila1 (
//	.clk(clk100), // input wire clk
//	.probe0(ledsr),  // input wire [4:0]  probe0  
//	.probe1(cnt)   // input wire [4:0]  probe1
//);



endmodule
