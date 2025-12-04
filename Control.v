module ControlUnit (
    input [5:0] opcode,
    output reg reg_dst,
    output reg branch,
    output reg mem_read,
    output reg mem_to_reg,
    output reg [1:0] alu_op,
    output reg mem_write,
    output reg alu_src,
    output reg reg_write
);
    always @(*) begin
        // Valores por defecto (para evitar latches)
        reg_dst = 0; branch = 0; mem_read = 0; mem_to_reg = 0;
        alu_op = 2'b00; mem_write = 0; alu_src = 0; reg_write = 0;

        case (opcode)
            6'b000000: begin // R-Type
                reg_dst = 1; reg_write = 1; alu_op = 2'b10;
            end
            6'b100011: begin // LW (Load Word)
                alu_src = 1; mem_to_reg = 1; reg_write = 1; mem_read = 1;
            end
            6'b101011: begin // SW (Store Word)
                alu_src = 1; mem_write = 1;
            end
            6'b000100: begin // BEQ (Branch Equal)
                branch = 1; alu_op = 2'b01;
            end
            // Añadir JUMP o ADDI si es necesario
        endcase
    end
endmodule