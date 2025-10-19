`timescale 1ns/1ps
module tb_tri_regfile();
    reg clk;
    reg parallel_enable;
    reg [3:0] opcode;
    reg [8:0] mask;
    reg [5:0] possel;
    reg rw;
    reg [1:0] reg_sel;
    reg [6:0] addr;
    reg [63:0] data_in;
    wire [63:0] data_out;

    tri_regfile uut (
        .clk(clk),
        .parallel_enable(parallel_enable),
        .opcode(opcode),
        .mask(mask),
        .possel(possel),
        .rw(rw),
        .reg_sel(reg_sel),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out)
    );

    // clock: 10 ns period
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_tri_regfile.vcd");
        $dumpvars(0, tb_tri_regfile);

        // init
        clk = 0;
        parallel_enable = 0;
        opcode = 4'h0;
        mask = 9'b0;
        possel = 6'b0;
        rw = 1; reg_sel = 2'b00; addr = 7'd0; data_in = 64'h0;

        #10;
        // write reg1[5] = AAAAAAAA...
        rw = 0; reg_sel = 2'b00; addr = 7'd5; data_in = 64'hAAAAAAAAAAAAAAAA; #10;
        // write reg2[5] = 55555555...
        rw = 0; reg_sel = 2'b01; addr = 7'd5; data_in = 64'h5555555555555555; #10;

        // perform reg->reg AND: reg3[5] = reg1[5] & reg2[5], full-word byte mask
        // possel: [5:4]=C=11, [3:2]=B=01, [1:0]=A=00 -> 11_01_00
        possel = 6'b110100;
        opcode = 4'h1; // AND
        mask = 9'b0_11111111; // byte mode, all bytes enabled
        parallel_enable = 1; #10;
        parallel_enable = 0; #10; // operation done

        // read back reg3[5]
        rw = 1; reg_sel = 2'b11; addr = 7'd5; #10;
        $display("REG3[5] = %h (expected A & 5 = 0x0000000000000000? or results depending on patterns)", data_out);

        #10;
        $finish;
    end
endmodule
