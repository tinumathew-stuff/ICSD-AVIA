module register (input clock,input read_write,input [6:0] address,input [63:0] datain,output reg [63:0] dataout);

    reg [63:0] A [0:127]; 
  always @(posedge clock) 
    begin
      if (read_write == 0) begin
        A[address] <= datain;
      end
        else begin
          dataout <= A[address];
        end
    end
endmodule
