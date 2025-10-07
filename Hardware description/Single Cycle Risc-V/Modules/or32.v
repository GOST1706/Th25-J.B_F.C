`timescale 1ns / 1ps
module or32 (
    input  wire [31:0] a,
    input  wire [31:0] b,
    output wire [31:0] y
);
    assign y = a | b;
endmodule
