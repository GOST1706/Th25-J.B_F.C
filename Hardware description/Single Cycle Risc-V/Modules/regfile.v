`timescale 1ns / 1ps
(* keep_hierarchy = "yes" *)
// regfile: lecturas sincronas (salidas registradas)
module regfile (
    input  wire        clk,
    input  wire        WE,
    input  wire [4:0]  A1, A2, A3,
    input  wire [31:0] WD3,
    output reg  [31:0] RD1, RD2
);
    reg [31:0] r [31:0];
    integer i;
    initial for (i=0; i<32; i=i+1) r[i] = 32'b0;

    // Escritura s�ncrona (no escribir r0)
    always @(posedge clk) begin
        if (WE && (A3 != 5'd0))
            r[A3] <= WD3;
    end

    // Lectura sincrona: muestreamos direcciones en flanco
    reg [31:0] rd1_reg, rd2_reg;
    always @(posedge clk) begin
        rd1_reg <= (A1 == 5'd0) ? 32'b0 : r[A1];
        rd2_reg <= (A2 == 5'd0) ? 32'b0 : r[A2];
    end

    // salida
    always @(*) begin
        RD1 = rd1_reg;
        RD2 = rd2_reg;
    end
endmodule



