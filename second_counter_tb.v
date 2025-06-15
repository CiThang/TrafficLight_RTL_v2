`timescale 1ns/1ps
`include "second_counter.v"
module second_counter_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // 100 MHz
    parameter pMAX_VAL = 99;

    // Testbench signals
    reg clk;
    reg rst_n;
    reg en;
    wire last;
    wire pre_last;
    wire [6:0] count;

    // DUT instance
    second_counter #(
        .pMAX_VAL(pMAX_VAL)
    ) uut (
        .clk(clk),
        .en(en),
        .rst_n(rst_n),
        .last(last),
        .pre_last(pre_last),
        .count(count)
    );

    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;

    // VCD dump
    initial begin
        $dumpfile("second_counter.vcd");
        $dumpvars(0, second_counter_tb);
    end

    // Test sequence
    initial begin
        // Khởi tạo
        clk = 0;
        rst_n = 0;
        en = 0;
        
        // Reset thấp → cao
        #10;
        rst_n = 1;
        en = 1;

        // Đếm đủ 2 chu kỳ từ 99 → 0 → 99
        #(pMAX_VAL * CLK_PERIOD + 20);  // chu kỳ đầu
        #(pMAX_VAL * CLK_PERIOD + 20);  // chu kỳ thứ hai

        // Tắt enable
        en = 0;
        #50;

        // Kết thúc mô phỏng
        $finish;
    end

endmodule
