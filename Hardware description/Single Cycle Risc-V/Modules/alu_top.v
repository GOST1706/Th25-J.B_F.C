`timescale 1ns / 1ps
(* keep_hierarchy = "yes" *)
module alu_top (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [2:0]  funct3,
    input  wire  funct7_5,
    input  wire [2:0]  ALUControl,
    output wire [31:0] Result,
    output wire Zero
);
    wire [31:0] add_res, sub_res, and_res, or_res, xor_res, shift_res, comp_res, Bmux, sum1;

   assign Zero = ~(|Result);


    assign sum1 = ~B + 32'b1;

    mux2_1 mxinst(
        .a(B),
        .b(sum1),
        .sel(ALUControl[0]),
        .y(Bmux)
    );
   // ADD / SUB
    assign add_res = A + Bmux;
    assign sub_res = add_res; 

    // L�GICAS
    
    // SHIFT
    shifter_top shft (
        .A(A),
        .shamt(B[4:0]),
        .funct3_2(funct3[2]),
        .funct7(funct7_5),
        .outshift(shift_res)
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
        .diff(add_res),
        .funct3(funct3[2:0]),
        .result(comp_res)
    );

    // MUX FINAL
    mux8_1_32 mux_final (
        .in0(add_res),
        .in1(sub_res),
        .in2(and_res),
        .in3(or_res),
        .in4(xor_res),
        .in5(comp_res),
        .in6(shift_res),
        .in7(shift_res) ,
        .sel(ALUControl),
        .y(Result)
    );

endmodule