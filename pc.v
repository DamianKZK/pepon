`timescale 1ns/1ns
module ProgramCounter (
    input clk,
    input reset,
    input enable, // <--- NUEVO: Solo actualiza si enable es 1
    input [31:0] pc_in,
    output reg [31:0] pc_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) pc_out <= 32'b0;
        else if (enable) pc_out <= pc_in; // Solo escribe si enable = 1
    end
endmodule