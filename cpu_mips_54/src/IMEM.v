`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 21:04:15
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


module IMEM(
    input [10:0] addr,
    output [31:0] inst
    );

    dist_mem_gen_0 your_instance_name (
        .a(addr),   // input wire [10 : 0] a
        .spo(inst)  // output wire [31 : 0] spo
    );
endmodule
