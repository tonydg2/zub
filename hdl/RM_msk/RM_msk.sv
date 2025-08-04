module RM_msk (
  input         clk           ,
  input         rst           ,
  output        data_o        ,
  output        data_val_o    ,
  input         axis_tvalid   ,
  output        axis_tready   ,
  input  [63:0] axis_tdata    , 
  input         axis_tlast    , 
  input  [7:0]  axis_tkeep   
);

(* dont_touch = "true" *) msk_top msk_top(
  .clk        (clk          ),
  .rst        (rst          ),
  .data_o     (data_o       ),
  .data_val_o (data_val_o   ),
  .axis_tvalid(axis_tvalid  ),
  .axis_tready(axis_tready  ),
  .axis_tdata (axis_tdata   ),
  .axis_tlast (axis_tlast   ),
  .axis_tkeep (axis_tkeep   )
);


endmodule



 