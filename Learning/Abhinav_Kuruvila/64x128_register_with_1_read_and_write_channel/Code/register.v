module register (
    input clk, rw,
    input [6:0] address,
    inout [63:0] data,
);
    reg [63:0] register_A [127:0];

    always @(posedge clk) begin
        if (rw) begin
            register_A[address] <= data;
        end else begin
            data <= register_A[address];
        end
    end
endmodule
