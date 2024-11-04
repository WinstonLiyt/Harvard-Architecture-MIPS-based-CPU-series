`timescale 1ns / 1ps

/* Fetch2Decode */
module PipeFD(
    input clk,              // ʱ���ź�
    input rst,              // ��λ�ź�
    input [31:0] pc4, inst,
    output reg [31:0] ID_pc4,   // �������һ����ˮ�߽׶ε� PC ֵ��4
    output reg [31:0] ID_inst   // �������һ����ˮ�߽׶ε�ָ��
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ID_inst <= 32'h0;
            ID_pc4 <= 32'h0;
        end 
        else begin  // ��ȡָ�׶δ���inst��npc��ָ������׶�
            ID_inst <= inst;
            ID_pc4 <= pc4;
        end
    end
endmodule