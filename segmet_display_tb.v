`timescale 1ns/1ps
`include "segment_display.v"

module segment_display_tb;

    reg [5:0] count_value;
    wire [6:0] seg_a;
    wire [6:0] seg_b;

    segment_display uut (
        .count_value(count_value),
        .seg_a(seg_a),
        .seg_b(seg_b)
    );

    initial begin
        $dumpfile("segment_display_tb.vcd");
        $dumpvars(0, segment_display_tb);
        // Test case 1: count_value = 0
        count_value = 6'd0;
        #10;
        
        // Test case 2: count_value = 5
        count_value = 6'd18;
        #10;

        // Test case 3: count_value = 10
        count_value = 6'd15;
        #10;

        // Test case 4: count_value = 15
        count_value = 6'd3;
        #10;

        // Test case 5: count_value = 20
        count_value = 6'd20;
        #10;

        // Test case 6: count_value = 35
        count_value = 6'd35;
        #10;

        // Test case 7: count_value = 50
        count_value = 6'd50;
        #10;

        // Test case 8: count_value = 63 (maximum for a 6-bit value)
        count_value = 6'd63;
        #10;

        $finish; // End simulation
    end

endmodule