`timescale 1ns / 1ps

module Pipe_cpu_tb();
reg clk;
    reg reset;
    wire [31:0] inst;
    wire [31:0] pc;
    wire [31:0] reg1;
    wire [31:0] reg2;
    wire [31:0] reg3;
    wire [31:0] reg4;
    wire [31:0] reg7;
 
    Pipe_cpu my_pipeline_cpu(
        .clk(clk),
        .rst(reset),
        .inst(inst),
        .pc(pc),
        .reg1(reg1),
        .reg2(reg2),
        .reg3(reg3),
        .reg4(reg4),
        .reg7(reg7)
    );
    initial begin
        clk = 0;
        reset = 1;
        #3
        reset = 0;
    end
 
    always begin
        #3 clk = ~clk;
    end

endmodule