// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module system_top (

  inout   [14:0]  ddr_addr,
  inout   [ 2:0]  ddr_ba,
  inout           ddr_cas_n,
  inout           ddr_ck_n,
  inout           ddr_ck_p,
  inout           ddr_cke,
  inout           ddr_cs_n,
  inout   [ 3:0]  ddr_dm,
  inout   [31:0]  ddr_dq,
  inout   [ 3:0]  ddr_dqs_n,
  inout   [ 3:0]  ddr_dqs_p,
  inout           ddr_odt,
  inout           ddr_ras_n,
  inout           ddr_reset_n,
  inout           ddr_we_n,

  inout           fixed_io_ddr_vrn,
  inout           fixed_io_ddr_vrp,
  inout   [53:0]  fixed_io_mio,
  inout           fixed_io_ps_clk,
  inout           fixed_io_ps_porb,
  inout           fixed_io_ps_srstb,

  inout   [31:0]  gpio_bd,

  output          spdif,

  input           otg_vbusoc,

  inout           ad7768_0_reset,
  inout           ad7768_0_sync_in,
  
  inout           ad7768_0_fda_dis,
  inout           ad7768_0_fda_mode,
  inout           ad7768_0_dac_buf_en,

  input           ad7768_0_spi_miso,
  output          ad7768_0_spi_mosi,
  output          ad7768_0_spi_sclk,
  output          ad7768_0_spi_cs,
  input           ad7768_0_drdy,

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;
  

  // instantiations

  ad_iobuf #(
    .DATA_WIDTH(5)
  ) i_iobuf_ad7768_0_gpio (
    .dio_t(gpio_t[36:32]),
    .dio_i(gpio_o[36:32]),
    .dio_o(gpio_i[36:32]),
    .dio_p({
            ad7768_0_fda_dis,
            ad7768_0_fda_mode,
			ad7768_0_dac_buf_en,
			ad7768_0_sync_in,
			ad7768_0_reset}));

  assign gpio_i[47:37] = gpio_o[47:37];
  assign gpio_i[63:55] = gpio_o[63:55];

/*   ad_iobuf #(
    .DATA_WIDTH(6)
  ) i_iobuf_ad7768_0_gpio (
    .dio_t({gpio_t[37:34], 1'b1, gpio_t[32]}),
    .dio_i({gpio_o[37:34]),
    .dio_o({gpio_i[37:34]),
    .dio_p({
	        
			ad7768_0_gpio,     // 37:34
            ad7768_0_sync_in,  // 33 
            ad7768_0_reset     // 32
			
			}));

  assign gpio_i[47:39] = gpio_o[47:39];
  assign gpio_i[63:55] = gpio_o[63:55]; */

  ad_iobuf #(
    .DATA_WIDTH(32)
  ) i_iobuf (
    .dio_t(gpio_t[31:0]),
    .dio_i(gpio_o[31:0]),
    .dio_o(gpio_i[31:0]),
    .dio_p(gpio_bd));

  assign gpio_i[47:39] = gpio_o[47:39];
  assign gpio_i[63:55] = gpio_o[63:55];


  system_wrapper i_system_wrapper (
    .ddr_addr (ddr_addr),
    .ddr_ba (ddr_ba),
    .ddr_cas_n (ddr_cas_n),
    .ddr_ck_n (ddr_ck_n),
    .ddr_ck_p (ddr_ck_p),
    .ddr_cke (ddr_cke),
    .ddr_cs_n (ddr_cs_n),
    .ddr_dm (ddr_dm),
    .ddr_dq (ddr_dq),
    .ddr_dqs_n (ddr_dqs_n),
    .ddr_dqs_p (ddr_dqs_p),
    .ddr_odt (ddr_odt),
    .ddr_ras_n (ddr_ras_n),
    .ddr_reset_n (ddr_reset_n),
    .ddr_we_n (ddr_we_n),
    .fixed_io_ddr_vrn (fixed_io_ddr_vrn),
    .fixed_io_ddr_vrp (fixed_io_ddr_vrp),
    .fixed_io_mio (fixed_io_mio),
    .fixed_io_ps_clk (fixed_io_ps_clk),
    .fixed_io_ps_porb (fixed_io_ps_porb),
    .fixed_io_ps_srstb (fixed_io_ps_srstb),
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .otg_vbusoc (otg_vbusoc),
    .spdif (spdif),
    .adc1_spi_sdo (ad7768_0_spi_mosi),
    .adc1_spi_sdo_t (),
    .adc1_spi_sdi (ad7768_0_spi_miso),
    .adc1_spi_cs (ad7768_0_spi_cs),
    .adc1_spi_sclk (ad7768_0_spi_sclk),
    .adc1_data_ready (ad7768_0_drdy));

endmodule

// ***************************************************************************
// ***************************************************************************
