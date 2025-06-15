// đếm từ 99->0->99
module second_counter #(
    parameter pMAX_VAL = 99
)(
    input wire clk,
    input wire en,
    input wire rst_n,
    output wire last,
    output wire pre_last,
    output wire [6:0] count 
);
    
   
    reg [6:0] pre_count;
    
    // Counter process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pre_count <= pMAX_VAL;
        end
        else if (en) begin
            // if (|pre_count) begin
            //     pre_count <= pre_count - 1;
            // end
            if (pre_count > 0) begin
                pre_count <= pre_count - 1;
            end
            else begin
                pre_count <= pMAX_VAL;
            end
        end
        else begin
            pre_count <= pMAX_VAL;
        end
    end
    
    // Output assignments
    assign last = (pre_count == 0) ? 1'b1 : 1'b0;
    assign pre_last = (pre_count == 1) ? 1'b1 : 1'b0;
    assign count = pre_count;

endmodule