`timescale 1ns / 1ps
module zero_extend_comp (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [2:0]  funct3,
    input  wire [6:0]  funct7,
    output wire [31:0] result
);

    wire [31:0] diff;
    wire zero_flag;     // 1 si A == B
    wire sign_A, sign_B;
    wire less, greater, not_equal, equal, geq, leq;

    assign diff = A - B;
    assign sign_A = A[31];
    assign sign_B = B[31];

    // OR 32?1 (ya la tienes implementada)
    wire or_out;
    or1 or1_inst ( 
        .a(diff),   
        .y(or_out)  
    );

    assign equal     = ~or_out;
    assign not_equal = or_out;

    assign less      = (sign_A & ~sign_B) | ((~(sign_A ^ sign_B)) & diff[31]);
    assign greater   = (~sign_A & sign_B) | ((~(sign_A ^ sign_B)) & ~diff[31]);
    assign geq       = greater | equal;
    assign leq       = less | equal;

    reg [31:0] comp_result;
    always @(*) begin
        case (funct3)
            3'b000: comp_result = {31'b0, geq};      // >=
            3'b001: comp_result = {31'b0, not_equal}; // !=
            3'b101: comp_result = {31'b0, greater};   // >
            3'b100: comp_result = {31'b0, less};      // <
            default: comp_result = {31'b0, leq};      // <= u otro caso
        endcase
    end

    assign result = comp_result;

endmodule
