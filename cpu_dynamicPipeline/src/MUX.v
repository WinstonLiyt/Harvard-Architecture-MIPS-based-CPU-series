`timescale 1ns / 1ps

/* 32λ3-1��·ѡ���� */
module MUX3_1_32b(
    input [31:0] x_0,
    input [31:0] x_1,
    input [31:0] x_2,
    input [1:0] select,
    output reg [31:0] y
    );

    always @(*) begin
        case (select)
            2'b00: y <= x_0;
            2'b01: y <= x_1;
            2'b10: y <= x_2;
            default: y <= 32'bz;
        endcase
    end
endmodule

/* 32λ4-1��·ѡ���� */
module MUX4_1_32b(
    input [31:0] x_0,
    input [31:0] x_1,
    input [31:0] x_2,
    input [31:0] x_3,
    input [1:0] select,
    output reg [31:0] y
    );

    always @(*) begin
        case (select)
            2'b00: y <= x_0;
            2'b01: y <= x_1;
            2'b10: y <= x_2;
            2'b11: y <= x_3;
            default: y <= 32'bz;
        endcase
    end
endmodule

/* 5λ3-1��·ѡ���� */
module MUX3_1_5b(
    input [4:0] x_0,
    input [4:0] x_1,
    input [4:0] x_2,
    input [1:0] select,
    output reg [4:0] y
    );

    always @(*) begin
        case (select)
            2'b00: y <= x_0;
            2'b01: y <= x_1;
            2'b10: y <= x_2;
            default: y <= 5'bz;
        endcase
    end
endmodule