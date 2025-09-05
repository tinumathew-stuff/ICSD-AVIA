`timescale 1ns/1ps
module tb_operand_select;
    localparam WIDTH = 8;
    reg [WIDTH-1:0] reg_in, mask;
    reg [$clog2(WIDTH)-1:0] pos;
    reg mode;
    wire [WIDTH-1:0] out;

    operand_select #(.WIDTH(WIDTH)) dut (
        .reg_in(reg_in), .mask(mask), .pos(pos), .mode(mode), .out(out)
    );

    initial begin
        $monitor("T=%0t mode=%b reg_in=%b mask=%b pos=%0d out=%b", 
                  $time, mode, reg_in, mask, pos, out);
        // Dynamic mask
        reg_in = 8'b10110101; mask = 8'b11110000; pos = 0; mode = 0; #10;
        // Bit select (pos=2)
        mode = 1; pos = 2; #10;
        // Dynamic mask again
        mode = 0; mask = 8'b00001111; #10;
        // Bit select (pos=7)
        mode = 1; pos = 7; #10;
        $finish;
    end

endmodule
