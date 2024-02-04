`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/03 21:04:33
// Design Name: 
// Module Name: DMEM
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


module DMEM(
    input clk,
    input ena,
    input DM_W,
    input DM_R,
    input [1:0] select,  // 11--32bit; 01--16bit; 00--8bit
    input [5:0] DM_addr,  // 原来是 【10:0】
    input [31:0] DM_wdata,
    output [31:0] DM_rdata
    );
    // wire [7:0] DM_addr;
    // assign DM_addr=DM_addr[7:0];
    // reg [31:0] mem [31:0];
    reg [7:0] mem [0:255];

    always @(negedge clk) begin
        if (ena && DM_W) begin
            // mem[DM_DM_addr] <= DM_wdata;  // SW
            mem[DM_addr] <= DM_wdata[7:0];
            if (select[0]) begin
                mem[DM_addr + 1] <= DM_wdata[15:8];
            end
            if (select[1]) begin
                mem[DM_addr + 2] <= DM_wdata[23:16];
                mem[DM_addr + 3] <= DM_wdata[31:24];
            end
        end
    end

    // assign DM_rdata = (ena && DM_R) ? mem[DM_DM_addr] : 32'bz;  // LW：DMEM中进行寻址并读取值
    // assign DM_rdata = (ena && DM_R) ? {mem[DM_addr], mem[DM_addr + 1], mem[DM_addr + 2], mem[DM_addr + 3]} : 32'bz;
    assign DM_rdata = (ena && DM_R) ? {(select[1] ? {mem[DM_addr + 3], mem[DM_addr + 2]} : 16'b0), (select[0] ? mem[DM_addr + 1] : 8'b0), mem[DM_addr]} : 32'bz;
    

endmodule
