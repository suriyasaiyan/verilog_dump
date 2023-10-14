`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.09.2023 22:24:16
// Design Name: 
// Module Name: rotatebychatgpt
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

module rotatebychatgpt(
  input [31:0] data_in,
  input [4:0] shift_amount,
  input direction, // 0 for right rotate, 1 for left rotate
  output [31:0] data_out
);

  wire [31:0] shifted_data;

  // Right Rotate Logic
  assign shifted_data = (direction) ? 
                       (data_in >> shift_amount) | (data_in << (32 - shift_amount)) :
                       (data_in << shift_amount) | (data_in >> (32 - shift_amount));

  assign data_out = shifted_data;

endmodule
