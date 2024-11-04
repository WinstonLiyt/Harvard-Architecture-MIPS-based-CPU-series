`timescale 1ns / 1ps

/* ������ͣ */
module ControllerStall(
    input clk,
    input rst,
    input [4:0] rs, rt,
	input [4:0] EXE_RF_waddr,   // ִ�н׶ε�д���ַ
    input EXE_RF_W_ena,         // ִ�н׶ε�дʹ��
	input [4:0] MEM_RF_waddr,   // �ڴ�׶ε�д���ַ
    input MEM_RF_W_ena,         // �ڴ�׶ε�дʹ��
    output reg stall            // ��ͣ�ź�
    );

    reg cnt;

    always @(negedge clk or posedge rst) begin
        if (rst) begin
            stall <= 1'b0;
            cnt <= 0;
        end
        else if (cnt >= 1) begin
            cnt <= cnt - 1;
        end
        else if (stall) begin
            stall <= 1'b0;
        end
        else if(!stall) begin
            if (EXE_RF_W_ena && (EXE_RF_waddr == rs || EXE_RF_waddr == rt)) begin
                stall <= 1'b1; 
                cnt <= 1'b1;
            end
            else if(MEM_RF_W_ena && (MEM_RF_waddr == rs || MEM_RF_waddr == rt)) begin
                stall <= 1'b1;
            end
        end
	end

endmodule