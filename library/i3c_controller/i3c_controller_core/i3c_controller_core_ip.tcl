source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

adi_ip_create i3c_controller_core
adi_ip_files i3c_controller_core [list \
	"i3c_controller_core_constr.ttcl" \
	"i3c_controller_core.v" \
	"i3c_controller_framing.v" \
	"i3c_controller_daa.v" \
	"i3c_controller_phy_sda.v" \
	"i3c_controller_word.v" \
 	"i3c_controller_word_cmd.v" \
	"i3c_controller_bit_mod.v" \
 	"i3c_controller_bit_mod_cmd.v" \
	"i3c_controller_clk_div.v" \
]

adi_ip_properties_lite i3c_controller_core
adi_ip_ttcl i3c_controller_core "i3c_controller_core_constr.ttcl"

set_property company_url {https://wiki.analog.com/resources/fpga/peripherals/i3c_controller/core} [ipx::current_core]

# Remove all inferred interfaces
ipx::remove_all_bus_interface [ipx::current_core]

## Interface definitions
adi_add_bus "i3c" "master" \
	"analog.com:interface:i3c_controller_rtl:1.0" \
	"analog.com:interface:i3c_controller:1.0" \
	{
		{"scl" "SCL"} \
		{"sda" "SDA"} \
	}
adi_add_bus_clock "clk" "i3c" "reset_n"

adi_add_bus "cmdp" "slave" \
	"analog.com:interface:i3c_controller_cmdp_rtl:1.0" \
	"analog.com:interface:i3c_controller_cmdp:1.0" \
	{
		{"cmdp_valid"        "CMDP_VALID"} \
		{"cmdp_ready"        "CMDP_READY"} \
		{"cmdp_ccc"          "CMDP_CCC"} \
		{"cmdp_ccc_bcast"    "CMDP_CCC_BCAST"} \
		{"cmdp_ccc_id"       "CMDP_CCC_ID"} \
		{"cmdp_bcast_header" "CMD_BCAST_HEADER"} \
		{"cmdp_xmit"         "CMDP_XMIT"} \
		{"cmdp_sr"           "CMDP_SR"} \
		{"cmdp_buffer_len"   "CMDP_BUFFER_LEN"} \
		{"cmdp_da"           "CMDP_DA"} \
		{"cmdp_rnw"          "CMDP_RNW"} \
		{"cmdp_do_daa"       "CMDP_DO_DAA"} \
		{"cmdp_do_daa_ready" "CMDP_DO_DAA_READY"} \
		{"cmdp_cancelled"    "CMDP_CANCELLED"} \
	}
adi_add_bus_clock "clk" "cmdp" "reset_n"

adi_add_bus "sdio" "slave" \
	"analog.com:interface:i3c_controller_sdio_rtl:1.0" \
	"analog.com:interface:i3c_controller_sdio:1.0" \
	{
		{"sdo_ready" "SDO_READY"} \
		{"sdo_valid" "SDO_VALID"} \
		{"sdo"       "SDO_DATA"} \
		{"sdi_ready" "SDI_READY"} \
		{"sdi_valid" "SDI_VALID"} \
		{"sdi"       "SDI_DATA"} \
	}
adi_add_bus_clock "clk" "sdio" "reset_n"

adi_add_bus "rmap" "slave" \
	"analog.com:interface:i3c_controller_rmap_rtl:1.0" \
	"analog.com:interface:i3c_controller_rmap:1.0" \
	{
		{"rmap_daa_status_in_progress" "RMAP_DAA_STATUS_IN_PROGRESS"} \
		{"rmap_daa_status_registered"  "RMAP_DAA_STATUS_REGISTERED"} \
		{"rmap_daa_peripheral_index"   "RMAP_DAA_PERIPHERAL_INDEX"} \
		{"rmap_daa_peripheral_da"      "RMAP_DAA_PERIPHERAL_DA"} \
	}
adi_add_bus_clock "i3c_clk" "rmap" "i3c_reset_n" "master"

adi_set_ports_dependency "clk_bus" \
      "(spirit:decode(id('MODELPARAM_VALUE.ASYNC_I3C_CLK')) = 1)"

## Parameter validations

set cc [ipx::current_core]

## ASYNC_I3C_CLK
set_property -dict [list \
  "value_format" "bool" \
  "value" "false" \
 ] \
 [ipx::get_user_parameters ASYNC_I3C_CLK -of_objects $cc]
set_property -dict [list \
  "value_format" "bool" \
  "value" "false" \
 ] \
 [ipx::get_hdl_parameters ASYNC_I3C_CLK -of_objects $cc]

## Customize IP Layout
## Remove the automatically generated GUI page
ipgui::remove_page -component $cc [ipgui::get_pagespec -name "Page 0" -component $cc]
ipx::save_core [ipx::current_core]

## Create general configuration page
ipgui::add_page -name {I3C Controller Core} -component [ipx::current_core] -display_name {AXI I3C Controller Core}
set page0 [ipgui::get_pagespec -name "I3C Controller Core" -component $cc]

set general_group [ipgui::add_group -name "General Configuration" -component $cc \
    -parent $page0 -display_name "General Configuration" ]

ipgui::add_param -name "ASYNC_I3C_CLK" -component $cc -parent $general_group
set_property -dict [list \
  "display_name" "Asynchronous core clock" \
  "tooltip" "\[ASYNC_I3C_CLK\] Define the relationship between the core clock and the memory mapped interface clock, if disabled, the mmi clock is divided internally to reach the bus clock frequency" \
] [ipgui::get_guiparamspec -name "ASYNC_I3C_CLK" -component $cc]

## Create and save the XGUI file
ipx::create_xgui_files $cc

ipx::save_core [ipx::current_core]
