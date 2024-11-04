`timescale 1ns / 1ps

/* Fetch2Decode */
module PipeFD(
    input clk,              // 时钟信号
    input rst,              // 复位信号
    input [31:0] pc4, inst,
    output reg [31:0] ID_pc4,   // 输出到下一个流水线阶段的 PC 值加4
    output reg [31:0] ID_inst   // 输出到下一个流水线阶段的指令
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ID_inst <= 32'h0;
            ID_pc4 <= 32'h0;
        end 
        else begin  // 从取指阶段传递inst和npc到指令译码阶段
            ID_inst <= inst;
            ID_pc4 <= pc4;
        end
    end
endmodule