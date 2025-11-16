`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module RV32I(
    input clk,
    input WE_mem,
    input [31:0] WD_mem,
    input Reset,
    output reg [31:0] RESULT
    );
    
    reg [9:0] PC;
    wire [31:0] instr;
    
    Instruction_memory ins_mem(
        .clk(clk),
        .WE(WE_mem),
        .A(PC[9:0]),
        .WD(WD_mem),
        .RD(instr)
    );
    
    wire [6:0] op;
    wire [2:0] funct3;
    wire funct7_5;
    wire Zero;
    
    assign op = instr[6:0];
    assign funct3 = instr[14:12];
    assign funct7_5 = instr[30];
    
    wire RegWrite;
    wire [1:0] ImmSrc;
    wire ALUSrc;
    wire MemWrite;
    wire [1:0] ResultSrc;
    wire PCSrc;      
    wire [2:0] ALUControl;
    
    Control_Unit CU(
        .op(op),
        .funct3(funct3),
        .funct7(funct7_5),
        .Zero(Zero),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .PCSrc(PCSrc),
        .ALUControl(ALUControl)
    );
    
    wire [31:0] WD3_reg;
    wire [31:0] RD1_reg, RD2_reg;
    
    regfile RegFile(
        .clk(clk),
        .WE(RegWrite),
        .A1(instr[19:15]),
        .A2(instr[24:20]),
        .A3(instr[11:7]),
        .WD3(WD3_reg),
        .RD1(RD1_reg),
        .RD2(RD2_reg)
    );
    
    wire [31:0] Immextend;
    
    ImmExt immext(
        .instr(instr[31:7]),
        .instr_4(instr[4]),
        .ImmSrc(ImmSrc),
        .imm_ext(Immextend)
    );
    
    wire [31:0] SrcA;
    wire [31:0] SrcB;
    assign SrcA = RD1_reg;
    
    mux2_1 muxSrcALU(
        .a(RD2_reg),
        .b(Immextend),
        .sel(ALUSrc),
        .y(SrcB)
    );
    
    wire [31:0] ALUResult;
    
    alu_top ALU (
        .A(SrcA),
        .B(SrcB),
        .funct3(funct3),
        .funct7_5(funct7_5),
        .ALUControl(ALUControl),
        .Result(ALUResult),
        .Zero(Zero)
    );
    
    wire [31:0] ReadData;
    
    Data_memory DataMem(
        .clk(clk),           
        .WE(MemWrite),            
        .A(ALUResult[9:0]),  
        .WD(RD2_reg), 
        .RD(ReadData)
    );
    
    //Contador del programa
    wire [31:0] PCPlus4;
    assign PCPlus4 = PC + 32'd4;
    
    wire [31:0] PCNext, PCTarget;
    assign PCNext = PCSrc ? PCTarget : PCPlus4;
    
    //Registro contador
    always @(posedge clk or posedge Reset) begin
        if (Reset)
            PC <= 0;
        else
            PC <= PCNext; 
    end
    
    //selector de salto
    wire [31:0] jumper;
    assign jumper = ImmSrc[0] ? PC : RD1_reg;
    
    assign PCTarget = Immextend + jumper;
   
    
    always @(*) begin
        case (ResultSrc)
            2'b00: RESULT = ALUResult;
            2'b01: RESULT = ReadData;
            2'b10: RESULT = PCPlus4;
            2'b11: RESULT = Immextend;
            default: RESULT = 32'b0;
        endcase
    end
    
    assign WD3_reg = RESULT;
    
endmodule
