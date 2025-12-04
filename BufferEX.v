module ID_EX_Buffer (
    input clk,
    input reset,
    // Control
    input RegWrite_in, MemtoReg_in, MemRead_in, MemWrite_in,
    input RegDst_in, ALUSrc_in,
    input [1:0] ALUOp_in,
    input Branch_in, 
    
    // Datos
    input [31:0] pc_next_in, read_data1_in, read_data2_in, sign_ext_in,
    input [4:0]  rs_in, rt_in, rd_in,
    input [5:0]  opcode_in, // <--- NUEVO: Entrada Opcode

    // Salidas
    output reg RegWrite_out, MemtoReg_out, MemRead_out, MemWrite_out,
    output reg RegDst_out, ALUSrc_out,
    output reg [1:0] ALUOp_out,
    output reg Branch_out, 
    
    output reg [31:0] pc_next_out, read_data1_out, read_data2_out, sign_ext_out,
    output reg [4:0]  rs_out, rt_out, rd_out,
    output reg [5:0]  opcode_out // <--- NUEVO: Salida Opcode
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            RegWrite_out <= 0; MemtoReg_out <= 0; MemRead_out <= 0; MemWrite_out <= 0;
            RegDst_out <= 0; ALUSrc_out <= 0; ALUOp_out <= 0; Branch_out <= 0;
            pc_next_out <= 0; read_data1_out <= 0; read_data2_out <= 0;
            sign_ext_out <= 0; rs_out <= 0; rt_out <= 0; rd_out <= 0;
            opcode_out <= 0; // Reset Opcode
        end else begin
            RegWrite_out <= RegWrite_in; MemtoReg_out <= MemtoReg_in;
            MemRead_out <= MemRead_in; MemWrite_out <= MemWrite_in;
            RegDst_out <= RegDst_in; ALUSrc_out <= ALUSrc_in; ALUOp_out <= ALUOp_in;
            Branch_out <= Branch_in;
            
            pc_next_out <= pc_next_in; read_data1_out <= read_data1_in;
            read_data2_out <= read_data2_in; sign_ext_out <= sign_ext_in;
            rs_out <= rs_in; rt_out <= rt_in; rd_out <= rd_in;
            opcode_out <= opcode_in; // Pasar Opcode
        end
    end
endmodule