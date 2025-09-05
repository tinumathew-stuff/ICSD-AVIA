module operand_select #(
    parameter WIDTH = 128
)(
    input  wire [WIDTH-1:0] reg_in,
    input  wire [WIDTH-1:0] mask,
  input  wire [$clog2(WIDTH)-1:0] pos, //scales automatically in case we need to change the WIDTH
    input  wire mode,
    output wire [WIDTH-1:0] out
);

    assign out = mode ? (reg_in & (1'b1 << pos)) : (reg_in & mask);

endmodule
