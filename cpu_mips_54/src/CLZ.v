`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/04 11:45:53
// Design Name: 
// Module Name: CLZ
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


module CLZ(
    input [31:0] in, 
    output [31:0] out
    );

    reg [31:0] cnt = 32'd0;

    always @(*) begin
        if (in[31] == 1'b1)                         cnt <= 0;
        else if (in[30] == 1'b1 && in[31] == 0)     cnt <= 1;
        else if (in[29] == 1'b1 && in[31:30] == 0)  cnt <= 2;
        else if (in[28] == 1'b1 && in[31:29] == 0)  cnt <= 3;
        else if (in[27] == 1'b1 && in[31:28] == 0)  cnt <= 4;
        else if (in[26] == 1'b1 && in[31:27] == 0)  cnt <= 5;
        else if (in[25] == 1'b1 && in[31:26] == 0)  cnt <= 6;
        else if (in[24] == 1'b1 && in[31:25] == 0)  cnt <= 7;
        else if (in[23] == 1'b1 && in[31:24] == 0)  cnt <= 8;
        else if (in[22] == 1'b1 && in[31:23] == 0)  cnt <= 9;
        else if (in[21] == 1'b1 && in[31:22] == 0)  cnt <= 10;
        else if (in[20] == 1'b1 && in[31:21] == 0)  cnt <= 11;
        else if (in[19] == 1'b1 && in[31:20] == 0)  cnt <= 12;
        else if (in[18] == 1'b1 && in[31:19] == 0)  cnt <= 13;
        else if (in[17] == 1'b1 && in[31:18] == 0)  cnt <= 14;
        else if (in[16] == 1'b1 && in[31:17] == 0)  cnt <= 15;
        else if (in[15] == 1'b1 && in[31:16] == 0)  cnt <= 16;
        else if (in[14] == 1'b1 && in[31:15] == 0)  cnt <= 17;
        else if (in[13] == 1'b1 && in[31:14] == 0)  cnt <= 18;
        else if (in[12] == 1'b1 && in[31:13] == 0)  cnt <= 19;
        else if (in[11] == 1'b1 && in[31:12] == 0)  cnt <= 20;
        else if (in[10] == 1'b1 && in[31:11] == 0)  cnt <= 21;
        else if (in[9] == 1'b1 && in[31:10] == 0)   cnt <= 22;
        else if (in[8] == 1'b1 && in[31:9] == 0)    cnt <= 23;
        else if (in[7] == 1'b1 && in[31:8] == 0)    cnt <= 24;
        else if (in[6] == 1'b1 && in[31:7] == 0)    cnt <= 25;
        else if (in[5] == 1'b1 && in[31:6] == 0)    cnt <= 26;
        else if (in[4] == 1'b1 && in[31:5] == 0)    cnt <= 27;
        else if (in[3] == 1'b1 && in[31:4] == 0)    cnt <= 28;
        else if (in[2] == 1'b1 && in[31:3] == 0)    cnt <= 29;
        else if (in[1] == 1'b1 && in[31:2] == 0)    cnt <= 30;
        else if (in[0] == 1'b1 && in[31:1] == 0)    cnt <= 31;
        else if (in == 0)                           cnt <= 32;
    end

    assign out = cnt;
    
endmodule
