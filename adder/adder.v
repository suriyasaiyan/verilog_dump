module nBitAdder (
  parameter n = 16,
  input [n-1:0] a, b,
  output [n-1:0] sum,
  output cout
);

  assign cout = 0;

  generate
    for (genvar i = 0; i < n; i += 1) begin
      fulladder adder (
        .in1(a[i]),
        .in2(b[i]),
        .cin(cout[i]),
        .sum(sum[i]),
        .cout(cout[i + 1])
      );
    end
  endgenerate
endmodule

module fulladder(
    input in1, in2, cin;
    output sum, cout        
)
    assign sum = (in1 ^ in2) ^ cin;
    assign cout = (in1 & in2) | (in2 & cin) | (cin & in1);

endmodule
