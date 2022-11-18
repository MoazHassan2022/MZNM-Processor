`include "defines.v"

module ALU(aluSignals,firstOperand,secondOperand,result,zeroFlag,carryFlag,overFlowFlag,negativeFlag);
input [3:0] aluSignals;
input [15:0] firstOperand,secondOperand;
output [15:0] result;
output zeroFlag,carryFlag,overFlowFlag,negativeFlag;


assign zeroFlag = (result==16'd0);
assign overFlowFlag = (firstOperand[15] ^ result[15]) & (secondOperand[15] ^ result[15]);
assign negativeFlag = result[15];
assign {carryFlag,result} = 
		(aluSignals == `ALU_NOP)?17'd0:
                (aluSignals == `ALU_NOT)?{1'b0,~firstOperand}:
                (aluSignals == `ALU_INC)?firstOperand+1:
                (aluSignals == `ALU_DEC)?firstOperand-1:
                (aluSignals == `ALU_MOV)?{1'b0,firstOperand}:
                (aluSignals == `ALU_ADD)?firstOperand+secondOperand:
                (aluSignals == `ALU_SUB)?firstOperand-secondOperand:
                (aluSignals == `ALU_AND)?{1'b0,firstOperand&secondOperand}:
                (aluSignals == `ALU_OR)? {1'b0,firstOperand|secondOperand}:
                (aluSignals == `ALU_SHL)?{1'b0,firstOperand<<secondOperand}:
                (aluSignals == `ALU_SHR)?{1'b0,firstOperand>>secondOperand}:
                17'dx;

endmodule
