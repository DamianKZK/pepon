module IF_ID_Buffer (
    input clk,
    input reset,
    input enable, // <--- NUEVO
    input [31:0] pc_next_in,
    input [31:0] instr_in,
    output reg [31:0] pc_next_out,
    output reg [31:0] instr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_next_out <= 32'b0; instr_out <= 32'b0;
        end else if (enable) begin // Solo escribe si enable = 1
            pc_next_out <= pc_next_in; instr_out <= instr_in;
        end
    end
endmodule