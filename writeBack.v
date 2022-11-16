module WriteBack (memData, aluData, regWrite, memToReg, outputData);
// regWrite 0 => no write back, 1 => write back
// memToReg 0 => take aluData, 1 => take memData
input  [15:0] memData, aluData;
input regWrite, memToReg;
output [15:0] outputData;
assign outputData = (regWrite === 1'b1) ? ((memToReg === 1'b0) ? aluData : memData) : 16'bx;
endmodule