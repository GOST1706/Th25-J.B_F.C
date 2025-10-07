`timescale 1ns / 1ps
module mux8_1_32 (
    input  wire [31:0] in0, // add
    input  wire [31:0] in1, // sub
    input  wire [31:0] in2, // and
    input  wire [31:0] in3, // or
    input  wire [31:0] in4, // xor
    input  wire [31:0] in5, // shift (SLL/SRL/SRA)
    input  wire [31:0] in6, // comparador zero extend
    input  wire [31:0] in7, // reservado / futuro
    input  wire [2:0]  sel,
    output reg  [31:0] y
);
    always @(*) begin
        case (sel)
            3'b000: y = in0; // add
            3'b001: y = in1; // sub
            3'b010: y = in2; // and
            3'b011: y = in3; // or
            3'b100: y = in4; // xor
            3'b101: y = in5; // shift
            3'b110: y = in6; // zero extend comparator
            default: y = 32'b0;
        endcase
    end
endmodule

