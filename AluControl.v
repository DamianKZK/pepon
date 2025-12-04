module ALUControl (
    input [1:0] alu_op,
    input [5:0] funct,
    output reg [3:0] alu_control_out
);
    always @(*) begin
        case (alu_op)
            2'b00: alu_control_out = 4'b0010; // LW/SW -> Add
            2'b01: alu_control_out = 4'b0110; // BEQ   -> Subtract
            2'b10: begin // R-Type (mira el campo funct)
                case (funct)
                    6'b100000: alu_control_out = 4'b0010; // ADD
                    6'b100010: alu_control_out = 4'b0110; // SUB
                    6'b100100: alu_control_out = 4'b0000; // AND
                    6'b100101: alu_control_out = 4'b0001; // OR
                    6'b101010: alu_control_out = 4'b0111; // SLT
                    default:   alu_control_out = 4'b0000;
                endcase
            end
            default: alu_control_out = 4'b0000;
        endcase
    end
endmodule