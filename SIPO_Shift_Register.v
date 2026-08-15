// ============================================================
// DESIGN : SIPO Shift Register
// ============================================================

module sipo_shift_register #(
    parameter WIDTH = 8
)(
    input                   clk,
    input                   rst,
    input                   serial_in,
    output reg [WIDTH-1:0]  parallel_out
);

always @(posedge clk or posedge rst) begin
    if (rst)
        parallel_out <= {WIDTH{1'b0}};
    else
        parallel_out <= {parallel_out[WIDTH-2:0], serial_in};
end

endmodule

// ============================================================
// TESTBENCH : SIPO Shift Register
// ============================================================

module sipo_shift_register_tb;

reg       clk;
reg       rst;
reg       serial_in;
wire [7:0] parallel_out;

// DUT instantiation
sipo_shift_register #(
    .WIDTH(8)
) dut (
    .clk         (clk),
    .rst         (rst),
    .serial_in   (serial_in),
    .parallel_out(parallel_out)
);

// Clock generation
always #5 clk = ~clk;

// Monitor
initial begin
    $monitor("Time = %0t | Reset = %b | Serial In = %b | Parallel Out = %b",
             $time, rst, serial_in, parallel_out);
end

// Test sequence
initial begin
    clk       = 0;
    rst       = 1;
    serial_in = 0;

    #10;
    rst = 0;

    // Serial data: 1 0 1 1 0 0 1 1
    #10 serial_in = 1;
    #10 serial_in = 0;
    #10 serial_in = 1;
    #10 serial_in = 1;
    #10 serial_in = 0;
    #10 serial_in = 0;
    #10 serial_in = 1;
    #10 serial_in = 1;

    #10 $finish;
end

endmodule
