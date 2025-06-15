`timescale 1ns/1ps
`include "traffic_fsm.v"
module traffic_fsm_tb;

    // Parameters
    parameter LIGHT_STATE_WIDTH = 3;
    parameter CLK_PERIOD = 10;

    // Inputs
    reg clk;
    reg rst_n;
    reg en;
    reg light_cnt_last;
    reg second_cnt_pre_last;

    // Outputs
    wire [LIGHT_STATE_WIDTH-1:0] light;
    wire [LIGHT_STATE_WIDTH-1:0] light_cnt_init;

    // Instantiate the DUT
    traffic_fsm #(
        .LIGHT_STATE_WIDTH(LIGHT_STATE_WIDTH)
    ) uut (
        .clk(clk),
        .en(en),
        .rst_n(rst_n),
        .light_cnt_last(light_cnt_last),
        .second_cnt_pre_last(second_cnt_pre_last),
        .light(light),
        .light_cnt_init(light_cnt_init)
    );

    // Clock generator
    always #(CLK_PERIOD / 2) clk = ~clk;

    // VCD file
    initial begin
        $dumpfile("traffic_fsm_tb.vcd");
        $dumpvars(0, traffic_fsm_tb);
    end

    // Test procedure
    initial begin
        // Initial values
        clk = 0;
        rst_n = 0;
        en = 0;
        light_cnt_last = 0;
        second_cnt_pre_last = 0;

        // Apply reset
        #20;
        rst_n = 1;

        // Enable FSM
        en = 1;

        // Wait in GREEN state
        #20;

        // Trigger transition GREEN -> YELLOW
        light_cnt_last = 1;
        second_cnt_pre_last = 1;
        #10;
        light_cnt_last = 0;
        second_cnt_pre_last = 0;

        // Wait in YELLOW state
        #30;

        // Trigger transition YELLOW -> RED
        light_cnt_last = 1;
        second_cnt_pre_last = 1;
        #10;
        light_cnt_last = 0;
        second_cnt_pre_last = 0;

        // Wait in RED state
        #30;

        // Trigger transition RED -> GREEN
        light_cnt_last = 1;
        second_cnt_pre_last = 1;
        #10;
        light_cnt_last = 0;
        second_cnt_pre_last = 0;

        // Wait in GREEN again
        #30;

        // Disable FSM
        en = 0;
        #20;

        // Apply reset
        rst_n = 0;
        #10;
        rst_n = 1;

        // Finish simulation
        #20;
        $finish;
    end

endmodule
