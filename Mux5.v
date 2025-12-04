module Mux2to1_5bit (
    input [4:0] in0,
    input [4:0] in1,
    input sel,
    output [4:0] out
);
    assign out = (sel) ? in1 : in0;
endmodule