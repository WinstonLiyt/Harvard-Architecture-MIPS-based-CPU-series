`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/04 10:18:03
// Design Name: 
// Module Name: CPU54
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


module CPU54(
    input clk,
    input ena,
    input reset,
    input [31:0] IMem_inst,
    input [31:0] DMem_rdata,
    output [31:0] DMem_wdata,
    output DMem_w,
    output DMem_r,
    output [1:0] DMem_sel,
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
    wire negative;

    // CLZ
    wire [31:0] CLZ_out;

    // DIV(U)
	wire [31:0] DIV_lo, DIV_hi, DIVU_lo, DIVU_hi;
	wire DIV_busy, DIVU_busy;
	wire busy = DIV_busy | DIVU_busy;
    wire DIV_sign;

    // MUL(TU)
	wire [31:0] MUL_out;
	wire [31:0] MULTU_hi, MULTU_lo;

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
    wire [31:0] MUX15;
    wire [31:0] MUX16;
    wire M1, M2, M3, M4, M5, M6, M7, M8, M9, M10, M11, M11_2, M12, M13, M14, M15, M16;
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
    wire CLZ, ERET, MFC0, MTC0, SYSCALL, TEQ, BREAK;
    wire DIVU, DIV, MUL, MULTU, MFHI, MFLO, MTHI, MTLO;
    wire SB, SH, LB, LH, LBU, LHU;
    wire JALR, BGEZ; 

    // assign ALU_out = res;

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

    assign CLZ = (IMem_inst[31:26] == 6'b011100 && IMem_inst[5:0] == 6'b100000) ? 1 : 0;
    assign ERET = (IMem_inst[31:26] == 6'b010000 && IMem_inst[5:0] == 6'b011000) ? 1 : 0;
    assign MFC0 = (IMem_inst[31:26] == 6'b010000 && IMem_inst[5:0] == 6'b000000 && IMem_inst[25:21] == 5'b00000) ? 1 : 0;
    assign MTC0 = (IMem_inst[31:26] == 6'b010000 && IMem_inst[5:0] == 6'b000000 && IMem_inst[25:21] == 5'b00100) ? 1 : 0;
    assign SYSCALL = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b001100) ? 1 : 0;
    assign TEQ = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b110100) ? 1 : 0;
    assign BREAK = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b001101) ? 1 : 0;

    // DIVU, DIV, MUL, MULTU, MFHI, MFLO, MTHI, MTLO;
    assign DIVU = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b011011) ? 1 : 0;
    assign DIV = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b011010) ? 1 : 0;
    assign MUL = (IMem_inst[31:26] == 6'b011100 && IMem_inst[5:0] == 6'b000010) ? 1 : 0;
    assign MULTU = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b011001) ? 1 : 0;
    assign MFHI = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b010000) ? 1 : 0;
    assign MFLO = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b010010) ? 1 : 0;
    assign MTHI = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b010001) ? 1 : 0;
    assign MTLO = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b010011) ? 1 : 0;

    // wire SB, SH, LB, LH, LBU, LHU;
    assign SB = (IMem_inst[31:26] == 6'b101000) ? 1 : 0;
    assign SH = (IMem_inst[31:26] == 6'b101001) ? 1 : 0;
    assign LB = (IMem_inst[31:26] == 6'b100000) ? 1 : 0;
    assign LH = (IMem_inst[31:26] == 6'b100001) ? 1 : 0;
    assign LBU = (IMem_inst[31:26] == 6'b100100) ? 1 : 0;
    assign LHU = (IMem_inst[31:26] == 6'b100101) ? 1 : 0;

    // wire JALR, BGEZ;
    assign JALR = (IMem_inst[31:26] == 6'b000000 && IMem_inst[5:0] == 6'b001001) ? 1 : 0;
    assign BGEZ = (IMem_inst[31:26] == 6'b000001) ? 1 : 0;

    parameter	CAUSE_SYSCALL	= 5'b01000,
				CAUSE_BREAK		= 5'b01001,
				CAUSE_TEQ		= 5'b01101;

    // CP0
	wire exception = BREAK || SYSCALL || (TEQ && zero);
	wire [4:0] cause = BREAK ? CAUSE_BREAK : (SYSCALL ? CAUSE_SYSCALL : (TEQ ? CAUSE_TEQ : 5'bz));
	wire [31:0] CP0_wdata = rt;  // MTC0
	wire [31:0] CP0_rdata;
	wire [31:0] status;
	wire [31:0] EPC;

    // lo, hi
	// wire [31:0] LO_in = MTLO ? rs : (MULTU ? MULTU_lo : (DIV ? DIV_lo : DIVU_lo));  // MTLO
	// wire [31:0] HI_in = MTHI ? rs : (MULTU ? MULTU_hi : (DIV ? DIV_hi : DIVU_hi));  // MTHI
    wire [31:0] LO_in = MTLO ? rs : (MULTU ? MULTU_lo : DIVU_lo);  // MTLO
	wire [31:0] HI_in = MTHI ? rs : (MULTU ? MULTU_hi : DIVU_hi);  // MTHI
	wire [31:0] LO_out, HI_out;
	wire HI_ENA = MULTU | DIV | DIVU | MTHI;
	wire LO_ENA = MULTU | DIV | DIVU | MTLO;

    // DMEM
    assign DMem_wdata = rt;
    assign DMem_w = SW || SB || SH;  // SW
    assign DMem_r = LW || LBU || LHU || LB || LH;
    wire DMem_32 = LW | SW;
	wire DMem_16 = LW | SW | LH | LHU | SH;
	assign DMem_sel = {DMem_32, DMem_16};

    assign DIV_sign = DIV;


    assign M1 = J || JAL;
    assign M2 = (!JR) && (!JALR);  // BEQ(1)  JALR：Rs给PC
    assign M3 = (!ADDI) && (!ADDIU) && (!ANDI) && (!ORI) && (!XORI) && (!SLTI) && (!SLTIU) && (!LUI) && (!LW) && (!LH) && (!LHU) && (!LB) && (!LBU) && (!MFC0);  // IMem[20:16](rt)
    assign M4 = (JAL);
    assign M5 = LW;  //  && (!JALR);  // 需要大改动
    assign M6 = SLL || SRL || SRA;  // ADDI(0)
    assign M7 = (!JAL) && (!JALR);  // ADDI(1)   JAL(0)
    assign M8 = (!ADDI) && (!ADDIU) && (!ANDI) && (!ORI) && (!XORI) && (!LW) && (!SW) && (!SLTI) && (!SLTIU) && (!LUI) && (!SB) && (!SH) && (!LB) && (!LH) && (!LBU) && (!LHU);  // ADDI(0)
    assign M9 = JAL || JALR;  // ADDI(0)   JAL(1)
    assign M10 = (BEQ && zero) || (BNE && (!zero)) || (BGEZ && !negative);
    assign M11 = MFLO;  // 选MFLO
    assign M11_2 = MFHI || MFLO;
    assign M12 = LW || LB || LH || LBU || LHU;
    assign M13 = LBU || LHU;  // 零扩展
    assign M14 = LH || LHU;  // 半字
    assign M15 = BGEZ;
    assign M16 = ERET || BREAK;  //  || BREAK;  // BREAK???

    assign aluc[4] = LUI;
    assign aluc[3] = SLT || SLTU || SLL || SRL || SRA || SLLV || SRLV || SRAV || SLTI || SLTIU;
    assign aluc[2] = AND || OR || XOR || NOR || SRA || SLLV || SRLV || SRAV || ANDI || ORI || XORI;
    assign aluc[1] = SUB || SUBU || XOR || NOR || SLL || SRL || SRLV || SRAV || XORI || BGEZ || TEQ;
    assign aluc[0] = ADDU || SUBU || OR || NOR || SLTU || SRL || SLLV || SRAV || ADDIU || ORI || SLTIU;

    assign rd = MUX5;
    assign rdc = M3 ? (M4 ? 5'd31 : IMem_inst[15:11]) : IMem_inst[20:16];  // ADDI(rtc)
    assign rsc = IMem_inst[25:21];
    assign rtc = IMem_inst[20:16];
    assign RF_w= (!SW) && (!BEQ) && (!BNE) && (!J) && (!JR) && (!DIV) && (!DIVU) && (!BGEZ) && (!SB) && (!SH) && (!BREAK) && (!SYSCALL) && (!ERET) && (!MTHI) && (!MTLO) && (!MTC0) && (!TEQ);  // ADDI(1)
    
    assign ext_16_sign_judge = ADDI || ADDIU || SLTI || SLTIU;  //!!! LW 无符号扩展 || LW; //  ADDI(1)
    assign ext_18_sign = {{14{IMem_inst[15]}}, {IMem_inst[15:0], 2'h0}};
    assign ext_16_sign = {{16{IMem_inst[15]}}, IMem_inst[15:0]};  // 0-15有符号扩展(imm16)
    assign ext_16 = {16'h0, IMem_inst[15:0]};
    assign M8_t = ext_16_sign_judge ? ext_16_sign : ext_16;  // ADDI(ext_16_sign)

    assign MUX16 = M16 ? EPC : MUX10;
    assign MUX1 = M1 ? {PC[31:28], IMem_inst[25:0], 2'b0} : MUX16;  //！！！【change】 PC or NPC???   J(1)  JAL(1)  BEQ(0)
    assign MUX2 = M2 ? MUX1 : rs;  // J(1)  JAL(1--拼接结果)  BEQ(1)
    // MUX3和MUX4与rdc相关
    assign MUX5 = CLZ ? CLZ_out : 
                 (MUL ? MUL_out :
                 (M11_2 ? (M11 ? LO_out : HI_out) :
                 (MFC0 ? CP0_rdata : 
                 (M12 ? (M5 ? DMem_rdata :
                 (M14 ? {M13 ? 16'b0 : {16{DMem_rdata[15]}}, DMem_rdata[15:0]} : 
                        {M13 ? 24'b0 : {24{DMem_rdata[7]}}, DMem_rdata[7:0]})) : 
                 ALU_out))));
    assign MUX6 = M6 ? {27'b0, IMem_inst[10:6]} : rs;   // ADDI(rs)
    assign MUX7 = M7 ? MUX6 : PC;  // PC or NPC???     ADDI(MUX6)   PC
    assign MUX8 = M8 ? rt : M8_t;  // M8_t
    assign MUX9 = M9 ? 32'd4 : MUX8;   // MUX8   JAL(32'd4) 本身已经加了4
    assign MUX15 = M15 ? 32'd0 : MUX9;
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
        .b(MUX15),  // ADDI(imm16(sign_ext)) √   ADD --- rt  J(rt)   JAL(32'd4)
        .aluc(aluc),  // 0
        .res(ALU_out),
        .zero(zero),
        .negative(negative)
    );

    CP0 cpu_CP0(
		.clk(clk),
		.rst(reset),
		.mfc0(MFC0),
		.mtc0(MTC0),
		.pc(PC),
		.Rd(IMem_inst[15:11]),
		.wdata(CP0_wdata),
		.exception(exception),
		.eret(ERET),
		.cause(cause),
		.rdata(CP0_rdata),
		.status(status),
		.exc_addr(EPC)
	);

    Reg cpu_lo(
		.clk(clk),
		.rst(reset),
		.ena(LO_ENA),
		.Reg_in(LO_in),
		.Reg_out(LO_out)
	);

	Reg cpu_hi(
		.clk(clk),
		.rst(reset),
		.ena(HI_ENA),
		.Reg_in(HI_in),
		.Reg_out(HI_out)
	);

    // DIV cpu_DIV(
	// 	.dividend(rs),
	// 	.divisor(rt),
	// 	.start(DIV & ~busy),  // busy(DIV_busy | DIVU_busy;)
	// 	.clock(clk),
	// 	.reset(reset),
	// 	.q(DIV_lo),
	// 	.r(DIV_hi),
	// 	.busy(DIV_busy)
	// );

    // DIV cpu_DIV(
	// 	.dividend(rs),
	// 	.divisor(rt),
	// 	.q(DIV_lo),
	// 	.r(DIV_hi)
	// );

    // DIVU cpu_DIVU(
	// 	.dividend(rs),
	// 	.divisor(rt),
	// 	.start(DIVU & ~busy), //启动除法运算//start = is_div & ~busy
	// 	.clock(clk),
	// 	.reset(reset),
	// 	.q(DIVU_lo),
	// 	.r(DIVU_hi),
	// 	.busy(DIVU_busy)
	// );

    DIVU cpu_DIVU(
		.a(rs),
		.b(rt),
        .sign(DIV_sign),
		.q(DIVU_lo),
		.r(DIVU_hi)
	);

    MUL cpu_MUL(
		.clk(clk), 
		.reset(reset),
		.a(rs),
		.b(rt),
		.c(MUL_out)
	);

	MULTU cpu_MULTU(
		.clk(clk), 
		.reset(reset),
		.a(rs),
		.b(rt),
		.hi(MULTU_hi),
		.lo(MULTU_lo)
	);

    CLZ cpu_CLZ(
        .in(rs),
        .out(CLZ_out)
    );

endmodule
