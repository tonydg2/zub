module top_io (
    output [2:0]    led_0,
    output [2:0]    led_1,
    inout           HD_SENSOR_I2C_SDA,
    inout           HD_SENSOR_I2C_SCL
);
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

  logic [63:0] DMA0_MM2S_0_tdata , axis_msk_tdata   ;
  logic [7:0]  DMA0_MM2S_0_tkeep , axis_msk_tkeep   ;
  logic        DMA0_MM2S_0_tlast , axis_msk_tlast   ;
  logic        DMA0_MM2S_0_tready, axis_msk_tready  ;
  logic        DMA0_MM2S_0_tvalid, axis_msk_tvalid  ;
  
  logic dma0_mm2s_int, dma0_rstn;

  logic led0,led1,clk100,rst,rstn;
  logic [4:0] led_div1,p0,p1;
  logic [63:0]  git_hash_scripts,git_hash_top,git_hash_common,git_hash_sw,git_hash_ip, bd_githash, msk_gh;
  logic [31:0]  timestamp_scripts,timestamp_top,timestamp_common,timestamp_sw, timestamp_ip, bd_timestamp,msk_ts;
  logic [2:0]   gpio,gpio2;
  
///////////////////////////////////////////////////////////////////////////////////////////////////

  //assign DMA0_MM2S_0_tready = 1;

  top_bd_wrapper top_bd_wrapper_inst (
    .M_AXIS_MM2S_0_tdata    (DMA0_MM2S_0_tdata  ),
    .M_AXIS_MM2S_0_tkeep    (DMA0_MM2S_0_tkeep  ),
    .M_AXIS_MM2S_0_tlast    (DMA0_MM2S_0_tlast  ),
    .M_AXIS_MM2S_0_tready   (DMA0_MM2S_0_tready ), //in
    .M_AXIS_MM2S_0_tvalid   (DMA0_MM2S_0_tvalid ),
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
    .mm2s_introut_0           (dma0_mm2s_int    ),
    .mm2s_prmry_reset_out_n_0 (dma0_rstn        ),
    .bd_githash             (bd_githash         ),
    .bd_timestamp           (bd_timestamp       ),
    .clk100                 (clk100             ),
    .rst                    (rst                ),
    .periph_rstn            (rstn               ),
    .led_o_0                (led0               )
  );

///////////////////////////////////////////////////////////////////////////////////////////////////

  ICAPE3 #(
    .DEVICE_ID          (32'h03628093), // Specifies the pre-programmed Device ID value to be used for simulation purposes.
    .ICAP_AUTO_SWITCH   ("DISABLE"), // Enable switch ICAP using sync word.
    .SIM_CFG_FILE_NAME  ("NONE") // Specifies the Raw Bitstream (RBT) file to be parsed by the simulation model.
  ) ICAPE3_inst (
    .AVAIL    (),         // 1-bit output: Availability status of ICAP.
    .O        (),         // 32-bit output: Configuration data output bus.
    .PRDONE   (prdone),   // 1-bit output: Indicates completion of Partial Reconfiguration.
    .PRERROR  (prerror),  // 1-bit output: Indicates error during Partial Reconfiguration.
    .CLK      (clk),      // 1-bit input: Clock input.
    .CSIB     (1),        // 1-bit input: Active-Low ICAP enable.
    .I        (0),        // 32-bit input: Configuration data input bus.
    .RDWRB    (0)         // 1-bit input: Read/Write Select input.
  );

///////////////////////////////////////////////////////////////////////////////////////////////////
//logic clk12p5;
//clk_div #(.DIV(8)) clk_div_inst (.clk_i(clk100),.clk_o(clk12p5));

ila1 ila1_inst (
	.clk    (clk100),
	.probe0 (DMA0_MM2S_0_tdata),
	.probe1 (DMA0_MM2S_0_tkeep),
	.probe2 ({DMA0_MM2S_0_tlast,DMA0_MM2S_0_tready,DMA0_MM2S_0_tvalid,dma0_mm2s_int,dma0_rstn})
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
  .dfx_decouple       (decouple),
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
  .git_hash_msk       (msk_gh               ),
  .timestamp_msk      (msk_ts               ),
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

dfx_decoupler_axis_src dfx_decoupler_axis_src (
  .rp_axis_TVALID (DMA0_MM2S_0_tvalid   ),  // input wire rp_axis_TVALID
  .rp_axis_TREADY (DMA0_MM2S_0_tready   ),  // output wire rp_axis_TREADY
  .rp_axis_TDATA  (DMA0_MM2S_0_tdata    ),  // input wire [31 : 0] rp_axis_TDATA
  .rp_axis_TLAST  (DMA0_MM2S_0_tlast    ),  // input wire rp_axis_TLAST
  .rp_axis_TKEEP  (DMA0_MM2S_0_tkeep    ),  // input wire [3 : 0] rp_axis_TKEEP
  .s_axis_TVALID  (axis_msk_tvalid      ),  // output wire s_axis_TVALID
  .s_axis_TREADY  (axis_msk_tready      ),  // input wire s_axis_TREADY
  .s_axis_TDATA   (axis_msk_tdata       ),  // output wire [31 : 0] s_axis_TDATA
  .s_axis_TLAST   (axis_msk_tlast       ),  // output wire s_axis_TLAST
  .s_axis_TKEEP   (axis_msk_tkeep       ),  // output wire [3 : 0] s_axis_TKEEP
  .decouple       (decouple             )   // input wire decouple
);

(* DONT_TOUCH = "TRUE", KEEP_HIERARCHY = "TRUE" *)  RM_msk RM_msk_inst(
  .clk        (clk100         ),
  .rst        (rst            ),
  .msk_gh     (msk_gh         ),
  .msk_ts     (msk_ts         ),
  .data_o     (msk_data       ),
  .data_val_o (msk_data_val   ),
  .axis_tvalid(axis_msk_tvalid),
  .axis_tready(axis_msk_tready),
  .axis_tdata (axis_msk_tdata ),
  .axis_tlast (axis_msk_tlast ),
  .axis_tkeep (axis_msk_tkeep ),
  .S_BSCAN_drck       (), // in
  .S_BSCAN_shift      (), // in
  .S_BSCAN_tdi        (), // in
  .S_BSCAN_update     (), // in
  .S_BSCAN_sel        (), // in
  .S_BSCAN_tdo        (), // out
  .S_BSCAN_tms        (), // in
  .S_BSCAN_tck        (), // in
  .S_BSCAN_runtest    (), // in
  .S_BSCAN_reset      (), // in
  .S_BSCAN_capture    (), // in
  .S_BSCAN_bscanid_en ()  // in

);

//(* dont_touch = "true" *) msk_top msk_top2(
//  .clk        (clk100 ),
//  .rst        (rst    ),
//  .data_o     (),
//  .data_val_o ()
//);


/*
  localparam shifterWid = 128;
  localparam int FDW = 256;
  localparam logic [FDW-1:0] FIXED_DATA = 'h901000000033000000FFFFFFFF010000007700ffff00000001010000ffa50ffe;

(* dont_touch = "true" *) shifter_viewer # (
    .FDW(FDW),
    .FIXED_DATA(FIXED_DATA),
    .WIDTH(shifterWid)
  ) shifter_viewer_SYN (
    .clk        (clk),
    .rst        (!rst),
    .data_i     (msk_data     ),
    .data_val_i (msk_data_val )
  );
*/

endmodule

// blackbox for DFX required
module RM_msk (
  input         clk           ,
  input         rst           ,
  output [63:0] msk_gh        ,
  output [31:0] msk_ts        ,
  output        data_o        ,
  output        data_val_o    ,
  input         axis_tvalid   ,
  output        axis_tready   ,
  input  [63:0] axis_tdata    , 
  input         axis_tlast    , 
  input  [7:0]  axis_tkeep    ,
  input         S_BSCAN_drck        ,   
  input         S_BSCAN_shift       ,   
  input         S_BSCAN_tdi         ,   
  input         S_BSCAN_update      ,   
  input         S_BSCAN_sel         ,   
  output        S_BSCAN_tdo         ,   
  input         S_BSCAN_tms         ,   
  input         S_BSCAN_tck         ,   
  input         S_BSCAN_runtest     ,   
  input         S_BSCAN_reset       ,   
  input         S_BSCAN_capture     ,   
  input         S_BSCAN_bscanid_en     
); endmodule
