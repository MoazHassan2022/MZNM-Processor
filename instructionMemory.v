module IntructionMemory (pc, instr, clk, writeAddress, writeData, writeEnable);
input  [31:0] pc;
input clk, writeEnable;
input [19:0]  writeAddress;
input [15:0]  writeData;
output reg [31:0] instr;
wire [19:0] firstAddress, secondAddress;

reg [15:0] instrMem [0:1048576]; // 2^20 row * 16 bit

assign firstAddress = pc[19:0];
assign secondAddress = pc[19:0]+1'b1;
assign instr = {instrMem[firstAddress], instrMem[secondAddress]};
always@(negedge clk)
begin
    if(writeEnable)
    begin
        instrMem[writeAddress] = writeData;
    end
end

endmodule