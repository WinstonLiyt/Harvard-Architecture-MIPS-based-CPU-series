`timescale 1ns / 1ps

/* Fetch2Decode */
module PipeFD(
    input clk,
    input rst,
    input [31:0] pc4, inst,
    input stall,
    input branch,
    output reg [31:0] ID_pc4,   // 输出到下一个流水线阶段的 PC 值加4
    output reg [31:0] ID_inst   // 输出到下一个流水线阶段的指令
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ID_inst <= 32'h0;
            ID_pc4 <= 32'h0;
        end
        else if (!stall) begin
            if (branch) begin
                ID_inst <= 32'h0;
                ID_pc4 <= 32'h0;
            end
            else begin
                ID_inst <= inst;
                ID_pc4 <= pc4;
            end
        end
        // 如果有暂停，保持当前值不变
    end

endmodule