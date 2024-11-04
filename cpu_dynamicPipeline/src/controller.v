`timescale 1ns / 1ps

module controller(
    input [5:0] op, func,
    input [31:0] rs_reg, rt_reg,

    output jump,
    output ID_DMEM_W_ena,
    output ID_RF_W_ena,
    output [4:0] aluc,

    output [1:0] pc_mux_select, 
    output aluc_input1_select,
    output [1:0] aluc_input2_select, 
    output [1:0] mux_waddr_ID,
    
    output ID_LW, ID_JAL, ID_MUL
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

    wire MUL = (op == 6'b011100 && func == 6'b000010) ? 1 : 0;

    assign ID_LW = LW;
    assign ID_JAL = JAL;
    assign ID_MUL = MUL;

    /* DMEM控制信号 */
	assign ID_DMEM_W_ena = SW; // 数据内存写使能
    assign ID_RF_W_ena =!BEQ && !BNE && !SW && !J && !JR; // 寄存器文件写使能

    /* 跳转信号 */
    assign jump = JR || J || JAL || (BEQ && (rs_reg == rt_reg)) || (BNE && (rs_reg != rt_reg));
    
    /* aluc */
    assign aluc[4] = LUI;
    assign aluc[3] = SLT || SLTU || SLL || SRL || SRA || SLLV || SRLV || SRAV || SLTI || SLTIU;
    assign aluc[2] = AND || OR || XOR || NOR || SRA || SLLV || SRLV || SRAV || ANDI || ORI || XORI;
    assign aluc[1] = SUB || SUBU || XOR || NOR || SLL || SRL || SRLV || SRAV || XORI;
    assign aluc[0] = ADDU || SUBU || OR || NOR || SLTU || SRL || SLLV || SRAV || ADDIU || ORI || SLTIU;

    /* aluc输入选择 */
	assign aluc_input1_select = SLL || SRA || SRL;
    assign aluc_input2_select = {!(ADDI || ADDIU || LUI || LW || SLTI || SW || ANDI || ORI || SLTIU || XORI),
                             ANDI || ORI || SLTIU || XORI};
    
    
    /* PC控制信号 */
	assign pc_mux_select = (J || JAL) ? 2'b00 : (JR ? 2'b01 : ((BNE || BEQ) ? 2'b11 : 2'bxx));

    /* 写地址选择 */
	assign mux_waddr_ID = {JAL, !(ADDI || ADDIU || ANDI || LUI || LW || ORI || SLTI || SLTIU || XORI || JAL)};

endmodule