`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.09.2023 23:17:43
// Design Name: 
// Module Name: rotatebychatgpt_tb
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


module rotatebychatgpt_tb;

   // Signals
   reg [31:0] data_in = 32'h00000001; // Initial data value
   reg [4:0] shift_amount = 0; // Initial shift amount
   reg direction = 0; // 0 for right rotate, 1 for left rotate
   wire [31:0] data_out;
   reg [3:0] i;

   // Instantiate the module under test
   rotatebychatgpt uut (
      .data_in(data_in),
      .shift_amount(shift_amount),
      .direction(direction),
      .data_out(data_out)
   );

   // Test procedure
   initial begin
      // Test right rotations
      for (i = 0; i < 10; i = i + 1) begin
         direction = 0; // Right rotate
         shift_amount = $random;
         #20; // Wait for some time to stabilize
         $display("Right shift of %d: Expected = %h, Result = %h", shift_amount, (data_in >> shift_amount) | (data_in << (32 - shift_amount)), data_out);
      end

      // Reset shift_amount for the left shift tests
      shift_amount = 0;

      // Test left rotations
      for (i = 0; i < 10; i = i + 1) begin
         direction = 1; // Left rotate
         shift_amount = $random;
         #20; // Wait for some time to stabilize
         $display("Left shift of %d: Expected = %h, Result = %h", shift_amount, (data_in << shift_amount) | (data_in >> (32 - shift_amount)), data_out);
      end

      $finish;
   end

endmodule

