###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/coraz7s/coraz7s_system_bd.tcl

adi_project_files ad4170_asdz_coraz7s [list \
	"../../../library/common/ad_edge_detect.v" \
	"../../../library/util_cdc/sync_bits.v" \
]

# block design
source ../common/ad4170_asdz_bd.tcl

set mem_init_sys_path [get_env_param ADI_PROJECT_DIR ""]mem_init_sys.txt;

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/$mem_init_sys_path"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

sysid_gen_sys_init_file

set sys_dma_clk [get_bd_nets sys_dma_clk]
