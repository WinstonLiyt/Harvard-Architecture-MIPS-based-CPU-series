`timescale 1ns / 1ps

module PipeMW(
    input clk,
    input rst,

    input [31:0] MEM_npc,
    input MEM_LW, MEM_JAL, MEM_MUL,

    input [31:0] MEM_aluc,
    input [31:0] MEM_MUL_res,
    
    input [31:0] MEM_DM_rdata,

    input MEM_RF_W_ena,
    input [4:0] MEM_RF_waddr,

    output reg [31:0] WB_npc,

    output reg WB_LW, WB_JAL, WB_MUL,

    output reg [31:0] WB_aluc,
    output reg [31:0] WB_MUL_res,

    output reg [31:0] WB_DM_rdata,

    output reg WB_RF_W_ena,
    output reg [4:0] WB_RF_waddr
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            {WB_npc, WB_LW, WB_JAL, WB_MUL,
             WB_aluc, WB_MUL_res, WB_DM_rdata,
             WB_RF_W_ena, WB_RF_waddr} <= 0;
        end 
        else begin
            WB_npc <= MEM_npc;
            WB_LW <= MEM_LW;
            WB_JAL <= MEM_JAL;
            WB_MUL <= MEM_MUL;
            WB_aluc <= MEM_aluc;
            WB_MUL_res <= MEM_MUL_res;
            WB_DM_rdata <= MEM_DM_rdata;
            WB_RF_W_ena <= MEM_RF_W_ena;
            WB_RF_waddr <= MEM_RF_waddr;
        end
    end

endmodule