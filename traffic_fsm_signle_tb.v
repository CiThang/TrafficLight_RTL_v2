`timescale 1ns/1ps
`include "traffic_fsm_single.v"

module traffic_fsm_single_tb;

    reg clk;
    reg rst_n;
    wire [1:0] led;

    // Instantiate the traffic_fsm_single module
    traffic_fsm_single uut (
        .clk(clk),
        .rst_n(rst_n),
        .led(led)
    );

    // Generate 1Hz clock (1s period => toggle every 0.5s)
    initial begin
        clk = 0;
        forever #500_000_000 clk = ~clk; // 0.5 second toggle
    end

    // Stimulus
    initial begin
        $dumpfile("traffic_fsm_single_tb.vcd");
        $dumpvars(0, traffic_fsm_single_tb);

        rst_n = 0;
        #1_000_000_000; // Wait 1 second
        rst_n = 1;

        #40_000_000_000; // Wait 40 seconds
        $finish;
    end
endmodule
