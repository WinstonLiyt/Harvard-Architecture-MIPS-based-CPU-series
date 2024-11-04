`timescale 1ns / 1ps

/* Memory2WriteBack */
module PipeMW(
    input clk,
    input rst,
    input W_ena,
    input [31:0] MEM_aluc,
    input [31:0] MEM_DMEM,
    input [31:0] MEM_pc4,
    input [31:0] MEM_rs_reg,

    input MEM_RF_W_ena,
    input [4:0] MEM_RF_waddr,
    input [2:0] MEM_RF_mux_select,

    output reg [31:0] WB_aluc,
    output reg [31:0] WB_DMEM,
    output reg [31:0] WB_pc4,
    output reg [31:0] WB_rs_reg,
    
    output reg WB_RF_W_ena,
    output reg [4:0] WB_RF_waddr,
    output reg [2:0] WB_RF_mux_select
    );

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            {WB_aluc, WB_DMEM, WB_pc4, WB_rs_reg,
             WB_RF_W_ena, WB_RF_waddr, WB_RF_mux_select} <= 0;
        end
        else if (W_ena) begin
            WB_aluc <= MEM_aluc;
            WB_DMEM <= MEM_DMEM;
            WB_pc4 <= MEM_pc4;
            WB_rs_reg <= MEM_rs_reg;
            WB_RF_W_ena <= MEM_RF_W_ena;
            WB_RF_waddr <= MEM_RF_waddr;
            WB_RF_mux_select <= MEM_RF_mux_select;
        end
    end

endmodule