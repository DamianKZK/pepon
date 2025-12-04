module InstructionMemory (
    input [31:0] address,
    output [31:0] instruction
);
    reg [31:0] memory [0:255]; 
    integer i;

    initial begin
        // 1. Limpiar memoria (llenar de ceros)
        for (i = 0; i < 256; i = i + 1) memory[i] = 32'b0;

        // 2. CARGAR EL NUEVO PROGRAMA CON ADDI (Hardcoded en Binario)
        // PC=0 (memory[0]): LW $t1, 0($zero)   -> Hex: 8C090000
        // Binary: 100011 00000 01001 0000000000000000
        memory[0] = 32'b10001100000010010000000000000000;

        // PC=4 (memory[1]): ADDI $t3, $t1, 5   -> Hex: 212B0005
        // Binary: 001000 01001 01011 0000000000000101
        // (Opcode 001000 | Rs=$t1 (9) | Rt=$t3 (11) | Immediate 5)
        memory[1] = 32'b00100001001010110000000000000101;

        // PC=8 (memory[2]): SW $t3, 8($zero)   -> Hex: AC0B0008
        // Binary: 101011 00000 01011 0000000000001000
        memory[2] = 32'b10101100000010110000000000001000;
        
        // El resto son NOPs
    end

    // Lectura alineada a palabra (address / 4)
    assign instruction = memory[address[9:2]]; 
endmodule