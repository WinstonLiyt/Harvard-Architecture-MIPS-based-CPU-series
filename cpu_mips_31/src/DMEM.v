`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/13 22:45:54
// Design Name: 
// Module Name: DMEM
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


module DMEM(
    input clk,
    input ena,
    input DM_W,
    input DM_R,
    input [10:0] DM_addr,
    input [31:0] DM_wdata,
    output [31:0] DM_rdata
    );

    reg [31:0] mem [31:0];

    always @(negedge clk) begin
        if (ena && DM_W) begin
            mem[DM_addr] <= DM_wdata;  // SW
        end
    end

    assign DM_rdata = (ena && DM_R) ? mem[DM_addr] : 32'bz;  // LW：DMEM中进行寻址并读取值

endmodule