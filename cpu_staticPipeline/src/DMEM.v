`timescale 1ns / 1ps

module DMEM(
    input clk,                  // ʱ���ź�
    input ena,                  // DMEMʹ��
    input w_ena,                // дʹ��
    input [1:0] dm_w,           // д���������ź�
    input [1:0] dm_r,           // �����������ź�
    input [31:0] dm_addr,       // ��ַ����
    input [31:0] dm_wdata,      // �������ݣ�д��
    output [31:0] dm_rdata  // ������ݣ�����
    );

reg [7:0] mem [0:255];  // �ڴ�����

always @(negedge clk) begin
    if (ena && dm_w) begin
        mem[dm_addr] <= dm_wdata;  // SW
    end
end

assign dm_rdata = (ena && dm_r) ? mem[dm_addr] : 32'bz;  // LW��DMEM�н���Ѱַ����ȡֵ

endmodule