module PC (aluOut, pcSrc, pc, reset, clk, interruptSignal);
// pcSrc = 00 => old pc+1, pcSrc = 01 => aluOut(branch result address), pcSrc = 10 => old pc-1
// interruptSignal = 11 => pc = 0, interruptSignal = 01 => pc = 30
// reset = 1 => 32d, reset = 0 => evaluate
input  [15:0] aluOut;
input [1:0] pcSrc, interruptSignal;
input reset, clk;
output reg [31:0] pc;
always@(posedge clk)
begin
	if(reset === 1'b1 || interruptSignal === 2'b01)
	begin
		pc =  32'd31; // 32d is the first place in instruction memory, then make it 31 to be 32 when incremented, 0 is for interrupt handling routine
	end
	else if(interruptSignal === 2'b11)
	begin
		pc =  32'd0;
	end
	else if(pcSrc === 2'b01)
	begin
		pc = pc + {16'b0,aluOut}; // Jump to an address that is summed with the current pc
	end
	else if(pcSrc === 2'b10)
	begin
		pc = pc - 32'b1;
	end
	else
	begin
		pc = pc + 32'b1;
	end
end
endmodule