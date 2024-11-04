`timescale 1ns / 1ps

/* �����ˮ���е����ݳ�ͻ�������Ƿ���Ҫ��ͣ��stall����ˮ�� */
module DataHazardDetector(
    input [31:0] inst,
    input ID_LW, EXE_LW, MEM_LW,
    input ID_RF_W_ena, EXE_RF_W_ena, MEM_RF_W_ena,
    input [4:0] ID_RF_waddr, EXE_RF_waddr, MEM_RF_waddr,
    output stall
);

	wire [4:0] rs = inst[25:21];    // Դ�Ĵ�����ַ
    wire [4:0] rt = inst[20:16];    // Ŀ��Ĵ�����ַ

    // ������ݳ�ͻ�������Ƿ���ͣ��ˮ��
    assign stall = ((ID_LW && ID_RF_W_ena && ID_RF_waddr != 5'b0) && ((rs == ID_RF_waddr) || (rt == ID_RF_waddr))) ||
                   ((EXE_LW && EXE_RF_W_ena && EXE_RF_waddr != 5'b0) && ((rs == EXE_RF_waddr) || (rt == EXE_RF_waddr))) ||
                   ((MEM_LW && MEM_RF_W_ena && MEM_RF_waddr != 5'b0) && ((rs == MEM_RF_waddr) || (rt == MEM_RF_waddr)));

endmodule