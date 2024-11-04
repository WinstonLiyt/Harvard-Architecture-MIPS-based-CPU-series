`timescale 1ns / 1ps

module PipeDE(
    input clk,
    input rst,

    input ID_LW, ID_JAL, ID_MUL,
    
    input [4:0] ID_aluc,
    input ID_aluc_mux1_select,
    input [1:0] ID_aluc_mux2_select,
    
    input [31:0] ID_npc,
    input [31:0] ID_shamt, ID_imm, ID_immu,
    input [31:0] ID_rs_reg, ID_rt_reg,

    input DM_W_ena,
    input [31:0] ID_DM_wdata,

    input RF_W_ena,
    input [4:0] ID_RF_waddr,


    output reg EXE_LW, EXE_JAL, EXE_MUL,

    output reg [4:0] EXE_aluc,
    output reg EXE_aluc_mux1_select,
    output reg [1:0] EXE_aluc_mux2_select,

    output reg [31:0] EXE_npc,
    
    output reg [31:0] EXE_shamt, EXE_imm, EXE_immu,
    output reg [31:0] EXE_rs_reg, EXE_rt_reg,

    output reg EXE_DM_W_ena,
    output reg [31:0] EXE_DM_wdata,

    output reg EXE_RF_W_ena,
    output reg [4:0] EXE_RF_waddr
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            {EXE_LW, EXE_JAL, EXE_MUL, EXE_aluc, 
             EXE_aluc_mux1_select, EXE_aluc_mux2_select,
             EXE_npc, EXE_shamt, EXE_imm, EXE_immu,
             EXE_rs_reg, EXE_rt_reg, EXE_DM_W_ena,
             EXE_DM_wdata, EXE_RF_W_ena, EXE_RF_waddr} <= 0;
        end
        else begin
            EXE_LW <= ID_LW;
            EXE_JAL <= ID_JAL;
            EXE_MUL <= ID_MUL;
            EXE_aluc <= ID_aluc;
            EXE_aluc_mux1_select <= ID_aluc_mux1_select;
            EXE_aluc_mux2_select <= ID_aluc_mux2_select;
            EXE_npc <= ID_npc;
            EXE_shamt <= ID_shamt;
            EXE_imm <= ID_imm;
            EXE_immu <= ID_immu;
            EXE_rs_reg <= ID_rs_reg;
            EXE_rt_reg <= ID_rt_reg;
            EXE_DM_W_ena <= DM_W_ena;
            EXE_DM_wdata <= ID_DM_wdata;
            EXE_RF_W_ena <= RF_W_ena;
            EXE_RF_waddr <= ID_RF_waddr;
        end
    end
endmodule