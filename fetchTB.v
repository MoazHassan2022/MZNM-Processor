module fetchTB;
reg [0:16777216] instrMem; // (must be flattened)
reg [31:0] aluOut;
reg clk, pcSrc, reset;
wire [31:0] pc, instr;
integer i;
PC pcCircuit(aluOut, pcSrc, pc, reset, clk);
Fetch fetch(pc, instr, instrMem);
initial begin
	reset = 1'b1;
	pcSrc = 0;
	clk = 1'b0;
	aluOut = 32'b0;
	for(i = 32; i < 40; i=i+2)
	begin
		instrMem[32'd16*(i)+:32'd31] = (i[31:0]+1'b1) * 32'd2; // dummy values in first 8 addresses in memory
		$display("32'd16*i= %d, (i[31:0]+1'b1) * 32'd2 = %d", 32'd16*i,(i[31:0]+1'b1) * 32'd2);	
	end
	#100;
	reset = 1'b0;
	$display("pc= %d, instr = %d, instrMem[512:543] = %d, 32'd16*pc = %d", pc, instr, instrMem[512:543], 32'd16*pc);	
	#100;
	$display("pc= %d, instr = %d, instrMem[544:575] = %d, 32'd16*pc = %d", pc, instr, instrMem[544:575], 32'd16*pc);	
	#100;
	aluOut = 32'd32;
	pcSrc = 1'b1;
	#100;
	pcSrc = 1'b0;
	
end
always begin
	#50;
	clk = ~clk;
end
endmodule