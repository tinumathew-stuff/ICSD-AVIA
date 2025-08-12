`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.08.2025 09:55:34
// Design Name: 
// Module Name: tb_regA
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps
module tb_regA();

    reg clk;
    reg rw;
    reg [6:0] addr;
    reg [63:0] data_in;
    wire [63:0] data_out;

  
    regA uut (
        .clk(clk),
        .rw(rw),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out)
    );

  
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rw = 0; 
        addr = 7'b0000001;
        data_in = 64'h123456789ABCDEF0;
        #10;

        rw = 0; 
        addr = 7'b0000010;
        data_in = 64'hFEDCBA9876543210;
        #10;

        rw = 1; 
        addr = 7'b0000001;
        #10;

        rw = 1; 
        addr = 7'b0000010;
        #10;

        $finish;
    end
endmodule

