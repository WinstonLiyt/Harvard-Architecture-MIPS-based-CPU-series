`timescale 1ns / 1ps

module Controller(
    input branch,
    input [31:0] inst,
    input [5:0] op, func,

    output DMEM_ena,
    output DMEM_W_ena,
    output [1:0] DMEM_W,
    output [1:0] DMEM_R,
    output RF_W_ena,

    output imm16_sign_extend,
    output [3:0] aluc,
    output [4:0] rd,
    output shift_amount_select,
    output load_store_mux_select,
    output aluc_input1_select,
    output [1:0] aluc_input2_select,
    output [2:0] rf_mux_select,
    output [2:0] pc_mux_select
    );

    wire ADD, ADDU, SUB, SUBU, AND, OR, XOR, NOR;
    wire SLT, SLTU, SLL, SRL, SRA, SLLV, SRLV, SRAV;
    wire JR;
    wire ADDI, ADDIU, ANDI, ORI, XORI;
    wire LW, SW, BEQ, BNE, SLTI, SLTIU, LUI;
    wire J, JAL;

    assign ADD = (op == 6'b000000 && func == 6'b100000) ? 1 : 0;
    assign ADDU = (op == 6'b000000 && func == 6'b100001) ? 1 : 0;
    assign SUB = (op == 6'b000000 && func == 6'b100010) ? 1 : 0;
    assign SUBU = (op == 6'b000000 && func == 6'b100011) ? 1 : 0;
    assign AND = (op == 6'b000000 && func == 6'b100100) ? 1 : 0;
    assign OR = (op == 6'b000000 && func == 6'b100101) ? 1 : 0;
    assign XOR = (op == 6'b000000 && func == 6'b100110) ? 1 : 0;
    assign NOR = (op == 6'b000000 && func == 6'b100111) ? 1 : 0;
    assign SLT = (op == 6'b000000 && func == 6'b101010) ? 1 : 0;
    assign SLTU = (op == 6'b000000 && func == 6'b101011) ? 1 : 0;
    assign SLL = (op == 6'b000000 && func == 6'b000000) ? 1 : 0;
    assign SRL = (op == 6'b000000 && func == 6'b000010) ? 1 : 0;
    assign SRA = (op == 6'b000000 && func == 6'b000011) ? 1 : 0;
    assign SLLV = (op == 6'b000000 && func == 6'b000100) ? 1 : 0;
    assign SRLV = (op == 6'b000000 && func == 6'b000110) ? 1 : 0;
    assign SRAV = (op == 6'b000000 && func == 6'b000111) ? 1 : 0;
    assign JR = (op == 6'b000000 && func == 6'b001000) ? 1 : 0;

    assign ADDI = (op == 6'b001000) ? 1 : 0;
    assign ADDIU = (op == 6'b001001) ? 1 : 0;
    assign ANDI = (op == 6'b001100) ? 1 : 0;
    assign ORI = (op == 6'b001101) ? 1 : 0;
    assign XORI = (op == 6'b001110) ? 1 : 0;
    assign LW = (op == 6'b100011) ? 1 : 0;
    assign SW = (op == 6'b101011) ? 1 : 0;
    assign BEQ = (op == 6'b000100) ? 1 : 0;
    assign BNE = (op == 6'b000101) ? 1 : 0;
    assign SLTI = (op == 6'b001010) ? 1 : 0;
    assign SLTIU = (op == 6'b001011) ? 1 : 0;
    assign LUI = (op == 6'b001111) ? 1 : 0;

    assign J = (op == 6'b000010) ? 1 : 0;
    assign JAL = (op == 6'b000011) ? 1 : 0;

    assign rd = (ADD || ADDU || SUB || SUBU || AND || OR || XOR || NOR || 
                SLT || SLTU || SLL || SRL || SRA || SLLV || SRLV || SRAV) ?
                inst[15:11] : 
                ((ADDI || ADDIU || ANDI || ORI || XORI || LW || SLTI || 
                  SLTIU || LUI) ? inst[20:16] : 
                  (JAL ? 5'd31 : 5'b0));

    /* aluc */
    assign aluc[0] = SUBU || SUB || OR || NOR || SLLV || SLT || 
                     SRLV || SLL || SRL || SLTI || ORI || BEQ || BNE;
    assign aluc[1] = ADD || SUB || XOR || NOR || SLT || SLTU || 
                     SLL || SLLV || ADDI || XORI || BEQ || BNE || SLTI || SLTIU;
    assign aluc[2] = AND || OR || XOR || NOR || SLL || SRL || SRA ||
                    SLLV || SRLV || SRAV || ANDI || ORI || XORI;
    assign aluc[3] = SLT || SLTU || SLLV || SRLV || SRAV || LUI ||
                     SRL || SRA || SLTI || SLTIU || SLL;
    
    /* aluc输入选择 */
    assign aluc_input1_select = !(SLL || SRL || SRA || J || JR || JAL);
    assign aluc_input2_select = {1'b0, SLTI || SLTIU || ADDI || ADDIU || ANDI || 
                                ORI || XORI || LW || SW || LUI};

    /* reg 写 */
    assign RF_W_ena = ADDI + ADDIU + ANDI + ORI + SLTIU + LUI + XORI + 
                    SLTI + ADDU + AND + XOR + NOR + OR + SLL + SLLV + 
                    SLTU + SRA + SRL + SUBU + ADD + SUB + SLT + SRLV + 
                    SRAV + LW + JAL;

    /* DMEM控制信号 */
    assign DMEM_ena = LW || SW;
    assign DMEM_W_ena = SW;
    assign DMEM_W = {1'b0, SW};
    assign DMEM_R = {1'b0, LW};

    /* PC控制信号 */
    assign pc_mux_select[2] = (BEQ && branch) || (BNE && branch);
    assign pc_mux_select[1] = !J && !JR && !JAL && !pc_mux_select[2];
    assign pc_mux_select[0] = JR;

    /* Regfile控制信号 */
    assign rf_mux_select[2] = !BEQ && !BNE && !SW && !J && !JR && !JAL;
    assign rf_mux_select[1] = 0;
    assign rf_mux_select[0] = !BEQ && !BNE && !LW && !SW && !J;

    /* 加载/存储多路选择器 */
    assign load_store_mux_select = !SW;

    /* 立即数与位移量扩展 */
    assign imm16_sign_extend = ADDI + ADDIU + SLTIU + SLTI;
    assign shift_amount_select = SLLV + SRAV + SRLV;

endmodule