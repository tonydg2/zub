module RM_msk (
  input   clk,
  input   rst,
  output  data_o,
  output  data_val_o
);

(* dont_touch = "true" *) msk_top msk_top(
  .clk        (clk),
  .rst        (rst),
  .data_o     (data_o),
  .data_val_o (data_val_o)
);


endmodule