`timescale 1ns / 1ps

module Pipe_cpu(
    input clk,
    input rst,
    output [31:0] inst,
    output [31:0] pc,
    output [31:0] reg1,
    output [31:0] reg2,
    output [31:0] reg3,
    output [31:0] reg4,
    output [31:0] reg7
    );

    wire stall, branch;

    /* IF */
    wire [31:0] if_pc_in, if_cpc_in, if_bpc_in, if_rpc_in, if_jpc_in;
    wire [2:0] if_pc_mux_select_in;

    wire [31:0] if_npc_out, if_pc4_out, if_inst_out;

    assign inst = if_inst_out;
    assign pc = if_pc_in;

    /* ID */
    wire [31:0] id_pc4_in, id_inst_in;
    wire [31:0] id_rpc_out, id_bpc_out, id_jpc_out, id_pc4_out;
    wire [31:0] id_rs_reg_out, id_rt_reg_out;
    wire [31:0] id_imm_out, id_shamt_out;
    
    // id-if
    wire [31:0] id_rf_wdata_in;
    wire [4:0] id_rf_waddr_in;
    wire id_rf_wena_in;

    // id-aluc
    wire [3:0] id_aluc_out;
    wire id_aluc_mux1_select_out;
    wire [1:0] id_aluc_mux2_select_out;

    // id-dmem
    wire id_dmem_ena_out, id_dmem_wena_out;
    wire [1:0] id_dmem_w_out, id_dmem_r_out;

    // id-rf
    wire id_rf_wena_out;
    wire [4:0] id_rf_waddr_out;
    wire [2:0] id_rf_mux_select_out, id_pc_mux_select_out;
    wire id_load_store_mux_select_out;

    assign if_bpc_in = id_bpc_out;
    assign if_rpc_in = id_rpc_out;
    assign if_jpc_in = id_jpc_out;
    assign if_pc_mux_select_in = id_pc_mux_select_out;

    /* EXE */
    wire [31:0] exe_pc4_in;
    wire [31:0] exe_rs_reg, exe_rt_reg;
    wire [31:0] exe_imm_in, exe_shamt_in;
    
    // exe-dmem
    wire exe_dmem_ena_in, exe_dmem_wena_in;
    wire [1:0] exe_dmem_w_in, exe_dmem_r_in;
    
    // exe-rf
    wire exe_rf_wena_in;
    wire [4:0] exe_rf_waddr_in;
    wire [2:0] exe_rf_mux_select_in;
    wire exe_load_store_mux_select_in;

    // exe-aluc
    wire [3:0] exe_aluc_in;
    wire exe_aluc_mux1_select_in;
    wire [1:0] exe_aluc_mux2_select_in;

    wire [31:0] exe_pc4_out;
    wire [31:0] exe_rs_reg_out, exe_rt_reg_out;
    wire [31:0] exe_aluc_out_out;
    
    // exe-rf(out)
    wire exe_rf_wena_out;
    wire [4:0] exe_rf_waddr_out;
    wire [2:0] exe_rf_mux_select_out;
    wire exe_load_store_mux_select_out;

    // exe-dmem(out)
    wire exe_dmem_ena_out, exe_dmem_wena_out;
    wire [1:0] exe_dmem_w_out, exe_dmem_r_out;

    /* MEM */
    wire [31:0] mem_pc4_in;
    wire [31:0] mem_rs_reg, mem_rt_reg;
    wire [31:0] mem_aluc_out_in;

    // mem-dmem
    wire mem_dmem_ena_in, mem_dmem_wena_in;
    wire [1:0] mem_dmem_w_in, mem_dmem_r_in;

    // mem-rf
    wire mem_rf_wena_in;
    wire [4:0] mem_rf_waddr_in;
    wire [2:0] mem_rf_mux_select_in;
    wire mem_load_store_mux_select_in;

    wire [31:0] mem_pc4_out;
    wire [31:0] mem_rs_reg_out;
    wire [31:0] mem_aluc_out_out;

    // mem-rf(out)
    wire mem_rf_wena_out;
    wire [4:0] mem_rf_waddr_out;
    wire [2:0] mem_rf_mux_select_out;

    wire [31:0] mem_dmem_out_out;

    /* WB */
    wire [31:0] wb_pc4_in;
    wire [31:0] wb_rd_reg_in;
    wire [31:0] wb_aluc_out_in;

    // wb-rf
    wire wb_rf_wena_in;
    wire [4:0] wb_rf_waddr_in;
    wire [2:0] wb_rf_mux_select_in;

    // wb-dmem
    wire [31:0] wb_dmem_out_in;

    //wb-rf(out)
    wire wb_rf_wena_out;
    wire [31:0] wb_rf_wdata_out;
    wire [4:0] wb_rf_waddr_out;

    assign id_rf_wdata_in = wb_rf_wdata_out;
    assign id_rf_waddr_in = wb_rf_waddr_out;
    assign id_rf_wena_in = wb_rf_wena_out;

    /* PC reg */ 
    PCreg cpu_pcreg(
        .clk(clk),
        .rst(rst),
        .w_ena(1),
        .stall(stall),
        .Pc_in(if_npc_out),
        .Pc_out(if_pc_in)
    );

    /* Instruction Fetch */ 
    PipeIF cpu_IF(
        .pc(if_pc_in),
        .cpc(0),
        .bpc(if_bpc_in),
        .rpc(if_rpc_in),
        .jpc(if_jpc_in),
        .pc_source_sel(if_pc_mux_select_in),
        .npc(if_npc_out),
        .pc4(if_pc4_out),
        .inst(if_inst_out)
    );

    /* Fetch2Decode */
    PipeFD cpu_FD(
        .clk(clk),
        .rst(rst),
        .pc4(if_pc4_out),
        .inst(if_inst_out),
        .stall(stall),
        .branch(branch),
        .ID_pc4(id_pc4_in),
        .ID_inst(id_inst_in)
    );

    /* Instruction Decode */
    PipeID cpu_ID(
        .clk(clk),
        .rst(rst),
        .pc4(id_pc4_in),
        .inst(id_inst_in),
        .RF_W_ena(id_rf_wena_in),
        .EXE_RF_W_ena(exe_rf_wena_out),
        .MEM_RF_W_ena(mem_rf_wena_out),
        .RF_wdata(id_rf_wdata_in),
        .RF_waddr(id_rf_waddr_in),
        .EXE_RF_waddr(exe_rf_waddr_out),
        .MEM_RF_waddr(mem_rf_waddr_out),
        .ID_read_pc(id_rpc_out),
        .ID_bpc(id_bpc_out),
        .ID_jpc(id_jpc_out),
        .ID_rs_reg(id_rs_reg_out),
        .ID_rt_reg(id_rt_reg_out),
        .ID_imm(id_imm_out),
        .ID_shamt(id_shamt_out),
        .ID_pc4(id_pc4_out),
        .ID_RF_waddr(id_rf_waddr_out),
        .ID_aluc(id_aluc_out),
        .ID_DMEM_ena(id_dmem_ena_out),
        .ID_DMEM_W_ena(id_dmem_wena_out),
        .ID_RF_W_ena(id_rf_wena_out),
        .ID_DMEM_w(id_dmem_w_out),
        .ID_DMEM_R(id_dmem_r_out),
        .id_load_store_mux_select(id_load_store_mux_select_out),
        .id_aluc_mux1_select(id_aluc_mux1_select_out),
        .id_aluc_mux2_select(id_aluc_mux2_select_out),
        .id_rf_mux_select(id_rf_mux_select_out),
        .id_pc_mux_select(id_pc_mux_select_out),
        .stall(stall),
        .branch(branch),
        .reg1(reg1),
        .reg2(reg2),
        .reg3(reg3),
        .reg4(reg4),
        .reg7(reg7)
    );

    /* Decode2Execute */
    PipeDE cpu_DE(
        .clk(clk),
        .rst(rst),
        .DE_W_ena(1),
        .ID_pc4(id_pc4_out),
        .ID_rs_reg(id_rs_reg_out),
        .ID_rt_reg(id_rt_reg_out),
        .ID_imm(id_imm_out),
        .ID_shamt(id_shamt_out),
        .ID_DMEM_ena(id_dmem_ena_out),
        .ID_DMEM_W_ena(id_dmem_wena_out),
        .ID_DMEM_W(id_dmem_w_out),
        .ID_DMEM_R(id_dmem_r_out),
        .ID_RF_waddr(id_rf_waddr_out),
        .ID_RF_W_ena(id_rf_wena_out),
        .stall(stall),
        .ID_load_store_mux_select(id_load_store_mux_select_out),
        .ID_aluc(id_aluc_out),
        .ID_aluc_mux1_select(id_aluc_mux1_select_out),
        .ID_aluc_mux2_select(id_aluc_mux2_select_out),
        .ID_RF_mux_select(id_rf_mux_select_out),
        .EXE_pc4(exe_pc4_in),
        .EXE_rs_reg(exe_rs_reg),
        .EXE_rt_reg(exe_rt_reg),
        .EXE_imm(exe_imm_in),
        .EXE_shamt(exe_shamt_in),
        .EXE_DMEM_ena(exe_dmem_ena_in),
        .EXE_DMEM_W_ena(exe_dmem_wena_in),
        .EXE_DMEM_W(exe_dmem_w_in),
        .EXE_DMEM_R(exe_dmem_r_in),
        .EXE_RF_waddr(exe_rf_waddr_in),
        .EXE_RF_W_ena(exe_rf_wena_in),
        .EXE_aluc(exe_aluc_in),
        .EXE_aluc_mux1_select(exe_aluc_mux1_select_in),
        .EXE_aluc_mux2_select(exe_aluc_mux2_select_in),
        .EXE_load_store_mux_select(exe_load_store_mux_select_in),
        .EXE_RF_mux_select(exe_rf_mux_select_in)
    );

    /* Execute Stage */
    PipeEXE cpu_EXE(
        .rst(rst),
        .pc4(exe_pc4_in),
        .rs_reg(exe_rs_reg),
        .rt_reg(exe_rt_reg),
        .imm(exe_imm_in),
        .shamt(exe_shamt_in),
        .DMEM_ena(exe_dmem_ena_in),
        .DMEM_W_ena(exe_dmem_wena_in),
        .DMEM_W(exe_dmem_w_in),
        .DMEM_R(exe_dmem_r_in),
        .RF_W_ena(exe_rf_wena_in),
        .RF_waddr(exe_rf_waddr_in),
        .RF_mux_select(exe_rf_mux_select_in),
        .aluc(exe_aluc_in),
        .aluc_mux1_select(exe_aluc_mux1_select_in),
        .aluc_mux2_select(exe_aluc_mux2_select_in),
        .load_store_mux_select(exe_load_store_mux_select_in),
        .EXE_aluc(exe_aluc_out_out),
        .EXE_pc4(exe_pc4_out),
        .EXE_rs_reg(exe_rs_reg_out),
        .EXE_rt_reg(exe_rt_reg_out),
        .EXE_DMEM_ena(exe_dmem_ena_out),
        .EXE_DMEM_W_ena(exe_dmem_wena_out),
        .EXE_DMEM_W(exe_dmem_w_out),
        .EXE_DMEM_R(exe_dmem_r_out),
        .EXE_RF_W_ena(exe_rf_wena_out),
        .EXE_RF_waddr(exe_rf_waddr_out),
        .EXE_RF_mux_select(exe_rf_mux_select_out),
        .EXE_load_store_mux_select(exe_load_store_mux_select_out)
    );

    /* Execute2Memory */
    PipeEM cpu_EM(
        .clk(clk),
        .rst(rst),
        .W_ena(1),
        .EXE_aluc(exe_aluc_out_out),
        .EXE_pc4(exe_pc4_out),
        .EXE_rs_reg(exe_rs_reg_out),
        .EXE_rt_reg(exe_rt_reg_out),
        .EXE_DMEM_ena(exe_dmem_ena_out),
        .EXE_DMEM_W_ena(exe_dmem_wena_out),
        .EXE_DMEM_W(exe_dmem_w_out),
        .EXE_DMEM_R(exe_dmem_r_out),
        .EXE_RF_W_ena(exe_rf_wena_out),
        .EXE_RF_waddr(exe_rf_waddr_out),
        .EXE_RF_mux_select(exe_rf_mux_select_out),
        .EXE_load_store_mux_select(exe_load_store_mux_select_out),
        .MEM_aluc(mem_aluc_out_in),
        .MEM_pc4(mem_pc4_in),
        .MEM_rs_reg(mem_rs_reg),
        .MEM_rt_reg(mem_rt_reg),
        .MEM_DMEM_ena(mem_dmem_ena_in),
        .MEM_DMEM_W_ena(mem_dmem_wena_in),
        .MEM_DMEM_W(mem_dmem_w_in),
        .MEM_DMEM_R(mem_dmem_r_in),
        .MEM_RF_waddr(mem_rf_waddr_in),
        .MEM_RF_W_ena(mem_rf_wena_in),
        .MEM_RF_mux_select(mem_rf_mux_select_in),
        .MEM_load_store_mux_select(mem_load_store_mux_select_in)
    );

    /* Memory Stage */
    PipeMEM cpu_MEM(
        .clk(clk),
        .aluc(mem_aluc_out_in),
        .pc4(mem_pc4_in),
        .rs_reg(mem_rs_reg),
        .rt_reg(mem_rt_reg),
        .DMEM_ena(mem_dmem_ena_in),
        .DMEM_W_ena(mem_dmem_wena_in),
        .DMEM_W(mem_dmem_w_in),
        .DMEM_R(mem_dmem_r_in),
        .RF_W_ena(mem_rf_wena_in),
        .RF_waddr(mem_rf_waddr_in),
        .RF_mux_select(mem_rf_mux_select_in),
        .load_store_mux_select(mem_load_store_mux_select_in),
        .MEM_aluc(mem_aluc_out_out),
        .MEM_DMEM_output(mem_dmem_out_out),
        .MEM_pc4(mem_pc4_out),
        .MEM_rs_reg(mem_rs_reg_out),
        .MEM_RF_W_ena(mem_rf_wena_out),
        .MEM_RF_waddr(mem_rf_waddr_out),
        .MEM_RF_mux_select(mem_rf_mux_select_out)
    );

    /* Memory2WriteBack */
    PipeMW cpu_MW(
        .clk(clk),
        .rst(rst),
        .W_ena(1),
        .MEM_aluc(mem_aluc_out_out),
        .MEM_DMEM(mem_dmem_out_out),
        .MEM_pc4(mem_pc4_out),
        .MEM_rs_reg(mem_rs_reg_out),
        .MEM_RF_W_ena(mem_rf_wena_out),
        .MEM_RF_waddr(mem_rf_waddr_out),
        .MEM_RF_mux_select(mem_rf_mux_select_out),
        .WB_aluc(wb_aluc_out_in),
        .WB_DMEM(wb_dmem_out_in),
        .WB_pc4(wb_pc4_in),
        .WB_rs_reg(wb_rd_reg_in),
        .WB_RF_W_ena(wb_rf_wena_in),
        .WB_RF_waddr(wb_rf_waddr_in),
        .WB_RF_mux_select(wb_rf_mux_select_in)
    );

    /* WriteBack Stage */
    PipeWB cpu_WB(
        .aluc(wb_aluc_out_in),
        .dmem_out(wb_dmem_out_in),
        .pc4(wb_pc4_in),
        .rs_reg(wb_rd_reg_in),
        .RF_W_ena(wb_rf_wena_in),
        .RF_waddr(wb_rf_waddr_in),
        .RF_mux_select(wb_rf_mux_select_in),
        .RF_wdate(wb_rf_wdata_out),
        .WB_RF_W_ena(wb_rf_wena_out),
        .WB_RF_waddr(wb_rf_waddr_out)
    );

endmodule