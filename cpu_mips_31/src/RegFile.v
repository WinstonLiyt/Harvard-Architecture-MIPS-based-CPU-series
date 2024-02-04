`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/14 16:42:25
// Design Name: 
// Module Name: RegFile
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


module RegFile(
    input ena,
    input reset,
    input clk,
    input RF_w,
    input [4:0] rdc,
    input [4:0] rsc,
    input [4:0] rtc,
    input [31:0] rd,
    output [31:0] rs,
    output [31:0] rt
    );

    reg [31:0] array_reg [31:0];

    always @(negedge clk, posedge reset) begin
        if (reset && ena) begin
            array_reg[0] <= 32'b0;
            array_reg[1] <= 32'b0;
            array_reg[2] <= 32'b0;
            array_reg[3] <= 32'b0;
            array_reg[4] <= 32'b0;
            array_reg[5] <= 32'b0;
            array_reg[6] <= 32'b0;
            array_reg[7] <= 32'b0;
            array_reg[8] <= 32'b0;
            array_reg[9] <= 32'b0;
            array_reg[10] <= 32'b0;
            array_reg[11] <= 32'b0;
            array_reg[12] <= 32'b0;
            array_reg[13] <= 32'b0;
            array_reg[14] <= 32'b0;
            array_reg[15] <= 32'b0;
            array_reg[16] <= 32'b0;
            array_reg[17] <= 32'b0;
            array_reg[18] <= 32'b0;
            array_reg[19] <= 32'b0;
            array_reg[20] <= 32'b0;
            array_reg[21] <= 32'b0;
            array_reg[22] <= 32'b0;
            array_reg[23] <= 32'b0;
            array_reg[24] <= 32'b0;
            array_reg[25] <= 32'b0;
            array_reg[26] <= 32'b0;
            array_reg[27] <= 32'b0;
            array_reg[28] <= 32'b0;
            array_reg[29] <= 32'b0;
            array_reg[30] <= 32'b0; 
            array_reg[31] <= 32'b0;
        end
        else begin
            if (RF_w == 1'b1 && ena && rdc != 5'b0)
                array_reg[rdc] <= rd;
        end
    
    end

    assign rs = ena ? array_reg[rsc] : 32'bz;
    assign rt = ena ? array_reg[rtc] : 32'bz;

endmodule