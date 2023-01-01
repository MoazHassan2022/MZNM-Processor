module DataMemory (Clk,MemeWrite,MemeRead,DataIn,DataOut,Addr);
input  MemeWrite,MemeRead,Clk;
input [15:0] DataIn;
output reg [15:0] DataOut;
input [10:0] Addr;
reg [15:0]  Memo [0:2047];

integer i;

initial begin 
    for(i = 0; i <= 2047; i = i + 1)
        Memo[i] = 16'b0;
    $readmemb("dataMemory.txt", Memo);
end

assign DataOut = MemeRead === 1'b1 ? Memo[Addr] : 16'b0;
always @(negedge Clk) begin
    if(MemeWrite==1'b1)
    begin
        Memo[Addr]=DataIn;
    end
    $display("Memo[%h] = %h", Addr, Memo[Addr]);
end

endmodule
