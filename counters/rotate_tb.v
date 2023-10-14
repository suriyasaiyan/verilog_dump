`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.09.2023 20:51:18
// Design Name: 
// Module Name: rotate_tb
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

module rotate_tb;

  // Declare signals to connect to the rotate module
  reg [31:0] inputVar;
  reg [4:0] shiftVar;
  reg leftRotate;
  wire [31:0] outputVar;
  reg [3:0] i;

  // Instantiate the rotate module
  rotate uut (
    .inputVar(inputVar),
    .shiftVar(shiftVar),
    .outputVar(outputVar),
    .leftRotate(leftRotate)
  );

  // Clock generation
  reg clk;
  always begin
    #5 clk = ~clk;
  end

  // Testbench procedure
  initial begin
    // Initialize signals
    clk = 0;
    inputVar = 32'h12345678;

    // Test cases
    for (i = 0; i <= 9; i = i + 1) begin
      // Right rotate
      leftRotate = 0;
      shiftVar = $random;
      #10;
      $display("Right Rotate: inputVar = 0x%h, shiftVar = %d, leftRotate = %b, outputVar = 0x%h", inputVar, shiftVar, leftRotate, outputVar);

      // Left rotate
      leftRotate = 1;
      shiftVar = $random;
      #10;
      $display("Left Rotate: inputVar = 0x%h, shiftVar = %d, leftRotate = %b, outputVar = 0x%h", inputVar, shiftVar, leftRotate, outputVar);
    end

    // Finish simulation
    $finish;
  end

endmodule
