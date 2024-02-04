`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 21:04:49
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] a,
    input [31:0] b,
    input [4:0] aluc,
    output [31:0] res,
    output zero,
    output negative
    );

    reg [32:0] r;

    wire signed [31:0] sign_a, sign_b;
    assign sign_a = a;
    assign sign_b = b;

    always @ (*) begin
        casex (aluc)
            5'b00000:   // ADD ADDI
                r <= sign_a + sign_b;
            5'b00001:   // ADDU ADDIU
                r <= a + b;
            5'b00010:   // SUB SUBI
                r <= sign_a - sign_b;
            5'b00011:   // SUBU SUBIU
                r <= a - b;
            5'b00100:   // AND ANDI
                r <= a & b;
            5'b00101:   // OR ORI
                r <= a | b;
            5'b00110:   // XOR XORI
                r <= a ^ b;
            5'b00111:   // NOR
                r <= ~(a | b);

            5'b01000:   // SLT SLTI
                r <= sign_a < sign_b ? 1 : 0;
            5'b01001:   // SLTU SLTIU
                r <= a < b ? 1 : 0;
            5'b01010:   // SLL
                r <= b << a;
            5'b01011:   // SRL
                r <= b >> a;
            5'b01100:   // SRA
                r <= sign_b >>> sign_a;
            5'b01101:   // SLLV
                r <= b << a[4:0];
            5'b01110:   // SRLV
                r <= b >> a[4:0];
            5'b01111:   // SRAV
                r <= sign_b >>> sign_a[4:0];
            
            5'b10000:   // LUI
                r <= {b[15:0], 16'b0};

            default:
            ;
        endcase
    end
    assign res = r[31:0];
    assign zero = ((a == b) == 1) ? 1 : 0;
    assign negative	= (aluc == 5'b00010) ? r[31] : 1'bz;
    
endmodule
