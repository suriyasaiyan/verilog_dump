`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.09.2023 22:37:34
// Design Name: 
// Module Name: rotatebybard_tb
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

module rotatebybard_tb;

   // Signals
   reg clk = 0;
   reg reset = 0;
   reg [31:0] data = 32'h00000001; // Initial data value
   reg [4:0] shift = 0; // Initial shift value
   wire [31:0] left_rotate;
   wire [31:0] right_rotate;
   reg [3:0] i;

   // Instantiate the module under test
   rotatebybard uut (
      .clk(clk),
      .reset(reset),
      .data(data),
      .shift(shift),
      .left_rotate(left_rotate),
      .right_rotate(right_rotate)
   );

   // Clock generation
   always begin
      #5 clk = ~clk;
   end

   // Test procedure
   initial begin
      // Apply reset
      reset = 1;
      #10 reset = 0;

      // Test left rotations
      for (i = 0; i < 10; i = i + 1) begin
         // Wait for some time to stabilize
         #20;
         shift = $random;
         // Check the result
         $display("Left shift of %d: Expected = %h, Result = %h", shift, (data << shift) | (data >> (32 - shift)), left_rotate);
      end

      // Reset shift for the right shift tests
      shift = 0;

      // Test right rotations
      for (i = 0; i < 10; i = i + 1) begin
         // Wait for some time to stabilize
         #20;
         shift = $random;
         // Check the result
         $display("Right shift of %d: Expected = %h, Result = %h", shift, (data >> shift) | (data << (32 - shift)), right_rotate);
      end

      $finish;
   end

endmodule
