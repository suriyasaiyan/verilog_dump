`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.10.2023 10:27:07
// Design Name: 
// Module Name: counterA_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module counterA_tb;

  // Inputs
  reg clk;
  reg rst;
  reg cnt_en;

  // Outputs
  wire [5:0] cnt;

  // Instantiate the CounterA module
  counterA uut (
    .clk(clk),
    .reset(reset),
    .cnt_en(cnt_en),
    .cnt(cnt)
  );

  // Clock generation (50% duty cycle)
  always begin
    clk = 0;
    #5;  // Half the clock period
    clk = 1;
    #5;  // Half the clock period
  end

  // Initialize signals
  initial begin
    clk = 0;
    reset = 0;
    cnt_en = 0;
    #10;  // Wait for a few clock cycles

    // Enable the counter and deassert reset
    reset = 1;
    cnt_en = 1;
    #50;  // Run for a while

    // Stop the counter and assert reset
    cnt_en = 0;
    reset = 0;
    #10;  // Wait for a few clock cycles

    // Enable the counter again
    cnt_en = 1;
    #50;  // Run for a while

    // Finish the simulation
    $finish;
  end

endmodule

