
# ad463x_fmc SPI interface

set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS25} [get_ports ad463x_spi_sdo]          ; ## C11  FMC_LPC_LA06_N
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25} [get_ports ad463x_spi_sclk]         ; ## G06  FMC_LPC_LA00_CC_P
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS25} [get_ports ad463x_spi_cs]           ; ## G07  FMC_LPC_LA00_CC_N

set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS25} [get_ports ad463x_resetn]           ; ## D09  FMC_LPC_LA01_N
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS25} [get_ports ad463x_busy]             ; ## C10  FMC_LPC_LA06_P
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25} [get_ports ad463x_cnv]              ; ## D08  FMC_LPC_LA01_P

