module memory (
    input  wire         clk,rw    
    input  wire [6:0]   addrs,    
    input  wire [63:0]  datain, 
    output reg  [63:0]  dataout   
);

    reg [63:0] mem [0:127];

    always @(posedge clk) begin
        if (rw) begin
           
            mem[addr] <= datain;
        end else begin
            dataout <= mem[addrs];
        end
    end

endmodule