module clock_divider(
    input wire clk,
    input wire rst_n,
    output reg clk_1Hz
);
    reg [23:0] counter;
    always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            counter <= 24'b0;
            clk_1Hz <= 1'b0;     
        end else begin
            if(counter == 24'd4_999_999) begin
                counter <= 24'b0;
                clk_1Hz <= ~clk_1Hz; // Toggle the clock signal
            end else begin
                counter <= counter + 1'b1; // Increment the counter
            end
        end
    end
endmodule