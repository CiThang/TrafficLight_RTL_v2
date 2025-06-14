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
    #10 rst_n = 0;
    #10 rst_n = 1;

    // Enable FSM
    en = 1;

    // === GREEN phase (IDLE -> GREEN)
    #20;
    toggle_last_cnt(); // trigger to YELLOW

    // === YELLOW phase
    #30;
    toggle_last_cnt(); // trigger to RED

    // === RED phase
    #30;
    toggle_last_cnt(); // trigger to GREEN again

    // === GREEN again
    #30;
    toggle_last_cnt();

    // Wait and finish
    #100;
    $finish;
  end

  // Monitor signal changes
  initial begin
    $display("Time\tclk\trst_n\ten\tlight\tinit");
    $monitor("%4t\t%b\t%b\t%b\t%b\t%b",
             $time, clk, rst_n, en, light, light_cnt_init);
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
      3'b001: $display("🟢 GREEN Light ON");
      3'b010: $display("🟡 YELLOW Light ON");
      3'b100: $display("🔴 RED Light ON");
      default: $display("--- No Light Active ---");
    endcase
  end

endmodule
