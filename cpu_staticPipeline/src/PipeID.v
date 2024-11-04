`timescale 1ns / 1ps

/* Instruction Decode */
module PipeID(
    input clk,
    input rst,
    input [31:0] pc4,inst,
    
    input RF_W_ena,
    input EXE_RF_W_ena,
    input MEM_RF_W_ena,

    input [31:0] RF_wdata,
    input [4:0] RF_waddr,
	input [4:0] EXE_RF_waddr,
	input [4:0] MEM_RF_waddr,

    output [31:0] ID_read_pc,
    output [31:0] ID_bpc,
    output [31:0] ID_jpc,

    output [31:0] ID_rs_reg,
    output [31:0] ID_rt_reg,

    output [31:0] ID_imm,
    output [31:0] ID_shamt,

    output [31:0] ID_pc4,
    output [4:0] ID_RF_waddr,
    output [3:0] ID_aluc,

    output ID_DMEM_ena,
    output ID_DMEM_W_ena,
    output ID_RF_W_ena,

    output [1:0] ID_DMEM_w,
    output [1:0] ID_DMEM_R,
    
    output id_load_store_mux_select,
    output id_aluc_mux1_select,
    output [1:0] id_aluc_mux2_select,
    output [2:0] id_rf_mux_select,
    output [2:0] id_pc_mux_select,

    output stall,
    output branch,

    output [31:0] reg1,
    output [31:0] reg2,
    output [31:0] reg3,
    output [31:0] reg4,
    output [31:0] reg7
    );

    /* 操作码与功能码 */
    wire [5:0] op = inst[31:26];
    wire [5:0] func = inst[5:0];

    /* 源寄存器、目标寄存器、目的地寄存器 */
    wire [4:0] rs = inst[25:21];
    wire [4:0] rt = inst[20:16];
    wire [4:0] rd;

    wire [31:0] imm16_extended;
    wire [31:0] branch_offset_extended;
    wire sign_extend_imm16;

    assign ID_imm = imm16_extended;

    wire select_shift_amount;   // 移位量选择信号
    wire [4:0] shift_amount;    // 移位量

    assign ID_jpc = {pc4[31:28], inst[25:0], 2'b00};
    assign ID_read_pc = ID_rs_reg;
    assign ID_pc4 = pc4;
    assign ID_RF_waddr = rd;
    assign ID_bpc = pc4 + branch_offset_extended;

    /* 检测数据冲突，pipeline是否暂停 */
    ControllerStall cpu_stall_controller(
        .clk(clk),
        .rst(rst),
        .rs(rs),
        .rt(rt),
	    .EXE_RF_waddr(EXE_RF_waddr),
        .EXE_RF_W_ena(EXE_RF_W_ena),
        .MEM_RF_waddr(MEM_RF_waddr),
        .MEM_RF_W_ena(MEM_RF_W_ena),
        .stall(stall)
    );

    /* regs */
    Regfile cpu_regfile(
        .ena(1),
        .clk(clk),
        .rst(rst),
        .RF_w(RF_W_ena),
        .rsc(rs),
        .rtc(rt),
        .rdc(RF_waddr),
        .rd(RF_wdata),
        .rs(ID_rs_reg),
        .rt(ID_rt_reg),
        .reg1(reg1),
        .reg2(reg2),
        .reg3(reg3),
        .reg4(reg4),
        .reg7(reg7)
    );

    /* 扩展分支偏移量 */
    SEXT18_32b bpc_sext18(
        .x({inst[15:0], 2'b00}),
        .y(branch_offset_extended)
    );

    ControllerBranch cpu_controller_branch(
        .clk(clk),
        .rst(rst),
        .ID_rs_reg(ID_rs_reg),
        .ID_rt_reg(ID_rt_reg),
        .op(op),
        .func(func),
        .branch(branch)
    );

    Controller cpu_controller(
        .branch(branch),
        .inst(inst),
        .op(op),
        .func(func),
        .DMEM_ena(ID_DMEM_ena),
        .DMEM_W_ena(ID_DMEM_W_ena),
        .DMEM_W(ID_DMEM_w),
        .DMEM_R(ID_DMEM_R),
        .RF_W_ena(ID_RF_W_ena),
        .imm16_sign_extend(sign_extend_imm16),
        .aluc(ID_aluc),
        .rd(rd),
        .shift_amount_select(select_shift_amount),
        .load_store_mux_select(id_load_store_mux_select),
        .aluc_input1_select(id_aluc_mux1_select),
        .aluc_input2_select(id_aluc_mux2_select),
        .rf_mux_select(id_rf_mux_select),
        .pc_mux_select(id_pc_mux_select)
    );

    /* 扩展立即数 */
    SEXT16_32b imm_ext16(
        .x(inst[15:0]),
        .s(sign_extend_imm16),
        .y(imm16_extended)
    );

    /* 指令or寄存器 */
    MUX2_1_5b ext_mux2_1(
        .x_0(inst[10:6]),
        .x_1(ID_rs_reg[4:0]),
        .select(select_shift_amount),
        .y(shift_amount)
    );

    /* 扩展shamt */
    EXT5_32b shamt_ext5(
        .x(shift_amount),
        .y(ID_shamt)
    );

endmodule