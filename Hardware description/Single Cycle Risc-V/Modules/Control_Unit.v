`timescale 1ns / 1ps
(* keep_hierarchy = "yes" *)
module Control_Unit(
    input  [6:0] op,         // Opcode
    input  [2:0] funct3,     // Campo funct3
    input        funct7,     // Bit 30 (funct7[5])
    input        Zero,       // Bandera de cero de la ALU
    
    output       RegWrite,
    output [1:0] ImmSrc,
    output       ALUSrc,
    output       MemWrite,
    output [1:0] ResultSrc,
    output       PCSrc,      
    output [2:0] ALUControl  // Signal de control hacia la ALU
);

    // Signal interna entre los decoders
    wire [1:0] ALUOp;
    wire Branch,Jump,PCt;
    // =============================
    // Instancia del MAIN DECODER
    // =============================
    Main_decoder main_dec (
        .op(op),
        .funct3(funct3),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .ALUOp(ALUOp),
        .Branch(Branch),
        .Jump(Jump)
    );

    // =============================
    // Instancia del ALU DECODER
    // =============================
    ALU_decoder alu_dec (
        .funct3(funct3),
        .funct7(funct7),
        .ALUOp(ALUOp),
        .ALUControl(ALUControl)
    );
    // =============================
    // Logica de PCSrc
    // =============================
    assign PCt   = Branch & Zero;
    assign PCSrc = Jump | PCt;
endmodule

