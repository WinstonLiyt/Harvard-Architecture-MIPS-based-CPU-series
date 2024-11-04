`timescale 1ns / 1ps

module ALU(
    input [31:0] a,
    input [31:0] b,
    input [3:0] aluc,
    output reg [31:0] r,
    output reg zero
    );

    always @ (*) begin
        case (aluc)
            4'b0000, 4'b0010: begin // ADD, ADDU
                r <= a + b;
            end
            4'b0001, 4'b0011: begin // SUB, SUBU
                r <= a - b;
            end
            4'b0100: r <= a & b;    // AND
            4'b0101: r <= a | b;    // OR
            4'b0110: r <= a ^ b;    // XOR
            4'b0111: r <= ~(a | b); // NOR
            4'b100x: r <= {b[15:0], 16'b0}; // LUI
            4'b1010: r <= (a < b ? 1 : 0); // SLT
            4'b1011: begin // SLTU
                if(a[31] == b[31])
                    r <= (a < b ? 1 : 0);
                else
                    r <= (a[31] == 1 ? 1 : 0);
            end
            4'b1100: begin // SRA
                r <= (a >= 32) ? (b[31] ? 32'hffffffff : 0) :
                     (b[31] ? (b >> a) | (32'hffffffff << (32 - a)) : b >> a);
            end
            4'b1101: r <= b >> a;   // SRL
            4'b111x: r <= b << a;   // SLL
            default: r <= 0;
        endcase

        zero <= (r == 0);
    end
endmodule