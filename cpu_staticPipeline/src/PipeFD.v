`timescale 1ns / 1ps

/* Fetch2Decode */
module PipeFD(
    input clk,
    input rst,
    input [31:0] pc4, inst,
    input stall,
    input branch,
    output reg [31:0] ID_pc4,   // �������һ����ˮ�߽׶ε� PC ֵ��4
    output reg [31:0] ID_inst   // �������һ����ˮ�߽׶ε�ָ��
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
        // �������ͣ�����ֵ�ǰֵ����
    end

endmodule