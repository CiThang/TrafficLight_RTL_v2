module segment_display (
    input      [5:0] count_value,
    output     [6:0] seg_a,
    output     [6:0] seg_b
);

    wire [3:0] digit_a; // hàng chục
    wire [3:0] digit_b; // hàng đơn vị

    assign digit_a = count_value / 10;
    assign digit_b = count_value % 10;

    display dis_a (
        .value(digit_a),
        .seg(seg_a)
    );

    display dis_b (
        .value(digit_b),
        .seg(seg_b)
    );

endmodule

module display (
    input  [3:0] value,
    output reg [6:0] seg
);

    always @(*) begin
        case (value)
            4'd0: seg = 7'b1111110;
            4'd1: seg = 7'b0110000;
            4'd2: seg = 7'b1101101;
            4'd3: seg = 7'b1111001;
            4'd4: seg = 7'b0110011;
            4'd5: seg = 7'b1011011;
            4'd6: seg = 7'b1011111;
            4'd7: seg = 7'b1110000;
            4'd8: seg = 7'b1111111;
            4'd9: seg = 7'b1111011;
            default: seg = 7'b0000000;
        endcase
    end

endmodule
