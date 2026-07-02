`timescale 1ns / 1ps

module plic_top
(
    input  wire               clk,
    input  wire               rst,
    input  wire [7:0]         x_in,
    input  wire signed [15:0] d_in,
    output wire signed [31:0] y_out,
    output wire signed [33:0] e_out
);
  
    // Harmonic Generator Outputs (Signed Wires)
    wire signed [7:0]  xf60;
    wire signed [16:0] xf120;
    wire signed [25:0] xf180;
    wire signed [35:0] xf240;

    harmonic_generator HG
    (
        .x(x_in),
        .xf60 (xf60),
        .xf120(xf120),
        .xf180(xf180),
        .xf240(xf240)
    );

    // Uniform Scaling of Harmonics to 16-bit Signed Format
    wire signed [15:0] xf60_s  = {{8{xf60[7]}}, xf60};
    wire signed [15:0] xf120_s = xf120 >>> 8;
    wire signed [15:0] xf180_s = xf180 >>> 16;
    wire signed [15:0] xf240_s = xf240 >>> 24;

    // Multi-Channel Filter Output Wires
    wire signed [31:0] y60;
    wire signed [31:0] y120;
    wire signed [31:0] y180;
    wire signed [31:0] y240;

    // System Error Signal and Bounded Saturation Grid
    wire signed [33:0] error_signal;
    wire signed [15:0] error_sat;
    
    assign error_sat = (error_signal > 34'sd32767)  ? 16'sd32767  :
                       (error_signal < -34'sd32768) ? -16'sd32768 :
                                                      error_signal[15:0];
    
    // LMS Sub-Filter Instantiations (All channels saturated)
    lms_filter LMS60
    (
        .clk(clk),
        .rst(rst),
        .x_ref(xf60_s),
        .error_in(error_sat),
        .y_out(y60)
    );

    lms_filter LMS120
    (
        .clk(clk),
        .rst(rst),
        .x_ref(xf120_s),
        .error_in(error_sat),
        .y_out(y120)
    );

    lms_filter LMS180
    (
        .clk(clk),
        .rst(rst),
        .x_ref(xf180_s),
        .error_in(error_sat),
        .y_out(y180)
    );

    lms_filter LMS240
    (
        .clk(clk),
        .rst(rst),
        .x_ref(xf240_s),
        .error_in(error_sat),
        .y_out(y240)
    );

    // Output Recombinations
    assign y_out = y60 + y120 + y180 + y240;
    assign error_signal = d_in - y_out;
    assign e_out = error_signal;

endmodule
