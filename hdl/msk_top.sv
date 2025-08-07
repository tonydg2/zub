module msk_top (
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
  input  [7:0]  axis_tkeep   
);
/*
  logic [7:0] cntr=0;

  always_ff @(posedge clk) begin
    if (rst) cntr <= '0;
    else cntr <= cntr + 1;    
  end

  ila1 ila1_0 (
  	.clk    (clk),
  	.probe0 ('0),
  	.probe1 (cntr),//DMA0_MM2S_0_tkeep),
  	.probe2 ('0)
  );
*/


///////////////////////////////////////////////////////////////////////////////////////////////////

//  1st sample: axis_tdata[15:0] 
//  2nd sample: axis_tdata[31:16] 
//  3rd sample: axis_tdata[47:32] 
//  4th sample: axis_tdata[63:48] 
  
  logic [63:0]  fifo_axis_tdata;
  logic [7:0]   fifo_axis_tkeep;
  logic [15:0]  m_axis_tdata;
  logic [1:0]   m_axis_tkeep;
  logic m_axis_tvalid,m_axis_tready,m_axis_tlast,fifo_axis_tvalid,fifo_axis_tready,fifo_axis_tlast;

(* dont_touch = "true" *)fifo_gen_0 fifo_gen_0 (
  .s_aclk         (clk              ),  // input wire s_aclk
  .s_aresetn      (~rst             ),  // input wire s_aresetn
  .s_axis_tvalid  (axis_tvalid      ),  // input wire s_axis_tvalid
  .s_axis_tready  (axis_tready      ),  // output wire s_axis_tready
  .s_axis_tdata   (axis_tdata       ),  // input wire [63 : 0] s_axis_tdata
  .s_axis_tkeep   (axis_tkeep       ),  // input wire [7 : 0] s_axis_tkeep
  .s_axis_tlast   (axis_tlast       ),  // input wire s_axis_tlast
  .m_axis_tvalid  (fifo_axis_tvalid ),  // output wire m_axis_tvalid
  .m_axis_tready  (fifo_axis_tready ),  // input wire m_axis_tready
  .m_axis_tdata   (fifo_axis_tdata  ),  // output wire [63 : 0] m_axis_tdata
  .m_axis_tkeep   (fifo_axis_tkeep  ),  // output wire [7 : 0] m_axis_tkeep
  .m_axis_tlast   (fifo_axis_tlast  )   // output wire m_axis_tlast
);


(* dont_touch = "true" *)axis_dwidth_converter_8x2 axis_dwidth_converter_8x2 (
  .aclk           (clk              ),  // input wire aclk
  .aresetn        (~rst             ),  // input wire aresetn
  .s_axis_tvalid  (fifo_axis_tvalid ),  // input wire s_axis_tvalid
  .s_axis_tready  (fifo_axis_tready ),  // output wire s_axis_tready
  .s_axis_tdata   (fifo_axis_tdata  ),  // input wire [63 : 0] s_axis_tdata
  .s_axis_tkeep   (fifo_axis_tkeep  ),  // input wire [7 : 0] s_axis_tkeep
  .s_axis_tlast   (fifo_axis_tlast  ),  // input wire s_axis_tlast
  .m_axis_tvalid  (m_axis_tvalid    ),  // output wire m_axis_tvalid
  .m_axis_tready  (m_axis_tready    ),  // input wire m_axis_tready
  .m_axis_tdata   (m_axis_tdata     ),  // output wire [15 : 0] m_axis_tdata
  .m_axis_tkeep   (m_axis_tkeep     ),  // output wire [1 : 0] m_axis_tkeep
  .m_axis_tlast   (m_axis_tlast     )   // output wire m_axis_tlast
);

  ila1 ila1_msk_inst (
  	.clk    (clk),
  	.probe0 ({48'h0,m_axis_tdata}),
  	.probe1 ({6'h0,m_axis_tkeep}),//DMA0_MM2S_0_tkeep),
  	.probe2 ({m_axis_tlast,m_axis_tready,m_axis_tvalid,'0,'0})
  );


  assign m_axis_tready = '1;
///////////////////////////////////////////////////////////////////////////////////////////////////

  localparam IQW = 16;
  logic signed [IQW-1:0] i_ddc, q_ddc, i_raw, q_raw;
  logic rstn;
  assign rstn = ~rst;

(* dont_touch = "true" *) duc_ddc_lpf_top #(
    .DUC_EN(0),
    .DDC_EN(1),
    .FS(200e6)
  ) duc_ddc_lpf_top (
    .clk      (clk),
    .rst      (rst),
    //DDC
    .adc_in   ('0), // from ADC
    .adc_val  ('1),
    .I_out    (i_ddc), // to demod
    .Q_out    (q_ddc), // to demod
    .IQ_val   (ddc_val),
    //DUC
    .I_in     (), // from modulator
    .Q_in     (), // from modulator
    .dac_out  ()  // to DAC
  );

  localparam int WERR   = 18;
  logic signed  [WERR-1:0]  ek, lf_ctrl;


(* dont_touch = "true" *) gardner_ted #(
    .RAW_DLY  (5), // adjusted here to 5 to stabilize coarse CFO. need repeat data sequence of "0011" / "00001111" 
    .OSF      (20),
    .WI       (16),
    .WO       (18)
  ) gardner_ted (
    .clk          (clk      ),
    .reset_n      (rstn     ),
    .i_in         (i_ddc    ),//mf_I         ),
    .q_in         (q_ddc    ),//mf_Q         ),
    .iq_val       (ddc_val  ),//mf_val       ),
    .sym_valid_i  (sym_val  ),
    .e_out_o      (ek       ),
    .e_valid_o    (ek_val   ),
    .i_raw_delay_o(i_raw    ),
    .q_raw_delay_o(q_raw    )
  );

(* dont_touch = "true" *) pi_loop_filter #(
    .KP_SHIFT  (7 ),
    .KI_SHIFT  (11),
    .WERR      (WERR),
    .ACC_WIDTH (24)
  ) pi_loop_filter (
    .clk        (clk          ),
    .reset_n    (rstn         ),
    .e_in_i     (ek           ),
    .e_valid_i  (ek_val       ),
    .ctrl_o     (lf_ctrl      ),
    .ctrl_val_o (lf_ctrl_val  )
  );

  localparam int INT_W  = 5;
  localparam int FRAC_W = 27;
  logic [INT_W-1:0]   phase_int;
  logic [FRAC_W-1:0]  mu;

(* dont_touch = "true" *) phase_accum #(
    .OSF       (20),
    .CTRL_W    (WERR),
    .INT_W     (INT_W),
    .FRAC_W    (FRAC_W)
  ) phase_accum (
    .clk          (clk        ),
    .reset_n      (rstn       ),
    .ctrl_i       (lf_ctrl    ),
    .ctrl_val_i   (lf_ctrl_val),
    .sym_valid_o  (sym_val    ),
    .phase_int_o  (phase_int  ),
    .mu_o         (mu         ),
    .phase_val_o  (phase_val  )
  );


  localparam int WIQ    = IQW;
  localparam PIW = 16;
  logic signed [PIW-1:0] i_sym_interp, q_sym_interp;

(* dont_touch = "true" *) polyphase_interp #(
    .OSF       (20),
    .TAPS_PPH  (INT_W ),
    .WIQ       (WIQ),
    .WO        (PIW)
  ) polyphase_interp (
    .clk          (clk            ),
    .rst          (rst            ),
    .i_raw_i      (i_raw          ),
    .q_raw_i      (q_raw          ),
    .iq_raw_val_i (ddc_val        ), 
    .phase_int_i  (phase_int      ),
    .mu_i         (mu             ),
    .phase_val_i  (phase_val      ),
    .sym_valid_i  (sym_val        ),
    .i_sym_o      (i_sym_interp   ),
    .q_sym_o      (q_sym_interp   ),
    .sym_valid_o  (sym_val_interp )
  );

//-------------------------------------------------------------------------------------------------
// COARSE CFO HERE
//-------------------------------------------------------------------------------------------------



  localparam DIW = 16;
  localparam DDSW = 16;
  localparam PW = 32;

  logic signed [DIW-1:0] derot_i, derot_q;
  logic signed [DDSW-1:0] dds_sin, dds_cos;

(* dont_touch = "true" *) derotator #(
    .WIDTH        (DIW),
    .DDS_WIDTH    (DDSW),
    .PHASE_WIDTH  (PW)
  ) derotator (
    .clk            (clk),
    .rst            (rst),            
    .sym_valid_in   (sym_val_interp),// && cfo_en), 
    .din_i          (i_sym_interp ),
    .din_q          (q_sym_interp ),
    .cos_in         (dds_cos      ),
    .sin_in         (dds_sin      ),
    .sym_valid_out  (derot_val    ),  
    .dout_i         (derot_i      ),
    .dout_q         (derot_q      )
  );


  localparam EW = 24;
  logic signed [EW-1:0] pdet_err;

(* dont_touch = "true" *) phase_detector #(
    .IW (DIW), 
    .EW (EW)  
  ) phase_detector (
    .clk        (clk),
    .rst        (rst),
    .sym_valid  (derot_val),// && cfo_en),
    .din_i      (derot_i),
    .din_q      (derot_q),
    .err_valid  (pdet_err_val),
    .phase_err  (pdet_err)
  );


  logic signed [PW-1:0] freq_word;

(* dont_touch = "true" *) loop_filter_cfo #(
    .ERR_WIDTH   (EW ), 
    .PHASE_WIDTH (PW ), 
    .KP_SHIFT    (22 ), 
    .KI_SHIFT    (22 ),
    .KP_COEFF    (322), 
    .KI_COEFF    (55 )  
  ) loop_filter_cfo (
    .clk          (clk),
    .rst          (rst),
    .err_valid_i  (pdet_err_val ),
    .phase_err_i  (pdet_err     ),
    .freq_valid_o (freq_word_val),
    .freq_word_o  (freq_word    )
  );


(* dont_touch = "true" *) nco_dds #(
    .PHASE_WIDTH  (32),
    .AMP_WIDTH    (16) 
  ) nco_dds (
    .clk              (clk),
    .rst              (rst),
    .freq_word_i      (freq_word), 
    .freq_word_val_i  (freq_word_val),
    .phase_word_o     (),   
    .cos_out          (dds_cos),   
    .sin_out          (dds_sin)    
  );

(* dont_touch = "true" *) msk_slicer_dec #(
    .IW (PIW)
  ) msk_slicer_dec_SYN(
    .clk          (clk          ),
    .reset_n      (reset_n      ),
    .i_sym_i      (derot_i      ),
    .q_sym_i      (derot_q      ),
    .sym_valid_i  (derot_val    ),
    .data_o       (data_o       ),
    .data_valid_o (data_val_o   )
  );



///////////////////////////////////////////////////////////////////////////////////////////////////
  user_init_64b msk_modem_git_hash_inst (
    .clk      (1'b0),
    .value_o  (msk_gh)
  );

  user_init_32b msk_modem_timestamp_inst (
    .clk      (1'b0),
    .value_o  (msk_ts)
  );

endmodule