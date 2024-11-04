`timescale 1ns / 1ps

/* 32位2-1多路选择器 */
module MUX2_1_32b(
    input [31:0] x_0,
    input [31:0] x_1,
    input select,
    output reg [31:0] y
    );

    always @(*) begin
        case (select)
            1'b0: y <= x_0;
            1'b1: y <= x_1;
        endcase
    end

endmodule

/* 32位4-1多路选择器 */
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
            default: y <= 31'bz;
        endcase
    end

endmodule

/* 32位6-1多路选择器 */
module MUX6_1_32b(
	input [31:0] x_0,
	input [31:0] x_1,
	input [31:0] x_2,
	input [31:0] x_3,
	input [31:0] x_4,
	input [31:0] x_5,
	input [2:0] select,
	output reg [31:0] y
	);

	always @(*) begin
		case (select)
			3'b000: y <= x_0;
			3'b001: y <= x_1;
			3'b010: y <= x_2;
			3'b011: y <= x_3;
			3'b100: y <= x_4;
			3'b101: y <= x_5;
			default: y <= 32'bz;
		endcase
	end

endmodule

/* 32位8-1多路选择器 */
module MUX8_1_32b(
    input [31:0] x_0,
    input [31:0] x_1,
    input [31:0] x_2,
    input [31:0] x_3,
    input [31:0] x_4,
    input [31:0] x_5,
    input [31:0] x_6,
    input [31:0] x_7,
    input [2:0] select,
    output reg [31:0] y
    );

    always @(*) begin
        case (select)
            3'b000: y <= x_0;
            3'b001: y <= x_1;
            3'b010: y <= x_2;
            3'b011: y <= x_3;
            3'b100: y <= x_4;
            3'b101: y <= x_5;
            3'b110: y <= x_6;
            3'b111: y <= x_7;
            default: y <= 32'bz;
        endcase
    end

endmodule

/* 5位2-1多路选择器 */
module MUX2_1_5b(
    input [4:0] x_0,
    input [4:0] x_1,
    input select,
    output reg [4:0] y
    );

    always @(*) begin
        case (select)
            1'b0: y <= x_0;
            1'b1: y <= x_1;
        endcase
    end

endmodule