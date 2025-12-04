module DataMemory (
    input clk,
    input [31:0] address,
    input [31:0] write_data,
    input mem_write,
    input mem_read,
    output [31:0] read_data
);
    reg [31:0] memory [0:255];
    initial begin
        // Carga los datos iniciales (el 10 y el 20)
        $readmemb("data.mem", memory);
    end
    always @(posedge clk) begin
        if (mem_write)
            memory[address[9:2]] <= write_data;
    end

    assign read_data = (mem_read) ? memory[address[9:2]] : 32'b0;
endmodule