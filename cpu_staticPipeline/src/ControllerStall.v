`timescale 1ns / 1ps

/* 控制暂停 */
module ControllerStall(
    input clk,
    input rst,
    input [4:0] rs, rt,
	input [4:0] EXE_RF_waddr,   // 执行阶段的写入地址
    input EXE_RF_W_ena,         // 执行阶段的写使能
	input [4:0] MEM_RF_waddr,   // 内存阶段的写入地址
    input MEM_RF_W_ena,         // 内存阶段的写使能
    output reg stall            // 暂停信号
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