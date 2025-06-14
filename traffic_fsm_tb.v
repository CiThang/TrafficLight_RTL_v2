`timescale 1ns/1ps
`include "traffic_fsm.v"

module traffic_fsm_tb;

  parameter LIGHT_STATE_WIDTH = 3;

  // Testbench signals
  reg clk;
  reg en;
  reg rst_n;
  reg light_cnt_last;
  reg second_cnt_pre_last;

  wire [LIGHT_STATE_WIDTH-1:0] light;
  wire [LIGHT_STATE_WIDTH-1:0] light_cnt_init;

  // Instantiate the Unit Under Test (UUT)
  traffic_fsm #(.LIGHT_STATE_WIDTH(LIGHT_STATE_WIDTH)) uut (
    .clk(clk),
    .en(en),
    .rst_n(rst_n),
    .light_cnt_last(light_cnt_last),
    .second_cnt_pre_last(second_cnt_pre_last),
    .light(light),
    .light_cnt_init(light_cnt_init)
  );

  // Clock generation: 10ns period
  always #5 clk = ~clk;

  // Simulation control
  initial begin
    // VCD for waveform
    $dumpfile("traffic_fsm_tb.vcd");
    $dumpvars(0, traffic_fsm_tb);

    // Initialize
    clk = 0;
    rst_n = 0;
    en = 0;
    light_cnt_last = 0;
    second_cnt_pre_last = 0;

    // Apply reset
    #10 rst_n = 1;

    // Enable FSM one time after reset
    #10 en = 1;

    // Keep FSM running with en=1 forever (no toggling)
    // === GREEN phase (IDLE -> GREEN)
    #30;
    toggle_last_cnt(); // trigger to YELLOW

    // === YELLOW phase
    #40;
    toggle_last_cnt(); // trigger to RED

    // === RED phase
    #50;
    toggle_last_cnt(); // trigger to GREEN again

    // === GREEN again
    #40;
    toggle_last_cnt(); // loop continues...

    // Wait and finish
    #100;
    $finish;
  end

  // Task: toggle both last flags high for one cycle
  task toggle_last_cnt;
    begin
      light_cnt_last = 1;
      second_cnt_pre_last = 1;
      #10;
      light_cnt_last = 0;
      second_cnt_pre_last = 0;
    end
  endtask

  // Optional: Human-readable light display
  always @(posedge clk) begin
    case (light)
      3'b001: $display("%t: 🟢 GREEN Light ON", $time);
      3'b010: $display("%t: 🟡 YELLOW Light ON", $time);
      3'b100: $display("%t: 🔴 RED Light ON", $time);
      default: $display("%t: --- No Light Active ---", $time);
    endcase
  end

endmodule
