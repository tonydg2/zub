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

  logic [63:0] DMA0_MM2S_0_tdata  , DMA0_S2MM_tdata   ;
  logic [7:0]  DMA0_MM2S_0_tkeep  , DMA0_S2MM_tkeep   ;
  logic        DMA0_MM2S_0_tlast  , DMA0_S2MM_tlast   ;
  logic        DMA0_MM2S_0_tready , DMA0_S2MM_tready  ;
  logic        DMA0_MM2S_0_tvalid , DMA0_S2MM_tvalid  ;
  
  logic dma0_mm2s_int, dma0_rstn;
  logic dma0_s2mm_int, dma0_s2mm_rstn;

  logic led0,led1,clk100,rst,rstn;
  logic [4:0] led_div1,p0,p1;
  logic [63:0]  git_hash_scripts,git_hash_top,git_hash_common,git_hash_sw,git_hash_ip, bd_githash;
  logic [31:0]  timestamp_scripts,timestamp_top,timestamp_common,timestamp_sw, timestamp_ip, bd_timestamp;
  logic [2:0]   gpio,gpio2;
  logic [31:0] reuse_31_x7C;

///////////////////////////////////////////////////////////////////////////////////////////////////

  assign DMA0_MM2S_0_tready = 1;

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
    .clk		        (clk100           )  ,
    .rst            (rst              )  ,
    .en             (reuse_31_x7C[0]  )  ,
    .clr            (reuse_31_x7C[4]  )  ,
    .cycle          (reuse_31_x7C[8]  )  , 
    .cont           (reuse_31_x7C[12] )  ,
    .M_AXIS_tdata   (DMA0_S2MM_tdata  )  ,
    .M_AXIS_tdest   (                 )  ,
    .M_AXIS_tkeep   (DMA0_S2MM_tkeep  )  ,
    .M_AXIS_tlast   (DMA0_S2MM_tlast  )  ,
    .M_AXIS_tready  (DMA0_S2MM_tready )  ,
    .M_AXIS_tvalid  (DMA0_S2MM_tvalid )
  );

/*
  logic [63:0] cnt_dma = 64'hA5E6_0000_0000_0000;

  always_ff @(posedge clk100) begin
    // optional reset here

    if (DMA0_S2MM_tready || !DMA0_S2MM_tvalid) begin
      // Produce next beat
      DMA0_S2MM_tdata  <= cnt_dma;
      DMA0_S2MM_tkeep  <= 8'hFF;
      DMA0_S2MM_tvalid <= '1;
      DMA0_S2MM_tlast  <= (cnt_dma[5:0] == 6'd63) ? '1 : '0;

      // Increment with wrap
      if (cnt_dma == 64'hA5E6_FFFF_FFFF_FFFF)
        cnt_dma <= 64'hA5E6_0000_0000_0000;
      else
        cnt_dma <= cnt_dma + 64'd1;
    end
    // else: hold all outputs and cnt_dma implicitly (nonblocking regs keep last values)
  end
*/
///////////////////////////////////////////////////////////////////////////////////////////////////
//logic clk12p5;
//clk_div #(.DIV(8)) clk_div_inst (.clk_i(clk100),.clk_o(clk12p5));


ila1 ila1_inst (
	.clk    (clk100), // input wire clk
	.probe0 (DMA0_MM2S_0_tdata),
	.probe1 (DMA0_S2MM_tdata),
	.probe2 ({DMA0_MM2S_0_tkeep,DMA0_S2MM_tkeep}),
  .probe3 ({DMA0_MM2S_0_tlast,DMA0_MM2S_0_tready,DMA0_MM2S_0_tvalid,dma0_mm2s_int,dma0_rstn}),
  .probe4 ({DMA0_S2MM_tlast,DMA0_S2MM_tready,DMA0_S2MM_tvalid,dma0_s2mm_int,dma0_s2mm_rstn}),
  .probe5 (reuse_31_x7C)
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
  .reuse_30_x78       (),
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





endmodule
