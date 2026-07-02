`timescale 1ns / 1ps

module radix4_square_8
(
    input  wire signed [7:0] x,
    output wire signed [15:0] x2
);
    wire [7:0] x_abs = (x < 0) ? -x : x;
    wire [3:0] low  = x_abs[3:0];
    wire [3:0] high = x_abs[7:4];

    wire [7:0] low_sq  = low  * low;
    wire [7:0] high_sq = high * high;
    wire [8:0] cross   = low  * high;

    assign x2 = low_sq + (cross << 5) + (high_sq << 8);
endmodule
