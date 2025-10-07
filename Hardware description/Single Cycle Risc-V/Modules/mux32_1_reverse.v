`timescale 1ns / 1ps

module mux32_1_reverse #(
    parameter WIDTH = 32
)(
    input  wire [WIDTH*32-1:0] din, // concatenación de 32 palabras
    input  wire [4:0] sel,
    input  wire dir,
    output wire [WIDTH-1:0] y
);
    // Función para invertir bits
    function [WIDTH-1:0] bit_reverse;
        input [WIDTH-1:0] a;
        integer i;
        begin
            for (i = 0; i < WIDTH; i = i + 1)
                bit_reverse[i] = a[WIDTH-1-i];
        end
    endfunction

    // Selección de palabra (de 32 posibles)
    wire [WIDTH-1:0] din_array [0:31];
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1)
            assign din_array[i] = din[WIDTH*(i+1)-1 -: WIDTH];
    endgenerate

    wire [WIDTH-1:0] selected = din_array[sel];
    assign y = dir ? bit_reverse(selected) : selected;
endmodule


