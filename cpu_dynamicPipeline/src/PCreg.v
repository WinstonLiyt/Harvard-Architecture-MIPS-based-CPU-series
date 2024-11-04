`timescale 1ns / 1ps

/* PCreg，更新PC的值 */
module PCreg(
    input clk,
    input rst,
    input [31:0] Pc_in,
    output [31:0] Pc_out
    );
    
    reg [31:0] pc_tmp;
	
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_tmp <= 32'h00400000;
        end
        else begin
            pc_tmp <= Pc_in;
        end
    end
    
    assign Pc_out = pc_tmp;

endmodule
