create_pblock led1_pb
resize_pblock led1_pb -add SLICE_X13Y49:SLICE_X16Y55
add_cells_to_pblock led1_pb [get_cells [list RM_led_inst]]


create_pblock led2_pb
#resize_pblock led2_pb -add SLICE_X13Y42:SLICE_X16Y46
resize_pblock led2_pb -add SLICE_X20Y50:SLICE_X23Y56
add_cells_to_pblock led2_pb [get_cells [list RM_led2_inst]]

