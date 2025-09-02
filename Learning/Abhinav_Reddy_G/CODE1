module register (
    input        clk,
    input        rw,         // 1 = write, 0 = read
    input  [6:0] address,    // 7 bits for 128 locations
    inout [63:0] data
);

    reg [63:0] register_A [127:0];
    reg [63:0] dout;

    // Tri-state buffer for bidirectional data bus
    assign data = (rw == 1'b0) ? dout : 64'bz;

    always @(posedge clk) begin
        if (rw) begin
            register_A[address] <= data;   // write to memory
        end else begin
            dout <= register_A[address];  // prepare read data
        end
    end

endmodule
