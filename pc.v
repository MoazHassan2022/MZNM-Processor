module PC (aluOut, memData, branchAddress, pcSrc, pc, reset, clk, firstTimeINTAfterD2E, firstTimeCallAfterD2E, firstTimeRETAfterE2M);
// pcSrc = 00 => old pc+1, pcSrc = 01 => branchAddress(branch result address), pcSrc = 10 => old pc
// firstTimeINTAfterD2E = 11 => pc = 0
// reset = 1 => 32d, reset = 0 => evaluate
input  [15:0] aluOut, memData, branchAddress;
input [1:0] pcSrc, firstTimeCallAfterD2E, firstTimeRETAfterE2M, firstTimeINTAfterD2E;
input reset, clk;
output reg [31:0] pc;

always@(negedge clk)
begin
	if(reset === 1'b1)
	begin
		pc =  32'd32; // 32d is the first place in instruction memory, 0 is for interrupt handling routine
	end
	else if(firstTimeINTAfterD2E === 2'b11)
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
		pc = {16'b0,branchAddress};
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