`timescale 1ns / 1ps
module alu_top (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [4:0]  shamt,
    input  wire [2:0]  funct3,
    input  wire [6:0]  funct7,
    input  wire [2:0]  ALUControl,
    output wire [31:0] Result
);
    wire [31:0] add_res, sub_res, and_res, or_res, xor_res, shift_res, comp_res;

    // ADD / SUB
    assign add_res = A + B;
    assign sub_res = A - B;

    // LÓGICAS

    // SHIFT
    shifter_top shft (
        .in(B),
        .shamt(shamt),
        .funct3(funct3),
        .funct7(funct7),
        .out(shift_res)
    );
    or32 or_inst(
    .a(A),
    .b(B),
    .y(or_res)
    );
    xor32 xor_inst(
    .a(A),
    .b(B),
    .y(xor_res)
    );
    and32 and_inst(
    .a(A),
    .b(B),
    .y(and_res)
    );    
    // ZERO EXTEND COMP
    zero_extend_comp zext_cmp (
        .A(A),
        .B(B),
        .funct3(funct3),
        .funct7(funct7),
        .result(comp_res)
    );

    // MUX FINAL
    mux8_1_32 mux_final (
        .in0(add_res),
        .in1(sub_res),
        .in2(and_res),
        .in3(or_res),
        .in4(xor_res),
        .in5(shift_res),
        .in6(comp_res),
        .in7(32'b0),
        .sel(ALUControl),
        .y(Result)
    );

endmodule

