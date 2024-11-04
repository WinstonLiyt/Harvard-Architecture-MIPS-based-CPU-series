`timescale 1ns / 1ps

/* Decode2Execute */
module PipeDE(
    input clk,
    input rst,
    input DE_W_ena,
    input [31:0] ID_pc4,
    input [31:0] ID_rs_reg, ID_rt_reg,
    input [31:0] ID_imm, ID_shamt,

    input ID_DMEM_ena,
    input ID_DMEM_W_ena,
    input [1:0] ID_DMEM_W, ID_DMEM_R,

    input [4:0] ID_RF_waddr,
    input ID_RF_W_ena,

    input stall,
    input ID_load_store_mux_select,
    input [3:0] ID_aluc,
    input ID_aluc_mux1_select,
    input [1:0] ID_aluc_mux2_select,
    input [2:0] ID_RF_mux_select,

    output reg [31:0] EXE_pc4,
    output reg [31:0] EXE_rs_reg, EXE_rt_reg,
    output reg [31:0] EXE_imm, EXE_shamt,

    output reg EXE_DMEM_ena,
    output reg EXE_DMEM_W_ena,
    output reg [1:0] EXE_DMEM_W, EXE_DMEM_R,

    output reg [4:0] EXE_RF_waddr,
    output reg EXE_RF_W_ena,

    output reg [3:0] EXE_aluc,
    output reg EXE_aluc_mux1_select,
    output reg [1:0] EXE_aluc_mux2_select,
    output reg EXE_load_store_mux_select,
    output reg [2:0] EXE_RF_mux_select
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            EXE_pc4 <= 32'b0;
            EXE_rs_reg <= 32'b0;
            EXE_rt_reg <= 32'b0;
            EXE_imm <= 32'b0;
            EXE_shamt <= 32'b0;
            EXE_DMEM_ena <= 1'b0;
            EXE_DMEM_W_ena <= 1'b0;
            EXE_DMEM_W <= 2'b0;
            EXE_DMEM_R <= 2'b0;
            EXE_load_store_mux_select <= 1'b0;
            EXE_RF_mux_select <= 3'b0;
            EXE_RF_waddr <= 5'b0;
            EXE_RF_W_ena <= 1'b0;
            EXE_aluc <= 4'b0;
            EXE_aluc_mux1_select <= 1'b0;
            EXE_aluc_mux2_select <= 1'b0;
        end
        // 在非暂停且写使能激活时传递数据
        else if (!stall && DE_W_ena) begin
            EXE_pc4 <= ID_pc4;
            EXE_rs_reg <= ID_rs_reg;
            EXE_rt_reg <= ID_rt_reg;
            EXE_imm <= ID_imm;
            EXE_shamt <= ID_shamt;
            EXE_DMEM_ena <= ID_DMEM_ena;
            EXE_DMEM_W_ena <= ID_DMEM_W_ena;
            EXE_DMEM_W <= ID_DMEM_W;
            EXE_DMEM_R <= ID_DMEM_R;
            EXE_load_store_mux_select <= ID_load_store_mux_select;
            EXE_RF_mux_select <= ID_RF_mux_select;
            EXE_RF_waddr <= ID_RF_waddr;
            EXE_RF_W_ena <= ID_RF_W_ena;
            EXE_aluc <= ID_aluc;
            EXE_aluc_mux1_select <= ID_aluc_mux1_select;
            EXE_aluc_mux2_select <= ID_aluc_mux2_select;
        end
    end

endmodule