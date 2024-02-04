`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/04 08:40:32
// Design Name: 
// Module Name: CP0
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


module CP0(
    input clk,
    input rst,
    input mfc0,             // MFC0
    input mtc0,             // MTC0
    input [31:0] pc,
    input [4:0] Rd,
    input [31:0] wdata,
    input exception,
    input eret,             // ERET
    input [4:0] cause,
    output [31:0] rdata,
    output [31:0] status,
    output [31:0] exc_addr
    );

    parameter STATUS_AD = 4'd12;
    // 中断把Status寄存器的内容左移5位关中断，中断返回时再将Status寄存器右移5位恢复其内容
    parameter CAUSE_AD = 4'd13;
    // cause[6:2] -- ExCode 1000:systcall; 1001:break; 1101:teq
    parameter EPC_AD = 4'd14;
    // 异常发生时 epc 存放当前指令地址作为返回地址

    reg [31:0] cp0_reg[31:0];

    assign exc_addr = eret ? cp0_reg[EPC_AD] : 32'h00400004;  // 异常发生地址
	assign rdata = mfc0 ? cp0_reg[Rd] : 32'bz;  // MFC0 读CP0寄存器（rt←CP0[rd]）

	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			cp0_reg[0] <= 32'b0;
			cp0_reg[1] <= 32'b0;
			cp0_reg[2] <= 32'b0;
			cp0_reg[3] <= 32'b0;
			cp0_reg[4] <= 32'b0;
			cp0_reg[5] <= 32'b0;
			cp0_reg[6] <= 32'b0;
			cp0_reg[7] <= 32'b0;
			cp0_reg[8] <= 32'b0;
			cp0_reg[9] <= 32'b0;
			cp0_reg[10] <= 32'b0;
			cp0_reg[11] <= 32'b0;
			cp0_reg[STATUS_AD] <= {27'b0, 5'b11111};  // 32'b0
			cp0_reg[13] <= 32'b0;
			cp0_reg[14] <= 32'b0;
			cp0_reg[15] <= 32'b0;
			cp0_reg[16] <= 32'b0;
			cp0_reg[17] <= 32'b0;
			cp0_reg[18] <= 32'b0;
			cp0_reg[19] <= 32'b0;
			cp0_reg[20] <= 32'b0;
			cp0_reg[21] <= 32'b0;
			cp0_reg[22] <= 32'b0;
			cp0_reg[23] <= 32'b0;
			cp0_reg[24] <= 32'b0;
			cp0_reg[25] <= 32'b0;
			cp0_reg[26] <= 32'b0;
			cp0_reg[27] <= 32'b0;
			cp0_reg[28] <= 32'b0;
			cp0_reg[29] <= 32'b0;
			cp0_reg[30] <= 32'b0;
			cp0_reg[31] <= 32'b0;
		end
		else if (mtc0) begin  // MTC0 写CP0寄存器（CP0[rd]←rt）
			cp0_reg[Rd] <= wdata;
		end
		else if (exception) begin
			cp0_reg[STATUS_AD] <= cp0_reg[STATUS_AD] << 5;
			cp0_reg[CAUSE_AD] <= {25'b0, cause, 2'b0};
			cp0_reg[EPC_AD] <= pc;
		end
		else if (eret) begin  // eret退出中断，status复位
			cp0_reg[STATUS_AD] <= cp0_reg[STATUS_AD] >> 5;
		end
	end

endmodule
