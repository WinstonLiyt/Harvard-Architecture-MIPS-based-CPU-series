`timescale 1ns / 1ps

module sccomp_dataflow_board(
    input clk,
    input rst,
    input stall,
    input [5:0] choose,
    output [7:0] o_seg,
    output [7:0] o_sel
    ); 
    wire [31:0] i_data;
    wire [31:0] inst, pc;
    wire [31:0] reg_i, reg_a, reg_b, reg_c, reg_d;
    wire clk_cpu, clk_board;
    wire clk_seg;
    

    assign i_data = (choose[5]) ? inst : (
                    (choose[4]) ? pc :(
                    (choose[3]) ? reg_d :(
                    (choose[2]) ? reg_c :(
                    (choose[1]) ? reg_b :(
                    (choose[0]) ? reg_a : reg_i)))));

    divider #(20000) div_cpu(clk, rst,clk_cpu);
    divider #(4) div_seg(clk, rst, clk_seg);

    seg7x16 my_seg(
        .clk(clk_seg),
        .reset(rst),
        .i_data(i_data),
        .o_seg(o_seg),
        .o_sel(o_sel)
    );

    wire [31:0] a;
    assign a = pc - 32'h00400000;
    assign clk_board = (inst != 32'b0) ? clk_cpu : 1'b0;
    
    IMEM cpu_imem(
            .addr(a[12:2]),
            .inst(inst)
    );
    
    Pipe_cpu my_cpu(
        .clk_in(clk_board),
        .rst(rst),
        .ena_stall(stall),
        .inst(inst),
        .pc(pc),
        .reg_i(reg_i),
        .reg_a(reg_a),
        .reg_b(reg_b),
        .reg_c(reg_c),
        .reg_d(reg_d)
    );  
    
endmodule