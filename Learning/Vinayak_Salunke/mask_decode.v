module mask_decode (
    input  [8:0] mask_in, 
    output mode,          // 1 = bit mode, 0 = byte mode
    output [7:0] mask_val // 8-bit mask value
);
    assign mode     = mask_in[8];
    assign mask_val = mask_in[7:0];
endmodule
