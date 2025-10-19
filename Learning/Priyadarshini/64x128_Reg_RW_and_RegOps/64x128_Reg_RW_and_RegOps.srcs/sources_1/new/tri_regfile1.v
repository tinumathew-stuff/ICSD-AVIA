// tri_regfile.v
// Top-level: 3 register blocks (128 x 64-bit each)
// Supports external read/write (rw + reg_sel) and a parallel reg->reg operation
// mask[8] = 1 -> BIT mode, mask[5:0] = bit index (0..63)
// mask[8] = 0 -> BYTE mode, mask[7:0] = byte enables (byte0 = LSB byte)
// possel: [1:0]=A, [3:2]=B, [5:4]=C (00=reg1,01=reg2,11=reg3)

module tri_regfile(
    input             clk,
    input             parallel_enable, // start reg->reg op (one cycle)
    input      [3:0]  opcode,          // operation code
    input      [8:0]  mask,            // 9-bit mask (mode + payload)
    input      [5:0]  possel,          // 3 x 2-bit selects: [5:4]=C [3:2]=B [1:0]=A
    input             rw,              // external read/write control: 1=read, 0=write
    input      [1:0]  reg_sel,         // external reg select: 00=reg1,01=reg2,11=reg3
    input      [6:0]  addr,            // 7-bit address (0..127)
    input      [63:0] data_in,         // external write data
    output reg [63:0] data_out         // external read data (registered)
);

    // Three register memories
    reg [63:0] mem1 [0:127];
    reg [63:0] mem2 [0:127];
    reg [63:0] mem3 [0:127];

    // Temporaries
    reg [63:0] a_val, b_val, raw_res, orig_dest, final_res, mask64;
    reg [7:0]  byte_mask;
    reg [5:0]  bit_index;
    integer    i;

    // Opcode map (suggested):
    // 4'h1 => AND
    // 4'h2 => OR
    // 4'h3 => XOR
    // 4'h4 => ADD
    // 4'h5 => SUB
    // 4'h6 => NOT A
    // 4'h7 => MOV B -> C (move)
    // Others => zero

    always @(posedge clk) begin
        if (parallel_enable) begin
            // --- select operand A ---
            case (possel[1:0])
                2'b00: a_val = mem1[addr];
                2'b01: a_val = mem2[addr];
                2'b11: a_val = mem3[addr];
                default: a_val = mem1[addr];
            endcase

            // --- select operand B ---
            case (possel[3:2])
                2'b00: b_val = mem1[addr];
                2'b01: b_val = mem2[addr];
                2'b11: b_val = mem3[addr];
                default: b_val = mem1[addr];
            endcase

            // --- perform opcode ---
            case (opcode)
                4'h1: raw_res = a_val & b_val;
                4'h2: raw_res = a_val | b_val;
                4'h3: raw_res = a_val ^ b_val;
                4'h4: raw_res = a_val + b_val;
                4'h5: raw_res = a_val - b_val;
                4'h6: raw_res = ~a_val;
                4'h7: raw_res = b_val; // move B->C
                default: raw_res = 64'h0;
            endcase

            // --- build 64-bit mask from mask[8:0] ---
            if (mask[8] == 1'b1) begin
                // BIT mode: mask[5:0] is bit index (6 bits -> 0..63)
                bit_index = mask[5:0];
                mask64 = 64'h0;
                mask64 = (64'h1 << bit_index);
            end else begin
                // BYTE mode: mask[7:0] contains 8 byte enables (byte0 = LSB byte)
                byte_mask = mask[7:0];
                mask64 = 64'h0;
                for (i = 0; i < 8; i = i + 1) begin
                    if (byte_mask[i])
                        mask64 = mask64 | (64'hFF << (i*8));
                end
            end

            // --- read original destination word ---
            case (possel[5:4])
                2'b00: orig_dest = mem1[addr];
                2'b01: orig_dest = mem2[addr];
                2'b11: orig_dest = mem3[addr];
                default: orig_dest = mem1[addr];
            endcase

            // --- compose final value (masked update) ---
            final_res = (orig_dest & ~mask64) | (raw_res & mask64);

            // --- write back to destination reg ---
            case (possel[5:4])
                2'b00: mem1[addr] <= final_res;
                2'b01: mem2[addr] <= final_res;
                2'b11: mem3[addr] <= final_res;
                default: mem1[addr] <= final_res;
            endcase
        end
        else begin
            // External read/write interface (single-word read/write)
            if (rw == 1'b0) begin
                // external WRITE
                case (reg_sel)
                    2'b00: mem1[addr] <= data_in;
                    2'b01: mem2[addr] <= data_in;
                    2'b11: mem3[addr] <= data_in;
                    default: mem1[addr] <= data_in;
                endcase
            end else begin
                // external READ (registered out)
                case (reg_sel)
                    2'b00: data_out <= mem1[addr];
                    2'b01: data_out <= mem2[addr];
                    2'b11: data_out <= mem3[addr];
                    default: data_out <= mem1[addr];
                endcase
            end
        end
    end

endmodule
