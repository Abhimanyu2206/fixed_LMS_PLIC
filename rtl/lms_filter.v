`timescale 1ns / 1ps

module lms_filter
(
    input  wire               clk,
    input  wire               rst,
    input  wire signed [15:0] x_ref,
    input  wire signed [15:0] error_in,
    output reg  signed [31:0] y_out
);

    reg signed [15:0] Rx;
    reg signed [31:0] Ry;
    reg signed [15:0] R0;
    reg signed [15:0] R1;
    reg signed [15:0] Rn;
    reg signed [15:0] Re;
    reg signed [31:0] mult_reg;

    localparam signed [15:0] MU = 16'd1; // Base filter adaptation step
    reg [1:0] state;

    // Arithmetic datapath matching the paper's 4-cycle schedule
    wire signed [31:0] mult_a   = (Rx * R1) >>> 9;
    wire signed [31:0] mult_b   = 16'sd1 * R0;
    wire signed [31:0] temp_sum = mult_a + mult_b;
    
    function signed [15:0] sat16(input signed [31:0] val);
        begin
            if (val >  32'sd32767) sat16 =  16'sd32767;
            else if (val < -32'sd32768) sat16 = -16'sd32768;
            else sat16 = val[15:0];
        end
    endfunction

    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            state <= 2'd0;
            Rx    <= 16'sd0;
            Ry    <= 32'sd0;
            R0    <= 16'sd0;
            R1    <= 16'sd0;
            Rn    <= 16'sd0;
            Re    <= 16'sd0;
            y_out <= 32'sd0;
        end
        else
        begin
            case(state)
            // CC1: Compute and latch output
            2'd0:
            begin
                Rx    <= x_ref;
                Ry    <= temp_sum;
                y_out <= temp_sum;
                Re    <= error_in;
                state <= 2'd1;
            end
            // CC2: Update gradient parameter
            2'd1: begin
                Rn    <= Re >>> 8;
                state <= 2'd2;
            end
            // CC3: Update weight coefficient w(0)
            2'd2: begin
                R0       <= R0 - (R0 >>> 8) + Rn;
                mult_reg <= (Rx * Rn) >>> 7;
                state    <= 2'd3;
            end 
            // CC4: Update weight coefficient w(1)
            2'd3: begin
                R1    <= sat16(R1 + mult_reg);
                state <= 2'd0;
            end
            endcase
        end
    end
endmodule
