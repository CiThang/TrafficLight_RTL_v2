`timescale 1ns/1ps
`include "light_counter.v"
module light_counter_tb;

  // Parameters
  parameter pTIME_GREEN_LIGHT  = 15;
  parameter pTIME_YELLOW_LIGHT = 3;
  parameter pTIME_RED_LIGHT    = 18;
  parameter pCNT_WIDTH = 5;
  parameter pINIT_WIDTH = 3;

  // Signals
  reg clk;
  reg en;
  reg rst_n;
  reg [pINIT_WIDTH-1:0] init;
  wire last;
  wire [pCNT_WIDTH-1:0] cnt_out;

  // Instantiate the DUT
  light_counter #(
    .pTIME_GREEN_LIGHT(pTIME_GREEN_LIGHT),
    .pTIME_YELLOW_LIGHT(pTIME_YELLOW_LIGHT),
    .pTIME_RED_LIGHT(pTIME_RED_LIGHT),
    .pCNT_WIDTH(pCNT_WIDTH),
    .pINIT_WIDTH(pINIT_WIDTH)
  ) dut (
    .clk(clk),
    .en(en),
    .rst_n(rst_n),
    .init(init),
    .last(last),
    .cnt_out(cnt_out)
  );

  // Clock generation
  always #2 clk = ~clk;

  // Initial block
  initial begin
    $dumpfile("light_counter_tb.vcd");
    $dumpvars(0, light_counter_tb);
    Start_Simulation;
    RESET;
    TEST_CASE;
  end

  // === Tasks ===
  task Start_Simulation; begin
    $display("-----------------------------------------------------");
    $display("------------ LIGHT COUNTER SIMULATION ---------------");
    $display("-----------------------------------------------------");
  end endtask

  task RESET; begin
    clk = 0;
    rst_n = 0;
    en = 0;
    init = 3'b000;
    #5;
    rst_n = 1;
  end endtask

  task TEST_CASE; begin
    $monitor("Time=%4t | clk=%b | rst_n=%b | en=%b | init=%3b | last=%b | cnt_out=%2d", 
              $time, clk, rst_n, en, init, last, cnt_out);

    // RED Light phase
    en = 1;
    init = 3'b100; // RED
    #5  init = 3'b000; // clear init
    wait(last); #4;

    // YELLOW Light phase
    init = 3'b010;
    #5  init = 3'b000;
    wait(last); #4;

    // GREEN Light phase
    init = 3'b001;
    #5  init = 3'b000;
    wait(last); #4;

    // Repeat again (optional)
    init = 3'b100;
    #5  init = 3'b000;
    wait(last); #4;

    ENDSIMULATION;
  end endtask

  task ENDSIMULATION; begin
    $display("-------------- SIMULATION FINISHED ------------------");
    $finish;
  end endtask

  task display_State; begin
    case (init)
      3'b100: $display("=== RED LIGHT ===");
      3'b010: $display("=== YELLOW LIGHT ===");
      3'b001: $display("=== GREEN LIGHT ===");
      default: $display("--- Counting ---");
    endcase
  end endtask

  // Show current state at every positive edge
  always @(posedge clk) begin
    display_State;
  end

endmodule
