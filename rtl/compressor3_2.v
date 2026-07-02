`timescale 1ns / 1ps

module compressor3_2 #
(
    parameter WIDTH = 16
)
(
    input  wire [WIDTH-1:0] A,
    input  wire [WIDTH-1:0] B,
    input  wire [WIDTH-1:0] C,
    output wire [WIDTH-1:0] RESULT
);
    assign RESULT = A - B - C;
endmodule
