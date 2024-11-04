`timescale 1ns / 1ps

module sccomp_dataflow_board_tb;

    reg clk;
    reg rst;
    reg stall;
    reg [5:0] choose;

    wire [7:0] o_seg;
    wire [7:0] o_sel;

    sccomp_dataflow_board uut (
        .clk(clk), 
        .rst(rst), 
        .stall(stall), 
        .choose(choose), 
        .o_seg(o_seg), 
        .o_sel(o_sel)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        // 初始化输入
        rst = 1;
        stall = 0;
        choose = 0;

        // 复位
        #15;
        rst = 0;
    end

endmodule
