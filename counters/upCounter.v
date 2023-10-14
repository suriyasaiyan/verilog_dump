module counterA (
   input clk,
   input reset,
   input cnt_en,
   output reg [5:0] cnt
);
   reg [31:0] counter;
   reg divClk;

  always @(posedge clk) begin
    counter <= counter + 1'b1;
    if (counter == 99999999) begin
      divClk <= ~divClk;
      counter <= 32'd0;
    end
  end

   always @ (posedge divClk or negedge reset) begin
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