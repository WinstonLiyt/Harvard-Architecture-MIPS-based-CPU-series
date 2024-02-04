`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/04 10:04:56
// Design Name: 
// Module Name: MULTU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MULTU(
    input clk,
    input reset,
    input [31:0] a,
    input [31:0] b,
    output [31:0] hi,
    output [31:0] lo
    );

    // assign {hi, lo} = a * b;
    /* 内部用变量 */
    wire [63:0] unsigned_result;        //保存无符号乘法结果
    wire signed [63:0] signed_result;   //保存有符号乘法结果
    wire [63:0] unsigned_A;             //扩展的无符号A
    wire [63:0] unsigned_B;             //扩展的无符号B

    assign unsigned_A = { 32'd0, a };
    assign unsigned_B = { 32'd0, b };
    assign unsigned_result = unsigned_A * unsigned_B;

    assign hi = unsigned_result[63:32];
    assign lo = unsigned_result[31:0];


endmodule
