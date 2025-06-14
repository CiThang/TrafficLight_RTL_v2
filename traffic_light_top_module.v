`include "light_counter.v"
`include "traffic_fsm.v"
`include "segment_display.v"
`include "second_counter.v"

module traffic_light_top_module #(
    parameter pSECOND_CNT_VAL      = 99,
    parameter pTIME_GREEN_LIGHT    = 15,
    parameter pTIME_YELLOW_LIGHT   = 3,
    parameter pTIME_RED_LIGHT      = 18,
    parameter LIGHT_STATE_WIDTH    = 3         // ✅ Thêm tham số thiếu
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

    parameter  pGREEN_LIGHT  = 0;
    parameter  pYELLOW_LIGHT = 1;
    parameter  pRED_LIGHT    = 2;

    parameter pLIGHT_CNT_WIDTH = 5;
    parameter pINIT_WIDTH      = 3;
    parameter pSECOND_CNT_WIDTH = 7;

    wire second_cnt_last,
         second_cnt_pre_last;

    wire [pINIT_WIDTH-1:0] light_cnt_init;
    wire light_cnt_last;
    wire [pLIGHT_CNT_WIDTH-1:0] light_cnt_out;
    wire light_cnt_en;
    wire [LIGHT_STATE_WIDTH-1:0] light;

    wire [6:0] count;

    // ✅ Gán enable đếm ánh sáng
    assign light_cnt_en = second_cnt_last;

    second_counter #(
        .pMAX_VALUE(pSECOND_CNT_VAL)
    ) second_counter_inst (
        .clk(clk),
        .en(en),
        .rst_n(rst_n),
        .last(second_cnt_last),
        .pre_last(second_cnt_pre_last),
        .second(count)
    );

    light_counter #(
        .pTIME_GREEN_LIGHT(pTIME_GREEN_LIGHT),
        .pTIME_YELLOW_LIGHT(pTIME_YELLOW_LIGHT),
        .pTIME_RED_LIGHT(pTIME_RED_LIGHT),
        .pCNT_WIDTH(pLIGHT_CNT_WIDTH),
        .pINIT_WIDTH(pINIT_WIDTH)
    ) light_counter_inst (
        .clk(clk),
        .en(light_cnt_en),
        .rst_n(rst_n),
        .init(light_cnt_init),
        .last(light_cnt_last),
        .cnt_out(light_cnt_out)
    );

    traffic_fsm #(
        .LIGHT_STATE_WIDTH(LIGHT_STATE_WIDTH)
    ) traffic_fsm_inst (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .second_cnt_pre_last(second_cnt_pre_last),
        .light_cnt_last(light_cnt_last),
        .light(light),
        .light_cnt_init(light_cnt_init)
    );

    segment_display segment_display_inst (
        .count_value(count),
        .seg_a(seg_a),
        .seg_b(seg_b)
    );

    assign green_light  = light[pGREEN_LIGHT];
    assign yellow_light = light[pYELLOW_LIGHT];
    assign red_light    = light[pRED_LIGHT];
endmodule
