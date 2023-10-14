`timescale 1ns / 1ps

module counterAsim(
   input clk,
   input reset,
   input cnt_en,
   output reg [5:0] cnt
);
   always @ (posedge clk or negedge reset) begin
      if(!reset)
       cnt <= 6'b000001;
      else if (cnt_en) begin
         if(cnt < 63)
            cnt <= cnt +1;  
         else
            cnt <= 6'b000001;
      end
   end
endmodule