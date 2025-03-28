module top_io (
    output [2:0]    led_0,
    output [2:0]    led_1
);
///////////////////////////////////////////////////////////////////////////////////////////////////
  logic  [8:0]  GPIO_PL_araddr      ;
  logic  [2:0]  GPIO_PL_arprot      ;
  logic         GPIO_PL_arready     ;
  logic         GPIO_PL_arvalid     ;
  logic  [8:0]  GPIO_PL_awaddr      ;
  logic  [2:0]  GPIO_PL_awprot      ;
  logic         GPIO_PL_awready     ;
  logic         GPIO_PL_awvalid     ;
  logic         GPIO_PL_bready      ;
  logic [1:0]   GPIO_PL_bresp       ;
  logic         GPIO_PL_bvalid      ;
  logic [31:0]  GPIO_PL_rdata       ;
  logic         GPIO_PL_rready      ;
  logic [1:0]   GPIO_PL_rresp       ;
  logic         GPIO_PL_rvalid      ;
  logic  [31:0] GPIO_PL_wdata       ;
  logic         GPIO_PL_wready      ;
  logic  [3:0]  GPIO_PL_wstrb       ;
  logic         GPIO_PL_wvalid      ;

  logic [31:0] gpio_io_i,gpio_io_o,gpio_io_t,gpio2_io_i,gpio2_io_o,gpio2_io_t;

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
    .M_AXI_GPIO_PL_araddr   (GPIO_PL_araddr     ),
    .M_AXI_GPIO_PL_arprot   (GPIO_PL_arprot     ),
    .M_AXI_GPIO_PL_arready  (GPIO_PL_arready    ),
    .M_AXI_GPIO_PL_arvalid  (GPIO_PL_arvalid    ),
    .M_AXI_GPIO_PL_awaddr   (GPIO_PL_awaddr     ),
    .M_AXI_GPIO_PL_awprot   (GPIO_PL_awprot     ),
    .M_AXI_GPIO_PL_awready  (GPIO_PL_awready    ),
    .M_AXI_GPIO_PL_awvalid  (GPIO_PL_awvalid    ),
    .M_AXI_GPIO_PL_bready   (GPIO_PL_bready     ),
    .M_AXI_GPIO_PL_bresp    (GPIO_PL_bresp      ),
    .M_AXI_GPIO_PL_bvalid   (GPIO_PL_bvalid     ),
    .M_AXI_GPIO_PL_rdata    (GPIO_PL_rdata      ),
    .M_AXI_GPIO_PL_rready   (GPIO_PL_rready     ),
    .M_AXI_GPIO_PL_rresp    (GPIO_PL_rresp      ),
    .M_AXI_GPIO_PL_rvalid   (GPIO_PL_rvalid     ),
    .M_AXI_GPIO_PL_wdata    (GPIO_PL_wdata      ),
    .M_AXI_GPIO_PL_wready   (GPIO_PL_wready     ),
    .M_AXI_GPIO_PL_wstrb    (GPIO_PL_wstrb      ),
    .M_AXI_GPIO_PL_wvalid   (GPIO_PL_wvalid     ),
    .git_hash_top           (git_hash_top       ),
    .timstamp_top           (timestamp_top      ),
    .git_hash_scripts       (git_hash_scripts   ),
    .timstamp_scripts       (timestamp_scripts  ),
    .git_hash_common        (git_hash_common    ),
    .timstamp_common        (timestamp_common   ),
    .led_div1_o_0           (led_div1           ),
    .led_o_0                (led0               ),
    .gpio_o                 (gpio               ),
    .gpio2_o                (gpio2              )
  );


///////////////////////////////////////////////////////////////////////////////////////////////////

gpio axi_gpio_pl (
  .s_axi_aclk     (clk100            ),   // input wire s_axi_aclk
  .s_axi_aresetn  (rstn              ),   // input wire s_axi_aresetn
  .s_axi_awaddr   (GPIO_PL_awaddr    ),   // input wire [8 : 0] s_axi_awaddr
  .s_axi_awvalid  (GPIO_PL_awvalid   ),   // input wire s_axi_awvalid
  .s_axi_awready  (GPIO_PL_awready   ),   // output wire s_axi_awready
  .s_axi_wdata    (GPIO_PL_wdata     ),   // input wire [31 : 0] s_axi_wdata
  .s_axi_wstrb    (GPIO_PL_wstrb     ),   // input wire [3 : 0] s_axi_wstrb
  .s_axi_wvalid   (GPIO_PL_wvalid    ),   // input wire s_axi_wvalid
  .s_axi_wready   (GPIO_PL_wready    ),   // output wire s_axi_wready
  .s_axi_bresp    (GPIO_PL_bresp     ),   // output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid   (GPIO_PL_bvalid    ),   // output wire s_axi_bvalid
  .s_axi_bready   (GPIO_PL_bready    ),   // input wire s_axi_bready
  .s_axi_araddr   (GPIO_PL_araddr    ),   // input wire [8 : 0] s_axi_araddr
  .s_axi_arvalid  (GPIO_PL_arvalid   ),   // input wire s_axi_arvalid
  .s_axi_arready  (GPIO_PL_arready   ),   // output wire s_axi_arready
  .s_axi_rdata    (GPIO_PL_rdata     ),   // output wire [31 : 0] s_axi_rdata
  .s_axi_rresp    (GPIO_PL_rresp     ),   // output wire [1 : 0] s_axi_rresp
  .s_axi_rvalid   (GPIO_PL_rvalid    ),   // output wire s_axi_rvalid
  .s_axi_rready   (GPIO_PL_rready    ),   // input wire s_axi_rready
  .gpio_io_i      (gpio_io_i         ),   // input wire [31 : 0] gpio_io_i
  .gpio_io_o      (gpio_io_o         ),   // output wire [31 : 0] gpio_io_o
  .gpio_io_t      (gpio_io_t         ),   // output wire [31 : 0] gpio_io_t
  .gpio2_io_i     (gpio2_io_i        ),   // input wire [31 : 0] gpio2_io_i
  .gpio2_io_o     (gpio2_io_o        ),   // output wire [31 : 0] gpio2_io_o
  .gpio2_io_t     (gpio2_io_t        )    // output wire [31 : 0] gpio2_io_t
);

ila1 ila1 (
	.clk(clk100), // input wire clk
	.probe0(gpio_io_o[4:0]),  // input wire [4:0]  probe0  
	.probe1(gpio2_io_o[4:0])   // input wire [4:0]  probe1
);

  assign gpio_io_i  = gpio2_io_o;
  assign gpio2_io_i = gpio_io_o;

///////////////////////////////////////////////////////////////////////////////////////////////////

//  led_cnt led_cnt_inst (
//    .rst      (~rstn    ),
//    .clk100   (clk100   ),
//    .div_i    (led_div1 ),
//    .wren_i   ('0       ),
//    .led_o    (led1     ) //BLUE
//  );
///////////////////////////////////////////////////////////////////////////////////////////////////
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

  assign led_0[2] = gpio[2];
  assign led_0[1] = gpio[1];
  assign led_0[0] = gpio[0];

  assign led_1[2] = gpio2[0];
  assign led_1[1] = gpio2[1];
  assign led_1[0] = gpio2[2];





endmodule
