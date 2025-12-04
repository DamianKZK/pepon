module Adder (
    input [31:0] a,
    input [31:0] b,
    output [31:0] result
);
    // Suma simple de 32 bits sin carry-out ni overflow check
    // (suficiente para PC+4 y direcciones de memoria)
    assign result = a + b;
endmodule