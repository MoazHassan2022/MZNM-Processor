module PC (aluOut, pcSrc, pc, reset, clk);
// pcSrc = 0 => old pc+2, pcSrc = 1 => aluOut(branch result address) 
// reset = 1 => 32d, reset = 0 => evaluate
input  [31:0] aluOut;
input pcSrc, reset, clk;
output reg [31:0] pc;
always@(posedge clk)
begin
	if(reset === 1'b1)
	begin
		pc =  32'h20;
	end
	else if(pcSrc === 1'b1)
	begin
		pc =  aluOut;
	end
	else
	begin
		pc = pc + 32'b10;
	end
end
endmodule