module DataMemory (
    // ... (puertos de entrada y salida)
    input clk,
    input [31:0] address,
    input [31:0] write_data,
    input mem_write,
    input mem_read,
    output [31:0] read_data
);
    reg [31:0] memory [0:255];
    integer i;

    initial begin
        // 1. Limpiar memoria
        for (i = 0; i < 256; i = i + 1) memory[i] = 32'b0;

        // 2. CARGAR DATO DE PRUEBA
        memory[0] = 32'd10; // Dirección 0: Valor 10 (para $t1)
    end

    always @(posedge clk) begin
        if (mem_write)
            memory[address[9:2]] <= write_data;
    end

    assign read_data = (mem_read) ? memory[address[9:2]] : 32'b0;
endmodule