module select_mux (
    input  [7:0] bit_data, // Mux input 1 (Mode=1)
    input  [7:0] dyn_data, // Mux input 0 (Mode=0)
    input        mode,     // Select signal (from mask[8])
    output [7:0] out
);
    assign out = (mode) ? bit_data : dyn_data;
endmodule
