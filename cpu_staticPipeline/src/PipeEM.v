`timescale 1ns / 1ps

/* Execute2Memory */
module PipeEM(
    input clk,
    input rst,
    input W_ena,
    input [31:0] EXE_aluc,
    input [31:0] EXE_pc4,
    input [31:0] EXE_rs_reg, EXE_rt_reg,

    input EXE_DMEM_ena,
    input EXE_DMEM_W_ena,
    input [1:0] EXE_DMEM_W, EXE_DMEM_R,

    input EXE_RF_W_ena,
    input [4:0] EXE_RF_waddr,
    input [2:0] EXE_RF_mux_select,
    input EXE_load_store_mux_select,

    output reg [31:0] MEM_aluc,
    output reg [31:0] MEM_pc4,
    output reg [31:0] MEM_rs_reg, MEM_rt_reg,

    output reg MEM_DMEM_ena,
    output reg MEM_DMEM_W_ena,
    output reg [1:0] MEM_DMEM_W, MEM_DMEM_R,
    output reg MEM_RF_W_ena,
    output reg [4:0] MEM_RF_waddr,
    output reg [2:0] MEM_RF_mux_select,
    output reg MEM_load_store_mux_select
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            {MEM_pc4, MEM_rs_reg, MEM_rt_reg, MEM_aluc,  
             MEM_DMEM_ena, MEM_DMEM_W_ena, MEM_DMEM_W, 
             MEM_DMEM_R, MEM_RF_W_ena, MEM_RF_waddr, 
             MEM_RF_mux_select, MEM_load_store_mux_select} <= 0;
        end
        else if (W_ena) begin
            MEM_pc4 <= EXE_pc4;
            MEM_rs_reg <= EXE_rs_reg;
            MEM_rt_reg <= EXE_rt_reg;
            MEM_aluc <= EXE_aluc;
            MEM_DMEM_ena <= EXE_DMEM_ena;
            MEM_DMEM_W_ena <= EXE_DMEM_W_ena;
            MEM_DMEM_W <= EXE_DMEM_W;
            MEM_DMEM_R <= EXE_DMEM_R;
            MEM_RF_W_ena <= EXE_RF_W_ena;
            MEM_RF_mux_select <= EXE_RF_mux_select;
            MEM_RF_waddr <= EXE_RF_waddr;
            MEM_load_store_mux_select <= EXE_load_store_mux_select;
        end
    end

endmodule