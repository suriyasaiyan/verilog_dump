`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.09.2023 15:27:06
// Design Name: 
// Module Name: rotate
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


module rotate(
    input [31:0] inputVar,
    input [4:0] shiftVar,
    output [31:0] outputVar,
    input  leftRotate
    );
assign outputVar = (leftRotate) ? ((inputVar << shiftVar) | (inputVar >> (32 - shiftVar))) : 
((inputVar >> shiftVar) | (inputVar << (32 - shiftVar)));

endmodule
