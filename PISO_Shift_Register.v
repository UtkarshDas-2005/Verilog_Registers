// ============================================================
// DESIGN : PISO Shift Register
// ============================================================

module piso_shift_register (
    input        clk,
    input        rst,
    input        load,
    input  [3:0] parallel_in,
    output       serial_out
);

    reg [3:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            shift_reg <= 4'b0000;
        else if (load)
            shift_reg <= parallel_in;
        else
            shift_reg <= {shift_reg[2:0], 1'b0};
    end

    assign serial_out = shift_reg[3];

endmodule

// ============================================================
// TESTBENCH : PISO Shift Register
// ============================================================

module piso_shift_register_tb;

    reg        clk;
    reg        rst;
    reg        load;
    reg  [3:0] parallel_in;
    wire       serial_out;

    piso_shift_register dut (
        .clk        (clk),
        .rst        (rst),
        .load       (load),
        .parallel_in(parallel_in),
        .serial_out (serial_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Monitor
    initial begin
        $monitor("Time=%0t | Reset=%b | Load=%b | Parallel_In=%b | Shift_Reg=%b | Serial_Out=%b",
                 $time, rst, load, parallel_in, dut.shift_reg, serial_out);
    end

    initial begin
        clk = 0;
        rst = 1;
        load = 0;
        parallel_in = 4'b0000;

        // Reset
        #10;
        rst = 0;

        // Load parallel data
        #5;
        load = 1;
        parallel_in = 4'b1011;

        #10;
        load = 0;

        // Shift data out
        #40;

        $finish;
    end

endmodule
