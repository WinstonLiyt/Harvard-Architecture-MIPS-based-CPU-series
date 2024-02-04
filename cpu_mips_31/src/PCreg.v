`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/14 17:00:59
// Design Name: 
// Module Name: PCreg
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


module PCreg(
    input ena,
    input reset,
    input clk,
    input [31:0] Pc_in,
    output [31:0] Pc_out
    );

    reg [31:0] t;

    always @(negedge clk, posedge reset) begin
        if (ena) begin
            if (reset)
                t <= 32'h00400000;
            else
                t <= Pc_in;
        end
    end

    assign Pc_out = ena ? t : 32'bz;

endmodule
