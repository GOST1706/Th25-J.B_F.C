`timescale 1ns / 1ps
module My_memory #(
    parameter N = 10,         // tamaño de dirección
    parameter M = 8           // bits por palabra
)(
    input clk, WE,
    input [N-1:0] A,
    input [M-1:0] WD,
    output reg [M-1:0] RD
);

    // Definimos la RAM
    reg [M-1:0] my_mem [0:(1<<N)-1];
    


    always @(posedge clk) begin
        if (WE)
            my_mem[A] <= WD;  // Escritura
        RD <= my_mem[A];      // Lectura sincrónica
    end

endmodule
