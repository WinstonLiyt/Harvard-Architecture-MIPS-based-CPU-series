`timescale 1ns / 1ps

/* WriteBack Stage */
module PipeWB(
    input [31:0] aluc,
    input [31:0] dmem_out,
    input [31:0] pc4,
    input [31:0] rs_reg,
    input RF_W_ena,
    input [4:0] RF_waddr,
    input [2:0] RF_mux_select,
    output [31:0] RF_wdate,
    output WB_RF_W_ena,
    output [4:0] WB_RF_waddr
    );

    assign WB_RF_waddr = RF_waddr;
    assign WB_RF_W_ena = RF_W_ena;

    MUX8_1_32b rb_mux8_1(
        .x_0(0),
        .x_1(pc4),
        .x_2(0),
        .x_3(0),
        .x_4(dmem_out),
        .x_5(aluc),
        .x_6(0),
        .x_7(0),
        .select(RF_mux_select),
        .y(RF_wdate)
    );

endmodule