module second_counter #(
    parameter pMAX_VALUE = 99
)(
    input clk,
    input en,
    input rst_n,
    output wire last,
    output wire pre_last,
    output wire [6:0] second
);

    reg [6:0] temp_second;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            temp_second <= pMAX_VALUE;
        end 
        else if(en) begin
            if (temp_second == 7'd0) begin
                temp_second <= pMAX_VALUE;
            end else begin
                temp_second <= temp_second - 1;
            end
        end else begin
            temp_second <= pMAX_VALUE;
        end
    end

    assign last = (temp_second == 0) ? 1'b1 : 1'b0;
    assign pre_last = (temp_second == 1) ? 1'b1 : 1'b0;
    assign second = temp_second;

endmodule
