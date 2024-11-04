`timescale 1ns / 1ps

/* �޷�����չ5λ��32λ */
module EXT5_32b (
    input [4:0] x,
    output [31:0] y
    );

    assign y = {27'b0, x};

endmodule

/* �У��ޣ�������չ16λ��32λ */
module SEXT16_32b (
    input [15:0] x,
    input s,
    output [31:0] y 
    );

    assign y = s ? {{16{x[15]}}, x} : {16'b0, x};

endmodule

/* �з�����չ16λ��32λ */
module SEXT18_32b (
    input [17:0] x,
    output [31:0] y
    );

    assign y = {{14{x[17]}}, x};

endmodule
