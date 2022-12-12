module IntructionMemory (pc, instr, clk, writeAddress, writeData, writeEnable);
input  [31:0] pc;
input clk, writeEnable;
input [19:0]  writeAddress;
input [15:0]  writeData;
output reg [15:0] instr;
wire [19:0] address;

reg [15:0] instrMem [0:1048576]; // 2^20 row * 16 bit

integer i;

initial begin 
    for(i = 0; i < 1048576; i = i + 1)
        instrMem[i] = 16'b0;
    $readmemb("instructionMemory.txt", instrMem);
end

assign address = pc[19:0];
assign instr = instrMem[address];
always@(negedge clk)
begin
    if(writeEnable)
    begin
        instrMem[writeAddress] = writeData;
    end
end

endmodule