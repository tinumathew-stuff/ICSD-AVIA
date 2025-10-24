module final_select_mux (
    input [7:0] out_a, out_b, out_c,
    input [1:0] key_sel, // Selects A (00), B (01), or C (10)
    output reg [7:0] final_operand
);
    always @(*) begin
        case(key_sel)
            2'b00: final_operand = out_a;
            2'b01: final_operand = out_b;
            2'b10: final_operand = out_c;
            default: final_operand = 8'h00; // Default: zero
        endcase
    end
endmodule
