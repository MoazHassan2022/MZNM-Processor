module DataMemory (Clk,MemeWrite,MemeRead,DataIn,DataOut,Addr);
input  MemeWrite,MemeRead,Clk;
input [15:0] DataIn;
output reg [15:0] DataOut;
input [10:0] Addr;
reg [15:0]  Memo [2047:0];
assign DataOut = MemeRead === 1'b1 ? Memo[Addr] : 16'bx;
always @(negedge Clk) begin
    $display("DataMemory[11'b1111_1111_101] = %d", Memo[11'b1111_1111_101]);
    if(MemeWrite==1'b1)
    begin
        Memo[Addr]=DataIn;
    end
end

endmodule
