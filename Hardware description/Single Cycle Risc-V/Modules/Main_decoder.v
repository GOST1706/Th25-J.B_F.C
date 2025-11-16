`timescale 1ns / 1ps
(* keep_hierarchy = "yes" *)
module Main_decoder(
    input  [6:0] op,
    input [2:0] funct3,            
    
    output reg RegWrite,
    output reg [1:0] ImmSrc,
    output reg ALUSrc,
    output reg MemWrite,
    output reg Branch,Jump,
    output reg [1:0] ResultSrc,
    output reg [1:0] ALUOp
);

    always @(*) begin
        // Valores por defecto
        RegWrite  = 0;
        ImmSrc    = 2'b00;
        ALUSrc    = 0;
        MemWrite  = 0;
        ResultSrc = 2'b00;
        Branch    = 0;
        ALUOp     = 2'b00;
        Jump = 0;

        case (op)
            
            7'b0110011: begin // Tipo R (add, sub, and, or, etc.)
                RegWrite  = 1;
                ALUSrc    = 0;
                MemWrite  = 0;
                ResultSrc = 2'b00;
                Branch    = 0;                
                ALUOp     = 2'b10;
            end

            7'b0010011: begin // Tipo I (addi, xori, andi, ori, etc.)
                RegWrite  = 1;
                ImmSrc    = 2'b00;
                ALUSrc    = 1;
                MemWrite  = 0;
                ResultSrc = 2'b00;
                Branch    = 0;                
                ALUOp = (funct3 == 3'b000) ? 2'b00 : 2'b10;
            end

            7'b0000011: begin // LW
                RegWrite  = 1;
                ImmSrc    = 2'b00;
                ALUSrc    = 1;
                MemWrite  = 0;
                ResultSrc = 2'b01;
                Branch    = 0;                
                ALUOp     = 2'b00;
            end

            7'b0100011: begin // SW   Tipo S
                RegWrite  = 0;
                ImmSrc    = 2'b01;
                ALUSrc    = 1;
                MemWrite  = 1;
                Branch    = 0;                
                ALUOp     = 2'b00;
            end

            7'b1100011: begin // BEQ, BNE, BLT, BGE
                RegWrite  = 0;
                ALUSrc    = 0;
                Branch    = 1;
                MemWrite  = 0;
                ImmSrc    = 2'b10;
                ALUOp     = 2'b01;
            end
       
            7'b1101111: begin // JAL
                RegWrite  = 1;
                ImmSrc    = 2'b11;
                ALUSrc    = 1;
                MemWrite  = 0;
                ResultSrc = 2'b10;                
                ALUOp     = 2'b00;
                Jump      = 1;
            end

            7'b1100111: begin // JALR
                RegWrite  = 1;
                ImmSrc    = 2'b00;
                ALUSrc    = 1;                
                MemWrite  = 0;
                ResultSrc = 2'b10;               
                ALUOp     = 2'b00;
                Jump      = 1;
            end

            7'b0110111: begin // LUI
                RegWrite  = 1;
                ImmSrc    = 2'b01;
                MemWrite  = 0; 
                ResultSrc = 2'b11;
                Branch    = 0;                               
                ALUOp     = 2'b00;
            end
        endcase
     end

endmodule

