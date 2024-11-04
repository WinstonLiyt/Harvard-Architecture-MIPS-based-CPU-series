`timescale 1ns / 1ps

module sccomp_dataflow(
    input clk,
    input rst,
    output [31:0] inst,
    output [31:0] pc,
    output [31:0] reg_i, reg_a, reg_b, reg_c, reg_d
    ); 
        
    wire [31:0] a;
    assign a = pc - 32'h00400000;
    
    IMEM cpu_imem(
            .addr(a[12:2]),
            .inst(inst)
    );
    
    Pipe_cpu my_cpu(
        .clk_in(clk),
        .rst(rst),
        .ena_stall(0),
        .inst(inst),
        .pc(pc),
        .reg_i(reg_i),
        .reg_a(reg_a),
        .reg_b(reg_b),
        .reg_c(reg_c),
        .reg_d(reg_d)
    );  
    
endmodule