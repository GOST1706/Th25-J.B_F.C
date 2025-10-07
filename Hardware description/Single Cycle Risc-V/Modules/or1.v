`timescale 1ns / 1ps

module or1 (
    input  wire [31:0] a,
    output wire y
);
    assign y = |a;   // operador de reducción OR
endmodule

