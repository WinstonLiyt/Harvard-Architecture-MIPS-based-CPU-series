`timescale 1ns / 1ps

module ControllerBranch(
    input clk,
    input rst,
    input [31:0] ID_rs_reg, 
    input [31:0] ID_rt_reg,
    input [5:0] op,
    input [5:0] func,
    output reg branch 
    );

	always @(*) begin
	    if (rst)
	        branch <= 1'b0;
		else if (op == 6'b000100) 
			branch <= (ID_rs_reg == ID_rt_reg) ? 1'b1 : 1'b0;
        else if (op == 6'b000101) 
			branch <= (ID_rs_reg != ID_rt_reg) ? 1'b1 : 1'b0;
		else if (op == 6'b000001) 
			branch <= (ID_rs_reg >= 0) ? 1'b1 : 1'b0;	
		else if (op == 6'b000000 && func == 6'b110100)
			branch <= (ID_rs_reg == ID_rt_reg) ? 1'b1 : 1'b0;
		else if (op == 6'b000010)
			branch <= 1'b1;
	    else if (op == 6'b000011)
	        branch <= 1'b1;
	    else if (op == 6'b000000 && func == 6'b001000)
            branch <= 1'b1;
        else if (op == 6'b000000 && func == 6'b001001)
            branch <= 1'b1;
        else
            branch <= 1'b0;
	end      

endmodule
