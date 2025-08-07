# #--------------------------------------------------------------------------------------------------
# # FIRST SUCCESS
# #--------------------------------------------------------------------------------------------------
# # static
# create_pblock pblock_1
# resize_pblock pblock_1 -add {SLICE_X0Y0:SLICE_X25Y59}
# add_cells_to_pblock pblock_1 [get_cells [list axil_reg32_inst top_bd_wrapper_inst version_inst]]
# 
# # RM_msk_inst
# create_pblock pblock_msk_top 
# resize_pblock pblock_msk_top -add SLICE_X0Y110:SLICE_X22Y179 
# resize_pblock pblock_msk_top -add DSP48E2_X0Y44:DSP48E2_X2Y71
# 
# # BRAM   1x RAMB18, 4x RAMB32
# resize_pblock pblock_msk_top -add {RAMB18_X0Y67:RAMB18_X1Y71 RAMB36_X0Y33:RAMB36_X1Y36} ;# +1/+1
# add_cells_to_pblock pblock_msk_top [get_cells [list RM_msk_inst]]
# 
# #--------------------------------------------------------------------------------------------------
# # 
# #--------------------------------------------------------------------------------------------------
##create_pblock pblock_msk_top
##resize_pblock pblock_msk_top -add CLOCKREGION_X0Y2:CLOCKREGION_X0Y2
##add_cells_to_pblock pblock_msk_top [get_cells [list RM_msk_inst]]

create_pblock pblock_msk_top 
resize_pblock pblock_msk_top -add SLICE_X0Y110:SLICE_X22Y179 
resize_pblock pblock_msk_top -add DSP48E2_X0Y44:DSP48E2_X2Y71
resize_pblock pblock_msk_top -add {RAMB18_X0Y46:RAMB18_X2Y71 RAMB36_X0Y22:RAMB36_X2Y35}
add_cells_to_pblock pblock_msk_top [get_cells [list RM_msk_inst]]

#--------------------------------------------------------------------------------------------------
# 
#--------------------------------------------------------------------------------------------------
#      # static
#      #   create_pblock pblock_1
#      #   resize_pblock pblock_1 -add {SLICE_X0Y0:SLICE_X25Y59}
#      #   add_cells_to_pblock pblock_1 [get_cells [list axil_reg32_inst top_bd_wrapper_inst version_inst]]
#
#
#      # RM_msk_inst
#      create_pblock pblock_msk_top 
#      #resize_pblock pblock_msk_top -add {SLICE_X0Y60:SLICE_X25Y179 DSP48E2_X0Y24:DSP48E2_X2Y71 RAMB18_X0Y24:RAMB18_X2Y71 RAMB36_X0Y12:RAMB36_X2Y35}
#      resize_pblock pblock_msk_top -add SLICE_X0Y110:SLICE_X22Y179 
#      resize_pblock pblock_msk_top -add DSP48E2_X0Y44:DSP48E2_X2Y71
#
#      # BRAM   1x RAMB18, 4x RAMB32
#      #resize_pblock pblock_msk_top -add {RAMB18_X0Y68:RAMB18_X1Y71 RAMB36_X0Y34:RAMB36_X1Y35} ;# 1x/4x
#      #resize_pblock pblock_msk_top -add {RAMB18_X0Y68:RAMB18_X1Y71 RAMB36_X0Y34:RAMB36_X1Y35} ;# 4x/4x
#      resize_pblock pblock_msk_top -add {RAMB18_X0Y67:RAMB18_X1Y71 RAMB36_X0Y33:RAMB36_X1Y36} ;# +1/+1
#
#      add_cells_to_pblock pblock_msk_top [get_cells [list RM_msk_inst]]
#
#
#
#      # SLICE_X0Y120:SLICE_X25Y179  DSP48E2_X0Y24:DSP48E2_X2Y71 RAMB18_X0Y48:RAMB18_X2Y71 RAMB36_X0Y24:RAMB36_X2Y35
#      # SLICE_X0Y60:SLICE_X25Y179   DSP48E2_X0Y24:DSP48E2_X2Y71 RAMB18_X0Y24:RAMB18_X2Y71 RAMB36_X0Y12:RAMB36_X2Y35
#      # SLICE_X0Y60:SLICE_X25Y179   DSP48E2_X0Y24:DSP48E2_X2Y71 RAMB18_X0Y24:RAMB18_X2Y71 RAMB36_X0Y12:RAMB36_X2Y35
#

