// ============================================================
SISO Shift Register
// ============================================================

module siso_shift_register (
    input clk,          // Clock signal
    input rst,          // Active-high synchronous reset
    input serial_in,    // Serial input
    output serial_out   // Serial output
);

    reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (rst)
            shift_reg <= 4'b0000;
        else
            shift_reg <= {shift_reg[2:0], serial_in};
    end

    assign serial_out = shift_reg[3];

endmodule

// ============================================================
// TESTBENCH : SISO Shift Register
// ============================================================

module tb_siso;

    reg clk;
    reg rst;
    reg serial_in;
    wire serial_out;

    // DUT instantiation
    siso_shift_register uut (
        .clk        (clk),
        .rst        (rst),
        .serial_in  (serial_in),
        .serial_out (serial_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Waveform generation
    initial begin
        $dumpfile("siso_waveform.vcd");
        $dumpvars(0, tb_siso);
    end

    // Monitor
    initial begin
        $monitor("Time=%0t | Reset=%b | Serial_In=%b | Shift_Reg=%b | Serial_Out=%b",
                 $time, rst, serial_in, uut.shift_reg, serial_out);
    end

    // Test sequence
    initial begin
        clk = 0;
        rst = 1;
        serial_in = 0;

        #10 rst = 0;

        // Apply serial data: 1 0 1 1
        #10 serial_in = 1;
        #10 serial_in = 0;
        #10 serial_in = 1;
        #10 serial_in = 1;

        // Allow remaining bits to shift out
        #40;

        $finish;
    end

endmodule
