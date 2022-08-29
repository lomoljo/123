source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project template_zc702
adi_project_files template_zc702 [list \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zc702/zc702_system_constr.xdc" \
  "system_constr.xdc" \
  "system_top.v" ]

adi_project_run template_zc702
