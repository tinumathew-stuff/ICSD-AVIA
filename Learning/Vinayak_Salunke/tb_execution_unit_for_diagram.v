`timescale 1ns/1ps

module tb_execution_unit_for_diagram;

    // --- Inputs to the DUT (Device Under Test) ---
    reg  [31:0] reg_data;
    
    // Key A Inputs
    reg  [8:0]  mask_A;
    reg  [1:0]  pos_A;
    
    // Key B Inputs
    reg  [8:0]  mask_B;
    reg  [1:0]  pos_B;
    
    // Key C Inputs
    reg  [8:0]  mask_C;
    reg  [1:0]  pos_C;
    
    // Final Selection and ALU
    reg  [1:0]  key_sel; 
    reg  [7:0]  alu_b;
    reg  [2:0]  alu_ctrl; 
    
    // PC
    reg  [7:0]  pc_in;
    
    // --- Outputs from the DUT ---
    wire [7:0]  pc_out;
    wire [7:0]  alu_result;

    // --- Instantiate the Execution Unit (ERROR FIXED HERE) ---
    execution_unit_for_diagram dut (
        .reg_data(reg_data),
        
        // Key A
        .mask_A(mask_A),
        .pos_A(pos_A),
        
        // Key B
        .mask_B(mask_B),
        .pos_B(pos_B),
        
        // Key C
        .mask_C(mask_C),
        .pos_C(pos_C),
        
        // Final Control
        .key_sel(key_sel),
        .alu_b(alu_b),
        .alu_ctrl(alu_ctrl),
        
        // PC
        .pc_in(pc_in),
        
        // Outputs
        .pc_out(pc_out),
        .alu_result(alu_result)
    );

    initial begin
        // Initialize all inputs
        pc_in    = 8'd0;
        alu_b    = 8'h00;
        alu_ctrl = 3'b000;
        reg_data = 32'h00000000;
        
        mask_A = 9'h000; pos_A = 2'b00;
        mask_B = 9'h000; pos_B = 2'b00;
        mask_C = 9'h000; pos_C = 2'b00;
        key_sel= 2'b00;
        
        $display("----------------------------------------------------------------------");
        $display("STARTING EXECUTION UNIT TESTBENCH");
        $display("----------------------------------------------------------------------");
        #10; // Initial settling time

        // =========================================================
        // TEST 1: Key A, Bit Mode (ADD)
        // Expected: 78h & F0h = 70h. 70h + 0Fh = 7Fh
        // =========================================================
        $display("TEST 1: Key A, Bit Mode (ADD)");
        reg_data = 32'h12345678; // LSB is 78h
        alu_b    = 8'h0F;
        alu_ctrl = 3'b000;       // ADD
        key_sel  = 2'b00;       // Select Key A
        mask_A   = 9'b1_11110000; // Bit Mode (1), Mask Value = F0h
        
        #10;
        $display("  Inputs: reg_data=%h, mask_A=%b, alu_b=%h, pc_in=%d", reg_data, mask_A, alu_b, pc_in);
        $display("  Result: alu_result=%h (Expected: 7F), pc_out=%d", alu_result, pc_out);
        $display("----------------------------------------------------------------------");
        pc_in = pc_in + 1; 
        
        
        // =========================================================
        // TEST 2: Key B, Byte Mode, pos=10 (3rd Byte), OR Operation
        // Expected: 34h & FFh = 34h. 34h | CCh = FCh
        // =========================================================
        $display("TEST 2: Key B, Byte Mode (OR)");
        reg_data = 32'h12345678; // 3rd Byte is 34h
        alu_b    = 8'hCC;
        alu_ctrl = 3'b011;       // OR
        key_sel  = 2'b01;       // Select Key B
        mask_B   = 9'b0_11111111; // Byte Mode (0), Mask Value = FFh
        pos_B    = 2'b10;        // Select 3rd byte [23:16]

        #10;
        $display("  Inputs: reg_data=%h, mask_B=%b, pos_B=%b, alu_b=%h", reg_data, mask_B, pos_B, alu_b);
        $display("  Result: alu_result=%h (Expected: FC), pc_out=%d", alu_result, pc_out);
        $display("----------------------------------------------------------------------");
        pc_in = pc_in + 1;
        
        
        // =========================================================
        // TEST 3: Key C, Byte Mode, pos=11 (MSB), AND Operation
        // Expected: DEh & 0Fh = 0Eh. 0Eh & 80h = 00h
        // =========================================================
        $display("TEST 3: Key C, Byte Mode (AND)");
        reg_data = 32'hDEADBEEF; // MSB is DEh
        alu_b    = 8'h80;
        alu_ctrl = 3'b010;       // AND
        key_sel  = 2'b10;       // Select Key C
        mask_C   = 9'b0_00001111; // Byte Mode (0), Mask Value = 0Fh
        pos_C    = 2'b11;        // Select MSB [31:24]

        #10;
        $display("  Inputs: reg_data=%h, mask_C=%b, pos_C=%b, alu_b=%h", reg_data, mask_C, pos_C, alu_b);
        $display("  Result: alu_result=%h (Expected: 00), pc_out=%d", alu_result, pc_out);
        $display("----------------------------------------------------------------------");
        pc_in = pc_in + 1;
        
        
        // =========================================================
        // TEST 4: Key A, Bit Mode (XOR)
        // Expected: EFh & F8h = E8h. E8h ^ 55h = BDh
        // =========================================================
        $display("TEST 4: Key A, Bit Mode (XOR)");
        reg_data = 32'hDEADBEEF; // LSB is EFh
        alu_b    = 8'h55;
        alu_ctrl = 3'b100;       // XOR
        key_sel  = 2'b00;       // Select Key A
        mask_A   = 9'b1_11111000; // Bit Mode (1), Mask Value = F8h
        
        // Ensure B and C don't interfere
        mask_B = 9'h000; pos_B = 2'b00;
        mask_C = 9'h000; pos_C = 2'b00;

        #10;
        $display("  Inputs: reg_data=%h, mask_A=%b, alu_b=%h", reg_data, mask_A, alu_b);
        $display("  Result: alu_result=%h (Expected: BD), pc_out=%d", alu_result, pc_out);
        $display("----------------------------------------------------------------------");
        
        $stop;
    end
endmodule
