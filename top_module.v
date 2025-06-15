// Traffic Light Controller Verilog Implementation
// Based on SystemVerilog version
`include "second_counter.v"
`include "light_counter.v"
`include "traffic_fsm.v"
`include "segment_display.v"
module top_module #(
    parameter pSECOND_CNT_VALUE = 99,
    parameter pGREEN_INIT_VAL = 14,
    parameter pYELLOW_INIT_VAL = 2,
    parameter pRED_INIT_VAL = 17
)(
    input wire clk,
    input wire en,
    input wire rst_n,
    output wire green_light,
    output wire yellow_light,
    output wire red_light,
    output wire [6:0] seg_a,
    output wire [6:0] seg_b 
);

    wire [6:0] count; 
    // Parameters
    parameter pNUMBER_WIDTH = 5;
    parameter pLED_WIDTH = 8;
    parameter pLED_NO = 2;
    
    parameter pGREEN_IDX = 0;
    parameter pYELLOW_IDX = 1;
    parameter pRED_IDX = 2;
    parameter pLIGHT_CNT_WIDTH = 5; // log2(pRED_INIT_VAL+1)
    parameter pINIT_WIDTH = 3;
    parameter pSECOND_CNT_WIDTH = 7; // log2(pSECOND_CNT_VALUE+1)
    parameter LIGHT_STATE_WIDTH = 3;
    
    // Internal signals
    wire second_cnt_last, second_cnt_pre_last;
    
    wire [pINIT_WIDTH-1:0] light_cnt_init;
    wire light_cnt_last;
    wire [pLIGHT_CNT_WIDTH-1:0] light_cnt_out;
    wire light_cnt_en;
    wire [LIGHT_STATE_WIDTH-1:0] light;
    
    // Second counter module
    second_counter #(
        .pMAX_VAL(pSECOND_CNT_VALUE)
    ) second_cnt (
        .clk(clk),
        .en(en),
        .rst_n(rst_n),
        .last(second_cnt_last),
        .pre_last(second_cnt_pre_last),
        .count(count)
    );
    
    // Light counter enable
    assign light_cnt_en = en & second_cnt_last;
    
    // Light counter module
    light_counter #(
        .pGREEN_INIT_VAL(pGREEN_INIT_VAL),
        .pYELLOW_INIT_VAL(pYELLOW_INIT_VAL),
        .pRED_INIT_VAL(pRED_INIT_VAL),
        .pCNT_WIDTH(pLIGHT_CNT_WIDTH),
        .pINIT_WIDTH(pINIT_WIDTH)
    ) dut1 (
        .clk(clk),
        .en(light_cnt_en),
        .rst_n(rst_n),
        .init(light_cnt_init),
        .last(light_cnt_last),
        .cnt_out(light_cnt_out)
    );
    
    
    
    // Light FSM module
    traffic_fsm #(
        .LIGHT_STATE_WIDTH(LIGHT_STATE_WIDTH)
    ) dut3 (
        .clk(clk),
        .en(en),
        .rst_n(rst_n),
        .light_cnt_last(light_cnt_last),
        .second_cnt_pre_last(second_cnt_pre_last),
        .light(light),
        .light_cnt_init(light_cnt_init)
    );
    
    // Segment display module
    segment_display seg_disp (
        .count(count),
        .seg_a(seg_a),
        .seg_b(seg_b)
    );

    // Light outputs
    assign green_light = light[pGREEN_IDX];
    assign yellow_light = light[pYELLOW_IDX];
    assign red_light = light[pRED_IDX];

endmodule