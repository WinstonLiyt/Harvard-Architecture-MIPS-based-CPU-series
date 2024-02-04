`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/16 14:55:50
// Design Name: 
// Module Name: sccomp_dataflow
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sccomp_dataflow(
    input clk_in,
    input reset,
    output [31:0] inst,
    output [31:0] pc
    );

    wire Dw, Dr;
    wire [31:0] res;
    wire [31:0] w_data, r_data;
    wire [31:0] DMEM_addr_t;  // DMEM临时地址，需要转化
    wire [10:0] DMEM_addr;
    wire [31:0] IMEM_addr;
    assign DMEM_addr = (DMEM_addr_t - 32'h10010000) / 4;
    assign IMEM_addr = pc - 32'h00400000;
    
    IMEM cpu_IMEM(
        .addr(IMEM_addr[12:2]),  // 从IMEM中读指令
        .inst(inst)
    );

    DMEM cpu_DMEM(
        .clk(clk_in),
        .ena(1),
        .DM_W(Dw),
        .DM_R(Dr),
        .DM_addr(DMEM_addr[10:0]),
        .DM_wdata(w_data),
        .DM_rdata(r_data)
    );

    CPU31 sccpu(
        .clk(clk_in),
        .ena(1),
        .reset(reset),
        .IMem_inst(inst),
        .DMem_rdata(r_data),
        .DMem_wdata(w_data),
        .DMem_w(Dw),
        .DMem_r(Dr),
        .Pc_out(pc),
        .ALU_out(DMEM_addr_t)
    );

endmodule
