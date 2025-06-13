`include "clock_divider.v"
`include "traffic_fsm_single.v"
`include "counter.v"
`include "segment_display.v"    


module top_module (
    input en, clk, rst_n,
    output      [1:0] led,         
    output      [6:0] seg_a,
    output      [6:0] seg_b
);


    wire [5:0] timer_value;
    wire [5:0] counter_value;

    // clock_divider clk_div (
    //     .clk(clk),
    //     .rst_n(rst_n),
    //     .clk_1Hz(clk_out)
    // );

    traffic_fsm_single fsm (
        .clk(clk),
        .rst_n(rst_n),
        .led(led),
        .timer_value(timer_value)
    );


    counter cnt (
        .clk(clk),
        .rst_n(rst_n),
        .timer_value(timer_value),
        .counter_value(counter_value)
    );

    segment_display seg_disp (
        .count_value(counter_value),
        .seg_a(seg_a),
        .seg_b(seg_b)
    );

endmodule
