module FDBuffer(clk, pc, instr, interruptSignal, pcOut, instrOut, interruptSignalOut);


// Inputs to the buffer
input [15:0] instr;
input [31:0] pc;
input clk, interruptSignal;

// Outputs from the buffer
output reg  [15:0] instrOut;
output reg [31:0] pcOut;
output reg interruptSignalOut;
reg interruptSignalTemp; // used for delaying the interrupt signal for 2 cycles to make the 2 instructions in Fetch & Decode stages finish their work

always@(posedge clk)
begin
    instrOut = instr;
    pcOut = pc;
    if(interruptSignalTemp === 1'b1) begin
        interruptSignalOut = 1'b1;
        interruptSignalTemp = 1'b0;
    end
    else
        interruptSignalOut = 1'b0;
    if(interruptSignal === 1'b1)
        interruptSignalTemp = 1'b1;
end
endmodule
