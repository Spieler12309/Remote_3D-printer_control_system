// (C) 2001-2018 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/18.1std/ip/merlin/altera_merlin_router/altera_merlin_router.sv.terp#1 $
// $Revision: #1 $
// $Date: 2018/07/18 $
// $Author: psgswbuild $

// -------------------------------------------------------
// Merlin Router
//
// Asserts the appropriate one-hot encoded channel based on 
// either (a) the address or (b) the dest id. The DECODER_TYPE
// parameter controls this behaviour. 0 means address decoder,
// 1 means dest id decoder.
//
// In the case of (a), it also sets the destination id.
// -------------------------------------------------------

`timescale 1 ns / 1 ns

module soc_system_mm_interconnect_1_router_default_decode
  #(
     parameter DEFAULT_CHANNEL = 1,
               DEFAULT_WR_CHANNEL = -1,
               DEFAULT_RD_CHANNEL = -1,
               DEFAULT_DESTID = 0 
   )
  (output [100 - 94 : 0] default_destination_id,
   output [128-1 : 0] default_wr_channel,
   output [128-1 : 0] default_rd_channel,
   output [128-1 : 0] default_src_channel
  );

  assign default_destination_id = 
    DEFAULT_DESTID[100 - 94 : 0];

  generate
    if (DEFAULT_CHANNEL == -1) begin : no_default_channel_assignment
      assign default_src_channel = '0;
    end
    else begin : default_channel_assignment
      assign default_src_channel = 128'b1 << DEFAULT_CHANNEL;
    end
  endgenerate

  generate
    if (DEFAULT_RD_CHANNEL == -1) begin : no_default_rw_channel_assignment
      assign default_wr_channel = '0;
      assign default_rd_channel = '0;
    end
    else begin : default_rw_channel_assignment
      assign default_wr_channel = 128'b1 << DEFAULT_WR_CHANNEL;
      assign default_rd_channel = 128'b1 << DEFAULT_RD_CHANNEL;
    end
  endgenerate

endmodule


module soc_system_mm_interconnect_1_router
(
    // -------------------
    // Clock & Reset
    // -------------------
    input clk,
    input reset,

    // -------------------
    // Command Sink (Input)
    // -------------------
    input                       sink_valid,
    input  [114-1 : 0]    sink_data,
    input                       sink_startofpacket,
    input                       sink_endofpacket,
    output                      sink_ready,

    // -------------------
    // Command Source (Output)
    // -------------------
    output                          src_valid,
    output reg [114-1    : 0] src_data,
    output reg [128-1 : 0] src_channel,
    output                          src_startofpacket,
    output                          src_endofpacket,
    input                           src_ready
);

    // -------------------------------------------------------
    // Local parameters and variables
    // -------------------------------------------------------
    localparam PKT_ADDR_H = 67;
    localparam PKT_ADDR_L = 36;
    localparam PKT_DEST_ID_H = 100;
    localparam PKT_DEST_ID_L = 94;
    localparam PKT_PROTECTION_H = 104;
    localparam PKT_PROTECTION_L = 102;
    localparam ST_DATA_W = 114;
    localparam ST_CHANNEL_W = 128;
    localparam DECODER_TYPE = 0;

    localparam PKT_TRANS_WRITE = 70;
    localparam PKT_TRANS_READ  = 71;

    localparam PKT_ADDR_W = PKT_ADDR_H-PKT_ADDR_L + 1;
    localparam PKT_DEST_ID_W = PKT_DEST_ID_H-PKT_DEST_ID_L + 1;



    // -------------------------------------------------------
    // Figure out the number of bits to mask off for each slave span
    // during address decoding
    // -------------------------------------------------------
    localparam PAD0 = log2ceil(64'h1008 - 64'h1000); 
    localparam PAD1 = log2ceil(64'h2008 - 64'h2000); 
    localparam PAD2 = log2ceil(64'h4010 - 64'h4000); 
    localparam PAD3 = log2ceil(64'h4030 - 64'h4020); 
    localparam PAD4 = log2ceil(64'h4050 - 64'h4040); 
    localparam PAD5 = log2ceil(64'h5010 - 64'h5000); 
    localparam PAD6 = log2ceil(64'h5030 - 64'h5020); 
    localparam PAD7 = log2ceil(64'h5050 - 64'h5040); 
    localparam PAD8 = log2ceil(64'h5070 - 64'h5060); 
    localparam PAD9 = log2ceil(64'h5090 - 64'h5080); 
    localparam PAD10 = log2ceil(64'h50b0 - 64'h50a0); 
    localparam PAD11 = log2ceil(64'h50d0 - 64'h50c0); 
    localparam PAD12 = log2ceil(64'h50f0 - 64'h50e0); 
    localparam PAD13 = log2ceil(64'h5110 - 64'h5100); 
    localparam PAD14 = log2ceil(64'h5130 - 64'h5120); 
    localparam PAD15 = log2ceil(64'h5150 - 64'h5140); 
    localparam PAD16 = log2ceil(64'h5170 - 64'h5160); 
    localparam PAD17 = log2ceil(64'h5190 - 64'h5180); 
    localparam PAD18 = log2ceil(64'h51b0 - 64'h51a0); 
    localparam PAD19 = log2ceil(64'h51d0 - 64'h51c0); 
    localparam PAD20 = log2ceil(64'h51f0 - 64'h51e0); 
    localparam PAD21 = log2ceil(64'h5210 - 64'h5200); 
    localparam PAD22 = log2ceil(64'h5230 - 64'h5220); 
    localparam PAD23 = log2ceil(64'h5250 - 64'h5240); 
    localparam PAD24 = log2ceil(64'h5270 - 64'h5260); 
    localparam PAD25 = log2ceil(64'h5290 - 64'h5280); 
    localparam PAD26 = log2ceil(64'h52b0 - 64'h52a0); 
    localparam PAD27 = log2ceil(64'h52d0 - 64'h52c0); 
    localparam PAD28 = log2ceil(64'h52f0 - 64'h52e0); 
    localparam PAD29 = log2ceil(64'h5310 - 64'h5300); 
    localparam PAD30 = log2ceil(64'h5330 - 64'h5320); 
    localparam PAD31 = log2ceil(64'h5350 - 64'h5340); 
    localparam PAD32 = log2ceil(64'h5370 - 64'h5360); 
    localparam PAD33 = log2ceil(64'h5390 - 64'h5380); 
    localparam PAD34 = log2ceil(64'h53b0 - 64'h53a0); 
    localparam PAD35 = log2ceil(64'h6010 - 64'h6000); 
    localparam PAD36 = log2ceil(64'h6030 - 64'h6020); 
    localparam PAD37 = log2ceil(64'h6050 - 64'h6040); 
    localparam PAD38 = log2ceil(64'h6070 - 64'h6060); 
    localparam PAD39 = log2ceil(64'h6090 - 64'h6080); 
    localparam PAD40 = log2ceil(64'h60b0 - 64'h60a0); 
    localparam PAD41 = log2ceil(64'h60d0 - 64'h60c0); 
    localparam PAD42 = log2ceil(64'h60f0 - 64'h60e0); 
    localparam PAD43 = log2ceil(64'h7010 - 64'h7000); 
    localparam PAD44 = log2ceil(64'h7030 - 64'h7020); 
    localparam PAD45 = log2ceil(64'h7050 - 64'h7040); 
    localparam PAD46 = log2ceil(64'h7070 - 64'h7060); 
    localparam PAD47 = log2ceil(64'h7090 - 64'h7080); 
    localparam PAD48 = log2ceil(64'h70b0 - 64'h70a0); 
    localparam PAD49 = log2ceil(64'h70d0 - 64'h70c0); 
    localparam PAD50 = log2ceil(64'h70f0 - 64'h70e0); 
    localparam PAD51 = log2ceil(64'h7110 - 64'h7100); 
    localparam PAD52 = log2ceil(64'h7130 - 64'h7120); 
    localparam PAD53 = log2ceil(64'h7150 - 64'h7140); 
    localparam PAD54 = log2ceil(64'h7170 - 64'h7160); 
    localparam PAD55 = log2ceil(64'h7190 - 64'h7180); 
    localparam PAD56 = log2ceil(64'h71b0 - 64'h71a0); 
    localparam PAD57 = log2ceil(64'h71d0 - 64'h71c0); 
    localparam PAD58 = log2ceil(64'h71f0 - 64'h71e0); 
    localparam PAD59 = log2ceil(64'h7210 - 64'h7200); 
    localparam PAD60 = log2ceil(64'h7230 - 64'h7220); 
    localparam PAD61 = log2ceil(64'h7250 - 64'h7240); 
    localparam PAD62 = log2ceil(64'h7270 - 64'h7260); 
    localparam PAD63 = log2ceil(64'h7290 - 64'h7280); 
    localparam PAD64 = log2ceil(64'h72b0 - 64'h72a0); 
    localparam PAD65 = log2ceil(64'h72d0 - 64'h72c0); 
    localparam PAD66 = log2ceil(64'h72f0 - 64'h72e0); 
    localparam PAD67 = log2ceil(64'h7310 - 64'h7300); 
    localparam PAD68 = log2ceil(64'h7330 - 64'h7320); 
    localparam PAD69 = log2ceil(64'h7350 - 64'h7340); 
    localparam PAD70 = log2ceil(64'h7370 - 64'h7360); 
    localparam PAD71 = log2ceil(64'h7390 - 64'h7380); 
    localparam PAD72 = log2ceil(64'h73b0 - 64'h73a0); 
    localparam PAD73 = log2ceil(64'h73d0 - 64'h73c0); 
    localparam PAD74 = log2ceil(64'h73f0 - 64'h73e0); 
    localparam PAD75 = log2ceil(64'h7410 - 64'h7400); 
    localparam PAD76 = log2ceil(64'h7430 - 64'h7420); 
    localparam PAD77 = log2ceil(64'h7450 - 64'h7440); 
    localparam PAD78 = log2ceil(64'h7470 - 64'h7460); 
    localparam PAD79 = log2ceil(64'h7490 - 64'h7480); 
    localparam PAD80 = log2ceil(64'h74b0 - 64'h74a0); 
    localparam PAD81 = log2ceil(64'h74d0 - 64'h74c0); 
    localparam PAD82 = log2ceil(64'h74f0 - 64'h74e0); 
    localparam PAD83 = log2ceil(64'h7510 - 64'h7500); 
    localparam PAD84 = log2ceil(64'h7530 - 64'h7520); 
    localparam PAD85 = log2ceil(64'h7550 - 64'h7540); 
    localparam PAD86 = log2ceil(64'h7570 - 64'h7560); 
    localparam PAD87 = log2ceil(64'h7590 - 64'h7580); 
    localparam PAD88 = log2ceil(64'h75b0 - 64'h75a0); 
    localparam PAD89 = log2ceil(64'h75d0 - 64'h75c0); 
    localparam PAD90 = log2ceil(64'h75f0 - 64'h75e0); 
    localparam PAD91 = log2ceil(64'h7610 - 64'h7600); 
    localparam PAD92 = log2ceil(64'h7630 - 64'h7620); 
    localparam PAD93 = log2ceil(64'h7650 - 64'h7640); 
    localparam PAD94 = log2ceil(64'h7670 - 64'h7660); 
    localparam PAD95 = log2ceil(64'h7690 - 64'h7680); 
    localparam PAD96 = log2ceil(64'h76b0 - 64'h76a0); 
    localparam PAD97 = log2ceil(64'h76d0 - 64'h76c0); 
    localparam PAD98 = log2ceil(64'h76f0 - 64'h76e0); 
    localparam PAD99 = log2ceil(64'h7710 - 64'h7700); 
    localparam PAD100 = log2ceil(64'h7730 - 64'h7720); 
    localparam PAD101 = log2ceil(64'h7750 - 64'h7740); 
    localparam PAD102 = log2ceil(64'h7770 - 64'h7760); 
    localparam PAD103 = log2ceil(64'h7790 - 64'h7780); 
    localparam PAD104 = log2ceil(64'h77b0 - 64'h77a0); 
    localparam PAD105 = log2ceil(64'h77d0 - 64'h77c0); 
    localparam PAD106 = log2ceil(64'h77f0 - 64'h77e0); 
    localparam PAD107 = log2ceil(64'h7810 - 64'h7800); 
    localparam PAD108 = log2ceil(64'h7830 - 64'h7820); 
    localparam PAD109 = log2ceil(64'h7850 - 64'h7840); 
    localparam PAD110 = log2ceil(64'h7870 - 64'h7860); 
    localparam PAD111 = log2ceil(64'h7890 - 64'h7880); 
    localparam PAD112 = log2ceil(64'h78b0 - 64'h78a0); 
    localparam PAD113 = log2ceil(64'h7910 - 64'h7900); 
    localparam PAD114 = log2ceil(64'h7930 - 64'h7920); 
    localparam PAD115 = log2ceil(64'h7950 - 64'h7940); 
    localparam PAD116 = log2ceil(64'h7970 - 64'h7960); 
    localparam PAD117 = log2ceil(64'h7990 - 64'h7980); 
    localparam PAD118 = log2ceil(64'h79b0 - 64'h79a0); 
    localparam PAD119 = log2ceil(64'h79d0 - 64'h79c0); 
    localparam PAD120 = log2ceil(64'h79f0 - 64'h79e0); 
    localparam PAD121 = log2ceil(64'h7a10 - 64'h7a00); 
    localparam PAD122 = log2ceil(64'h7a30 - 64'h7a20); 
    localparam PAD123 = log2ceil(64'h7a50 - 64'h7a40); 
    localparam PAD124 = log2ceil(64'h7a70 - 64'h7a60); 
    localparam PAD125 = log2ceil(64'h7a90 - 64'h7a80); 
    localparam PAD126 = log2ceil(64'h7ab0 - 64'h7aa0); 
    localparam PAD127 = log2ceil(64'h30100 - 64'h30000); 
    // -------------------------------------------------------
    // Work out which address bits are significant based on the
    // address range of the slaves. If the required width is too
    // large or too small, we use the address field width instead.
    // -------------------------------------------------------
    localparam ADDR_RANGE = 64'h30100;
    localparam RANGE_ADDR_WIDTH = log2ceil(ADDR_RANGE);
    localparam OPTIMIZED_ADDR_H = (RANGE_ADDR_WIDTH > PKT_ADDR_W) ||
                                  (RANGE_ADDR_WIDTH == 0) ?
                                        PKT_ADDR_H :
                                        PKT_ADDR_L + RANGE_ADDR_WIDTH - 1;

    localparam RG = RANGE_ADDR_WIDTH-1;
    localparam REAL_ADDRESS_RANGE = OPTIMIZED_ADDR_H - PKT_ADDR_L;

      reg [PKT_ADDR_W-1 : 0] address;
      always @* begin
        address = {PKT_ADDR_W{1'b0}};
        address [REAL_ADDRESS_RANGE:0] = sink_data[OPTIMIZED_ADDR_H : PKT_ADDR_L];
      end   

    // -------------------------------------------------------
    // Pass almost everything through, untouched
    // -------------------------------------------------------
    assign sink_ready        = src_ready;
    assign src_valid         = sink_valid;
    assign src_startofpacket = sink_startofpacket;
    assign src_endofpacket   = sink_endofpacket;
    wire [PKT_DEST_ID_W-1:0] default_destid;
    wire [128-1 : 0] default_src_channel;




    // -------------------------------------------------------
    // Write and read transaction signals
    // -------------------------------------------------------
    wire read_transaction;
    assign read_transaction  = sink_data[PKT_TRANS_READ];


    soc_system_mm_interconnect_1_router_default_decode the_default_decode(
      .default_destination_id (default_destid),
      .default_wr_channel   (),
      .default_rd_channel   (),
      .default_src_channel  (default_src_channel)
    );

    always @* begin
        src_data    = sink_data;
        src_channel = default_src_channel;
        src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = default_destid;

        // --------------------------------------------------
        // Address Decoder
        // Sets the channel and destination ID based on the address
        // --------------------------------------------------

    // ( 0x1000 .. 0x1008 )
    if ( {address[RG:PAD0],{PAD0{1'b0}}} == 18'h1000  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 104;
    end

    // ( 0x2000 .. 0x2008 )
    if ( {address[RG:PAD1],{PAD1{1'b0}}} == 18'h2000   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 16;
    end

    // ( 0x4000 .. 0x4010 )
    if ( {address[RG:PAD2],{PAD2{1'b0}}} == 18'h4000  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 14;
    end

    // ( 0x4020 .. 0x4030 )
    if ( {address[RG:PAD3],{PAD3{1'b0}}} == 18'h4020   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 15;
    end

    // ( 0x4040 .. 0x4050 )
    if ( {address[RG:PAD4],{PAD4{1'b0}}} == 18'h4040   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 10;
    end

    // ( 0x5000 .. 0x5010 )
    if ( {address[RG:PAD5],{PAD5{1'b0}}} == 18'h5000   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 11;
    end

    // ( 0x5020 .. 0x5030 )
    if ( {address[RG:PAD6],{PAD6{1'b0}}} == 18'h5020   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 12;
    end

    // ( 0x5040 .. 0x5050 )
    if ( {address[RG:PAD7],{PAD7{1'b0}}} == 18'h5040   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 13;
    end

    // ( 0x5060 .. 0x5070 )
    if ( {address[RG:PAD8],{PAD8{1'b0}}} == 18'h5060   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 2;
    end

    // ( 0x5080 .. 0x5090 )
    if ( {address[RG:PAD9],{PAD9{1'b0}}} == 18'h5080   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 3;
    end

    // ( 0x50a0 .. 0x50b0 )
    if ( {address[RG:PAD10],{PAD10{1'b0}}} == 18'h50a0   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 6;
    end

    // ( 0x50c0 .. 0x50d0 )
    if ( {address[RG:PAD11],{PAD11{1'b0}}} == 18'h50c0   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 9;
    end

    // ( 0x50e0 .. 0x50f0 )
    if ( {address[RG:PAD12],{PAD12{1'b0}}} == 18'h50e0   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 1;
    end

    // ( 0x5100 .. 0x5110 )
    if ( {address[RG:PAD13],{PAD13{1'b0}}} == 18'h5100   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 93;
    end

    // ( 0x5120 .. 0x5130 )
    if ( {address[RG:PAD14],{PAD14{1'b0}}} == 18'h5120   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 94;
    end

    // ( 0x5140 .. 0x5150 )
    if ( {address[RG:PAD15],{PAD15{1'b0}}} == 18'h5140   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 95;
    end

    // ( 0x5160 .. 0x5170 )
    if ( {address[RG:PAD16],{PAD16{1'b0}}} == 18'h5160   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 91;
    end

    // ( 0x5180 .. 0x5190 )
    if ( {address[RG:PAD17],{PAD17{1'b0}}} == 18'h5180   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 92;
    end

    // ( 0x51a0 .. 0x51b0 )
    if ( {address[RG:PAD18],{PAD18{1'b0}}} == 18'h51a0   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 83;
    end

    // ( 0x51c0 .. 0x51d0 )
    if ( {address[RG:PAD19],{PAD19{1'b0}}} == 18'h51c0   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 84;
    end

    // ( 0x51e0 .. 0x51f0 )
    if ( {address[RG:PAD20],{PAD20{1'b0}}} == 18'h51e0   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 85;
    end

    // ( 0x5200 .. 0x5210 )
    if ( {address[RG:PAD21],{PAD21{1'b0}}} == 18'h5200   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 81;
    end

    // ( 0x5220 .. 0x5230 )
    if ( {address[RG:PAD22],{PAD22{1'b0}}} == 18'h5220   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 82;
    end

    // ( 0x5240 .. 0x5250 )
    if ( {address[RG:PAD23],{PAD23{1'b0}}} == 18'h5240   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 88;
    end

    // ( 0x5260 .. 0x5270 )
    if ( {address[RG:PAD24],{PAD24{1'b0}}} == 18'h5260   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 89;
    end

    // ( 0x5280 .. 0x5290 )
    if ( {address[RG:PAD25],{PAD25{1'b0}}} == 18'h5280   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 90;
    end

    // ( 0x52a0 .. 0x52b0 )
    if ( {address[RG:PAD26],{PAD26{1'b0}}} == 18'h52a0   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 86;
    end

    // ( 0x52c0 .. 0x52d0 )
    if ( {address[RG:PAD27],{PAD27{1'b0}}} == 18'h52c0   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 87;
    end

    // ( 0x52e0 .. 0x52f0 )
    if ( {address[RG:PAD28],{PAD28{1'b0}}} == 18'h52e0   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 97;
    end

    // ( 0x5300 .. 0x5310 )
    if ( {address[RG:PAD29],{PAD29{1'b0}}} == 18'h5300   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 98;
    end

    // ( 0x5320 .. 0x5330 )
    if ( {address[RG:PAD30],{PAD30{1'b0}}} == 18'h5320   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 96;
    end

    // ( 0x5340 .. 0x5350 )
    if ( {address[RG:PAD31],{PAD31{1'b0}}} == 18'h5340   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 7;
    end

    // ( 0x5360 .. 0x5370 )
    if ( {address[RG:PAD32],{PAD32{1'b0}}} == 18'h5360   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 8;
    end

    // ( 0x5380 .. 0x5390 )
    if ( {address[RG:PAD33],{PAD33{1'b0}}} == 18'h5380   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 4;
    end

    // ( 0x53a0 .. 0x53b0 )
    if ( {address[RG:PAD34],{PAD34{1'b0}}} == 18'h53a0   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 5;
    end

    // ( 0x6000 .. 0x6010 )
    if ( {address[RG:PAD35],{PAD35{1'b0}}} == 18'h6000  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 105;
    end

    // ( 0x6020 .. 0x6030 )
    if ( {address[RG:PAD36],{PAD36{1'b0}}} == 18'h6020  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 106;
    end

    // ( 0x6040 .. 0x6050 )
    if ( {address[RG:PAD37],{PAD37{1'b0}}} == 18'h6040  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 107;
    end

    // ( 0x6060 .. 0x6070 )
    if ( {address[RG:PAD38],{PAD38{1'b0}}} == 18'h6060  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 78;
    end

    // ( 0x6080 .. 0x6090 )
    if ( {address[RG:PAD39],{PAD39{1'b0}}} == 18'h6080  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 79;
    end

    // ( 0x60a0 .. 0x60b0 )
    if ( {address[RG:PAD40],{PAD40{1'b0}}} == 18'h60a0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 80;
    end

    // ( 0x60c0 .. 0x60d0 )
    if ( {address[RG:PAD41],{PAD41{1'b0}}} == 18'h60c0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 76;
    end

    // ( 0x60e0 .. 0x60f0 )
    if ( {address[RG:PAD42],{PAD42{1'b0}}} == 18'h60e0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 77;
    end

    // ( 0x7000 .. 0x7010 )
    if ( {address[RG:PAD43],{PAD43{1'b0}}} == 18'h7000  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 61;
    end

    // ( 0x7020 .. 0x7030 )
    if ( {address[RG:PAD44],{PAD44{1'b0}}} == 18'h7020  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 62;
    end

    // ( 0x7040 .. 0x7050 )
    if ( {address[RG:PAD45],{PAD45{1'b0}}} == 18'h7040  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 63;
    end

    // ( 0x7060 .. 0x7070 )
    if ( {address[RG:PAD46],{PAD46{1'b0}}} == 18'h7060  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 64;
    end

    // ( 0x7080 .. 0x7090 )
    if ( {address[RG:PAD47],{PAD47{1'b0}}} == 18'h7080  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 65;
    end

    // ( 0x70a0 .. 0x70b0 )
    if ( {address[RG:PAD48],{PAD48{1'b0}}} == 18'h70a0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 66;
    end

    // ( 0x70c0 .. 0x70d0 )
    if ( {address[RG:PAD49],{PAD49{1'b0}}} == 18'h70c0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 67;
    end

    // ( 0x70e0 .. 0x70f0 )
    if ( {address[RG:PAD50],{PAD50{1'b0}}} == 18'h70e0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 68;
    end

    // ( 0x7100 .. 0x7110 )
    if ( {address[RG:PAD51],{PAD51{1'b0}}} == 18'h7100  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 69;
    end

    // ( 0x7120 .. 0x7130 )
    if ( {address[RG:PAD52],{PAD52{1'b0}}} == 18'h7120  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 70;
    end

    // ( 0x7140 .. 0x7150 )
    if ( {address[RG:PAD53],{PAD53{1'b0}}} == 18'h7140  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 71;
    end

    // ( 0x7160 .. 0x7170 )
    if ( {address[RG:PAD54],{PAD54{1'b0}}} == 18'h7160  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 72;
    end

    // ( 0x7180 .. 0x7190 )
    if ( {address[RG:PAD55],{PAD55{1'b0}}} == 18'h7180  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 73;
    end

    // ( 0x71a0 .. 0x71b0 )
    if ( {address[RG:PAD56],{PAD56{1'b0}}} == 18'h71a0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 74;
    end

    // ( 0x71c0 .. 0x71d0 )
    if ( {address[RG:PAD57],{PAD57{1'b0}}} == 18'h71c0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 75;
    end

    // ( 0x71e0 .. 0x71f0 )
    if ( {address[RG:PAD58],{PAD58{1'b0}}} == 18'h71e0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 51;
    end

    // ( 0x7200 .. 0x7210 )
    if ( {address[RG:PAD59],{PAD59{1'b0}}} == 18'h7200  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 52;
    end

    // ( 0x7220 .. 0x7230 )
    if ( {address[RG:PAD60],{PAD60{1'b0}}} == 18'h7220  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 53;
    end

    // ( 0x7240 .. 0x7250 )
    if ( {address[RG:PAD61],{PAD61{1'b0}}} == 18'h7240  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 54;
    end

    // ( 0x7260 .. 0x7270 )
    if ( {address[RG:PAD62],{PAD62{1'b0}}} == 18'h7260  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 55;
    end

    // ( 0x7280 .. 0x7290 )
    if ( {address[RG:PAD63],{PAD63{1'b0}}} == 18'h7280  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 56;
    end

    // ( 0x72a0 .. 0x72b0 )
    if ( {address[RG:PAD64],{PAD64{1'b0}}} == 18'h72a0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 57;
    end

    // ( 0x72c0 .. 0x72d0 )
    if ( {address[RG:PAD65],{PAD65{1'b0}}} == 18'h72c0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 58;
    end

    // ( 0x72e0 .. 0x72f0 )
    if ( {address[RG:PAD66],{PAD66{1'b0}}} == 18'h72e0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 59;
    end

    // ( 0x7300 .. 0x7310 )
    if ( {address[RG:PAD67],{PAD67{1'b0}}} == 18'h7300  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 60;
    end

    // ( 0x7320 .. 0x7330 )
    if ( {address[RG:PAD68],{PAD68{1'b0}}} == 18'h7320  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 116;
    end

    // ( 0x7340 .. 0x7350 )
    if ( {address[RG:PAD69],{PAD69{1'b0}}} == 18'h7340  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 117;
    end

    // ( 0x7360 .. 0x7370 )
    if ( {address[RG:PAD70],{PAD70{1'b0}}} == 18'h7360  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 118;
    end

    // ( 0x7380 .. 0x7390 )
    if ( {address[RG:PAD71],{PAD71{1'b0}}} == 18'h7380  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 119;
    end

    // ( 0x73a0 .. 0x73b0 )
    if ( {address[RG:PAD72],{PAD72{1'b0}}} == 18'h73a0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 120;
    end

    // ( 0x73c0 .. 0x73d0 )
    if ( {address[RG:PAD73],{PAD73{1'b0}}} == 18'h73c0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 121;
    end

    // ( 0x73e0 .. 0x73f0 )
    if ( {address[RG:PAD74],{PAD74{1'b0}}} == 18'h73e0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 122;
    end

    // ( 0x7400 .. 0x7410 )
    if ( {address[RG:PAD75],{PAD75{1'b0}}} == 18'h7400  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 123;
    end

    // ( 0x7420 .. 0x7430 )
    if ( {address[RG:PAD76],{PAD76{1'b0}}} == 18'h7420  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 124;
    end

    // ( 0x7440 .. 0x7450 )
    if ( {address[RG:PAD77],{PAD77{1'b0}}} == 18'h7440  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 125;
    end

    // ( 0x7460 .. 0x7470 )
    if ( {address[RG:PAD78],{PAD78{1'b0}}} == 18'h7460  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 126;
    end

    // ( 0x7480 .. 0x7490 )
    if ( {address[RG:PAD79],{PAD79{1'b0}}} == 18'h7480  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 127;
    end

    // ( 0x74a0 .. 0x74b0 )
    if ( {address[RG:PAD80],{PAD80{1'b0}}} == 18'h74a0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 108;
    end

    // ( 0x74c0 .. 0x74d0 )
    if ( {address[RG:PAD81],{PAD81{1'b0}}} == 18'h74c0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 109;
    end

    // ( 0x74e0 .. 0x74f0 )
    if ( {address[RG:PAD82],{PAD82{1'b0}}} == 18'h74e0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 110;
    end

    // ( 0x7500 .. 0x7510 )
    if ( {address[RG:PAD83],{PAD83{1'b0}}} == 18'h7500  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 111;
    end

    // ( 0x7520 .. 0x7530 )
    if ( {address[RG:PAD84],{PAD84{1'b0}}} == 18'h7520  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 112;
    end

    // ( 0x7540 .. 0x7550 )
    if ( {address[RG:PAD85],{PAD85{1'b0}}} == 18'h7540  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 113;
    end

    // ( 0x7560 .. 0x7570 )
    if ( {address[RG:PAD86],{PAD86{1'b0}}} == 18'h7560  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 114;
    end

    // ( 0x7580 .. 0x7590 )
    if ( {address[RG:PAD87],{PAD87{1'b0}}} == 18'h7580  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 115;
    end

    // ( 0x75a0 .. 0x75b0 )
    if ( {address[RG:PAD88],{PAD88{1'b0}}} == 18'h75a0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 36;
    end

    // ( 0x75c0 .. 0x75d0 )
    if ( {address[RG:PAD89],{PAD89{1'b0}}} == 18'h75c0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 37;
    end

    // ( 0x75e0 .. 0x75f0 )
    if ( {address[RG:PAD90],{PAD90{1'b0}}} == 18'h75e0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 38;
    end

    // ( 0x7600 .. 0x7610 )
    if ( {address[RG:PAD91],{PAD91{1'b0}}} == 18'h7600  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 39;
    end

    // ( 0x7620 .. 0x7630 )
    if ( {address[RG:PAD92],{PAD92{1'b0}}} == 18'h7620  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 40;
    end

    // ( 0x7640 .. 0x7650 )
    if ( {address[RG:PAD93],{PAD93{1'b0}}} == 18'h7640  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 41;
    end

    // ( 0x7660 .. 0x7670 )
    if ( {address[RG:PAD94],{PAD94{1'b0}}} == 18'h7660  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 42;
    end

    // ( 0x7680 .. 0x7690 )
    if ( {address[RG:PAD95],{PAD95{1'b0}}} == 18'h7680  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 43;
    end

    // ( 0x76a0 .. 0x76b0 )
    if ( {address[RG:PAD96],{PAD96{1'b0}}} == 18'h76a0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 44;
    end

    // ( 0x76c0 .. 0x76d0 )
    if ( {address[RG:PAD97],{PAD97{1'b0}}} == 18'h76c0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 45;
    end

    // ( 0x76e0 .. 0x76f0 )
    if ( {address[RG:PAD98],{PAD98{1'b0}}} == 18'h76e0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 46;
    end

    // ( 0x7700 .. 0x7710 )
    if ( {address[RG:PAD99],{PAD99{1'b0}}} == 18'h7700  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 47;
    end

    // ( 0x7720 .. 0x7730 )
    if ( {address[RG:PAD100],{PAD100{1'b0}}} == 18'h7720  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 48;
    end

    // ( 0x7740 .. 0x7750 )
    if ( {address[RG:PAD101],{PAD101{1'b0}}} == 18'h7740  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 49;
    end

    // ( 0x7760 .. 0x7770 )
    if ( {address[RG:PAD102],{PAD102{1'b0}}} == 18'h7760  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 50;
    end

    // ( 0x7780 .. 0x7790 )
    if ( {address[RG:PAD103],{PAD103{1'b0}}} == 18'h7780  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 26;
    end

    // ( 0x77a0 .. 0x77b0 )
    if ( {address[RG:PAD104],{PAD104{1'b0}}} == 18'h77a0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 27;
    end

    // ( 0x77c0 .. 0x77d0 )
    if ( {address[RG:PAD105],{PAD105{1'b0}}} == 18'h77c0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 28;
    end

    // ( 0x77e0 .. 0x77f0 )
    if ( {address[RG:PAD106],{PAD106{1'b0}}} == 18'h77e0  && read_transaction  ) begin
            src_channel = 128'b00000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 29;
    end

    // ( 0x7800 .. 0x7810 )
    if ( {address[RG:PAD107],{PAD107{1'b0}}} == 18'h7800  && read_transaction  ) begin
            src_channel = 128'b00000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 30;
    end

    // ( 0x7820 .. 0x7830 )
    if ( {address[RG:PAD108],{PAD108{1'b0}}} == 18'h7820  && read_transaction  ) begin
            src_channel = 128'b00000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 31;
    end

    // ( 0x7840 .. 0x7850 )
    if ( {address[RG:PAD109],{PAD109{1'b0}}} == 18'h7840  && read_transaction  ) begin
            src_channel = 128'b00000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 32;
    end

    // ( 0x7860 .. 0x7870 )
    if ( {address[RG:PAD110],{PAD110{1'b0}}} == 18'h7860  && read_transaction  ) begin
            src_channel = 128'b00000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 33;
    end

    // ( 0x7880 .. 0x7890 )
    if ( {address[RG:PAD111],{PAD111{1'b0}}} == 18'h7880  && read_transaction  ) begin
            src_channel = 128'b00000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 34;
    end

    // ( 0x78a0 .. 0x78b0 )
    if ( {address[RG:PAD112],{PAD112{1'b0}}} == 18'h78a0  && read_transaction  ) begin
            src_channel = 128'b00000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 35;
    end

    // ( 0x7900 .. 0x7910 )
    if ( {address[RG:PAD113],{PAD113{1'b0}}} == 18'h7900  && read_transaction  ) begin
            src_channel = 128'b00000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 101;
    end

    // ( 0x7920 .. 0x7930 )
    if ( {address[RG:PAD114],{PAD114{1'b0}}} == 18'h7920  && read_transaction  ) begin
            src_channel = 128'b00000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 102;
    end

    // ( 0x7940 .. 0x7950 )
    if ( {address[RG:PAD115],{PAD115{1'b0}}} == 18'h7940  && read_transaction  ) begin
            src_channel = 128'b00000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 103;
    end

    // ( 0x7960 .. 0x7970 )
    if ( {address[RG:PAD116],{PAD116{1'b0}}} == 18'h7960  && read_transaction  ) begin
            src_channel = 128'b00000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 99;
    end

    // ( 0x7980 .. 0x7990 )
    if ( {address[RG:PAD117],{PAD117{1'b0}}} == 18'h7980  && read_transaction  ) begin
            src_channel = 128'b00000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 100;
    end

    // ( 0x79a0 .. 0x79b0 )
    if ( {address[RG:PAD118],{PAD118{1'b0}}} == 18'h79a0  && read_transaction  ) begin
            src_channel = 128'b00000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 17;
    end

    // ( 0x79c0 .. 0x79d0 )
    if ( {address[RG:PAD119],{PAD119{1'b0}}} == 18'h79c0  && read_transaction  ) begin
            src_channel = 128'b00000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 18;
    end

    // ( 0x79e0 .. 0x79f0 )
    if ( {address[RG:PAD120],{PAD120{1'b0}}} == 18'h79e0  && read_transaction  ) begin
            src_channel = 128'b00000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 19;
    end

    // ( 0x7a00 .. 0x7a10 )
    if ( {address[RG:PAD121],{PAD121{1'b0}}} == 18'h7a00  && read_transaction  ) begin
            src_channel = 128'b00000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 20;
    end

    // ( 0x7a20 .. 0x7a30 )
    if ( {address[RG:PAD122],{PAD122{1'b0}}} == 18'h7a20  && read_transaction  ) begin
            src_channel = 128'b00001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 21;
    end

    // ( 0x7a40 .. 0x7a50 )
    if ( {address[RG:PAD123],{PAD123{1'b0}}} == 18'h7a40  && read_transaction  ) begin
            src_channel = 128'b00010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 22;
    end

    // ( 0x7a60 .. 0x7a70 )
    if ( {address[RG:PAD124],{PAD124{1'b0}}} == 18'h7a60  && read_transaction  ) begin
            src_channel = 128'b10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 23;
    end

    // ( 0x7a80 .. 0x7a90 )
    if ( {address[RG:PAD125],{PAD125{1'b0}}} == 18'h7a80  && read_transaction  ) begin
            src_channel = 128'b01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 24;
    end

    // ( 0x7aa0 .. 0x7ab0 )
    if ( {address[RG:PAD126],{PAD126{1'b0}}} == 18'h7aa0  && read_transaction  ) begin
            src_channel = 128'b00100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 25;
    end

    // ( 0x30000 .. 0x30100 )
    if ( {address[RG:PAD127],{PAD127{1'b0}}} == 18'h30000   ) begin
            src_channel = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 0;
    end

end


    // --------------------------------------------------
    // Ceil(log2()) function
    // --------------------------------------------------
    function integer log2ceil;
        input reg[65:0] val;
        reg [65:0] i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction

endmodule


