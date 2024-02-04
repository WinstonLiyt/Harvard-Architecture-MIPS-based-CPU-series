`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/04 10:04:40
// Design Name: 
// Module Name: MUL
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


module MUL(
    input clk,
    input reset,
    input [31:0] a,
    input [31:0] b,
    output [31:0] c
    );

    // 都化为正数
    wire [31:0] s_a = a[31] ? -a : a;
    wire [31:0] s_b = b[31] ? -b : b;

    wire [31:0] tmp = s_a * s_b;
    
    assign c = a[31] == b[31] ? tmp : -tmp;

endmodule
