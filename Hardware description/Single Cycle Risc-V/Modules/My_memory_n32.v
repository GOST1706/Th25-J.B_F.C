`timescale 1ns / 1ps
module My_memory_n8 #(
    parameter N = 7,          // número de bits de dirección (2^N bytes)
    parameter M = 8           // ancho de palabra (8 bits = 1 byte)
)(
    input clk,
    input we,
    input [N-1:0] addr,
    input [M-1:0] data_in,
    output reg [4*M-1:0] data_out
);

    // RAM de bytes
    reg [M-1:0] my_mem [0:(1<<N)-1];

    // Inicialización desde archivo externo
    initial begin
        $display(">>> Cargando memoria desde archivo tb.mem ...");
        $readmemh("tb.mem", my_mem);  
        // O usa $readmemb("program.mem", my_mem); si el archivo está en binario
    end

    // Escritura síncrona
    always @(posedge clk) begin
        if (we)
            my_mem[addr] <= data_in;
    end

    // Lectura combinacional de 4 bytes consecutivos
    always @(*) begin
        data_out = { my_mem[addr], 
                     my_mem[addr+1], 
                     my_mem[addr+2], 
                     my_mem[addr+3] };
    end

endmodule

