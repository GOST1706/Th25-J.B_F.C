`timescale 1ns / 1ps
(* keep_hierarchy = "yes" *)
module ALU_decoder(
    input [1:0] ALUOp,       // Desde el Main Decoder
    input [2:0] funct3,      // Bits [14:12] de la instruccion
    input funct7,          // Bit [30] de la instruccion (funct7[5])
    output reg [2:0] ALUControl
);

    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = 3'b000; // lw, sw (ADD)
            2'b01: ALUControl = 3'b101; // beq,bne,blt,bge // sub
            2'b10: begin
                case (funct3)
                    3'b000: ALUControl = (funct7) ? 3'b001 : 3'b000; // sub / add
                    3'b001: ALUControl = 3'b110; // sll , slli
                    3'b100: ALUControl = 3'b100;  //xor
                    3'b101: ALUControl = (funct7) ? 3'b111 : 3'b110; //sra,srai  & srl,srli
                    3'b110: ALUControl = 3'b011; // or
                    3'b111: ALUControl = 3'b010; // and
                    default: ALUControl = 3'b000; // default add
                endcase
            end
            default: ALUControl = 3'b000;
        endcase
    end

endmodule

