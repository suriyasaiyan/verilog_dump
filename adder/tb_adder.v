module nBitAdder_tb;

    parameter n = 16;
    reg [n-1:0] a, b;
    wire [n-1:0] sum;
    wire cout;
    integer i;

    nBitAdder adder(
        .a(a),
        .b(b),
        .sum(sum),
        .cout(cout)
    );

    initial begin
        for (i = 0; i < 100, i = i + 1) begin
            a = $random;
            b = $random;
            #10
            if (sum != (a + b)) begin
        $display("Error: sum is incorrect. Expected %d, got %d.", a + b, sum);
        $finish;
      end

      if (cout != (a[n-1] & b[n-1]) | (b[n-1] & cin) | (cin & a[n-1])) begin
        $display("Error: cout is incorrect. Expected %d, got %d.", (a[n-1] & b[n-1]) | (b[n-1] & cin) | (cin & a[n-1]), cout);
        $finish;
      end
    end

    $display("All tests passed successfully.");
    $finish;
  end

endmodule