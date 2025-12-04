module InstructionMemory (
    input [31:0] address,
    output [31:0] instruction
);
    reg [31:0] memory [0:255]; // Memoria pequeña de 256 palabras para pruebas

    // Inicialización opcional con un programa de prueba
    initial begin
        $readmemb("programa.mem", memory); 
    end

    // Alineación de palabra (dividir por 4 o ignorar los 2 bits menos significativos)
    assign instruction = memory[address[9:2]]; 
endmodule