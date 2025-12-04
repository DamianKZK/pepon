`timescale 1ns / 1ps

module MIPS_TB;

    // Entradas para el procesador (Registros en el TB)
    reg clk;
    reg reset;

    // Instancia del Procesador (Unit Under Test - UUT)
    MIPS_Pipeline_Top UUT (
        .clk(clk),
        .reset(reset)
    );

    // 1. Generador de Reloj (Clock)
    // El reloj cambiará de estado cada 5ns -> Periodo de 10ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // 2. Secuencia de Prueba
    initial begin
        // A) Inicialización
        $display("Iniciando Simulación MIPS Pipeline...");
        reset = 1;  // Mantenemos el reset activado al inicio
        #10;        // Esperamos 10ns (un ciclo)
        
        // B) Soltar el Reset (Arrancar procesador)
        reset = 0;
        $display("Reset desactivado. Procesador corriendo.");

        // C) Dejar correr la simulación
        // Como el programa es corto (4 instrucciones + pipeline), 
        // 200ns es tiempo suficiente.
        #200;

        // D) Fin de la simulación
        $display("Simulación terminada.");
        $stop; // Detiene ModelSim/Vivado
    end
    
endmodule