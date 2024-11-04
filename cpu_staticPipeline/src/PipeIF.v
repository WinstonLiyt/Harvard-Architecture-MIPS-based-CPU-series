`timescale 1ns / 1ps

/* Instruction Fetch */ 
module PipeIF(
    input [31:0] pc,
    input [31:0] cpc,       // 协处理器的跳转地址
    input [31:0] bpc,       // 分支计算的跳转地址
    input [31:0] rpc,       // 寄存器的跳转地址
    input [31:0] jpc,       // 跳转指令的跳转地址
    input [2:0] pc_source_sel,   // 程序计数器源选择信号
    output [31:0] npc,      // 下一个程序计数器（PC）值
    output [31:0] pc4,      // 当前 PC 值加4
    output [31:0] inst      // 取出的指令
    );
    
    assign pc4 = pc + 32'h4;

    IMEM cpu_imem(
        .addr(pc[12:2]),
        .inst(inst)
    );

    /* 选择下一个PC的值给npc */
    MUX6_1_32b pc_mux6_1(
        .x_0(jpc),
        .x_1(rpc),
        .x_2(pc4),
        .x_3(32'h00400004),
        .x_4(bpc),
        .x_5(cpc),
        .select(pc_source_sel),
        .y(npc)
    );

endmodule