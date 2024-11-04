`timescale 1ns / 1ps

module MUL(
    input rst,
    input [31:0] a,
    input [31:0] b,
    output [63:0] c
    );

    // 都化为正数
    wire [31:0] s_a = a[31] ? -a : a;
    wire [31:0] s_b = b[31] ? -b : b;

    wire [63:0] tmp = s_a * s_b;
    
    assign c = a[31] == b[31] ? tmp : -tmp;

endmodule