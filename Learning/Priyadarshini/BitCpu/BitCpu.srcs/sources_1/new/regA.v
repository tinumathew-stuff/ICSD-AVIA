`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.08.2025 09:52:08
// Design Name: 
// Module Name: regA
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


module regA(
    input clk,
    input rw,               
    input [6:0] addr,        
    input [63:0] data_in,    
    output reg [63:0] data_out 
);

    reg [63:0] mem [0:127]; 

    always @(posedge clk) begin
        if (rw == 0) begin
            mem[addr] <= data_in;
        end
        else begin
            data_out <= mem[addr];
        end
    end

endmodule

