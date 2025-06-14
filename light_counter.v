// Thực hiện chuyển đè n và xuất ra trạng thái "last" khi đếm đến 0
//    
module light_counter #(
    parameter pTIME_GREEN_LIGHT  = 15,
    parameter pTIME_YELLOW_LIGHT = 3,
    parameter pTIME_RED_LIGHT    = 18,
    parameter pCNT_WIDTH         = 5,
    parameter pINIT_WIDTH        = 3
)(
    input wire clk,
    input wire en,
    input wire rst_n,
    input wire [pINIT_WIDTH-1:0] init,
    output wire last,
    output reg [pCNT_WIDTH-1:0] cnt_out
);

// Định nghĩa các trạng thái đèn giao thông
    parameter pGREEN_LIGHT  = 0;
    parameter pYELLOW_LIGHT = 1;
    parameter pRED_LIGHT    = 2;

    initial begin
        cnt_out = pTIME_YELLOW_LIGHT;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_out <= pTIME_YELLOW_LIGHT;
        end else if (init[pGREEN_LIGHT]) begin
            cnt_out <= pTIME_GREEN_LIGHT;
        end else if (init[pYELLOW_LIGHT]) begin  
            cnt_out <= pTIME_YELLOW_LIGHT;
        end else if (init[pRED_LIGHT]) begin
            cnt_out <= pTIME_RED_LIGHT;
        end 
        else if (en) 
            begin
                if(cnt_out != 0) begin
                    cnt_out <= cnt_out - 1;
                end 
            end  
    end

    assign last = (cnt_out == 0) ? 1'b1 : 1'b0;
   

endmodule
