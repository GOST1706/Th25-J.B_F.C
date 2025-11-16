`timescale 1ns / 1ps
module tb_instruction_memory;

    reg clk;
    reg WE;
    reg [31:0] A;
    reg [31:0] WD;
    wire [31:0] RD;

    integer i;

    // Instancia del módulo bajo prueba
    Instruction_memory dut (
        .clk(clk),
        .WE(WE),
        .A(A[9:0]),
        .WD(WD),
        .RD(RD)
    );

    // Generación del reloj (10 ns)
    always #5 clk = ~clk;

    // Arreglo con las instrucciones del RV32I
    reg [31:0] instructions [0:10];

    initial begin
        // ===================================================
        // Inicialización
        // ===================================================
        clk = 0;
        WE  = 0;
        A   = 0;
        WD  = 0;

        // Cargar las instrucciones en el arreglo
        instructions[0]  = 32'h00500093;
        instructions[1]  = 32'h00A00113;
        instructions[2]  = 32'h002081B3;
        instructions[3]  = 32'h00302023;
        instructions[4]  = 32'h00002203;
        instructions[5]  = 32'h00F00293;
        instructions[6]  = 32'h00520463;
        instructions[7]  = 32'h06F00313;
        instructions[8]  = 32'h0040006F;
        instructions[9]  = 32'h0DE00313;
        instructions[10] = 32'hFFDFF06F;

        // ===================================================
        // Escritura en memoria (simula la carga del programa)
        // ===================================================
        #10;
        WE = 1;

        for (i = 0; i < 11; i = i + 1) begin
            A  = i * 4;                // Dirección palabra-alineada
            WD = instructions[i];      // Instrucción a escribir
            #10;                       // Espera un ciclo
        end

        WE = 0;

        // ===================================================
        // Lectura y verificación de memoria
        // ===================================================
        #20;
        $display("=====================================================");
        $display("    LECTURA DE INSTRUCCIONES DESDE LA MEMORIA");
        $display("=====================================================");

        for (i = 0; i < 11; i = i + 1) begin
            A = i * 4;
            @(posedge clk); // pide lectura
            @(posedge clk); // espera un ciclo para que RD se actualice
            $display("Addr = %0d | Esperado = %h | Leido = %h", A, instructions[i], RD);
        end


        $display("=====================================================");
        $display("              FIN DE SIMULACIÓN");
        $display("=====================================================");
        $stop;
    end

endmodule

