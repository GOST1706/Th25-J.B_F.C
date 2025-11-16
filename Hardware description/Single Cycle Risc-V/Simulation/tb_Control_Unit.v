`timescale 1ns / 1ps
module tb_Control_Unit;

    // Entradas
    reg  [6:0] op;
    reg  [2:0] funct3;
    reg        funct7;
    reg        Zero;

    // Salidas
    wire       RegWrite;
    wire [1:0] ImmSrc;
    wire       ALUSrc;
    wire       MemWrite;
    wire [1:0] ResultSrc;
    wire       PCSrc;
    wire [2:0] ALUControl;

    // Instancia del modulo bajo prueba (UUT)
    Control_Unit uut (
        .op(op),
        .funct3(funct3),
        .funct7(funct7),
        .Zero(Zero),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .PCSrc(PCSrc),
        .ALUControl(ALUControl)
    );

    // ==============================================
    // Simulacion principal
    // ==============================================
    initial begin
        $display("==================================================================================================================");
        $display("                                  TESTBENCH: CONTROL UNIT RISC-V (Post-Synth Ready)");
        $display("==================================================================================================================");
        $display(" Instr.    |  op(6:0)  funct3 funct7 | RegW  ImmSrc  ALUSrc  MemW  ResultSrc  ALUControl  PCSrc ");
        $display("------------------------------------------------------------------------------------------------------------------");

        Zero = 0;

        // ---------------- R-TYPE ----------------
        op = 7'b0110011; funct3 = 3'b000; funct7 = 1'b0; #10; // ADD
        $display(" R-type ADD | %b  %b     %b    |   %b    %02b      %b      %b        %02b        %03b        %b",
            op, funct3, funct7, RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, ALUControl, PCSrc);
            
        op = 7'b0110011; funct3 = 3'b000; funct7 = 1'b1; #10; // SUB
        $display(" R-type SUB | %b  %b     %b    |   %b    %02b      %b      %b        %02b        %03b        %b",
            op, funct3, funct7, RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, ALUControl, PCSrc);

        op = 7'b0110011; funct3 = 3'b111; funct7 = 1'b0; #10; // AND
        $display(" R-type AND | %b  %b     %b    |   %b    %02b      %b      %b        %02b        %03b        %b",
            op, funct3, funct7, RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, ALUControl, PCSrc);

        // ---------------- I-TYPE ----------------
        op = 7'b0010011; funct3 = 3'b000; #10; // ADDI
        $display(" I-type ADDI| %b  %b     %b    |   %b    %02b      %b      %b        %02b        %03b        %b",
            op, funct3, funct7, RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, ALUControl, PCSrc);

        op = 7'b0010011; funct3 = 3'b101; funct7 = 1'b1; #10; // SRAI
        $display(" I-type SRAI| %b  %b     %b    |   %b    %02b      %b      %b        %02b        %03b        %b",
            op, funct3, funct7, RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, ALUControl, PCSrc);

        op = 7'b0000011; funct3 = 3'b010; #10; // LW
        $display(" I-type LW  | %b  %b     %b    |   %b    %02b      %b      %b        %02b        %03b        %b",
            op, funct3, funct7, RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, ALUControl, PCSrc);

        // ---------------- S-TYPE ----------------
        op = 7'b0100011; funct3 = 3'b010; #10; // SW
        $display(" S-type SW  | %b  %b     %b    |   %b    %02b      %b      %b        %02b        %03b        %b",
            op, funct3, funct7, RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, ALUControl, PCSrc);

        // ---------------- B-TYPE ----------------
        op = 7'b1100011; funct3 = 3'b000; Zero = 0; #10; // BEQ (no salta)
        $display(" B-type BEQ | %b  %b     %b    |   %b    %02b      %b      %b        %02b        %03b        %b (Zero=0)",
            op, funct3, funct7, RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, ALUControl, PCSrc);
        Zero = 1; #10; // BEQ (si salta)
        $display(" B-type BEQ | %b  %b     %b    |   %b    %02b      %b      %b        %02b        %03b        %b (Zero=1)",
            op, funct3, funct7, RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, ALUControl, PCSrc);

        op = 7'b1100011; funct3 = 3'b101; Zero = 1; #10; // BGE
        $display(" B-type BGE | %b  %b     %b    |   %b    %02b      %b      %b        %02b        %03b        %b",
            op, funct3, funct7, RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, ALUControl, PCSrc);

        // ---------------- J-TYPE ----------------
        op = 7'b1101111; funct3 = 3'b000; #10; // JAL
        $display(" J-type JAL | %b  %b     %b    |   %b    %02b      %b      %b        %02b        %03b        %b",
            op, funct3, funct7, RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, ALUControl, PCSrc);

        // ---------------- U-TYPE ----------------
        op = 7'b0110111; funct3 = 3'b000; #10; // LUI
        $display(" U-type LUI | %b  %b     %b    |   %b    %02b      %b      %b        %02b        %03b        %b",
            op, funct3, funct7, RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, ALUControl, PCSrc);

        $display("==================================================================================================================");
        $finish;
    end
endmodule
