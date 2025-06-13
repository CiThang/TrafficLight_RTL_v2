module counter (
    input clk,
    input reset,   
    input [5:0] timer_value,
    output reg [5:0] counter_value

);
    reg [5:0] prev_timer_value;
    always @(negedge clk or posedge reset) begin
        if (reset) begin
            counter_value <= timer_value;
            prev_timer_value <= timer_value;
        end else if(timer_value != prev_timer_value) begin
                counter_value <= timer_value;
                prev_timer_value <= timer_value;
            end else if(counter_value > 0) begin
                counter_value <= counter_value - 1;
            end else begin
                counter_value <= 0; // Đảm bảo không âm
            end
        end

endmodule