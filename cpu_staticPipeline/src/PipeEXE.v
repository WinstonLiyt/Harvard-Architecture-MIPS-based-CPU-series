`timescale 1ns / 1ps

/* Execute Stage */
module PipeEXE(
    input rst,
    input [31:0] pc4,
    input [31:0] rs_reg, rt_reg,
    input [31:0] imm, shamt,

    input DMEM_ena,
    input DMEM_W_ena,
    input [1:0] DMEM_W, DMEM_R,

    input RF_W_ena,
    input [4:0] RF_waddr,
    input [2:0] RF_mux_select,

    input [3:0] aluc,
    input aluc_mux1_select,
    input [1:0] aluc_mux2_select,
    input load_store_mux_select,

    output [31:0] EXE_aluc,
    output [31:0] EXE_pc4,
    output [31:0] EXE_rs_reg, EXE_rt_reg,
    
    output EXE_DMEM_ena,
    output EXE_DMEM_W_ena,
    output [1:0] EXE_DMEM_W, EXE_DMEM_R,
    
    output EXE_RF_W_ena,
    output [4:0] EXE_RF_waddr,
    output [2:0] EXE_RF_mux_select,
    output EXE_load_store_mux_select
    );

    wire aluc_zero;
    wire [31:0] aluc_a, aluc_b;

    assign EXE_pc4 = pc4;
    assign EXE_rs_reg = rs_reg;
    assign EXE_rt_reg = rt_reg;

    assign EXE_DMEM_ena = DMEM_ena;
    assign EXE_DMEM_W_ena = DMEM_W_ena;
    assign EXE_DMEM_R = DMEM_R;
    assign EXE_DMEM_W = DMEM_W;
    
    assign EXE_RF_W_ena = RF_W_ena;
    assign EXE_RF_waddr = RF_waddr;
    assign EXE_RF_mux_select = RF_mux_select;
    assign EXE_load_store_mux_select = load_store_mux_select;

    MUX2_1_32b alu_mux2_1(
        .x_0(shamt),
        .x_1(rs_reg),
        .select(aluc_mux1_select),
        .y(aluc_a)
    );

    MUX4_1_32b alu_mux4_1(
        .x_0(rt_reg),
        .x_1(imm),
        .x_2(32'b0),
        .x_3(32'b0),
        .select(aluc_mux2_select),
        .y(aluc_b)
    );

    ALU cpu_alu(
        .a(aluc_a),
        .b(aluc_b),
        .aluc(aluc),
        .r(EXE_aluc),
        .zero(aluc_zero)
    );

endmodule