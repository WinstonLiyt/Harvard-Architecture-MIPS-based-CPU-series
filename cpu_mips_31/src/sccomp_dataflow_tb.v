`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/16 15:39:14
// Design Name: 
// Module Name: sccomp_dataflow_tb
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


module sccomp_dataflow_tb();
    reg clk, rst;
    wire [31:0] inst, pc;
    reg [31:0] cnt;
    
    integer file_open;
    initial begin
        clk = 1'b0;
        rst = 1'b1;
        #50
        rst = 1'b0;
        cnt = 0;
    end

    always begin
        #3
        clk = !clk;
    end

    always @(posedge clk) begin
        cnt <= cnt + 1;
        file_open = $fopen("myresult.txt", "a");
        // $fdisplay(file_open, "step: %h", cnt);
        $fdisplay(file_open, "pc: %h", sccomp_dataflow_tb.pc);
        $fdisplay(file_open, "instr: %h", sccomp_dataflow_tb.inst);
        
        $fdisplay(file_open, "regfile0: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[0]);
        $fdisplay(file_open, "regfile1: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[1]);
        $fdisplay(file_open, "regfile2: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[2]);
        $fdisplay(file_open, "regfile3: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[3]);
        $fdisplay(file_open, "regfile4: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[4]);
        $fdisplay(file_open, "regfile5: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[5]);
        $fdisplay(file_open, "regfile6: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[6]);
        $fdisplay(file_open, "regfile7: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[7]);
        $fdisplay(file_open, "regfile8: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[8]);
        $fdisplay(file_open, "regfile9: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[9]);
        $fdisplay(file_open, "regfile10: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[10]);
        $fdisplay(file_open, "regfile11: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[11]);
        $fdisplay(file_open, "regfile12: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[12]);
        $fdisplay(file_open, "regfile13: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[13]);
        $fdisplay(file_open, "regfile14: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[14]);
        $fdisplay(file_open, "regfile15: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[15]);
        $fdisplay(file_open, "regfile16: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[16]);
        $fdisplay(file_open, "regfile17: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[17]);
        $fdisplay(file_open, "regfile18: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[18]);
        $fdisplay(file_open, "regfile19: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[19]);
        $fdisplay(file_open, "regfile20: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[20]);
        $fdisplay(file_open, "regfile21: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[21]);
        $fdisplay(file_open, "regfile22: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[22]);
        $fdisplay(file_open, "regfile23: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[23]);
        $fdisplay(file_open, "regfile24: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[24]);
        $fdisplay(file_open, "regfile25: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[25]);
        $fdisplay(file_open, "regfile26: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[26]);
        $fdisplay(file_open, "regfile27: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[27]);
        $fdisplay(file_open, "regfile28: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[28]);
        $fdisplay(file_open, "regfile29: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[29]);
        $fdisplay(file_open, "regfile30: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[30]);
        $fdisplay(file_open, "regfile31: %h", sccomp_dataflow_tb.sccpu.cpu_ref.array_reg[31]);
        $fclose(file_open);
    end

    sccomp_dataflow sccomp_dataflow_tb(
        .clk_in(clk),
        .reset(rst),
        .inst(inst),
        .pc(pc)
    );
endmodule