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
); 

(* DONT_TOUCH = "TRUE", KEEP_HIERARCHY = "TRUE" *)  msk_top msk_top_inst(
  .clk        (clk          ),
  .rst        (rst          ),
  .msk_gh     (msk_gh       ),
  .msk_ts     (msk_ts       ),
  .data_o     (data_o       ),
  .data_val_o (data_val_o   ),
  .axis_tvalid(axis_tvalid  ),
  .axis_tready(axis_tready  ),
  .axis_tdata (axis_tdata   ),
  .axis_tlast (axis_tlast   ),
  .axis_tkeep (axis_tkeep   )
);


endmodule



 