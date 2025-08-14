module reg_1 (
    input clk,
    input rw,                  
    input [6:0] addr,          
    input [63:0] data_in,     
    output reg [63:0] data_out
);

    reg [63:0] A [0:127]; 
    always @(posedge clk) begin
        if (rw)
            data_out <= A[addr];   
        else
            A[addr] <= data_in;    
    end
endmodule
