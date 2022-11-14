module WriteBack (memData, aluData, regWrite, memToReg, outputData, clk);
// regWrite 0 => no write back, 1 => write back
// memToReg 0 => take aluData, 1 => take memData
input  [15:0] memData, aluData;
input regWrite, memToReg, clk;
output reg [15:0] outputData;
always@(posedge clk)
begin
	if(regWrite === 1'b1)
	begin 
		if(memToReg === 1'b0)
		begin
			outputData =  aluData;
		end
		else
		begin
			outputData =  memData;
		end
	end
	else
	begin
		outputData =  16'bx;
	end
end
endmodule