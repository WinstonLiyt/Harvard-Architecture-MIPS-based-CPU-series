`timescale 1ns / 1ps

/* PCreg，更新PC的值 */
module PCreg(
    input clk,
    input rst,
    input w_ena,
    input stall,
    input [31:0] Pc_in,
    output [31:0] Pc_out
    );

    reg [31:0] pc_tmp;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_tmp <= 32'h00400000; // 起始地址
        end
        else if (!stall && w_ena) begin
            pc_tmp <= Pc_in; // 更新PC值
        end
        // 如果有暂停或写使能未激活，则保持PC不变
    end

    assign Pc_out = pc_tmp;

endmodule
