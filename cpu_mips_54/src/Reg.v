`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/04 13:47:45
// Design Name: 
// Module Name: Reg
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


module Reg(
    input clk,
	input rst,
	input ena,
	input [31:0] Reg_in,
	output reg [31:0] Reg_out
    );

	always@(negedge clk or posedge rst) begin
		if (rst) begin
			Reg_out <= 32'b0;
		end
		else if (ena) begin
			Reg_out <= Reg_in;
		end
	end

endmodule
