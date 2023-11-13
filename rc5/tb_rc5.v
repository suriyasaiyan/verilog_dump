`timescale 1ns / 1ps

module rc5_encryption_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [63:0] d_in;

    // Outputs
    wire [63:0] d_out;
    
    // Instantiate the Unit Under Test (UUT)
    rc5_encryption uut (
        .clk(clk),
        .rst(rst),
        .d_in(d_in),
        .d_out(d_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk =0;
        rst = 1;
        #20;
        rst = 0;
        d_in = 64'h1111111111111111 ;
        #160;
        if (d_out !== 64'h186778e155e06292) $display("Test failed for input %h", d_in);

        #225;
        $finish;
    end

endmodule
