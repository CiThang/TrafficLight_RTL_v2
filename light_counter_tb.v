`timescale 1ns/1ps
`include "light_counter.v"
module light_counter_tb;

    // Parameters
    parameter pGREEN_INIT_VAL  = 14;
    parameter pYELLOW_INIT_VAL = 2;
    parameter pRED_INIT_VAL    = 17;
    parameter pCNT_WIDTH       = 5; // log2(pRED_INIT_VAL+1)
    parameter pINIT_WIDTH      = 3;
    parameter CLK_PERIOD       = 10;

    // Signals
    reg clk;
    reg rst_n;
    reg en;
    reg [pINIT_WIDTH-1:0] init;
    wire last;
    wire [pCNT_WIDTH-1:0] cnt_out;

    // Instantiate DUT
    light_counter #(
        .pGREEN_INIT_VAL(pGREEN_INIT_VAL),
        .pYELLOW_INIT_VAL(pYELLOW_INIT_VAL),
        .pRED_INIT_VAL(pRED_INIT_VAL),
        .pCNT_WIDTH(pCNT_WIDTH),
        .pINIT_WIDTH(pINIT_WIDTH)
    ) uut (
        .clk(clk),
        .en(en),
        .rst_n(rst_n),
        .init(init),
        .last(last),
        .cnt_out(cnt_out)
    );

    // Clock generator
    always #(CLK_PERIOD/2) clk = ~clk;

    // VCD
    initial begin
        $dumpfile("light_counter_tb.vcd");
        $dumpvars(0, light_counter_tb);
    end

    // Test procedure
    initial begin
        // Initial values
        clk = 0;
        rst_n = 0;
        en = 0;
        init = 3'b000;

        // Reset
        #20;
        rst_n = 1;

        // Start with GREEN
        #10;
        init = 3'b001; // GREEN
        #10;
        init = 3'b000;
        en = 1;

        // Wait until GREEN expires
        wait (last);
        #10;
        en = 0;

        // Set YELLOW
        init = 3'b010;
        #10;
        init = 3'b000;
        en = 1;

        // Wait until YELLOW expires
        wait (last);
        #10;
        en = 0;

        // Set RED
        init = 3'b100;
        #10;
        init = 3'b000;
        en = 1;

        // Wait until RED expires
        wait (last);
        #10;
        en = 0;

        // Back to GREEN
        init = 3'b001;
        #10;
        init = 3'b000;
        en = 1;

        // Run for a bit then finish
        #(20 * CLK_PERIOD);
        $finish;
    end

endmodule
