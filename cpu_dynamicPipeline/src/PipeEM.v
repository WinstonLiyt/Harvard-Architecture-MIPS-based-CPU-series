`timescale 1ns / 1ps

module PipeEM(
    input clk,
    input rst,

    input [31:0] EXE_npc,

    input EXE_LW, EXE_JAL, EXE_MUL,

    input [31:0] EXE_aluc,
    input [31:0] EXE_MUL_res,
    
    input EXE_DM_W_ena,
    input [31:0] EXE_DM_wdata,

    input EXE_RF_W_ena,
    input [4:0] EXE_RF_waddr,

    output reg [31:0] MEM_npc,

    output reg MEM_LW, MEM_JAL, MEM_MUL,

    output reg [31:0] MEM_aluc,
    output reg [31:0] MEM_MUL_res,

    output reg MEM_DM_W_ena,
    output reg [31:0] MEM_DM_wdata,

    output reg MEM_RF_W_ena,
    output reg [4:0] MEM_RF_waddr
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            {MEM_npc, MEM_LW, MEM_JAL, MEM_MUL,
             MEM_aluc, MEM_MUL_res, MEM_DM_W_ena,
             MEM_DM_wdata, MEM_RF_W_ena, MEM_RF_waddr} <= 0;
        end 
        else begin
            MEM_npc <= EXE_npc;
            MEM_LW <= EXE_LW;
            MEM_JAL <= EXE_JAL;
            MEM_MUL <= EXE_MUL;
            MEM_aluc <= EXE_aluc;
            MEM_MUL_res <= EXE_MUL_res;
            MEM_DM_W_ena <= EXE_DM_W_ena;
            MEM_DM_wdata <= EXE_DM_wdata;
            MEM_RF_W_ena <= EXE_RF_W_ena;
            MEM_RF_waddr <= EXE_RF_waddr;
        end
    end

endmodule