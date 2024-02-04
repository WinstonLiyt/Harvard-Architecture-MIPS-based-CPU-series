`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/13 22:38:48
// Design Name: 
// Module Name: IMEM
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

// 给定addr，返回相应的instruction。
module IMEM(
    input [10:0] addr,
    output [31:0] inst
    );

    dist_mem_gen_0 your_instance_name (
        .a(addr),   // input wire [10 : 0] a
        .spo(inst)  // output wire [31 : 0] spo
    );
endmodule