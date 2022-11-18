module IntructionMemory (pc, instr);
input  [31:0] pc;
output reg [31:0] instr;
wire [15:0] firstAddress, secondAddress;
reg [15:0] instrMem [0:1048576];
assign firstAddress = pc[19:0];
assign secondAddress = pc[19:0]+1'b1;
assign instr = {instrMem[firstAddress], instrMem[secondAddress]};
endmodule