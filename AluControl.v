`timescale 1ns/1ns
module ALUControl (
    input [1:0] alu_op,
    input [5:0] funct,
    // NUEVA ENTRADA: Necesaria para distinguir ANDI, ORI, SLTI
    input [5:0] opcode,
    output reg [3:0] alu_control_out
);
    
    // Códigos de control de la ALU (estándar MIPS)
    parameter ALU_AND = 4'b0000;
    parameter ALU_OR  = 4'b0001;
    parameter ALU_ADD = 4'b0010;
    parameter ALU_SUB = 4'b0110;
    parameter ALU_SLT = 4'b0111;
    parameter ALU_XOR = 4'b1100; // Asumiendo este código para XOR

    always @(*) begin
        case (alu_op)
            // 00: I-Type (Memoria, ADDI, Lógicas, SLTI)
            2'b00: begin 
                // Si ALUOp=00, miramos el opcode para saber qué operación hacer
                case (opcode)
                    6'b100011: alu_control_out = ALU_ADD; // LW: ADD (dirección)
                    6'b101011: alu_control_out = ALU_ADD; // SW: ADD (dirección)
                    6'b001000: alu_control_out = ALU_ADD; // ADDI: ADD
                    6'b001100: alu_control_out = ALU_AND; // ANDI: AND
                    6'b001101: alu_control_out = ALU_OR;  // ORI: OR
                    6'b001110: alu_control_out = ALU_XOR; // XORI: XOR
                    6'b001010: alu_control_out = ALU_SLT; // SLTI: SLT
                    default: alu_control_out = ALU_ADD;
                endcase
            end
            
            // 01: BEQ (Branch)
            2'b01: alu_control_out = ALU_SUB; // BEQ: SUB (para verificar A-B=0)
            
            // 10: R-Type (mira el campo funct)
            2'b10: begin 
                case (funct)
                    6'b100000: alu_control_out = ALU_ADD; // ADD
                    6'b100010: alu_control_out = ALU_SUB; // SUB
                    6'b100100: alu_control_out = ALU_AND; // AND
                    6'b100101: alu_control_out = ALU_OR;  // OR
                    6'b101010: alu_control_out = ALU_SLT; // SLT
                    default: alu_control_out = ALU_ADD;
                endcase
            end
            
            default: alu_control_out = ALU_ADD;
        endcase
    end
endmodule