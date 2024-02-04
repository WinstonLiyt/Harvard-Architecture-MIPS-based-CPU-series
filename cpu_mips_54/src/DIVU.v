`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/04 10:05:22
// Design Name: 
// Module Name: DIVU
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


// module DIVU(
//     input [31:0]dividend,   // ������
//     input [31:0]divisor,    // ����
//     // input start,            // ��ʼ����
//     // input clock, 
//     // input reset, 
//     output [31:0]q,         // ��
//     output [31:0]r         // ����    
//     // output  reg busy        // ������æ��־λ
//     );

//     assign r =  (divisor == 32'd0) ? 32'd0 : (dividend % divisor);
//     assign q =  (divisor == 32'd0) ? 32'd0 : (dividend / divisor);
// endmodule

module DIVU(
    input [31:0] a,
    input [31:0] b,

    input sign,

    output [31:0] q,
    output [31:0] r
    );

    // a/b = q ,a % b = r;
    //�޷���
    wire [31:0] unsigned_q,unsigned_r;
    assign unsigned_q = (b==0)?0 : (a/b);
    assign unsigned_r = (b==0)?0 : (a%b);

    //�з���
    wire signed [31:0] signed_q,signed_r;
    wire signed [31:0] sa,sb;
    assign sa = a;
    assign sb = b;
    assign signed_q = (sb==0)?0:(sa/sb);
    assign signed_r = (sb==0)?0:(sa%sb);

    //���ս��
    assign q = sign ? signed_q : unsigned_q;
    assign r = sign ? signed_r : unsigned_r;

endmodule