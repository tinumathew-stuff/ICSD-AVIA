// -----------------------------------------------------------
// 7. Main Execution Unit (Implements the Diagram)
// -----------------------------------------------------------
module execution_unit_for_diagram (
    // Assuming all 3 keys (A, B, C) read from the same 32-bit Register Data
    input  [31:0] reg_data, 
    
    // Inputs for Key A, B, and C
    input  [8:0]  mask_A, mask_B, mask_C,
    input  [1:0]  pos_A, pos_B, pos_C,
    
    // Control to select which key (A, B, C) provides the final operand
    input  [1:0]  key_sel, 
    
    // ALU Inputs and Control
    input  [7:0]  alu_b,
    input  [2:0]  alu_ctrl, 
    
    // PC Update
    input  [7:0]  pc_in,
    
    // Outputs
    output [7:0]  pc_out,
    output [7:0]  alu_result
);

    // --- Wire Declarations for Block A ---
    wire mode_A;
    wire [7:0] mask_val_A;
    wire [7:0] bit_out_A, dyn_out_A, out_A;

    // --- Wire Declarations for Block B ---
    wire mode_B;
    wire [7:0] mask_val_B;
    wire [7:0] bit_out_B, dyn_out_B, out_B;
    
    // --- Wire Declarations for Block C ---
    wire mode_C;
    wire [7:0] mask_val_C;
    wire [7:0] bit_out_C, dyn_out_C, out_C;
    
    // --- Final Wires ---
    wire [7:0] final_operand; 
    wire carry_flag; 


    // ================== BLOCK A INSTANTIATION ==================
    mask_decode decode_A (.mask_in(mask_A), .mode(mode_A), .mask_val(mask_val_A));
    
    bit_select     bs_A (.data_in(reg_data[7:0]), .mask_val(mask_val_A), .data_out(bit_out_A));
    dynamic_select ds_A (.data_in(reg_data), .pos_sel(pos_A), .mask_val(mask_val_A), .data_out(dyn_out_A));
    
    select_mux     sm_A (.bit_data(bit_out_A), .dyn_data(dyn_out_A), .mode(mode_A), .out(out_A));


    // ================== BLOCK B INSTANTIATION ==================
    mask_decode decode_B (.mask_in(mask_B), .mode(mode_B), .mask_val(mask_val_B));
    
    bit_select     bs_B (.data_in(reg_data[7:0]), .mask_val(mask_val_B), .data_out(bit_out_B));
    dynamic_select ds_B (.data_in(reg_data), .pos_sel(pos_B), .mask_val(mask_val_B), .data_out(dyn_out_B));
    
    select_mux     sm_B (.bit_data(bit_out_B), .dyn_data(dyn_out_B), .mode(mode_B), .out(out_B));


    // ================== BLOCK C INSTANTIATION ==================
    mask_decode decode_C (.mask_in(mask_C), .mode(mode_C), .mask_val(mask_val_C));
    
    bit_select     bs_C (.data_in(reg_data[7:0]), .mask_val(mask_val_C), .data_out(bit_out_C));
    dynamic_select ds_C (.data_in(reg_data), .pos_sel(pos_C), .mask_val(mask_val_C), .data_out(dyn_out_C));
    
    select_mux     sm_C (.bit_data(bit_out_C), .dyn_data(dyn_out_C), .mode(mode_C), .out(out_C));


    // ================== FINAL STAGES ==================
    
    // 4. Final MUX (Selects Operand A, B, or C based on instruction/key_sel)
    final_select_mux final_mux_inst (
        .out_a(out_A), 
        .out_b(out_B), 
        .out_c(out_C), 
        .key_sel(key_sel), 
        .final_operand(final_operand)
    );
    
    // 5. ALU Execution
    alu alu0 (
        .a(final_operand), 
        .b(alu_b), 
        .alu_ctrl(alu_ctrl),
        .result(alu_result), 
        .carry(carry_flag)
    );

    // 6. Program Counter (PC) Update
    assign pc_out = pc_in + 1;

endmodule
