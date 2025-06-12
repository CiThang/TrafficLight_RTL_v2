`timescale 1ns/1ps
`include "clock_divider.v"

module clock_divider_tb;
    reg clk;
    reg rst_n;
    wire clk_1Hz;

    // Instantiate the clock divider module
    clock_divider uut (
        .clk(clk),
        .rst_n(rst_n),
        .clk_1Hz(clk_1Hz)
    );

    // 10MHz Clock generation: Period = 100ns => Toggle every 50ns
    initial begin
        clk = 0;
        forever #50 clk = ~clk;
    end

    // Testbench stimulus
    initial begin
        $dumpfile("clock_divider_tb.vcd");
        $dumpvars(0, clock_divider_tb);

        rst_n = 0; // Assert reset
        #200;
        rst_n = 1; // Deassert reset

        // Run simulation long enough to see several toggles of clk_1Hz
        #2000000000; // 0.5 seconds (sim time in ns) → bạn nên dùng 2_000_000_000 để thấy 2s nếu muốn
        $display("Simulation finished.");
        $finish;
    end
endmodule
