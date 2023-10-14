`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.09.2023 22:25:21
// Design Name: 
// Module Name: rotatebybard
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

module rotatebybard (
    input clk,
    input reset,
    input [31:0] data,
    input [4:0] shift,
    output [31:0] left_rotate,
    output [31:0] right_rotate
);

    // Left rotate
    assign left_rotate = (data << shift) | (data >> (32 - shift));

    // Right rotate
    assign right_rotate = (data >> shift) | (data << (32 - shift));

endmodule