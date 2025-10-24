module alu (
    input  [7:0] a,      // Operand A
    input  [7:0] b,      // Operand B
    input  [2:0] alu_ctrl, // ALU operation select
    output reg [7:0] result,
    output reg carry 
);
    reg [8:0] tmp; 

    always @(*) begin
        carry = 0;
        result = 0;

        case (alu_ctrl)
            3'b000: begin // ADD
                tmp = a + b;
                result = tmp[7:0];
                carry  = tmp[8];
            end
            3'b001: begin // SUB
                tmp = a - b;
                result = tmp[7:0];
                carry  = tmp[8]; 
            end
            3'b010: result = a & b;  // AND
            3'b011: result = a | b;  // OR
            3'b100: result = a ^ b;  // XOR
            3'b101: result = ~a;     // NOT (on A)
            3'b110: result = a << 1; // Shift left
            3'b111: result = a >> 1; // Shift right
            default: result = 8'b0;
        endcase
    end
endmodule
