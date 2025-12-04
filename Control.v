`timescale 1ns/1ns
module ControlUnit (
    input [5:0] opcode,
    // Salidas (Señales de control de 1 bit)
    output reg RegDst,      // 1: rd, 0: rt
    output reg ALUSrc,      // 1: Immediate, 0: RegB
    output reg MemToReg,    // 1: Memoria, 0: ALU/Immediate
    output reg RegWrite,    // Habilita escritura en Banco de Registros
    output reg MemRead,     // Habilita lectura de Memoria
    output reg MemWrite,    // Habilita escritura en Memoria
    output reg Branch,      // Habilita salto condicional (BEQ)
    output reg Jump,        // Habilita salto incondicional (J)
    // Salida (Señal de control de 2 bits para ALUControl)
    output reg [1:0] ALUOp
);

    always @(*) begin
        // Inicializar todas las salidas a 0 (NOP)
        RegDst = 1'b0; ALUSrc = 1'b0; MemToReg = 1'b0; RegWrite = 1'b0;
        MemRead = 1'b0; MemWrite = 1'b0; Branch = 1'b0; Jump = 1'b0; ALUOp = 2'b00;

        case (opcode)
            // R-Type: ADD, SUB, AND, OR, SLT (Opcode 000000)
            6'b000000: begin
                RegDst = 1'b1;    // Destino: rd (Instruction[15:11])
                RegWrite = 1'b1;  // Escribir resultado
                ALUOp = 2'b10;    // Operación R-Type (Miras 'funct')
            end
            
            // I-Type: LW (Opcode 100011)
            6'b100011: begin 
                ALUSrc = 1'b1;    // Segunda entrada ALU: Immediate
                MemToReg = 1'b1;  // Origen de dato escrito: Memoria
                RegWrite = 1'b1;  // Escribir resultado
                MemRead = 1'b1;   // Leer Memoria
                ALUOp = 2'b00;    // Operación: ADD (para dirección)
            end
            
            // I-Type: SW (Opcode 101011)
            6'b101011: begin 
                ALUSrc = 1'b1;    // Segunda entrada ALU: Immediate
                MemWrite = 1'b1;  // Escribir en Memoria
                ALUOp = 2'b00;    // Operación: ADD (para dirección)
            end
            
            // I-Type: BEQ (Opcode 000100)
            6'b000100: begin 
                Branch = 1'b1;    // Es una rama condicional
                ALUOp = 2'b01;    // Operación: SUB (para comparación)
            end
            
            // I-Type: ADDI, ANDI, ORI, XORI, SLTI (Opcode 001xxx)
            // Estas comparten el mismo control I-Type, solo cambia la ALUOp.
            // Se agrupan aquí y se distinguen en ALUControl con el Opcode.
            6'b001000, 6'b001100, 6'b001101, 6'b001110, 6'b001010: begin 
                RegDst = 1'b0;    // Destino: rt (Instruction[20:16])
                ALUSrc = 1'b1;    // Segunda entrada ALU: Immediate
                RegWrite = 1'b1;  // Escribir resultado
                ALUOp = 2'b00;    // ALUOp 00 (Deja que ALUControl decida la operación)
            end
            
            // J-Type: J (Jump) (Opcode 000010)
            6'b000010: begin
                Jump = 1'b1;      // Es un salto incondicional
            end
            
            // Default: Otros opcodes (NOP)
            default: begin
                // Ya inicializado a 0/00
            end
        endcase
    end
endmodule