`timescale 1ns/1ps
`include "top_module.v"
module top_module_tb;

    // Parameters
    parameter pSECOND_CNT_VAL    = 99;
    parameter pTIME_GREEN_LIGHT  = 15;
    parameter pTIME_YELLOW_LIGHT = 3;
    parameter pTIME_RED_LIGHT    = 18;
    // Testbench signals
    reg clk;
    reg en;
    reg rst_n;

    wire green_light;
    wire yellow_light;
    wire red_light;
    wire [6:0] seg_a;
    wire [6:0] seg_b;

    // Clock parameters
    parameter CLK_DELAY  = 5;
    parameter CLK_WIDTH  = 5;
    parameter CLK_PERIOD = 10;

    // Clock generation
    always begin
        #(CLK_DELAY)  clk = 1'b1;
        #(CLK_WIDTH)  clk = 1'b0;
        #(CLK_PERIOD - CLK_DELAY - CLK_WIDTH);
    end

    // Device under test
    top_module #(
        .pSECOND_CNT_VAL(pSECOND_CNT_VAL),
        .pTIME_GREEN_LIGHT(pTIME_GREEN_LIGHT),
        .pTIME_YELLOW_LIGHT(pTIME_YELLOW_LIGHT),
        .pTIME_RED_LIGHT(pTIME_RED_LIGHT)
    ) u_dut (
        .clk(clk),
        .en(en),
        .rst_n(rst_n),
        .green_light(green_light),
        .yellow_light(yellow_light),
        .red_light(red_light),
        .seg_a(seg_a),
        .seg_b(seg_b)
    );

    // Monitor traffic light changes

    // Test sequence
    initial begin
        // Dump waveform to file
        $dumpfile("top_module.vcd");
        $dumpvars(0, top_module_tb);

        // Initialize signals
        clk   = 1'b0;
        rst_n = 1'b0;
        en    = 0;

        // Apply reset and then release
        #(5 * CLK_PERIOD) rst_n = 1'b1; en = 1;

        // Run long enough to see full GREEN → YELLOW → RED transitions
        #(4000 * CLK_PERIOD);  // 40000 x 10ps = 400,000ps (adjust if needed)

        // End simulation
        $finish;
    end

endmodule
