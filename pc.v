module PC (aluOut, memData, read_data1, pcSrc, pc, reset, clk, interruptSignal, firstTimeCallAfterD2E, firstTimeRETAfterE2M);
// pcSrc = 00 => old pc+1, pcSrc = 01 => read_data1(branch result address), pcSrc = 10 => old pc
// interruptSignal = 11 => pc = 0, interruptSignal = 01 => pc = 30
// reset = 1 => 32d, reset = 0 => evaluate
input  [15:0] aluOut, memData, read_data1;
input [1:0] pcSrc, interruptSignal, firstTimeCallAfterD2E, firstTimeRETAfterE2M;
input reset, clk;
output reg [31:0] pc;
always@(negedge clk)
begin
	if(reset === 1'b1 || interruptSignal === 2'b01)
	begin
		pc =  32'd31; // 32d is the first place in instruction memory, then make it 31 to be 32 when incremented, 0 is for interrupt handling routine
	end
	else if(interruptSignal === 2'b11)
	begin
		pc =  32'd0;
	end
	else if(firstTimeCallAfterD2E === 2'b11)
	begin
		pc = aluOut; // First time in call, we need to go the specified address
	end
	else if(firstTimeRETAfterE2M === 2'b11)
	begin
		pc[31:16] = memData; // First time in ret, we need to take higher part
	end
	else if(firstTimeRETAfterE2M === 2'b01)
	begin
		pc[15:0] = memData; // Second time in ret, we need to take the lower part
	end
	else if(pcSrc === 2'b01)
	begin
		pc = {16'b0,read_data1};
	end
	else if(pcSrc === 2'b10)
	begin
		pc = pc;
	end
	else
	begin
		pc = pc + 32'b1;
	end
end
endmodule