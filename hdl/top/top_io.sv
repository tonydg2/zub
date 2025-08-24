module top_io (
    output [2:0]    led_0,
    output [2:0]    led_1,
    inout           HD_SENSOR_I2C_SDA,
    inout           HD_SENSOR_I2C_SCL
);

///////////////////////////////////////////////////////////////////////////////////////////////////
  logic  [16:0]    AXI_DMA_1k_araddr  ;
  logic  [1:0]     AXI_DMA_1k_arburst ;
  logic  [3:0]     AXI_DMA_1k_arcache ;
  logic  [7:0]     AXI_DMA_1k_arlen   ;
  logic  [0:0]     AXI_DMA_1k_arlock  ;
  logic  [2:0]     AXI_DMA_1k_arprot  ;
  logic  [3:0]     AXI_DMA_1k_arqos   ;
  logic            AXI_DMA_1k_arready ;
  logic  [2:0]     AXI_DMA_1k_arsize  ;
  logic            AXI_DMA_1k_arvalid ;
  logic  [16:0]    AXI_DMA_1k_awaddr  ;
  logic  [1:0]     AXI_DMA_1k_awburst ;
  logic  [3:0]     AXI_DMA_1k_awcache ;
  logic  [7:0]     AXI_DMA_1k_awlen   ;
  logic  [0:0]     AXI_DMA_1k_awlock  ;
  logic  [2:0]     AXI_DMA_1k_awprot  ;
  logic  [3:0]     AXI_DMA_1k_awqos   ;
  logic            AXI_DMA_1k_awready ;
  logic  [2:0]     AXI_DMA_1k_awsize  ;
  logic            AXI_DMA_1k_awvalid ;
  logic            AXI_DMA_1k_bready  ;
  logic  [1:0]     AXI_DMA_1k_bresp   ;
  logic            AXI_DMA_1k_bvalid  ;
  logic  [1023:0]  AXI_DMA_1k_rdata   ;
  logic            AXI_DMA_1k_rlast   ;
  logic            AXI_DMA_1k_rready  ;
  logic  [1:0]     AXI_DMA_1k_rresp   ;
  logic            AXI_DMA_1k_rvalid  ;
  logic  [1023:0]  AXI_DMA_1k_wdata   ;
  logic            AXI_DMA_1k_wlast   ;
  logic            AXI_DMA_1k_wready  ;
  logic  [127:0]   AXI_DMA_1k_wstrb   ;
  logic            AXI_DMA_1k_wvalid  ;

///////////////////////////////////////////////////////////////////////////////////////////////////
  localparam integer ADDRW = 9; // 9 for axi iic
  localparam integer DATAW = 32;

  logic   [ADDRW-1:0]      AXIL_reg32_araddr   ;
  logic   [2:0]            AXIL_reg32_arprot   ;
  logic                    AXIL_reg32_arready  ;
  logic                    AXIL_reg32_arvalid  ;
  logic   [ADDRW-1:0]      AXIL_reg32_awaddr   ;
  logic   [2:0]            AXIL_reg32_awprot   ;
  logic                    AXIL_reg32_awready  ;
  logic                    AXIL_reg32_awvalid  ;
  logic                    AXIL_reg32_bready   ;
  logic   [1:0]            AXIL_reg32_bresp    ;
  logic                    AXIL_reg32_bvalid   ;
  logic   [DATAW-1:0]      AXIL_reg32_rdata    ;
  logic                    AXIL_reg32_rready   ;
  logic   [1:0]            AXIL_reg32_rresp    ;
  logic                    AXIL_reg32_rvalid   ;
  logic   [DATAW-1:0]      AXIL_reg32_wdata    ;
  logic                    AXIL_reg32_wready   ;
  logic   [(DATAW/8)-1:0]  AXIL_reg32_wstrb    ;
  logic                    AXIL_reg32_wvalid   ;

  localparam int DMADW = 64;
  logic [DMADW-1:0]       DMA0_MM2S_0_tdata  , DMA0_S2MM_tdata   ;
  logic [(DMADW/8)-1:0]   DMA0_MM2S_0_tkeep  , DMA0_S2MM_tkeep   ;
  logic                   DMA0_MM2S_0_tlast  , DMA0_S2MM_tlast   ;
  logic                   DMA0_MM2S_0_tready , DMA0_S2MM_tready  ;
  logic                   DMA0_MM2S_0_tvalid , DMA0_S2MM_tvalid  ;

  localparam int DMADW2 = 1024;
  logic [DMADW2-1:0]      DMA_1k_MM2S_tdata  , DMA_1k_S2MM_tdata   ;
  logic [(DMADW2/8)-1:0]  DMA_1k_MM2S_tkeep  , DMA_1k_S2MM_tkeep   ;
  logic                   DMA_1k_MM2S_tlast  , DMA_1k_S2MM_tlast   ;
  logic                   DMA_1k_MM2S_tready , DMA_1k_S2MM_tready  ;
  logic                   DMA_1k_MM2S_tvalid , DMA_1k_S2MM_tvalid  ;


  logic dma0_mm2s_int, dma0_rstn;
  logic dma0_s2mm_int, dma0_s2mm_rstn;

  logic led0,led1,clk100,rst,rstn;
  logic [4:0] led_div1,p0,p1;
  logic [63:0]  git_hash_scripts,git_hash_top,git_hash_common,git_hash_sw,git_hash_ip, bd_githash;
  logic [31:0]  timestamp_scripts,timestamp_top,timestamp_common,timestamp_sw, timestamp_ip, bd_timestamp;
  logic [2:0]   gpio,gpio2;
  logic [31:0] reuse_30_x78,reuse_31_x7C;

///////////////////////////////////////////////////////////////////////////////////////////////////

  assign DMA0_MM2S_0_tready = 1;
  assign DMA_1k_MM2S_tready = 1;

  top_bd_wrapper top_bd_wrapper_inst (
    .S_AXIS_S2MM_DMA_0_tdata  (DMA0_S2MM_tdata    ),
    .S_AXIS_S2MM_DMA_0_tkeep  (DMA0_S2MM_tkeep    ),
    .S_AXIS_S2MM_DMA_0_tlast  (DMA0_S2MM_tlast    ),
    .S_AXIS_S2MM_DMA_0_tready (DMA0_S2MM_tready   ),
    .S_AXIS_S2MM_DMA_0_tvalid (DMA0_S2MM_tvalid   ),
    .M_AXIS_MM2S_0_tdata      (DMA0_MM2S_0_tdata  ),
    .M_AXIS_MM2S_0_tkeep      (DMA0_MM2S_0_tkeep  ),
    .M_AXIS_MM2S_0_tlast      (DMA0_MM2S_0_tlast  ),
    .M_AXIS_MM2S_0_tready     (DMA0_MM2S_0_tready ), //in
    .M_AXIS_MM2S_0_tvalid     (DMA0_MM2S_0_tvalid ),

    .S_AXIS_S2MM_1k_tdata     (DMA_1k_S2MM_tdata    ),
    .S_AXIS_S2MM_1k_tkeep     (DMA_1k_S2MM_tkeep    ),
    .S_AXIS_S2MM_1k_tlast     (DMA_1k_S2MM_tlast    ),
    .S_AXIS_S2MM_1k_tready    (DMA_1k_S2MM_tready   ),
    .S_AXIS_S2MM_1k_tvalid    (DMA_1k_S2MM_tvalid   ),
    .M_AXIS_MM2S_1k_tdata     (DMA_1k_MM2S_tdata    ),
    .M_AXIS_MM2S_1k_tkeep     (DMA_1k_MM2S_tkeep    ),
    .M_AXIS_MM2S_1k_tlast     (DMA_1k_MM2S_tlast    ),
    .M_AXIS_MM2S_1k_tready    (DMA_1k_MM2S_tready   ), //in
    .M_AXIS_MM2S_1k_tvalid    (DMA_1k_MM2S_tvalid   ),

    .M_AXI_DMA_1k_araddr      (AXI_DMA_1k_araddr   ),    // output    [16:0]    M_AXI_DMA_1k_araddr       
    .M_AXI_DMA_1k_arburst     (AXI_DMA_1k_arburst  ),    // output    [1:0]     M_AXI_DMA_1k_arburst       
    .M_AXI_DMA_1k_arcache     (AXI_DMA_1k_arcache  ),    // output    [3:0]     M_AXI_DMA_1k_arcache       
    .M_AXI_DMA_1k_arlen       (AXI_DMA_1k_arlen    ),    // output    [7:0]     M_AXI_DMA_1k_arlen       
    .M_AXI_DMA_1k_arlock      (AXI_DMA_1k_arlock   ),    // output    [0:0]     M_AXI_DMA_1k_arlock       
    .M_AXI_DMA_1k_arprot      (AXI_DMA_1k_arprot   ),    // output    [2:0]     M_AXI_DMA_1k_arprot       
    .M_AXI_DMA_1k_arqos       (AXI_DMA_1k_arqos    ),    // output    [3:0]     M_AXI_DMA_1k_arqos       
    .M_AXI_DMA_1k_arready     (AXI_DMA_1k_arready  ),    // input               M_AXI_DMA_1k_arready       
    .M_AXI_DMA_1k_arsize      (AXI_DMA_1k_arsize   ),    // output    [2:0]     M_AXI_DMA_1k_arsize       
    .M_AXI_DMA_1k_arvalid     (AXI_DMA_1k_arvalid  ),    // output              M_AXI_DMA_1k_arvalid       
    .M_AXI_DMA_1k_awaddr      (AXI_DMA_1k_awaddr   ),    // output    [16:0]    M_AXI_DMA_1k_awaddr       
    .M_AXI_DMA_1k_awburst     (AXI_DMA_1k_awburst  ),    // output    [1:0]     M_AXI_DMA_1k_awburst       
    .M_AXI_DMA_1k_awcache     (AXI_DMA_1k_awcache  ),    // output    [3:0]     M_AXI_DMA_1k_awcache       
    .M_AXI_DMA_1k_awlen       (AXI_DMA_1k_awlen    ),    // output    [7:0]     M_AXI_DMA_1k_awlen       
    .M_AXI_DMA_1k_awlock      (AXI_DMA_1k_awlock   ),    // output    [0:0]     M_AXI_DMA_1k_awlock       
    .M_AXI_DMA_1k_awprot      (AXI_DMA_1k_awprot   ),    // output    [2:0]     M_AXI_DMA_1k_awprot       
    .M_AXI_DMA_1k_awqos       (AXI_DMA_1k_awqos    ),    // output    [3:0]     M_AXI_DMA_1k_awqos       
    .M_AXI_DMA_1k_awready     (AXI_DMA_1k_awready  ),    // input               M_AXI_DMA_1k_awready       
    .M_AXI_DMA_1k_awsize      (AXI_DMA_1k_awsize   ),    // output    [2:0]     M_AXI_DMA_1k_awsize       
    .M_AXI_DMA_1k_awvalid     (AXI_DMA_1k_awvalid  ),    // output              M_AXI_DMA_1k_awvalid       
    .M_AXI_DMA_1k_bready      (AXI_DMA_1k_bready   ),    // output              M_AXI_DMA_1k_bready       
    .M_AXI_DMA_1k_bresp       (AXI_DMA_1k_bresp    ),    // input     [1:0]     M_AXI_DMA_1k_bresp       
    .M_AXI_DMA_1k_bvalid      (AXI_DMA_1k_bvalid   ),    // input               M_AXI_DMA_1k_bvalid       
    .M_AXI_DMA_1k_rdata       (AXI_DMA_1k_rdata    ),    // input     [1023:0]  M_AXI_DMA_1k_rdata       
    .M_AXI_DMA_1k_rlast       (AXI_DMA_1k_rlast    ),    // input               M_AXI_DMA_1k_rlast       
    .M_AXI_DMA_1k_rready      (AXI_DMA_1k_rready   ),    // output              M_AXI_DMA_1k_rready       
    .M_AXI_DMA_1k_rresp       (AXI_DMA_1k_rresp    ),    // input     [1:0]     M_AXI_DMA_1k_rresp       
    .M_AXI_DMA_1k_rvalid      (AXI_DMA_1k_rvalid   ),    // input               M_AXI_DMA_1k_rvalid       
    .M_AXI_DMA_1k_wdata       (AXI_DMA_1k_wdata    ),    // output    [1023:0]  M_AXI_DMA_1k_wdata       
    .M_AXI_DMA_1k_wlast       (AXI_DMA_1k_wlast    ),    // output              M_AXI_DMA_1k_wlast       
    .M_AXI_DMA_1k_wready      (AXI_DMA_1k_wready   ),    // input               M_AXI_DMA_1k_wready       
    .M_AXI_DMA_1k_wstrb       (AXI_DMA_1k_wstrb    ),    // output    [127:0]   M_AXI_DMA_1k_wstrb       
    .M_AXI_DMA_1k_wvalid      (AXI_DMA_1k_wvalid   ),    // output              M_AXI_DMA_1k_wvalid       


    .M_AXI_reg32_0_araddr     (AXIL_reg32_araddr  ),
    .M_AXI_reg32_0_arprot     (AXIL_reg32_arprot  ),
    .M_AXI_reg32_0_arready    (AXIL_reg32_arready ),
    .M_AXI_reg32_0_arvalid    (AXIL_reg32_arvalid ),
    .M_AXI_reg32_0_awaddr     (AXIL_reg32_awaddr  ),
    .M_AXI_reg32_0_awprot     (AXIL_reg32_awprot  ),
    .M_AXI_reg32_0_awready    (AXIL_reg32_awready ),
    .M_AXI_reg32_0_awvalid    (AXIL_reg32_awvalid ),
    .M_AXI_reg32_0_bready     (AXIL_reg32_bready  ),
    .M_AXI_reg32_0_bresp      (AXIL_reg32_bresp   ),
    .M_AXI_reg32_0_bvalid     (AXIL_reg32_bvalid  ),
    .M_AXI_reg32_0_rdata      (AXIL_reg32_rdata   ),
    .M_AXI_reg32_0_rready     (AXIL_reg32_rready  ),
    .M_AXI_reg32_0_rresp      (AXIL_reg32_rresp   ),
    .M_AXI_reg32_0_rvalid     (AXIL_reg32_rvalid  ),
    .M_AXI_reg32_0_wdata      (AXIL_reg32_wdata   ),
    .M_AXI_reg32_0_wready     (AXIL_reg32_wready  ),
    .M_AXI_reg32_0_wstrb      (AXIL_reg32_wstrb   ),
    .M_AXI_reg32_0_wvalid     (AXIL_reg32_wvalid  ),
    .mm2s_introut_0           (dma0_mm2s_int      ),
    .mm2s_prmry_reset_out_n_0 (dma0_rstn          ),
    .s2mm_introut_0           (dma0_s2mm_int      ),
    .s2mm_prmry_reset_out_n_0 (dma0_s2mm_rstn     ),
    .bd_githash               (bd_githash         ),
    .bd_timestamp             (bd_timestamp       ),
    .clk100                   (clk100             ),
    .rst                      (rst                ),
    .periph_rstn              (rstn               ),
    .led_o_0                  (led0               )
  );


  axis_stim_syn #
  (
    .TDATA_NUM_BYTES(8),
    .FIXED(56'hAFE6_0000_6600)
  ) axis_stim_syn (
    .clk		        (clk100           ) ,
    .rst            (rst              ) ,
    .en             (reuse_31_x7C[0]  ) ,
    .clr            (reuse_31_x7C[4]  ) ,
    .cycle_i        (reuse_31_x7C[8]  ) , 
    .cont_i         (reuse_31_x7C[12] ) ,
    .frame_len      (reuse_31_x7C[31:24]) ,
    .M_AXIS_tdata   (DMA0_S2MM_tdata  ) ,
    .M_AXIS_tkeep   (DMA0_S2MM_tkeep  ) ,
    .M_AXIS_tlast   (DMA0_S2MM_tlast  ) ,
    .M_AXIS_tready  (DMA0_S2MM_tready ) ,
    .M_AXIS_tvalid  (DMA0_S2MM_tvalid ) ,
    .M_AXIS_tdest   ()
  );

  axis_stim_syn #
  (
    .TDATA_NUM_BYTES  (128),
    .FIXED            (1016'h0)
  ) axis_stim_syn_1k (
    .clk		        (clk100             ) ,
    .rst            (rst                ) ,
    .en             (reuse_30_x78[0]    ) ,
    .clr            (reuse_30_x78[4]    ) ,
    .cycle_i        (reuse_30_x78[8]    ) , 
    .cont_i         (reuse_30_x78[12]   ) ,
    .frame_len      (reuse_30_x78[31:24]) ,
    .M_AXIS_tdata   (DMA_1k_S2MM_tdata  ) ,
    .M_AXIS_tkeep   (DMA_1k_S2MM_tkeep  ) ,
    .M_AXIS_tlast   (DMA_1k_S2MM_tlast  ) ,
    .M_AXIS_tready  (DMA_1k_S2MM_tready ) ,
    .M_AXIS_tvalid  (DMA_1k_S2MM_tvalid ) ,
    .M_AXIS_tdest   ()
  );

  axi_bram_ctrl_0 axi_bram_ctrl_0 (
    .s_axi_aclk     (clk100                 ),   // input wire s_axi_aclk
    .s_axi_aresetn  (rstn                   ),   // input wire s_axi_aresetn
    .s_axi_awaddr   (AXI_DMA_1k_awaddr      ),   // input wire [16 : 0] s_axi_awaddr
    .s_axi_awlen    (AXI_DMA_1k_awlen       ),   // input wire [7 : 0] s_axi_awlen
    .s_axi_awsize   (AXI_DMA_1k_awsize      ),   // input wire [2 : 0] s_axi_awsize
    .s_axi_awburst  (AXI_DMA_1k_awburst     ),   // input wire [1 : 0] s_axi_awburst
    .s_axi_awlock   (AXI_DMA_1k_awlock      ),   // input wire s_axi_awlock
    .s_axi_awcache  (AXI_DMA_1k_awcache     ),   // input wire [3 : 0] s_axi_awcache
    .s_axi_awprot   (AXI_DMA_1k_awprot      ),   // input wire [2 : 0] s_axi_awprot
    .s_axi_awvalid  (AXI_DMA_1k_awvalid     ),   // input wire s_axi_awvalid
    .s_axi_awready  (AXI_DMA_1k_awready     ),   // output wire s_axi_awready
    .s_axi_wdata    (AXI_DMA_1k_wdata       ),   // input wire [1023 : 0] s_axi_wdata
    .s_axi_wstrb    (AXI_DMA_1k_wstrb       ),   // input wire [127 : 0] s_axi_wstrb
    .s_axi_wlast    (AXI_DMA_1k_wlast       ),   // input wire s_axi_wlast
    .s_axi_wvalid   (AXI_DMA_1k_wvalid      ),   // input wire s_axi_wvalid
    .s_axi_wready   (AXI_DMA_1k_wready      ),   // output wire s_axi_wready
    .s_axi_bresp    (AXI_DMA_1k_bresp       ),   // output wire [1 : 0] s_axi_bresp
    .s_axi_bvalid   (AXI_DMA_1k_bvalid      ),   // output wire s_axi_bvalid
    .s_axi_bready   (AXI_DMA_1k_bready      ),   // input wire s_axi_bready
    .s_axi_araddr   (AXI_DMA_1k_araddr      ),   // input wire [16 : 0] s_axi_araddr
    .s_axi_arlen    (AXI_DMA_1k_arlen       ),   // input wire [7 : 0] s_axi_arlen
    .s_axi_arsize   (AXI_DMA_1k_arsize      ),   // input wire [2 : 0] s_axi_arsize
    .s_axi_arburst  (AXI_DMA_1k_arburst     ),   // input wire [1 : 0] s_axi_arburst
    .s_axi_arlock   (AXI_DMA_1k_arlock      ),   // input wire s_axi_arlock
    .s_axi_arcache  (AXI_DMA_1k_arcache     ),   // input wire [3 : 0] s_axi_arcache
    .s_axi_arprot   (AXI_DMA_1k_arprot      ),   // input wire [2 : 0] s_axi_arprot
    .s_axi_arvalid  (AXI_DMA_1k_arvalid     ),   // input wire s_axi_arvalid
    .s_axi_arready  (AXI_DMA_1k_arready     ),   // output wire s_axi_arready
    .s_axi_rdata    (AXI_DMA_1k_rdata       ),   // output wire [1023 : 0] s_axi_rdata
    .s_axi_rresp    (AXI_DMA_1k_rresp       ),   // output wire [1 : 0] s_axi_rresp
    .s_axi_rlast    (AXI_DMA_1k_rlast       ),   // output wire s_axi_rlast
    .s_axi_rvalid   (AXI_DMA_1k_rvalid      ),   // output wire s_axi_rvalid
    .s_axi_rready   (AXI_DMA_1k_rready      )    // input wire s_axi_rready
  );



///////////////////////////////////////////////////////////////////////////////////////////////////
//logic clk12p5;
//clk_div #(.DIV(8)) clk_div_inst (.clk_i(clk100),.clk_o(clk12p5));


ila1 ila1_inst (
	.clk    (clk100), // input wire clk
	.probe0 (DMA0_MM2S_0_tdata),
	.probe1 (DMA0_S2MM_tdata),
	.probe2 ({DMA0_S2MM_tlast,    DMA0_S2MM_tready,   DMA0_S2MM_tvalid}),
  .probe3 ({DMA0_MM2S_0_tlast,  DMA0_MM2S_0_tready, DMA0_MM2S_0_tvalid}),
  .probe4 ({reuse_31_x7C[0],reuse_31_x7C[4],reuse_31_x7C[8],reuse_31_x7C[12]})
);

ila1 ila1_dma_1k (
	.clk    (clk100), // input wire clk
	.probe0 (DMA_1k_MM2S_tdata[63:0]),
	.probe1 (DMA_1k_S2MM_tdata[63:0]),
	.probe2 ({DMA_1k_S2MM_tlast,  DMA_1k_S2MM_tready, DMA_1k_S2MM_tvalid  }),
  .probe3 ({DMA_1k_MM2S_tlast,  DMA_1k_MM2S_tready, DMA_1k_MM2S_tvalid}),
  .probe4 ({reuse_30_x78[0],reuse_30_x78[4],reuse_30_x78[8],reuse_30_x78[12]})
);


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
  .reuse_30_x78       (reuse_30_x78         ),
  .reuse_31_x7C       (reuse_31_x7C         ),
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


///////////////////////////////////////////////////////////////////////////////////////////////////



endmodule
