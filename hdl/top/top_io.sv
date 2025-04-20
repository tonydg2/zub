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
  logic i2c0_scl_i, i2c0_scl_o, i2c0_scl_t, i2c0_sda_i, i2c0_sda_o, i2c0_sda_t, i2c_int;
  logic i2c1_scl_i, i2c1_scl_o, i2c1_scl_t, i2c1_sda_i, i2c1_sda_o, i2c1_sda_t;

///////////////////////////////////////////////////////////////////////////////////////////////////

  top_bd_wrapper top_bd_wrapper_inst (
    .clk100                 (clk100             ),
    .rst                    (rst                ),
    .periph_rstn            (rstn               ),
    .led_div1_o_0           (led_div1           ),
    .led_o_0                (led0               ),
    .git_hash_top           (git_hash_top       ),
    .timstamp_top           (timestamp_top      ),
    .emio_i2c0_scl_i_0      (i2c0_scl_i         ), // input 
    .emio_i2c0_scl_o_0      (i2c0_scl_o         ), // output
    .emio_i2c0_scl_t_0      (i2c0_scl_t         ), // output
    .emio_i2c0_sda_i_0      (i2c0_sda_i         ), // input 
    .emio_i2c0_sda_o_0      (i2c0_sda_o         ), // output
    .emio_i2c0_sda_t_0      (i2c0_sda_t         ), // output
    .emio_i2c1_scl_i_0      (i2c1_scl_i         ), // input 
    .emio_i2c1_scl_o_0      (i2c1_scl_o         ), // output
    .emio_i2c1_scl_t_0      (i2c1_scl_t         ), // output
    .emio_i2c1_sda_i_0      (i2c1_sda_i         ), // input 
    .emio_i2c1_sda_o_0      (i2c1_sda_o         ), // output
    .emio_i2c1_sda_t_0      (i2c1_sda_t         )  // output 
  );

///////////////////////////////////////////////////////////////////////////////////////////////////

logic [9:0] bscan_vec;
logic tdo;


// !! DONT FORGET ABOUT BLACKBOX DECLARATION BOOTOM OF FILE! WHEN CHANGING PORTS!!
(* DONT_TOUCH = "TRUE", KEEP_HIERARCHY = "TRUE" *) i2c_top i2c_top_inst (
  .clk            (clk100         ),
  .clk12          (clk8),
  .rst            (rst            ),
  .git_hash_top   (git_hash_top   ),
  .timestamp_top  (timestamp_top  ),
  .scl0_i         (i2c0_scl_o     ),
  .scl0_t         (i2c0_scl_t     ),
  .scl0_o         (i2c0_scl_i     ),
  .sda0_i         (i2c0_sda_o     ),
  .sda0_o         (i2c0_sda_i     ),
  .sda0_t         (i2c0_sda_t     ),
  .scl1_i         (i2c1_scl_o     ),
  .scl1_t         (i2c1_scl_t     ),
  .scl1_o         (i2c1_scl_i     ),
  .sda1_i         (i2c1_sda_o     ),
  .sda1_o         (i2c1_sda_i     ),
  .sda1_t         (i2c1_sda_t     ),
  .S_BSCAN_drck(),
  .S_BSCAN_shift(),
  .S_BSCAN_tdi(),
  .S_BSCAN_update(),
  .S_BSCAN_sel(),
  .S_BSCAN_tdo(),
  .S_BSCAN_tms(),
  .S_BSCAN_tck(),
  .S_BSCAN_runtest(),
  .S_BSCAN_reset(),
  .S_BSCAN_capture(),
  .S_BSCAN_bscanid_en()  
);


logic clk8;

clk_div #(
  .DIV(8)
) clk_div_inst (
  .clk_i (clk100),
  .clk_o (clk8) // 12.5M
);

//2,000,000
ila1 ila1 (
	.clk(clk8), // input wire clk
	.probe0({0, i2c0_scl_i, i2c0_scl_o, i2c0_scl_t, i2c0_sda_i, i2c0_sda_o, i2c0_sda_t}  ),  // input wire [6:0]  probe0  
	.probe1({0, i2c1_scl_i, i2c1_scl_o, i2c1_scl_t, i2c1_sda_i, i2c1_sda_o, i2c1_sda_t}  )   // input wire [6:0]  probe1
);


///////////////////////////////////////////////////////////////////////////////////////////////////
  logic [1:0] idx;
  logic [2:0] ledsr;
  logic [3:0] cnt;
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

  assign led_0[2] = cnt[3];
  assign led_0[1] = cnt[2];
  assign led_0[0] = cnt[1];

  assign led_1[2] = cnt[0];
  assign led_1[1] = cnt[1];
  assign led_1[0] = cnt[2];


endmodule

// blackbox for DFX
module i2c_top (
  input       clk     ,
  input       clk12     ,
  input       rst     ,
  output [63:0] git_hash_top,
  output [31:0] timestamp_top,
  input       scl0_i  ,
  input       scl0_t  ,
  output      scl0_o  ,
  input       sda0_i  ,
  output      sda0_o  ,
  input       sda0_t  ,
  input       scl1_i  ,
  input       scl1_t  ,
  output      scl1_o  ,
  input       sda1_i  ,
  output      sda1_o  ,
  input       sda1_t  ,
  input       S_BSCAN_drck        ,
  input       S_BSCAN_shift       ,
  input       S_BSCAN_tdi         ,
  input       S_BSCAN_update      ,
  input       S_BSCAN_sel         ,
  output      S_BSCAN_tdo         ,
  input       S_BSCAN_tms         ,
  input       S_BSCAN_tck         ,
  input       S_BSCAN_runtest     ,
  input       S_BSCAN_reset       ,
  input       S_BSCAN_capture     ,
  input       S_BSCAN_bscanid_en  
); endmodule
/*
module i2c_sink (
  input   clk   ,
  input   rst   ,
  input   scl_i ,
  input   scl_t ,
  output  scl_o ,
  input   sda_i ,
  output  sda_o ,
  input   sda_t);
endmodule

module i2c_sink1 (
  input   clk   ,
  input   rst   ,
  input   scl_i ,
  input   scl_t ,
  output  scl_o ,
  input   sda_i ,
  output  sda_o ,
  input   sda_t);
endmodule
*/