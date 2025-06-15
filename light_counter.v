// Cho đèn sáng theo thứ tự: xanh, vàng, đỏ
// Đếm từ 14->0->2->17->0->14
module light_counter #(
    parameter pGREEN_INIT_VAL = 14,
    parameter pYELLOW_INIT_VAL = 2,
    parameter pRED_INIT_VAL = 17,
    parameter pCNT_WIDTH = 5, // log2(pRED_INIT_VAL+1)
    parameter pINIT_WIDTH = 3
)(
    input wire clk,
    input wire en,
    input wire rst_n,
    input wire [pINIT_WIDTH-1:0] init,
    output wire last,
    output wire [pCNT_WIDTH-1:0] cnt_out
);
    
    
    parameter pGREEN_IDX = 0;
    parameter pYELLOW_IDX = 1;
    parameter pRED_IDX = 2;
    
    
    reg [pCNT_WIDTH-1:0] count;
    
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= pGREEN_INIT_VAL;
        end
        else if (init[pGREEN_IDX]) begin
            count <= pGREEN_INIT_VAL;
        end
        else if (init[pYELLOW_IDX]) begin
            count <= pYELLOW_INIT_VAL;
        end
        else if (init[pRED_IDX]) begin
            count <= pRED_INIT_VAL;
        end
        else if (en) begin
            count <= count - 1;
        end
    end
    
   
    assign last = (count == 0) ? 1'b1 : 1'b0;
    assign cnt_out = count;

endmodule
