module FDBuffer(clk, pc, instr, pcOut, instrOut);


// Inputs to the buffer
input [15:0] instr;
input [31:0] pc;
input clk;

// Outputs from the buffer
output reg  [15:0] instrOut;
output reg [31:0] pcOut;

always@(posedge clk)
begin
    instrOut = instr;
    pcOut = pc;
end
endmodule
