`timescale 1ns/1ps
`include "top_module.v"

module top_module_tb;

    reg en, clk, rst_n;
    wire [1:0] led;
    wire [6:0] seg_a, seg_b;

    // Instantiate DUT (Design Under Test)
    top_module uut (
        .en(en),
        .clk(clk),
        .rst_n(rst_n),
        .led(led),
        .seg_a(seg_a),
        .seg_b(seg_b)
    );

    // Clock generation: siêu nhanh để mô phỏng nhanh
    initial begin
        clk = 0;
        forever #0.5 clk = ~clk; // Toggle every 0.5ns = 1GHz
    end

    // Simulation flow
    initial begin
        $dumpfile("top_module_tb.vcd");
        $dumpvars(0, top_module_tb);

        // Initial setup
        en = 0;
        rst_n = 0;

        // Release reset
        #2;
        rst_n = 1;
        en = 1;

       
        // Giả lập nhanh: chờ 40ns (tương ứng với 40 "logic seconds")
        #40;

        // Tắt hệ thống
        en = 0;

        #10;
        $finish;
    end

endmodule
