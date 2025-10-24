module bit_select (
    input  [7:0] data_in,
    input  [7:0] mask_val,
    output [7:0] data_out
);
    assign data_out = data_in & mask_val;
endmodule
