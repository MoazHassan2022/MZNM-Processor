`include "defines.v"

module ALU(aluSignals,firstOperand,secondOperand,result,zeroFlag,carryFlag,overFlowFlag,negativeFlag);
input [3:0] aluSignals;
input [15:0] firstOperand,secondOperand;
output [15:0] result;
output zeroFlag,carryFlag,overFlowFlag,negativeFlag;
wire zeroFlagTemp,negativeFlagTemp, overFlowFlagTemp;


assign zeroFlagTemp = (result==16'd0);
assign overFlowFlagTemp = (firstOperand[15] ^ result[15]) & (secondOperand[15] ^ result[15]);
assign negativeFlagTemp = result[15];
assign {overFlowFlag,zeroFlag,negativeFlag,carryFlag,result} = 
		(aluSignals == `ALU_NOP)?{1'b0,1'b0,1'b0,17'd0}:
                (aluSignals == `ALU_NOT)?{1'b0,zeroFlagTemp,negativeFlagTemp,1'b0,~firstOperand}:
                (aluSignals == `ALU_STD)?{1'b0,1'b0,1'b0,1'b0,firstOperand}: // aluOut must be Rdst
                (aluSignals == `ALU_LDD)?{1'b0,1'b0,1'b0,1'b0,secondOperand}: // aluOut must be Rsrc
                (aluSignals == `ALU_JMP)?{1'b0,1'b0,1'b0,1'b0,firstOperand}: // aluOut must be Rdst
                (aluSignals == `ALU_INC)?{overFlowFlagTemp,zeroFlagTemp,negativeFlagTemp,firstOperand+1}:
                (aluSignals == `ALU_DEC)?{overFlowFlagTemp,zeroFlagTemp,negativeFlagTemp,firstOperand-1}:
                (aluSignals == `ALU_MOV)?{1'b0,1'b0,1'b0,1'b0,secondOperand}:
                (aluSignals == `ALU_ADD)?{overFlowFlagTemp,zeroFlagTemp,negativeFlagTemp,firstOperand+secondOperand}:
                (aluSignals == `ALU_SUB)?{overFlowFlagTemp,zeroFlagTemp,negativeFlagTemp,firstOperand-secondOperand}:   /*rdst= rdst-rsrc*/
                (aluSignals == `ALU_AND)?{1'b0,zeroFlagTemp,negativeFlagTemp,1'b0,firstOperand&secondOperand}:
                (aluSignals == `ALU_OR)?{1'b0,zeroFlagTemp,negativeFlagTemp,1'b0,firstOperand|secondOperand}:
                (aluSignals == `ALU_SHL)?(secondOperand == 16'b0 ? {1'b0,zeroFlagTemp,negativeFlagTemp,1'b0, firstOperand} : {1'b0,zeroFlagTemp,negativeFlagTemp,firstOperand[15 - (secondOperand - 1)] , firstOperand << secondOperand}) : 
                (aluSignals == `ALU_SHR)?(secondOperand == 16'b0) ? {1'b0,zeroFlagTemp,negativeFlagTemp,1'b0, firstOperand} : {1'b0,zeroFlagTemp,negativeFlagTemp,firstOperand[secondOperand - 1], firstOperand >> secondOperand} :
                (aluSignals == `ALU_SETC)?{1'b0,1'b0,1'b0,1'b1, 16'b0}: /// we just raised the setC to 1, in CLRC we pass ALU_NOP that clears carry
                17'dx;

endmodule



