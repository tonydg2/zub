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
  logic i2c0_scl_i=1, i2c0_scl_o, i2c0_scl_t, i2c0_sda_i=1, i2c0_sda_o, i2c0_sda_t, i2c_int;
  logic i2c1_scl_i=1, i2c1_scl_o, i2c1_scl_t, i2c1_sda_i=1, i2c1_sda_o, i2c1_sda_t;

///////////////////////////////////////////////////////////////////////////////////////////////////

  top_bd_wrapper top_bd_wrapper_inst (
    .clk100                 (clk100             ),
    .rst                    (rst                ),
    .periph_rstn            (rstn               ),
    .led_div1_o_0           (led_div1           ),
    .led_o_0                (led0               ),
    .emio_i2c0_scl_i_0      (i2c0_scl_i         ), 
    .emio_i2c0_scl_o_0      (i2c0_scl_o         ), 
    .emio_i2c0_scl_t_0      (i2c0_scl_t         ), 
    .emio_i2c0_sda_i_0      (i2c0_sda_i         ), 
    .emio_i2c0_sda_o_0      (i2c0_sda_o         ), 
    .emio_i2c0_sda_t_0      (i2c0_sda_t         ), 
    .emio_i2c1_scl_i_0      (i2c1_scl_i         ), 
    .emio_i2c1_scl_o_0      (i2c1_scl_o         ), 
    .emio_i2c1_scl_t_0      (i2c1_scl_t         ), 
    .emio_i2c1_sda_i_0      (i2c1_sda_i         ), 
    .emio_i2c1_sda_o_0      (i2c1_sda_o         ), 
    .emio_i2c1_sda_t_0      (i2c1_sda_t         )
  );


///////////////////////////////////////////////////////////////////////////////////////////////////

(* dont_touch = "true" *) i2c_sink i2c_sink_inst (
  .clk    (clk100     ),
  .rst    (rst        ),
  .scl_i  (i2c0_scl_o ),
  .scl_t  (i2c0_scl_t ),
  .scl_o  (i2c0_scl_i ),
  .sda_i  (i2c0_sda_o ),
  .sda_o  (i2c0_sda_i ),
  .sda_t  (i2c0_sda_t )
);

(* dont_touch = "true" *) i2c_sink1 i2c_sink1_inst (
  .clk    (clk100     ),
  .rst    (rst        ),
  .scl_i  (i2c1_scl_o ),
  .scl_t  (i2c1_scl_t ),
  .scl_o  (i2c1_scl_i ),
  .sda_i  (i2c1_sda_o ),
  .sda_o  (i2c1_sda_i ),
  .sda_t  (i2c1_sda_t )
);


ila1 ila1 (
	.clk(clk100), // input wire clk
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
