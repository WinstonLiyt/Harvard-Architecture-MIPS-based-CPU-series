`timescale 1ns / 1ps

module sccomp_dataflow_tb;

    reg clk_in;
    wire clk_real;
    reg reset;
    wire [31:0] inst;
    wire [31:0] pc;
    wire [31:0] reg_i, reg_a, reg_b, reg_c, reg_d;
    integer file_output;
    
    initial  begin
        file_output = $fopen("C:/Users/Liyt/Desktop/result/result.txt");
        clk_in = 0;
        reset = 1; #0.5 reset = 0; 
    end
    sccomp_dataflow uut(
        .clk(clk_real),
        .rst(reset),
        .inst(inst),
        .pc(pc),
        .reg_i(reg_i),
        .reg_a(reg_a),
        .reg_b(reg_b),
        .reg_c(reg_c),
        .reg_d(reg_d)
    );
    
    always begin
        #10 clk_in <= ~clk_in;
    end
    assign clk_real = (inst != 32'b0) ? clk_in : 1'b0;

    always @(posedge clk_real) begin
        $fdisplay(file_output,"pc: %h",pc);
        $fdisplay(file_output,"instr: %h",inst);
        $fdisplay(file_output,"regfiles0: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[0]);
        $fdisplay(file_output,"regfiles1: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[1]);
        $fdisplay(file_output,"regfiles2: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[2]);
        $fdisplay(file_output,"regfiles3: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[3]);
        $fdisplay(file_output,"regfiles4: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[4]);
        $fdisplay(file_output,"regfiles5: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[5]);
        $fdisplay(file_output,"regfiles6: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[6]);
        $fdisplay(file_output,"regfiles7: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[7]);
        $fdisplay(file_output,"regfiles8: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[8]);
        $fdisplay(file_output,"regfiles9: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[9]);
        $fdisplay(file_output,"regfiles10: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[10]);
        $fdisplay(file_output,"regfiles11: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[11]);
        $fdisplay(file_output,"regfiles12: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[12]);
        $fdisplay(file_output,"regfiles13: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[13]);
        $fdisplay(file_output,"regfiles14: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[14]);
        $fdisplay(file_output,"regfiles15: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[15]);
        $fdisplay(file_output,"regfiles16: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[16]);
        $fdisplay(file_output,"regfiles17: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[17]);
        $fdisplay(file_output,"regfiles18: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[18]);
        $fdisplay(file_output,"regfiles19: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[19]);
        $fdisplay(file_output,"regfiles20: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[20]);
        $fdisplay(file_output,"regfiles21: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[21]);
        $fdisplay(file_output,"regfiles22: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[22]);
        $fdisplay(file_output,"regfiles23: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[23]);
        $fdisplay(file_output,"regfiles24: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[24]);
        $fdisplay(file_output,"regfiles25: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[25]);
        $fdisplay(file_output,"regfiles26: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[26]);
        $fdisplay(file_output,"regfiles27: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[27]);
        $fdisplay(file_output,"regfiles28: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[28]);
        $fdisplay(file_output,"regfiles29: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[29]);
        $fdisplay(file_output,"regfiles30: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[30]);
        $fdisplay(file_output,"regfiles31: %h",sccomp_dataflow_tb.uut.my_cpu.cpu_regfile.array_reg[31]);
    end
endmodule
