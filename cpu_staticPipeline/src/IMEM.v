`timescale 1ns / 1ps

/* IMEM */
module IMEM(
    input [10:0] addr,
    output [31:0] inst
    );

    dist_mem_gen_0 your_instance_name (
        .a(addr),   // input wire [10 : 0] a
        .spo(inst)  // output wire [31 : 0] spo
    );
endmodule