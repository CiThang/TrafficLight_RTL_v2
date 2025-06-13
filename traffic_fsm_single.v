module traffic_fsm_single(
    input clk,
    input rst_n,
    output reg [1:0] led, // 00: Red, 01: Green, 10: Yellow
    output reg [5:0] timer_value 
);

    reg [1:0] state;
    reg [4:0] counter; // để đếm giây (1Hz)

    // Định nghĩa trạng thái
    localparam S_RED    = 2'b00,
               S_GREEN  = 2'b01,
               S_YELLOW = 2'b10;

    always @(negedge clk or posedge  rst_n) begin
        if (!rst_n) begin
            timer_value <= 6'd18; // Reset timer value
            state <= S_RED;
            counter <= 0;
            led <= 2'b00;
        end else begin
            case (state)
                S_RED: begin
                    led <= 2'b00;
                    timer_value <= 6'd18;
                    if (counter == 17) begin // 18s
                        state <= S_GREEN;
                        counter <= 0;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                S_GREEN: begin
                    led <= 2'b01;
                    timer_value <= 6'd15;
                    if (counter == 14) begin // 15s
                        state <= S_YELLOW;
                        counter <= 0;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                S_YELLOW: begin
                    led <= 2'b10;
                    timer_value <= 6'd3;
                    if (counter == 2) begin // 3s
                        state <= S_RED;
                        counter <= 0;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                default: begin
                    state <= S_RED;
                    counter <= 0;
                    led <= 2'b00;
                end
            endcase
        end
    end
endmodule
