`timescale 1ns / 1ps

module divider#(parameter num = 2)(
    input clk_in,
    input rst,
    output reg clk_out
    );

    integer i = 0;
    
    always @ (posedge clk_in or posedge rst) begin
        if (rst == 1) begin
            clk_out <= 0;
            i <= 0; 
        end
        else begin
            if (i == num - 1) begin
                clk_out <= ~clk_out; 
                i <= 0;
            end
            else
                i <= i + 1;
        end
    end
    
endmodule