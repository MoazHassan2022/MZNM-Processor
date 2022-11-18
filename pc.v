module PC (extendedAddress, pcSrc, pc, reset, clk);
// pcSrc = 0 => old pc+2, pcSrc = 1 => aluOut(branch result address) 
// reset = 1 => 32d, reset = 0 => evaluate
input  [31:0] extendedAddress;
input pcSrc, reset, clk;
output reg [31:0] pc;
always@(posedge clk)
begin
	if(reset === 1'b1)
	begin
		pc =  32'd30; // 30d
	end
	else if(pcSrc === 1'b1)
	begin
		pc = extendedAddress;
	end
	else
	begin
		pc = pc + 32'b10;
	end
end
endmodule