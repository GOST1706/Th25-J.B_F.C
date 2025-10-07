`timescale 1ns / 1ps

module shifter_top (
    input  wire [31:0] in,          // dato de entrada
    input  wire [4:0]  shamt,       // desplazamiento
    input  wire [2:0]  funct3,      // 001=SLL, 101=SRL/SRA
    input  wire [6:0]  funct7,      // bit[5] distingue SRA de SRL
    output wire [31:0] out
);
    wire dir  = funct3[2];          // 0=izquierda, 1=derecha
    wire arith = funct7[5];         // activa sign extend en SRA
    wire fill  = arith ? in[31] : 1'b0; // bit de relleno (signo o 0)

    // Generamos las 32 versiones desplazadas
    wire [31:0] shifts[31:0];
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : gen_shift
            assign shifts[i] = dir ? {{i{fill}}, in[31:i]} : {in[31-i:0], {i{1'b0}}};
        end
    endgenerate

    // Mux principal (con reverse interno)
mux32_1_reverse #(32) main (
    .din({shifts[31], shifts[30], shifts[29], shifts[28],
          shifts[27], shifts[26], shifts[25], shifts[24],
          shifts[23], shifts[22], shifts[21], shifts[20],
          shifts[19], shifts[18], shifts[17], shifts[16],
          shifts[15], shifts[14], shifts[13], shifts[12],
          shifts[11], shifts[10], shifts[9],  shifts[8],
          shifts[7],  shifts[6],  shifts[5],  shifts[4],
          shifts[3],  shifts[2],  shifts[1],  shifts[0]}),
    .sel(shamt),
    .dir(dir),
    .y(out)
);


endmodule

