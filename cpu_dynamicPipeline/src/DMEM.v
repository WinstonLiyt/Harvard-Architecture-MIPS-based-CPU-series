`timescale 1ns / 1ps

/* DMEM */
module DMEM(
    input clk,
    input rst,
    input DM_w,
	input [31:0] addr,
    input [31:0] data_in,
    output [31:0] data_out
    );

    parameter MEM_SIZE = 2048;
    reg [31:0] mem[0:MEM_SIZE-1];

    wire [31:0] adjusted_addr;
    assign adjusted_addr = addr - 32'h10010000;

    integer i;  // 在Verilog的always块中不允许声明变量
    always @(negedge clk) begin
        if (rst) begin
            for (i = 0; i < MEM_SIZE; i = i + 1) begin
                mem[i] <= 0;
            end
        end 
        else if (DM_w) begin
            mem[adjusted_addr[10:0]] <= data_in;
        end
    end

    assign data_out = mem[adjusted_addr[10:0]];

endmodule