module Fetch (pc, instr, instrMem);
input  [31:0] pc;
output reg [31:0] instr;
input wire [0:16777216] instrMem; // 2*20 * 2 * 8  (must be flattened)
assign instr = instrMem[32'd16*(pc)+:32'd31];
endmodule