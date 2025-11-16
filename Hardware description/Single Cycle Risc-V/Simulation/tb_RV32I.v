`timescale 1ns / 1ps
module tb_RV32I;

   reg clk;
   reg WE_mem;
   reg Reset;
   reg [31:0] WD_mem;
   wire [31:0] RESULT;

   integer i;

   // Instancia del procesador
   RV32I dut (
      .clk(clk),
      .WE_mem(WE_mem),
      .WD_mem(WD_mem),
      .Reset(Reset),
      .RESULT(RESULT)
   );

   // Instrucciones a cargar
   reg [31:0] instructions [0:10];


   // Generar reloj (10 ns período)
   always #10 clk = ~clk;

   initial begin
    Reset = 1;
    #20;       // Espera a que la memoria esté estable
    Reset = 0;
      // ===================================================
      // Inicialización
      // ===================================================
      clk = 0;
      WE_mem = 0;
      Reset = 1;
      WD_mem = 32'd0;

      // Cargar instrucciones en el arreglo
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
      // Cargar instrucciones en memoria
      // ===================================================


      for (i = 0; i < 11; i = i + 1) begin
         WD_mem = instructions[i];
         #10; // 1 ciclo de reloj por instrucción
      end

      WE_mem = 0;
      @(posedge clk);
      Reset = 1;
      @(posedge clk);
      Reset = 0;

      // ===================================================
      // Ejecutar el programa
      // ===================================================
      $display("=====================================================");
      $display("           INICIANDO SIMULACION DEL RV32I");
      $display("=====================================================");

      for (i = 0; i < 15; i = i + 1) begin
         #10;
         $display("Tiempo=%0t ns | RESULT = %h", $time, RESULT);
      end

      $display("=====================================================");
      $display("          FIN DE LA SIMULACION DEL RV32I");
      $display("=====================================================");
      $stop;
   end
   

endmodule