`timescale 1ns / 1ps

module radix4_square_16
(
    input  wire signed [15:0] x,
    output wire signed [31:0] x2
);
    wire [15:0] x_abs = (x < 0) ? -x : x;
    wire [7:0]  low   = x_abs[7:0];
    wire [7:0]  high  = x_abs[15:8];

    wire [15:0] low_sq  = low  * low;
    wire [15:0] high_sq = high * high;
    wire [16:0] cross   = low  * high;

    assign x2 = low_sq + (cross << 9) + (high_sq << 16);
endmodule
