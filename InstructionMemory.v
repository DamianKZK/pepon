module InstructionMemory (
    input [31:0] address,
    output [31:0] instruction
);
    reg [31:0] memory [0:255]; 
    integer i;

    initial begin
        // 1. Limpiar memoria (llenar de ceros)
        for (i = 0; i < 256; i = i + 1) memory[i] = 32'b0;

        // 2. CARGAR EL PROGRAMA EN BINARIO (Hardcoded)
        // Programa: Sumar dos números de la memoria y guardar el resultado
        
        // Instr 1: LW $t1, 0($zero)  -> Hex: 8C090000
        // Binary: 100011 00000 01001 0000000000000000
        memory[0] = 32'b10001100000010010000000000000000;

        // Instr 2: LW $t2, 4($zero)  -> Hex: 8C0A0004
        // Binary: 100011 00000 01010 0000000000000100
        memory[1] = 32'b10001100000010100000000000000100;

        // Instr 3: ADD $t3, $t1, $t2  -> Hex: 012A5820
        // Binary: 000000 01001 01010 01011 00000 100000
        memory[2] = 32'b00000001001010100101100000100000;

        // Instr 4: SW $t3, 8($zero)  -> Hex: AC0B0008
        // Binary: 101011 00000 01011 0000000000001000
        memory[3] = 32'b10101100000010110000000000001000;
        
        // El resto son NOPs (00000000)
    end

    // Lectura alineada a palabra (address / 4)
    assign instruction = memory[address[9:2]]; 
endmodule