`timescale 1ns / 1ps

/* ¼Ä´æÆ÷¶ÁĞ´ */
module Regfile(
    input ena,
    input clk, 
    input rst, 
    input RF_w,

    input [4:0] rdc,
    input [4:0] rsc,
    input [4:0] rtc,
    input [31:0] rd,
    output [31:0] rs, rt,
    output [31:0] reg_i, reg_a, reg_b, reg_c, reg_d
    );
    
    integer i;
    reg [31:0] array_reg [0:31];

	always @(negedge clk or posedge rst) begin
        if (rst) begin
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
            if ((RF_w == 1'b1) && (rdc != 5'b0))
                array_reg[rdc] <= rd;
        end
	end

    assign rs = ena ? array_reg[rsc] : 32'bz;
    assign rt = ena ? array_reg[rtc] : 32'bz;
    assign reg_i = array_reg[6];
    assign reg_a = array_reg[7];
    assign reg_b = array_reg[8];
    assign reg_c = array_reg[9];
    assign reg_d = array_reg[10];

endmodule