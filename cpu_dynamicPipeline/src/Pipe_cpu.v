`timescale 1ns / 1ps

module Pipe_cpu(
    input clk_in,
    input rst,
    input ena_stall,
    input [31:0] inst,
    output [31:0] pc,
    output [31:0] reg_i, reg_a, reg_b, reg_c, reg_d
    );
    wire clk;
    assign clk = (ena_stall) ? clk :clk_in;

    wire jump, stall;   // 跳转与延迟信号

    /* Instruction Fetch */
    wire [31:0] pc4; // npc = pc + 4
    wire [31:0] if_pc_in, if_inst_in, id_pc_out;

    assign pc4   = pc + 32'd4;

    wire [1:0] if_pc_select;
    assign if_pc_select = (stall) ? 2'b00 : ((jump) ? 2'b01 : 2'b10);

    MUX3_1_32b if_pc_mux3_1(
        .x_0(pc),           // stall时选择pc
        .x_1(id_pc_out),    // jump时选择id_pc_out
        .x_2(pc4),          // 默认是pc4
        .select(if_pc_select),
        .y(if_pc_in)
    );

    // 指令输入的处理
    // - 如果stall（暂停）信号激活，则将指令输入清零
    // - 否则，使用当前的指令
    assign if_inst_in = (stall) ? 32'b0 : inst;

    // 程序计数器寄存器模块
    PCreg cpu_pcreg(
        .clk(clk),
        .rst(rst),
        .Pc_in(if_pc_in),
        .Pc_out(pc)
    );
    
    /* Fetch2Decode */
    wire [31:0] id_inst_in;
    wire [31:0] id_pc4_in;

    PipeFD cpu_FD(
        .clk(clk),
        .rst(rst),
        .pc4(pc4),
        .inst(if_inst_in),
        .ID_pc4(id_pc4_in),
        .ID_inst(id_inst_in)
    );
    
    /* Instruction Decode */
    wire [31:0] id_rs_reg_out, id_rt_reg_out;
    wire [1:0] id_pc_out_select;
    wire [31:0] id_pc_add;  // 条件跳转（如BEQ、BNE）的目标地址
    wire [31:0] id_pc_j;  // J和JAL指令的目标地址
    wire [31:0] id_rs_j;  // JR指令的目标地址

    wire [31:0] id_shamt, id_immu, id_imm, id_offset;

    wire [4:0] rs, rt, rd;
    assign rs = id_inst_in[25:21];
	assign rt = id_inst_in[20:16];
	assign rd = id_inst_in[15:11];
    
    assign id_shamt = {27'b0, id_inst_in[10:6]};  // shamt 拓展
    assign id_immu = {16'b0, id_inst_in[15:0]};
    assign id_imm = {{16{id_inst_in[15]}}, id_inst_in[15:0]};
    assign id_offset = {{14{id_inst_in[15]}}, id_inst_in[15:0], 2'b0};

    assign id_rs_j  = id_rs_reg_out;
    assign id_pc_add = pc + id_offset;
    assign id_pc_j = {pc4[31:28], id_inst_in[25:0], 2'b0};

    MUX4_1_32b id_pc_mux4_1(
        .x_0(id_pc_j),
        .x_1(id_rs_j),
        .x_2(id_pc_add),
        .x_3(id_pc_add),
        .select(id_pc_out_select),
        .y(id_pc_out)
    );


    // 先写后读专用路径
    wire [31:0] exe_npc, mem_npc;
    wire exe_RF_W_ena, mem_RF_W_ena;
    wire [4:0] exe_RF_waddr, mem_RF_waddr;
    wire exe_lw, exe_jal, exe_mul;
    wire mem_lw, mem_jal, mem_mul;
    wire [31:0] exe_aluc, mem_aluc_out;
    wire [31:0] exe_mul_res;
    wire [31:0] mem_mul_res;
    wire conf_LW;  // LW冲突信号
    wire [31:0] rs_reg, rt_reg;

    DataHazardResolver cpu_DHResolver(
        .rs(rs),
        .rt(rt),
        .rs_reg(id_rs_reg_out),
        .rt_reg(id_rt_reg_out),
        .EXE_RF_W_ena(exe_RF_W_ena),
        .EXE_RF_waddr(exe_RF_waddr),
        .EXE_npc(exe_npc),
        .EXE_mul(exe_mul_res),
        .EXE_aluc(exe_aluc),
        .EXE_LW(exe_lw),
        .EXE_JAL(exe_jal),
        .EXE_MUL(exe_mul),
        .MEM_npc(mem_npc),
        .MEM_mul(mem_mul_res),
        .MEM_aluc(mem_aluc_out),
        .MEM_RF_waddr(mem_RF_waddr),
        .MEM_RF_W_ena(mem_RF_W_ena),
        .MEM_LW(mem_lw),
        .MEM_JAL(mem_jal),
        .MEM_MUL(mem_mul),
        .rs_MUX(rs_reg),
        .rt_MUX(rt_reg),
        .conf_LW(conf_LW)
    );

    wire id_RF_W_ena, id_DMEM_W_ena;
    wire [4:0] id_RF_waddr;    // ID段写地址
    wire id_lw, id_jal, id_mul;
    wire [4:0] id_aluc;
    wire id_aluc_input1_select_out;
    wire [1:0] id_aluc_input2_select_out;
    wire [1:0] id_waddr_mux;

    controller cpu_controller(
        .op(id_inst_in[31:26]),
        .func(id_inst_in[5:0]),
        .rs_reg(rs_reg),
        .rt_reg(rt_reg),
        .jump(jump),
        .ID_DMEM_W_ena(id_DMEM_W_ena), 
        .ID_RF_W_ena(id_RF_W_ena), 
        .aluc(id_aluc), 
        .pc_mux_select(id_pc_out_select), 
        .aluc_input1_select(id_aluc_input1_select_out), 
        .aluc_input2_select(id_aluc_input2_select_out), 
        .mux_waddr_ID(id_waddr_mux),
        .ID_LW(id_lw), 
        .ID_JAL(id_jal), 
        .ID_MUL(id_mul) 
    );

    MUX3_1_5b id_RF_waddr_mux3_1(
        .x_0(rt),
        .x_1(rd), 
        .x_2(5'd31),
        .select(id_waddr_mux),
        .y(id_RF_waddr)
    );

    DataHazardDetector cpu_DHDetector(
        .inst(inst),
        .ID_LW(id_lw),
        .EXE_LW(exe_lw),
        .MEM_LW(mem_lw),
        .ID_RF_W_ena(id_RF_W_ena),
        .EXE_RF_W_ena(exe_RF_W_ena),
        .MEM_RF_W_ena(mem_RF_W_ena),
        .ID_RF_waddr(id_RF_waddr),
        .EXE_RF_waddr(exe_RF_waddr),
        .MEM_RF_waddr(mem_RF_waddr),
        .stall(stall)
    );

    /* Decode2Execute */
    wire dmem_w_ena;
    assign dmem_w_ena = id_DMEM_W_ena && (~conf_LW);
    wire [31:0] exe_shamt, exe_imm, exe_immu;
    wire [31:0] exe_rs_reg, exe_rt_reg;
    wire [4:0] id_exe_aluc;
    wire [31:0] exe_DM_wdata;
    wire exe_DM_w_ena;
    wire exe_aluc_mux1_select;
    wire [1:0] exe_aluc_mux2_select;

    PipeDE cpu_DE(
        .clk(clk),
        .rst(rst),
        .ID_LW(id_lw), 
        .ID_JAL(id_jal), 
        .ID_MUL(id_mul),
        .ID_aluc(id_aluc),
        .ID_aluc_mux1_select(id_aluc_input1_select_out),
        .ID_aluc_mux2_select(id_aluc_input2_select_out),
        .ID_npc(id_pc4_in),
        .ID_shamt(id_shamt),
        .ID_imm(id_imm),
        .ID_immu(id_immu),
        .ID_rs_reg(rs_reg),
        .ID_rt_reg(rt_reg),
        .DM_W_ena(dmem_w_ena),
        .ID_DM_wdata(rt_reg),
        .RF_W_ena(id_RF_W_ena),
        .ID_RF_waddr(id_RF_waddr),
        .EXE_LW(exe_lw), 
        .EXE_JAL(exe_jal), 
        .EXE_MUL(exe_mul),
        .EXE_aluc(id_exe_aluc),
        .EXE_aluc_mux1_select(exe_aluc_mux1_select),
        .EXE_aluc_mux2_select(exe_aluc_mux2_select),
        .EXE_npc(exe_npc),
        .EXE_shamt(exe_shamt),
        .EXE_imm(exe_imm),
        .EXE_immu(exe_immu),
        .EXE_rs_reg(exe_rs_reg),
        .EXE_rt_reg(exe_rt_reg),
        .EXE_DM_W_ena(exe_DM_w_ena),
        .EXE_DM_wdata(exe_DM_wdata),
        .EXE_RF_W_ena(exe_RF_W_ena),
        .EXE_RF_waddr(exe_RF_waddr)
    );
    
    /* Execute Stage */
    wire [31:0] exe_aluc_a, exe_aluc_b;
    wire [63:0] exe_mul_out;
    assign exe_aluc_a = exe_aluc_mux1_select ? exe_shamt : exe_rs_reg;
    assign exe_aluc_b = (exe_aluc_mux2_select[1]) ? exe_rt_reg : (exe_aluc_mux2_select[0]) ? exe_immu : exe_imm;
    
    ALU cpu_alu(
        .a(exe_aluc_a),
        .b(exe_aluc_b),
        .aluc(id_exe_aluc),
        .res(exe_aluc)
    );

    MUL cpu_mul(
        .rst(rst),
        .a(exe_aluc_a),
        .b(exe_aluc_b),
        .c(exe_mul_out)
    );
    assign exe_mul_res = exe_mul_out[31:0];
    
    /* Execute2Memory */
    wire mem_dmem_w_ena;
    wire [31:0] mem_dmem_wdata;

    PipeEM cpu_EM(
        .clk(clk),
        .rst(rst),
        .EXE_npc(exe_npc),
        .EXE_LW(exe_lw),
        .EXE_JAL(exe_jal),
        .EXE_MUL(exe_mul),
        .EXE_aluc(exe_aluc),
        .EXE_MUL_res(exe_mul_res),
        .EXE_DM_W_ena(exe_DM_w_ena),
        .EXE_DM_wdata(exe_DM_wdata),
        .EXE_RF_W_ena(exe_RF_W_ena),
        .EXE_RF_waddr(exe_RF_waddr),
        .MEM_npc(mem_npc),
        .MEM_LW(mem_lw),
        .MEM_JAL(mem_jal),
        .MEM_MUL(mem_mul),
        .MEM_aluc(mem_aluc_out),
        .MEM_MUL_res(mem_mul_res),
        .MEM_DM_W_ena(mem_dmem_w_ena),
        .MEM_DM_wdata(mem_dmem_wdata),
        .MEM_RF_W_ena(mem_RF_W_ena),
        .MEM_RF_waddr(mem_RF_waddr)
    );


    /* Memory Stage */
    wire DM_w_ena;
    wire [31:0] DM_addr, DM_rdata, DM_wdata;
    assign DM_w_ena = mem_dmem_w_ena;
    assign DM_addr = mem_aluc_out;
    assign DM_wdata = mem_dmem_wdata;

    DMEM cpu_dmem(
        .clk(clk),
        .rst(rst),
        .DM_w(DM_w_ena),
        .addr(DM_addr),
        .data_in(DM_wdata),
        .data_out(DM_rdata)
    );
    
    /* Memory2WriteBack */
    wire wb_rf_w_ena;
    wire [4:0] wb_rf_waddr;

    wire [31:0] wb_pc4_in;

    wire wb_lw, wb_jal, wb_mul;
    wire [31:0] wb_aluc;
    wire [31:0] wb_mul_res;
    wire [31:0] wb_dm_rdata;

    PipeMW cpu_MW(
        .clk(clk),
        .rst(rst),
        .MEM_npc(mem_npc),
        .MEM_LW(mem_lw),
        .MEM_JAL(mem_jal),
        .MEM_MUL(mem_mul),
        .MEM_aluc(mem_aluc_out),
        .MEM_MUL_res(mem_mul_res),
        .MEM_DM_rdata(DM_rdata),
        .MEM_RF_W_ena(mem_RF_W_ena),
        .MEM_RF_waddr(mem_RF_waddr),
        .WB_npc(wb_pc4_in),
        .WB_LW(wb_lw),
        .WB_JAL(wb_jal),
        .WB_MUL(wb_mul),
        .WB_aluc(wb_aluc),
        .WB_MUL_res(wb_mul_res),
        .WB_DM_rdata(wb_dm_rdata),
        .WB_RF_W_ena(wb_rf_w_ena),
        .WB_RF_waddr(wb_rf_waddr)
    );

    
    /* WriteBack Stage */
    wire [31:0] wb_wdata;
    wire [1:0] wb_wdata_select;
    assign wb_wdata_select = {wb_mul, wb_jal || wb_lw};
    assign wb_wdata = (wb_lw) ? wb_dm_rdata : (wb_jal) ? wb_pc4_in : (wb_mul) ? wb_mul_res : wb_aluc;

    Regfile cpu_regfile(
        .ena(1),
        .clk(clk),
        .rst(rst),
        .RF_w(wb_rf_w_ena),
        .rdc(wb_rf_waddr),
        .rsc(rs),
        .rtc(rt),
        .rd(wb_wdata),
        .rs(id_rs_reg_out),
        .rt(id_rt_reg_out),
        .reg_i(reg_i),
        .reg_a(reg_a),
        .reg_b(reg_b),
        .reg_c(reg_c),
        .reg_d(reg_d)
    );

endmodule