module dynamic_select (
    input  [31:0] data_in,
    input  [1:0]  pos_sel,
    input  [7:0]  mask_val,
    output [7:0]  data_out
);
    reg [7:0] selected_byte;

    always @(*) begin
        case (pos_sel)
            2'b00: selected_byte = data_in[7:0];
            2'b01: selected_byte = data_in[15:8];
            2'b10: selected_byte = data_in[23:16];
            2'b11: selected_byte = data_in[31:24];
            default: selected_byte = 8'h00;
        endcase
    end
    
    assign data_out = selected_byte & mask_val;
endmodule
