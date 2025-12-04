
`timescale 1ns/1ns
module EX_MEM_Buffer (
    input clk,
    input reset,
    // Control
    input RegWrite_in, MemtoReg_in, MemRead_in, MemWrite_in,
    input Branch_in, // <--- NUEVO
    
    // Datos
    input Zero_in,   // <--- NUEVO: Resultado Zero de la ALU
    input [31:0] alu_result_in, write_data_in,
    input [4:0]  write_reg_in,

    // Salidas
    output reg RegWrite_out, MemtoReg_out, MemRead_out, MemWrite_out,
    output reg Branch_out, // <--- NUEVO
    output reg Zero_out,   // <--- NUEVO
    
    output reg [31:0] alu_result_out, write_data_out,
    output reg [4:0]  write_reg_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            RegWrite_out <= 0; MemtoReg_out <= 0; MemRead_out <= 0; MemWrite_out <= 0;
            Branch_out <= 0; Zero_out <= 0; // Reset
            alu_result_out <= 0; write_data_out <= 0; write_reg_out <= 0;
        end else begin
            RegWrite_out <= RegWrite_in; MemtoReg_out <= MemtoReg_in;
            MemRead_out <= MemRead_in; MemWrite_out <= MemWrite_in;
            Branch_out <= Branch_in; // Pasar Branch
            Zero_out <= Zero_in;     // Pasar Zero
            
            alu_result_out <= alu_result_in; write_data_out <= write_data_in;
            write_reg_out <= write_reg_in;
        end
    end
endmodule