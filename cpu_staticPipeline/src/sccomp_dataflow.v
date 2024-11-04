`timescale 1ns / 1ps

module sccomp_dataflow(
    input clk,
    input rst,
    output [7:0] o_seg,
	output [7:0] o_sel,
	output last_broken
    );

    wire [31:0] inst, pc;
    wire [31:0] reg1, reg2, reg3, reg4, reg7;

    Pipe_cpu my_cpu(
        .clk(clk),
        .rst(rst),
        .inst(inst),
        .pc(pc),
        .reg1(reg1),
        .reg2(reg2),
        .reg3(reg3),
        .reg4(reg4),
        .reg7(reg7)
        );

    wire [31:0] data_in;
    assign data_in[31:16] = reg3[15:0];
    assign data_in[15:0] = reg4[15:0];
    assign last_broken = reg7[0];

    seg7x16 seg(
        .clk(clk),
        .reset(rst),
        .i_data(data_in),
        .o_seg(o_seg),
        .o_sel(o_sel)
        );

endmodule