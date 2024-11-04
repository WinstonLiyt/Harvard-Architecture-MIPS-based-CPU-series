`timescale 1ns / 1ps

/* Memory Stage */
module PipeMEM(
    input clk,
    input [31:0] aluc, 
    input [31:0] pc4,
    input [31:0] rs_reg, rt_reg,
    
    input DMEM_ena,      
    input DMEM_W_ena,
    input [1:0] DMEM_W, DMEM_R,

    input RF_W_ena,   
    input [4:0] RF_waddr,
    input [2:0] RF_mux_select,
    input load_store_mux_select,

    output [31:0] MEM_aluc, 
    output [31:0] MEM_DMEM_output,
    output [31:0] MEM_pc4,
    output [31:0] MEM_rs_reg,

    output MEM_RF_W_ena,
    output [4:0] MEM_RF_waddr,    
    output [2:0] MEM_RF_mux_select
    );

    wire [31:0] DMEM_out;
    assign MEM_pc4 = pc4;
    assign MEM_rs_reg = rs_reg;
    assign MEM_aluc = aluc;
    assign MEM_RF_waddr = RF_waddr;
    assign MEM_RF_W_ena = RF_W_ena;
    assign MEM_RF_mux_select = RF_mux_select;

    MUX2_1_32b load_store_mux2_1(
        .x_0(rt_reg),
        .x_1(DMEM_out),
        .select(load_store_mux_select),
        .y(MEM_DMEM_output)
    );

    DMEM cpu_dmem(
        .clk(clk),
        .ena(DMEM_ena),
        .w_ena(DMEM_W_ena),
        .dm_w(DMEM_W),
        .dm_r(DMEM_R),
        .dm_wdata(rt_reg),
        .dm_addr(aluc),
        .dm_rdata(DMEM_out)
    );

endmodule