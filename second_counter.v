
module second_counter #(
    parameter pSECOND_CNT_VALUE = 99,
    parameter pMAX_VAL = pSECOND_CNT_VALUE
)(
    input wire clk,
    input wire en,
    input wire rst_n,
    output wire last,
    output wire pre_last,
    output reg [6:0] count
);

    reg [6:0] temp_count;

    initial begin
        temp_count = pMAX_VAL;
        count = pMAX_VAL;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            temp_count <= pMAX_VAL;
            count <= pMAX_VAL;
        end 
        else if (en) begin
            if (temp_count > 0) begin
                temp_count <= temp_count - 1;
                count <= temp_count - 1;
            end else begin
                temp_count <= pMAX_VAL;
                count <= pMAX_VAL;
            end
        end
    end


    assign last = (temp_count == 0) ? 1'b1 : 1'b0;
    assign pre_last = (temp_count == 1) ? 1'b1 : 1'b0;

endmodule


