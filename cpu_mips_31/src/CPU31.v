`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/14 22:12:50
// Design Name: 
// Module Name: CPU31
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


module CPU31(
    input clk,
    input ena,
    input reset,
    input [31:0] IMem_inst,
    input [31:0] DMem_rdata,
    output [31:0] DMem_wdata,
    output DMem_w,
    output DMem_r,
    output [31:0] Pc_out,
    output [31:0] ALU_out
    );

    wire [31:0] PC, NPC;
    assign NPC = PC + 4;
    assign Pc_out = PC;

    // RegFile
    wire [4:0] rdc, rsc, rtc;
    wire [31:0] rd, rs, rt;
    wire RF_w;

    // ALU
    wire [4:0] aluc;
    wire zero;

    wire [31:0] MUX1;
    wire [31:0] MUX2;
    wire [31:0] MUX3;
    wire [31:0] MUX4;
    wire [31:0] MUX5;
    wire [31:0] MUX6;
    wire [31:0] MUX7;
    wire [31:0] MUX8;
    wire [31:0] MUX9;
    wire [31:0] MUX10;
    wire M1, M2, M3, M4, M5, M6, M7, M8, M9, M10;
    wire [31:0] M8_t;

    wire [31:0] ext_18_sign;
    wire [31:0] ext_16;
    wire [31:0] ext_16_sign;
    wire ext_16_sign_judge;

    wire ADD, ADDU, SUB, SUBU, AND, OR, XOR, NOR;
    wire SLT, SLTU, SLL, SRL, SRA, SLLV, SRLV, SRAV;
    wire JR;
    wire ADDI, ADDIU, ANDI, ORI, XORI;
    wire LW, SW, BEQ, BNE, SLTI, SLTIU, LUI;
    wire J, JAL;

    // assign ALU_out = res;
    assign DMem_wdata = rt;
    assign DMem_w = SW;  // SW
    assign DMem_r = LW;

    assign ADD = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b100000) ? 1 : 0;
    assign ADDU = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b100001) ? 1 : 0;
    assign SUB = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b100010) ? 1 : 0;
    assign SUBU = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b100011) ? 1 : 0;
    assign AND = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b100100) ? 1 : 0;
    assign OR = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b100101) ? 1 : 0;
    assign XOR = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b100110) ? 1 : 0;
    assign NOR = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b100111) ? 1 : 0;
    assign SLT = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b101010) ? 1 : 0;
    assign SLTU = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b101011) ? 1 : 0;
    assign SLL = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b000000) ? 1 : 0;
    assign SRL = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b000010) ? 1 : 0;
    assign SRA = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b000011) ? 1 : 0;
    assign SLLV = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b000100) ? 1 : 0;
    assign SRLV = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b000110) ? 1 : 0;
    assign SRAV = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b000111) ? 1 : 0;
    assign JR = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b001000) ? 1 : 0;

    assign ADDI = (IMem_inst[31:26] == 6'b001000) ? 1 : 0;
    assign ADDIU = (IMem_inst[31:26] == 6'b001001) ? 1 : 0;
    assign ANDI = (IMem_inst[31:26] == 6'b001100) ? 1 : 0;
    assign ORI = (IMem_inst[31:26] == 6'b001101) ? 1 : 0;
    assign XORI = (IMem_inst[31:26] == 6'b001110) ? 1 : 0;
    assign LW = (IMem_inst[31:26] == 6'b100011) ? 1 : 0;
    assign SW = (IMem_inst[31:26] == 6'b101011) ? 1 : 0;
    assign BEQ = (IMem_inst[31:26] == 6'b000100) ? 1 : 0;
    assign BNE = (IMem_inst[31:26] == 6'b000101) ? 1 : 0;
    assign SLTI = (IMem_inst[31:26] == 6'b001010) ? 1 : 0;
    assign SLTIU = (IMem_inst[31:26] == 6'b001011) ? 1 : 0;
    assign LUI = (IMem_inst[31:26] == 6'b001111) ? 1 : 0;

    assign J = (IMem_inst[31:26] == 6'b000010) ? 1 : 0;
    assign JAL = (IMem_inst[31:26] == 6'b000011) ? 1 : 0;

    assign M1 = J || JAL;
    assign M2 = (!JR);  // BEQ(1)
    assign M3 = (!ADDI) && (!ADDIU) && (!ANDI) && (!ORI) && (!XORI) && (!SLTI) && (!SLTIU) && (!LUI) && (!LW);  // IMem[20:16](rt)
    assign M4 = (JAL);
    assign M5 = (!LW);
    assign M6 = SLL || SRL || SRA;  // ADDI(0)
    assign M7 = (!JAL);  // ADDI(1)   JAL(0)
    assign M8 = (!ADDI) && (!ADDIU) && (!ANDI) && (!ORI) && (!XORI) && (!LW) && (!SW) && (!SLTI) && (!SLTIU) && (!LUI);  // ADDI(0)
    assign M9 = JAL;  // ADDI(0)   JAL(1)
    assign M10 = (BEQ && zero) || (BNE && (!zero));

    assign aluc[4] = LUI;
    assign aluc[3] = SLT || SLTU || SLL || SRL || SRA || SLLV || SRLV || SRAV || SLTI || SLTIU;
    assign aluc[2] = AND || OR || XOR || NOR || SRA || SLLV || SRLV || SRAV || ANDI || ORI || XORI;
    assign aluc[1] = SUB || SUBU || XOR || NOR || SLL || SRL || SRLV || SRAV || XORI;
    assign aluc[0] = ADDU || SUBU || OR || NOR || SLTU || SRL || SLLV || SRAV || ADDIU || ORI || SLTIU;

    assign rd = MUX5;
    assign rdc = M3 ? (M4 ? 5'd31 : IMem_inst[15:11]) : IMem_inst[20:16];  // ADDI(rtc)
    assign rsc = IMem_inst[25:21];
    assign rtc = IMem_inst[20:16];
    assign RF_w= (!SW) && (!BEQ) && (!BNE) && (!J) && (!JR);  // ADDI(1)
    
    assign ext_16_sign_judge = ADDI || ADDIU || SLTI || SLTIU || LW; //  ADDI(1)
    assign ext_18_sign = {{14{IMem_inst[15]}}, {IMem_inst[15:0], 2'h0}};
    assign ext_16_sign = {{16{IMem_inst[15]}}, IMem_inst[15:0]};  // 0-15有符号扩展(imm16)
    assign ext_16 = {16'h0, IMem_inst[15:0]};
    assign M8_t = ext_16_sign_judge ? ext_16_sign : ext_16;  // ADDI(ext_16_sign)

    assign MUX1 = M1 ? {PC[31:28], IMem_inst[25:0], 2'b0} : MUX10;  // PC or NPC???   J(1)  JAL(1)  BEQ(0)
    assign MUX2 = M2 ? MUX1 : rs;  // J(1)  JAL(1--拼接结果)  BEQ(1)
    // MUX3和MUX4与rdc相关
    assign MUX5 = M5 ? ALU_out : DMem_rdata;
    assign MUX6 = M6 ? {27'b0, IMem_inst[10:6]} : rs;   // ADDI(rs)
    assign MUX7 = M7 ? MUX6 : PC;  // PC or NPC???     ADDI(MUX6)   PC
    assign MUX8 = M8 ? rt : M8_t;  // M8_t
    assign MUX9 = M9 ? 32'd4 : MUX8;   // MUX8   JAL(32'd4) 本身已经加了4
    assign MUX10 = M10 ? ext_18_sign + NPC : NPC;   //BEQ(1)

    RegFile cpu_ref(
        .ena(1),
        .reset(reset),
        .clk(clk),
        .RF_w(RF_w),  // ADDI(1)
        .rdc(rdc),
        .rsc(rsc),
        .rtc(rtc),
        .rd(rd),  // rd
        .rs(rs),
        .rt(rt)
    );

    PCreg cpu_PR(
        .ena(1),
        .reset(reset),
        .clk(clk),
        .Pc_in(MUX2),
        .Pc_out(PC)
    );

    ALU cpu_ALU(
        .a(MUX7),  // ADDI --- rs √    J(rs)   JAL(PC)
        .b(MUX9),  // ADDI(imm16(sign_ext)) √   ADD --- rt  J(rt)   JAL(32'd4)
        .aluc(aluc),  // 0
        .res(ALU_out),
        .zero(zero)
    );

endmodule