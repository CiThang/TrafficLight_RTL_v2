module traffic_fsm#(
    parameter LIGHT_STATE_WIDTH = 3
)(
    input wire clk,
    input wire rst_n,
    input wire en,
    input wire second_cnt_pre_last,
    input wire light_cnt_last,
    output wire [LIGHT_STATE_WIDTH-1:0] light,
    output wire [LIGHT_STATE_WIDTH-1:0] light_cnt_init
);

    // Light indices
    parameter pGREEN_LIGHT  = 0;
    parameter pYELLOW_LIGHT = 1;
    parameter pRED_LIGHT    = 2;

    // FSM states
    parameter pIDLE = 2'b00;
    parameter pGREEN = 2'b01;
    parameter pYELLOW = 2'b10;
    parameter pRED = 2'b11;

    // State registers
    reg [1:0] light_current_state, light_next_state;

    // Output registers
    reg [LIGHT_STATE_WIDTH-1:0] signal_current_light;
    reg [LIGHT_STATE_WIDTH-1:0] signal_current_init;
    reg [LIGHT_STATE_WIDTH-1:0] signal_next_light;
    reg [LIGHT_STATE_WIDTH-1:0] signal_next_init;

    // Last count signal
    wire last_cnt;
    assign last_cnt = light_cnt_last & second_cnt_pre_last;

    assign light = signal_current_light;
    assign light_cnt_init = signal_current_init;

    // State transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            light_current_state <= pIDLE;
            signal_current_light <= 0;
            signal_current_init <= 0;
        end else if (en) begin
            light_current_state <= light_next_state;
            signal_current_light <= signal_next_light;
            signal_current_init <= signal_next_init;
        end else begin
            light_current_state <= pIDLE;
            signal_current_light <= 0;
            signal_current_init <= 0;
        end
    end

    // Combinational logic
    always @(*) begin
        light_next_state = pIDLE;
        signal_next_light = 0;
        signal_next_init = 0;

        case (light_current_state)
            pIDLE: begin
                if (en) begin
                    light_next_state = pGREEN;
                    signal_next_light[pGREEN_LIGHT] = 1'b1;
                    signal_next_init[pGREEN_LIGHT] = 1'b1;
                end
            end

            pGREEN: begin
                if (last_cnt) begin
                    light_next_state = pYELLOW;
                    signal_next_light[pYELLOW_LIGHT] = 1'b1;
                    signal_next_init[pYELLOW_LIGHT] = 1'b1;
                end else begin
                    light_next_state = pGREEN;
                    signal_next_light[pGREEN_LIGHT] = 1'b1;
                    signal_next_init[pGREEN_LIGHT] = 1'b1;
                end
            end

            pYELLOW: begin
                if (last_cnt) begin
                    light_next_state = pRED;
                    signal_next_light[pRED_LIGHT] = 1'b1;
                    signal_next_init[pRED_LIGHT] = 1'b1;
                end else begin
                    light_next_state = pYELLOW;
                    signal_next_light[pYELLOW_LIGHT] = 1'b1;
                    signal_next_init[pYELLOW_LIGHT] = 1'b1;
                end
            end

            pRED: begin
                if (last_cnt) begin
                    light_next_state = pGREEN;
                    signal_next_light[pGREEN_LIGHT] = 1'b1;
                    signal_next_init[pGREEN_LIGHT] = 1'b1;
                end else begin
                    light_next_state = pRED;
                    signal_next_light[pRED_LIGHT] = 1'b1;
                    signal_next_init[pRED_LIGHT] = 1'b1;
                end
            end
        endcase
    end

endmodule
