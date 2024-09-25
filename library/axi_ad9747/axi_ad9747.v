// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2022-2024 Analog Devices, Inc. All rights reserved.
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
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************


`timescale 1ns/100ps

module axi_ad9747 #(
    parameter   ID = 0,
    parameter   FPGA_TECHNOLOGY = 0,
    parameter   FPGA_FAMILY = 0,
    parameter   SPEED_GRADE = 0,
    parameter   DEV_PACKAGE = 0,
    parameter   DAC_DDS_TYPE = 2,
    parameter   DAC_DDS_CORDIC_DW = 16,
    parameter   DAC_DDS_CORDIC_PHASE_DW = 16,
    parameter   DAC_DATAPATH_DISABLE = 0,
    parameter   ONEPORT = 0 // default, dual-port mode on
) (
    // dac interface
    // from dco
    input                   dac_clk_in,
    
    output      [ 15:0]     dac_data_out_p1,
    output      [ 15:0]     dac_data_out_p2,

    // dma interface
    
    output                  dac_div_clk,
    input                   dac_rst,
    output                  dac_valid,
    output                  dac_enable_0,
    output                  dac_enable_1,
    input       [ 63:0]     dac_ddata_0,
    input       [ 63:0]     dac_ddata_1,
    input                   dac_dunf,

    // axi interface
    
    input                   s_axi_aclk,
    input                   s_axi_aresetn,
    input                   s_axi_awvalid,
    input       [ 15:0]     s_axi_awaddr,
    output                  s_axi_awready,
    input                   s_axi_wvalid,
    input       [ 31:0]     s_axi_wdata,
    input       [  3:0]     s_axi_wstrb,
    output                  s_axi_wready,
    output                  s_axi_bvalid,
    output      [  1:0]     s_axi_bresp,
    input                   s_axi_bready,
    input                   s_axi_arvalid,
    input       [ 15:0]     s_axi_araddr,
    output                  s_axi_arready,
    output                  s_axi_rvalid,
    output      [ 31:0]     s_axi_rdata,
    output      [  1:0]     s_axi_rresp,
    input                   s_axi_rready,
    input       [  2:0]     s_axi_awprot,
    input       [  2:0]     s_axi_arprot
);
    
    // internal clocks and resets
    wire              up_clk;
    wire              up_rstn;
    wire              dac_rst_s;

    // internal signals
    

    // temp: AXI IP signals
    wire    [ 15:0]   dac_data_a0_s;
    wire    [ 15:0]   dac_data_a1_s;
    wire    [ 15:0]   dac_data_a2_s;
    wire    [ 15:0]   dac_data_a3_s;
    wire    [ 15:0]   dac_data_b0_s;
    wire    [ 15:0]   dac_data_b1_s;
    wire    [ 15:0]   dac_data_b2_s;
    wire    [ 15:0]   dac_data_b3_s;
    wire              dac_status_s;

    wire              up_wreq_s;
    wire    [ 13:0]   up_waddr_s;
    wire    [ 31:0]   up_wdata_s;
    wire              up_wack_s;
    wire              up_rreq_s;
    wire    [ 13:0]   up_raddr_s;
    wire    [ 31:0]   up_rdata_s;
    wire              up_rack_s;

    // temp: signals used in the AXI IP
    assign up_clk  = s_axi_aclk;
    assign up_rstn = s_axi_aresetn;
    assign dac_rst = dac_rst_s;

    // device interface

    axi_ad9747_if #(
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY)
  ) i_if (
    .dac_clk_in (dac_clk_in),
    .dac_data_out_p1 (dac_data_out_p1),
    .dac_data_out_p2 (dac_data_out_p2),
    .dac_rst (dac_rst),
    .dac_div_clk (dac_div_clk),
    .dac_status (dac_status_s),
    .dac_data_a0 (dac_data_a0_s),
    .dac_data_a1 (dac_data_a1_s),
    .dac_data_a2 (dac_data_a2_s),
    .dac_data_a3 (dac_data_a3_s),
    .dac_data_b0 (dac_data_b0_s),
    .dac_data_b1 (dac_data_b1_s),
    .dac_data_b2 (dac_data_b2_s),
    .dac_data_b3 (dac_data_b3_s));

  // core

  axi_ad9747_core #(
    .ID(ID),
    .FPGA_TECHNOLOGY (FPGA_TECHNOLOGY),
    .FPGA_FAMILY (FPGA_FAMILY),
    .SPEED_GRADE (SPEED_GRADE),
    .DEV_PACKAGE (DEV_PACKAGE),
    .DAC_DDS_TYPE (DAC_DDS_TYPE),
    .DAC_DDS_CORDIC_DW (DAC_DDS_CORDIC_DW),
    .DAC_DDS_CORDIC_PHASE_DW (DAC_DDS_CORDIC_PHASE_DW),
    .DATAPATH_DISABLE(DAC_DATAPATH_DISABLE),
    .ONEPORT (ONEPORT)
  ) i_core (
    .dac_div_clk (dac_div_clk),
    .dac_rst (dac_rst),
    .dac_data_a0 (dac_data_a0_s),
    .dac_data_a1 (dac_data_a1_s),
    .dac_data_a2 (dac_data_a2_s),
    .dac_data_a3 (dac_data_a3_s),
    .dac_data_b0 (dac_data_b0_s),
    .dac_data_b1 (dac_data_b1_s),
    .dac_data_b2 (dac_data_b2_s),
    .dac_data_b3 (dac_data_b3_s),
    .dac_status (dac_status_s),
    .dac_valid (dac_valid),
    .dac_enable_0 (dac_enable_0),
    .dac_enable_1 (dac_enable_1),
    .dac_ddata_0 (dac_ddata_0),
    .dac_ddata_1 (dac_ddata_1),
    .dac_dunf (dac_dunf),
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_wreq (up_wreq_s),
    .up_waddr (up_waddr_s),
    .up_wdata (up_wdata_s),
    .up_wack (up_wack_s),
    .up_rreq (up_rreq_s),
    .up_raddr (up_raddr_s),
    .up_rdata (up_rdata_s),
    .up_rack (up_rack_s));
    

    // axi interface
    up_axi i_up_axi (
        .up_rstn (up_rstn),
        .up_clk (up_clk),
        .up_axi_awvalid (s_axi_awvalid),
        .up_axi_awaddr (s_axi_awaddr),
        .up_axi_awready (s_axi_awready),
        .up_axi_wvalid (s_axi_wvalid),
        .up_axi_wdata (s_axi_wdata),
        .up_axi_wstrb (s_axi_wstrb),
        .up_axi_wready (s_axi_wready),
        .up_axi_bvalid (s_axi_bvalid),
        .up_axi_bresp (s_axi_bresp),
        .up_axi_bready (s_axi_bready),
        .up_axi_arvalid (s_axi_arvalid),
        .up_axi_araddr (s_axi_araddr),
        .up_axi_arready (s_axi_arready),
        .up_axi_rvalid (s_axi_rvalid),
        .up_axi_rresp (s_axi_rresp),
        .up_axi_rdata (s_axi_rdata),
        .up_axi_rready (s_axi_rready),
        .up_wreq (up_wreq_s),
        .up_waddr (up_waddr_s),
        .up_wdata (up_wdata_s),
        .up_wack (up_wack_s),
        .up_rreq (up_rreq_s),
        .up_raddr (up_raddr_s),
        .up_rdata (up_rdata_s),
        .up_rack (up_rack_s));
endmodule