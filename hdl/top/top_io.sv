module top_io (
    output [2:0]    led_0,
    output [2:0]    led_1,
    inout           HD_SENSOR_I2C_SDA,
    inout           HD_SENSOR_I2C_SCL
);
///////////////////////////////////////////////////////////////////////////////////////////////////
  localparam integer ADDRW = 9; // 9 for axi iic
  localparam integer DATAW = 32;

  logic   [ADDRW-1:0]      AXIL_reg32_araddr   ,  AXIL_IIC_araddr  ,  AXIL_IIC2_araddr  ;
  logic   [2:0]            AXIL_reg32_arprot   ,  AXIL_IIC_arprot  ,  AXIL_IIC2_arprot  ;
  logic                    AXIL_reg32_arready  ,  AXIL_IIC_arready ,  AXIL_IIC2_arready ;
  logic                    AXIL_reg32_arvalid  ,  AXIL_IIC_arvalid ,  AXIL_IIC2_arvalid ;
  logic   [ADDRW-1:0]      AXIL_reg32_awaddr   ,  AXIL_IIC_awaddr  ,  AXIL_IIC2_awaddr  ;
  logic   [2:0]            AXIL_reg32_awprot   ,  AXIL_IIC_awprot  ,  AXIL_IIC2_awprot  ;
  logic                    AXIL_reg32_awready  ,  AXIL_IIC_awready ,  AXIL_IIC2_awready ;
  logic                    AXIL_reg32_awvalid  ,  AXIL_IIC_awvalid ,  AXIL_IIC2_awvalid ;
  logic                    AXIL_reg32_bready   ,  AXIL_IIC_bready  ,  AXIL_IIC2_bready  ;
  logic   [1:0]            AXIL_reg32_bresp    ,  AXIL_IIC_bresp   ,  AXIL_IIC2_bresp   ;
  logic                    AXIL_reg32_bvalid   ,  AXIL_IIC_bvalid  ,  AXIL_IIC2_bvalid  ;
  logic   [DATAW-1:0]      AXIL_reg32_rdata    ,  AXIL_IIC_rdata   ,  AXIL_IIC2_rdata   ;
  logic                    AXIL_reg32_rready   ,  AXIL_IIC_rready  ,  AXIL_IIC2_rready  ;
  logic   [1:0]            AXIL_reg32_rresp    ,  AXIL_IIC_rresp   ,  AXIL_IIC2_rresp   ;
  logic                    AXIL_reg32_rvalid   ,  AXIL_IIC_rvalid  ,  AXIL_IIC2_rvalid  ;
  logic   [DATAW-1:0]      AXIL_reg32_wdata    ,  AXIL_IIC_wdata   ,  AXIL_IIC2_wdata   ;
  logic                    AXIL_reg32_wready   ,  AXIL_IIC_wready  ,  AXIL_IIC2_wready  ;
  logic   [(DATAW/8)-1:0]  AXIL_reg32_wstrb    ,  AXIL_IIC_wstrb   ,  AXIL_IIC2_wstrb   ;
  logic                    AXIL_reg32_wvalid   ,  AXIL_IIC_wvalid  ,  AXIL_IIC2_wvalid  ;


  logic led0,led1,clk100,rst,rstn;
  logic [4:0] led_div1,p0,p1;
  logic [63:0]  git_hash_scripts,git_hash_top,git_hash_common,git_hash_sw,git_hash_ip, bd_githash;
  logic [31:0]  timestamp_scripts,timestamp_top,timestamp_common,timestamp_sw, timestamp_ip, bd_timestamp;
  logic [2:0]   gpio,gpio2;
  
  logic iic_sda_i,iic_sda_o,iic_sda_t,iic_scl_i,iic_scl_o,iic_scl_t;
  logic iic_pl_sda_i,iic_pl_sda_o,iic_pl_sda_t,iic_pl_scl_i,iic_pl_scl_o,iic_pl_scl_t;
  logic iic_bd_sda_i,iic_bd_sda_o,iic_bd_sda_t,iic_bd_scl_i,iic_bd_scl_o,iic_bd_scl_t;
  logic iic2_pl_sda_i,iic2_pl_sda_o,iic2_pl_sda_t,iic2_pl_scl_i,iic2_pl_scl_o,iic2_pl_scl_t;
///////////////////////////////////////////////////////////////////////////////////////////////////

  top_bd_wrapper top_bd_wrapper_inst (
    .M_AXI_iic_0_araddr     (AXIL_IIC_araddr    ),
    .M_AXI_iic_0_arprot     (AXIL_IIC_arprot    ),
    .M_AXI_iic_0_arready    (AXIL_IIC_arready   ),
    .M_AXI_iic_0_arvalid    (AXIL_IIC_arvalid   ),
    .M_AXI_iic_0_awaddr     (AXIL_IIC_awaddr    ),
    .M_AXI_iic_0_awprot     (AXIL_IIC_awprot    ),
    .M_AXI_iic_0_awready    (AXIL_IIC_awready   ),
    .M_AXI_iic_0_awvalid    (AXIL_IIC_awvalid   ),
    .M_AXI_iic_0_bready     (AXIL_IIC_bready    ),
    .M_AXI_iic_0_bresp      (AXIL_IIC_bresp     ),
    .M_AXI_iic_0_bvalid     (AXIL_IIC_bvalid    ),
    .M_AXI_iic_0_rdata      (AXIL_IIC_rdata     ),
    .M_AXI_iic_0_rready     (AXIL_IIC_rready    ),
    .M_AXI_iic_0_rresp      (AXIL_IIC_rresp     ),
    .M_AXI_iic_0_rvalid     (AXIL_IIC_rvalid    ),
    .M_AXI_iic_0_wdata      (AXIL_IIC_wdata     ),
    .M_AXI_iic_0_wready     (AXIL_IIC_wready    ),
    .M_AXI_iic_0_wstrb      (AXIL_IIC_wstrb     ),
    .M_AXI_iic_0_wvalid     (AXIL_IIC_wvalid    ),

    .M_AXI_iic_2_araddr     (AXIL_IIC2_araddr    ),
    .M_AXI_iic_2_arprot     (AXIL_IIC2_arprot    ),
    .M_AXI_iic_2_arready    (AXIL_IIC2_arready   ),
    .M_AXI_iic_2_arvalid    (AXIL_IIC2_arvalid   ),
    .M_AXI_iic_2_awaddr     (AXIL_IIC2_awaddr    ),
    .M_AXI_iic_2_awprot     (AXIL_IIC2_awprot    ),
    .M_AXI_iic_2_awready    (AXIL_IIC2_awready   ),
    .M_AXI_iic_2_awvalid    (AXIL_IIC2_awvalid   ),
    .M_AXI_iic_2_bready     (AXIL_IIC2_bready    ),
    .M_AXI_iic_2_bresp      (AXIL_IIC2_bresp     ),
    .M_AXI_iic_2_bvalid     (AXIL_IIC2_bvalid    ),
    .M_AXI_iic_2_rdata      (AXIL_IIC2_rdata     ),
    .M_AXI_iic_2_rready     (AXIL_IIC2_rready    ),
    .M_AXI_iic_2_rresp      (AXIL_IIC2_rresp     ),
    .M_AXI_iic_2_rvalid     (AXIL_IIC2_rvalid    ),
    .M_AXI_iic_2_wdata      (AXIL_IIC2_wdata     ),
    .M_AXI_iic_2_wready     (AXIL_IIC2_wready    ),
    .M_AXI_iic_2_wstrb      (AXIL_IIC2_wstrb     ),
    .M_AXI_iic_2_wvalid     (AXIL_IIC2_wvalid    ),

    .M_AXI_reg32_0_araddr   (AXIL_reg32_araddr  ),
    .M_AXI_reg32_0_arprot   (AXIL_reg32_arprot  ),
    .M_AXI_reg32_0_arready  (AXIL_reg32_arready ),
    .M_AXI_reg32_0_arvalid  (AXIL_reg32_arvalid ),
    .M_AXI_reg32_0_awaddr   (AXIL_reg32_awaddr  ),
    .M_AXI_reg32_0_awprot   (AXIL_reg32_awprot  ),
    .M_AXI_reg32_0_awready  (AXIL_reg32_awready ),
    .M_AXI_reg32_0_awvalid  (AXIL_reg32_awvalid ),
    .M_AXI_reg32_0_bready   (AXIL_reg32_bready  ),
    .M_AXI_reg32_0_bresp    (AXIL_reg32_bresp   ),
    .M_AXI_reg32_0_bvalid   (AXIL_reg32_bvalid  ),
    .M_AXI_reg32_0_rdata    (AXIL_reg32_rdata   ),
    .M_AXI_reg32_0_rready   (AXIL_reg32_rready  ),
    .M_AXI_reg32_0_rresp    (AXIL_reg32_rresp   ),
    .M_AXI_reg32_0_rvalid   (AXIL_reg32_rvalid  ),
    .M_AXI_reg32_0_wdata    (AXIL_reg32_wdata   ),
    .M_AXI_reg32_0_wready   (AXIL_reg32_wready  ),
    .M_AXI_reg32_0_wstrb    (AXIL_reg32_wstrb   ),
    .M_AXI_reg32_0_wvalid   (AXIL_reg32_wvalid  ),

    .bd_githash             (bd_githash     ),
    .bd_timestamp           (bd_timestamp   ),
    .sda_i_0                (iic_bd_sda_i       ),
    .sda_o_0                (iic_bd_sda_o       ),
    .sda_t_0                (iic_bd_sda_t       ),
    .scl_i_0                (iic_bd_scl_i       ),
    .scl_o_0                (iic_bd_scl_o       ),
    .scl_t_0                (iic_bd_scl_t       ),
    .clk100                 (clk100             ),
    .rst                    (rst                ),
    .periph_rstn            (rstn               ),
    .led_o_0                (led0               )
    //.git_hash_scripts_0     (git_hash_scripts   ),
    //.git_hash_top_0         (git_hash_top       ),
    //.git_hash_common_0      (git_hash_common    ),
    //.timstamp_scripts_0     (timestamp_scripts  ),
    //.timstamp_top_0         (timestamp_top      ),
    //.timstamp_common_0      (timestamp_common   )
  );


///////////////////////////////////////////////////////////////////////////////////////////////////

axi_iic_0 axi_iic_pl_inst (
  .s_axi_aclk       (clk100               ),// input wire s_axi_aclk
  .s_axi_aresetn    (rstn                 ),// input wire s_axi_aresetn
  .iic2intc_irpt    (                     ),// output wire iic2intc_irpt
  .s_axi_awaddr     (AXIL_IIC_awaddr      ), // input wire [8 : 0] s_axi_awaddr
  .s_axi_awvalid    (AXIL_IIC_awvalid     ),// input wire s_axi_awvalid
  .s_axi_awready    (AXIL_IIC_awready     ),// output wire s_axi_awready
  .s_axi_wdata      (AXIL_IIC_wdata       ),  // input wire [31 : 0] s_axi_wdata
  .s_axi_wstrb      (AXIL_IIC_wstrb       ),  // input wire [3 : 0] s_axi_wstrb
  .s_axi_wvalid     (AXIL_IIC_wvalid      ), // input wire s_axi_wvalid
  .s_axi_wready     (AXIL_IIC_wready      ), // output wire s_axi_wready
  .s_axi_bresp      (AXIL_IIC_bresp       ),  // output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid     (AXIL_IIC_bvalid      ), // output wire s_axi_bvalid
  .s_axi_bready     (AXIL_IIC_bready      ), // input wire s_axi_bready
  .s_axi_araddr     (AXIL_IIC_araddr      ), // input wire [8 : 0] s_axi_araddr
  .s_axi_arvalid    (AXIL_IIC_arvalid     ),// input wire s_axi_arvalid
  .s_axi_arready    (AXIL_IIC_arready     ),// output wire s_axi_arready
  .s_axi_rdata      (AXIL_IIC_rdata       ),  // output wire [31 : 0] s_axi_rdata
  .s_axi_rresp      (AXIL_IIC_rresp       ),  // output wire [1 : 0] s_axi_rresp
  .s_axi_rvalid     (AXIL_IIC_rvalid      ), // output wire s_axi_rvalid
  .s_axi_rready     (AXIL_IIC_rready      ), // input wire s_axi_rready
  .sda_i            (iic_pl_sda_i         ), // input wire sda_i
  .sda_o            (iic_pl_sda_o         ), // output wire sda_o
  .sda_t            (iic_pl_sda_t         ), // output wire sda_t
  .scl_i            (iic_pl_scl_i         ), // input wire scl_i
  .scl_o            (iic_pl_scl_o         ), // output wire scl_o
  .scl_t            (iic_pl_scl_t         ), // output wire scl_t
  .gpo              ()               // output wire [0 : 0] gpo
);

axi_iic_0 axi_iic2_pl_inst (
  .s_axi_aclk       (clk100               ),// input wire s_axi_aclk
  .s_axi_aresetn    (rstn                 ),// input wire s_axi_aresetn
  .iic2intc_irpt    (                     ),// output wire iic2intc_irpt
  .s_axi_awaddr     (AXIL_IIC2_awaddr      ), // input wire [8 : 0] s_axi_awaddr
  .s_axi_awvalid    (AXIL_IIC2_awvalid     ),// input wire s_axi_awvalid
  .s_axi_awready    (AXIL_IIC2_awready     ),// output wire s_axi_awready
  .s_axi_wdata      (AXIL_IIC2_wdata       ),  // input wire [31 : 0] s_axi_wdata
  .s_axi_wstrb      (AXIL_IIC2_wstrb       ),  // input wire [3 : 0] s_axi_wstrb
  .s_axi_wvalid     (AXIL_IIC2_wvalid      ), // input wire s_axi_wvalid
  .s_axi_wready     (AXIL_IIC2_wready      ), // output wire s_axi_wready
  .s_axi_bresp      (AXIL_IIC2_bresp       ),  // output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid     (AXIL_IIC2_bvalid      ), // output wire s_axi_bvalid
  .s_axi_bready     (AXIL_IIC2_bready      ), // input wire s_axi_bready
  .s_axi_araddr     (AXIL_IIC2_araddr      ), // input wire [8 : 0] s_axi_araddr
  .s_axi_arvalid    (AXIL_IIC2_arvalid     ),// input wire s_axi_arvalid
  .s_axi_arready    (AXIL_IIC2_arready     ),// output wire s_axi_arready
  .s_axi_rdata      (AXIL_IIC2_rdata       ),  // output wire [31 : 0] s_axi_rdata
  .s_axi_rresp      (AXIL_IIC2_rresp       ),  // output wire [1 : 0] s_axi_rresp
  .s_axi_rvalid     (AXIL_IIC2_rvalid      ), // output wire s_axi_rvalid
  .s_axi_rready     (AXIL_IIC2_rready      ), // input wire s_axi_rready
  .sda_i            (iic2_pl_sda_i         ), // input wire sda_i
  .sda_o            (iic2_pl_sda_o         ), // output wire sda_o
  .sda_t            (iic2_pl_sda_t         ), // output wire sda_t
  .scl_i            (iic2_pl_scl_i         ), // input wire scl_i
  .scl_o            (iic2_pl_scl_o         ), // output wire scl_o
  .scl_t            (iic2_pl_scl_t         ), // output wire scl_t
  .gpo              ()               // output wire [0 : 0] gpo
);

logic [1:0] i2c_sel;

assign iic_sda_o      = (i2c_sel == 'h1) ? iic_pl_sda_o : (i2c_sel == 'h2) ? iic2_pl_sda_o : iic_bd_sda_o;
assign iic_sda_t      = (i2c_sel == 'h1) ? iic_pl_sda_t : (i2c_sel == 'h2) ? iic2_pl_sda_t : iic_bd_sda_t;
assign iic_scl_o      = (i2c_sel == 'h1) ? iic_pl_scl_o : (i2c_sel == 'h2) ? iic2_pl_scl_o : iic_bd_scl_o;
assign iic_scl_t      = (i2c_sel == 'h1) ? iic_pl_scl_t : (i2c_sel == 'h2) ? iic2_pl_scl_t : iic_bd_scl_t;
assign iic_pl_sda_i   = (i2c_sel == 'h1) ? iic_sda_i : '1;
assign iic_pl_scl_i   = (i2c_sel == 'h1) ? iic_scl_i : '1;
assign iic2_pl_sda_i  = (i2c_sel == 'h2) ? iic_sda_i : '1;
assign iic2_pl_scl_i  = (i2c_sel == 'h2) ? iic_scl_i : '1;
assign iic_bd_sda_i   = (i2c_sel == 'h0) ? iic_sda_i : '1;
assign iic_bd_scl_i   = (i2c_sel == 'h0) ? iic_scl_i : '1;


// A logic-High on the T pin disables the output buffer
// When the output buffer is 3-stated (T = High), the input buffer is ON
IOBUF IOBUF_iic_sda (
  .O  (iic_sda_i          ),  // 1-bit output: Buffer output
  .I  (iic_sda_o          ),  // 1-bit input: Buffer input
  .IO (HD_SENSOR_I2C_SDA  ),  // 1-bit inout: Buffer inout (connect directly to top-level port)
  .T  (iic_sda_t          )   // 1-bit input: 3-state enable input
);

IOBUF IOBUF_iic_scl (
  .O  (iic_scl_i          ),  // 1-bit output: Buffer output
  .I  (iic_scl_o          ),  // 1-bit input: Buffer input
  .IO (HD_SENSOR_I2C_SCL  ),  // 1-bit inout: Buffer inout (connect directly to top-level port)
  .T  (iic_scl_t          )   // 1-bit input: 3-state enable input
);


///////////////////////////////////////////////////////////////////////////////////////////////////
//logic clk12p5;
//clk_div #(.DIV(8)) clk_div_inst (.clk_i(clk100),.clk_o(clk12p5));

//ila1 ila1 (
//	.clk(clk12p5), // input wire clk
//	.probe0({iic_sda_i,iic_sda_o,iic_sda_t,iic_scl_i,iic_scl_o,iic_scl_t}),  // input wire [5:0]  probe0  
//	.probe1()   // input wire [5:0]  probe1
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

version version_inst (
  .git_hash_scripts   (git_hash_scripts    ),
  .git_hash_top       (git_hash_top        ),
  .git_hash_common    (git_hash_common     ),
  .git_hash_sw        (git_hash_sw         ),
  .git_hash_ip        (git_hash_ip         ),
  .timestamp_scripts  (timestamp_scripts   ),
  .timestamp_top      (timestamp_top       ),
  .timestamp_common   (timestamp_common    ),
  .timestamp_sw       (timestamp_sw        ),
  .timestamp_ip       (timestamp_ip        )
);

axil_reg32 axil_reg32_inst	(
  .git_hash_scripts   (git_hash_scripts     ),
  .git_hash_top       (git_hash_top         ),
  .git_hash_bd        (bd_githash           ),
  .git_hash_common    (git_hash_common      ),
  .git_hash_sw        (git_hash_sw          ),
  .git_hash_ip        (git_hash_ip          ),
  .timestamp_scripts  (timestamp_scripts    ),
  .timestamp_top      (timestamp_top        ),
  .timestamp_bd       (bd_timestamp         ),
  .timestamp_common   (timestamp_common     ),
  .timestamp_sw       (timestamp_sw         ),
  .timestamp_ip       (timestamp_ip         ),
	.i2c_sel            (i2c_sel              ),
  .S_AXI_ACLK         (clk100               ),
	.S_AXI_ARESETN      (rstn                 ),
	.S_AXI_AWADDR       (AXIL_reg32_awaddr    ),
	.S_AXI_AWPROT       (AXIL_reg32_awprot    ),
	.S_AXI_AWVALID      (AXIL_reg32_awvalid   ),
	.S_AXI_AWREADY      (AXIL_reg32_awready   ),
	.S_AXI_WDATA        (AXIL_reg32_wdata     ),
	.S_AXI_WSTRB        (AXIL_reg32_wstrb     ),
	.S_AXI_WVALID       (AXIL_reg32_wvalid    ),
	.S_AXI_WREADY       (AXIL_reg32_wready    ),
	.S_AXI_BRESP        (AXIL_reg32_bresp     ),
	.S_AXI_BVALID       (AXIL_reg32_bvalid    ),
	.S_AXI_BREADY       (AXIL_reg32_bready    ),
	.S_AXI_ARADDR       (AXIL_reg32_araddr    ),
	.S_AXI_ARPROT       (AXIL_reg32_arprot    ),
	.S_AXI_ARVALID      (AXIL_reg32_arvalid   ),
	.S_AXI_ARREADY      (AXIL_reg32_arready   ),
	.S_AXI_RDATA        (AXIL_reg32_rdata     ),
	.S_AXI_RRESP        (AXIL_reg32_rresp     ),
	.S_AXI_RVALID       (AXIL_reg32_rvalid    ),
	.S_AXI_RREADY       (AXIL_reg32_rready    )
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

  assign led_0[2] = cnt[2];
  assign led_0[1] = cnt[1];
  assign led_0[0] = cnt[0];

  assign led_1[2] = cnt[0];
  assign led_1[1] = cnt[1];
  assign led_1[0] = cnt[2];





endmodule
