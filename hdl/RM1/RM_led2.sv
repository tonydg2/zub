module RM_led2 (
  //input         S_BSCAN_drck        ,   
  //input         S_BSCAN_shift       ,   
  //input         S_BSCAN_tdi         ,   
  //input         S_BSCAN_update      ,   
  //input         S_BSCAN_sel         ,   
  //output        S_BSCAN_tdo         ,   
  //input         S_BSCAN_tms         ,   
  //input         S_BSCAN_tck         ,   
  //input         S_BSCAN_runtest     ,   
  //input         S_BSCAN_reset       ,   
  //input         S_BSCAN_capture     ,   
  //input         S_BSCAN_bscanid_en  ,
  input         clk           ,
  input         rst           ,
  output        led_o        
); 

  led_cnt led_cnt_inst (
    .rst    (rst  ),
    .clk100 (clk  ),
    .div_i  (5'hA ), // [4:0]
    .wren_i ('0   ),
    .led_o  (led_o)
  );


endmodule

