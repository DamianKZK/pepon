`timescale 1ns/1ns
module MEM_WB_Buffer (
    input clk,
    input reset,
    // Señales de Control (WB)
    input RegWrite_in, MemtoReg_in,
    
    // Datos
    input [31:0] mem_read_data_in,
    input [31:0] alu_result_in,
    input [4:0]  write_reg_in,

    // Salidas
    output reg RegWrite_out, MemtoReg_out,
    output reg [31:0] mem_read_data_out,
    output reg [31:0] alu_result_out,
    output reg [4:0]  write_reg_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            RegWrite_out <= 0; MemtoReg_out <= 0;
            mem_read_data_out <= 0; alu_result_out <= 0; write_reg_out <= 0;
        end else begin
            RegWrite_out <= RegWrite_in; MemtoReg_out <= MemtoReg_in;
            mem_read_data_out <= mem_read_data_in;
            alu_result_out <= alu_result_in;
            write_reg_out <= write_reg_in;
        end
    end
endmodule