`timescale 1ns/1ps
`include "second_counter.v"

module second_counter_tb;

    reg clk;
    reg en;
    reg rst_n;
    wire last;
    wire pre_last;
    wire [6:0] second;

    // Khởi tạo đối tượng cần test
    second_counter #(.MAX_VALUE(10)) uut (
        .clk(clk),
        .en(en),
        .rst_n(rst_n),
        .last(last),
        .pre_last(pre_last),
        .second(second)
    );

    // Tạo xung clock 100MHz
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Mô phỏng hoạt động
    initial begin
        $dumpfile("second_counter_tb.vcd");
        $dumpvars(0, second_counter_tb);

        // Reset
        rst_n = 0;
        en = 0;
        #10;

        rst_n = 1;
        en = 1;
        #200;

        en = 0;
        #20;

        en = 1;
        #100;

        $finish;
    end


endmodule
