`timescale 1ns / 1ps

/* Instruction Fetch */ 
module PipeIF(
    input [31:0] pc,
    input [31:0] cpc,       // Э����������ת��ַ
    input [31:0] bpc,       // ��֧�������ת��ַ
    input [31:0] rpc,       // �Ĵ�������ת��ַ
    input [31:0] jpc,       // ��תָ�����ת��ַ
    input [2:0] pc_source_sel,   // ���������Դѡ���ź�
    output [31:0] npc,      // ��һ�������������PC��ֵ
    output [31:0] pc4,      // ��ǰ PC ֵ��4
    output [31:0] inst      // ȡ����ָ��
    );
    
    assign pc4 = pc + 32'h4;

    IMEM cpu_imem(
        .addr(pc[12:2]),
        .inst(inst)
    );

    /* ѡ����һ��PC��ֵ��npc */
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