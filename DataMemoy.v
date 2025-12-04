module DataMemory (
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

        // 2. CARGAR DATOS DE PRUEBA
        memory[0] = 32'd10; // Dirección 0: Valor 10
        memory[1] = 32'd20; // Dirección 4: Valor 20
        // La Dirección 8 (índice 2) se queda en 0, ahí se escribirá el resultado (30)
    end

    always @(posedge clk) begin
        if (mem_write)
            memory[address[9:2]] <= write_data;
    end

    assign read_data = (mem_read) ? memory[address[9:2]] : 32'b0;
endmodule