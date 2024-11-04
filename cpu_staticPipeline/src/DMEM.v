`timescale 1ns / 1ps

module DMEM(
    input clk,                  // 时钟信号
    input ena,                  // DMEM使能
    input w_ena,                // 写使能
    input [1:0] dm_w,           // 写操作控制信号
    input [1:0] dm_r,           // 读操作控制信号
    input [31:0] dm_addr,       // 地址输入
    input [31:0] dm_wdata,      // 读入数据（写）
    output [31:0] dm_rdata  // 输出数据（读）
    );

reg [7:0] mem [0:255];  // 内存数组

always @(negedge clk) begin
    if (ena && dm_w) begin
        mem[dm_addr] <= dm_wdata;  // SW
    end
end

assign dm_rdata = (ena && dm_r) ? mem[dm_addr] : 32'bz;  // LW：DMEM中进行寻址并读取值

endmodule