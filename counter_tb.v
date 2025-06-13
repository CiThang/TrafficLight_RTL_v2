`timescale 1ns/1ps
`include "counter.v"

module counter_tb;
    reg clk;
    reg reset;
    reg [5:0] timer_value;
    wire [5:0] counter_value;

    counter uut (
        .clk(clk),
        .reset(reset),
        .timer_value(timer_value),
        .counter_value(counter_value)
    );

    // Tạo xung clk 1Hz
    initial begin
        clk = 0;
        forever #500_000_000 clk = ~clk; // 0.5s mỗi cạnh => 1s chu kỳ
    end

    // Test chính
    initial begin
        $dumpfile("counter_tb.vcd");
        $dumpvars(0, counter_tb);

        // Reset hệ thống
        reset = 1;
        timer_value = 6'd18; // RED
        #1_000_000_000; // 1s

        reset = 0;

        // Chờ RED hết
        #18_000_000_000; // 18s

        // GREEN
        timer_value = 6'd15;
        #1_000_000_000; // 1s
        #15_000_000_000; // 15s

        // YELLOW
        timer_value = 6'd3;
        #1_000_000_000; // 1s
        #3_000_000_000; // 3s

        // Quay lại RED
        timer_value = 6'd18;
        #1_000_000_000; // 1s
        #18_000_000_000; // 18s

        $finish;
    end

endmodule
