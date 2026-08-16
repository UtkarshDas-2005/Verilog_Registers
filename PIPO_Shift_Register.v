// ============================================================
// DESIGN : PIPO Shift Register
// ============================================================

module pipo_shift_register (
    input        clk,
    input        rst,
    input  [3:0] parallel_in,
    output reg [3:0] parallel_out
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            parallel_out <= 4'b0000;
        else
            parallel_out <= parallel_in;
    end

endmodule

// ============================================================
// TESTBENCH : PIPO Shift Register
// ============================================================

module pipo_shift_register_tb;

    reg        clk;
    reg        rst;
    reg  [3:0] parallel_in;
    wire [3:0] parallel_out;

    // DUT instantiation
    pipo_shift_register dut (
        .clk          (clk),
        .rst          (rst),
        .parallel_in  (parallel_in),
        .parallel_out (parallel_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Monitor
    initial begin
        $monitor("Time=%0t | Reset=%b | Parallel In=%b | Parallel Out=%b",
                 $time, rst, parallel_in, parallel_out);
    end

    // Test sequence
    initial begin
        clk = 0;
        rst = 1;
        parallel_in = 4'b0000;

        #10;
        rst = 0;

        #10 parallel_in = 4'b1010;
        #10 parallel_in = 4'b1100;
        #10 parallel_in = 4'b0110;
        #10 parallel_in = 4'b1111;

        #10 $finish;
    end

endmodule
