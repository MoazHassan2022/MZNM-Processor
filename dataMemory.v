module DataMemory (Clk,MemeWrite,MemeRead,DataIn,DataOut,Addr);
input  MemeWrite,MemeRead,Clk;
input [15:0] DataIn;
output [15:0] DataOut;
input [10:0] Addr;
reg [15:0]  Memo [2047:0];
reg [15:0] DataOut;
always @(negedge Clk) begin
    if(MemeWrite==1'b1)
    begin
        Memo[Addr]=DataIn;
    end
    if(MemeRead==1'b1)
    begin
        DataOut=Memo[Addr];
    end
end

endmodule
