`timescale 1ns / 1ps

/* PCreg������PC��ֵ */
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
            pc_tmp <= 32'h00400000; // ��ʼ��ַ
        end
        else if (!stall && w_ena) begin
            pc_tmp <= Pc_in; // ����PCֵ
        end
        // �������ͣ��дʹ��δ����򱣳�PC����
    end

    assign Pc_out = pc_tmp;

endmodule
