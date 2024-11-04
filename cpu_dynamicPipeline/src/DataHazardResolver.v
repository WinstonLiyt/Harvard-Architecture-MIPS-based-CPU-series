`timescale 1ns / 1ps

/* 解决数据冲突(EXE&MEM) */
module DataHazardResolver(
    input [4:0] rs, rt,
    input [31:0] rs_reg, rt_reg,

    input EXE_RF_W_ena,
    input [4:0] EXE_RF_waddr,
    
    input [31:0] EXE_npc,
    input [31:0] EXE_mul,
    input [31:0] EXE_aluc,
    input EXE_LW, EXE_JAL, EXE_MUL,
    
    input [31:0] MEM_npc,
    input [31:0] MEM_mul,
    input [31:0] MEM_aluc,
    input [4:0] MEM_RF_waddr,
    input MEM_RF_W_ena,
    input MEM_LW, MEM_JAL, MEM_MUL,
    
    output reg [31:0] rs_MUX, rt_MUX, 
    output reg conf_LW = 1'b0  // 加载冲突标志
);

reg load_conflict_rs = 1'b0;
reg load_conflict_rt = 1'b0;

// 更新总的加载冲突标志
always @(*) begin
    conf_LW = load_conflict_rs || load_conflict_rt;
end

// 更新rs_MUX和load_conflict_rs
always @(*) begin
    load_conflict_rs = 1'b0;
    rs_MUX = rs_reg; // 默认值为源寄存器数据

    if (EXE_RF_W_ena && EXE_RF_waddr == rs && rs != 5'b0) begin
        rs_MUX = EXE_JAL ? EXE_npc : 
                 EXE_MUL ? EXE_mul : 
                 EXE_LW  ? 32'b0 : EXE_aluc;
        load_conflict_rs = EXE_LW;
    end
    else if (MEM_RF_W_ena && MEM_RF_waddr == rs && rs != 5'b0) begin
        rs_MUX = MEM_JAL ? MEM_npc : 
                 MEM_MUL ? MEM_mul : 
                 MEM_LW  ? 32'b0 : MEM_aluc;
        load_conflict_rs = MEM_LW;
    end
end

// 更新rt_MUX和load_conflict_rt
always @(*) begin
    load_conflict_rt = 1'b0;
    rt_MUX = rt_reg; // 默认值为目标寄存器数据

    if (EXE_RF_W_ena && EXE_RF_waddr == rt && rt != 5'b0) begin
        rt_MUX = EXE_JAL ? EXE_npc : 
                 EXE_MUL ? EXE_mul : 
                 EXE_LW  ? 32'b0 : EXE_aluc;
        load_conflict_rt = EXE_LW;
    end
    else if (MEM_RF_W_ena && MEM_RF_waddr == rt && rt != 5'b0) begin
        rt_MUX = MEM_JAL ? MEM_npc : 
                 MEM_MUL ? MEM_mul : 
                 MEM_LW  ? 32'b0 : MEM_aluc;
        load_conflict_rt = MEM_LW;
    end
end

endmodule