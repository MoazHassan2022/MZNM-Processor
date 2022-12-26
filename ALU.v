`include "defines.v"

module ALU(aluSignals,firstOperand,secondOperand,result,zeroFlag,carryFlag,overFlowFlag,negativeFlag,zeroFlagOut,carryFlagOut,overFlowFlagOut,negativeFlagOut);
input [4:0] aluSignals;
input [15:0] firstOperand,secondOperand;
input zeroFlag,carryFlag,overFlowFlag,negativeFlag;
output [15:0] result;
output zeroFlagOut,carryFlagOut,overFlowFlagOut,negativeFlagOut;
wire zeroFlagTemp,negativeFlagTemp, overFlowFlagTemp;

assign zeroFlagTemp = (result==16'd0);
assign overFlowFlagTemp = (firstOperand[15] ^ result[15]) & (secondOperand[15] ^ result[15]);
assign negativeFlagTemp = result[15];
assign {overFlowFlagOut,zeroFlagOut,negativeFlagOut,carryFlagOut,result} = 
		(aluSignals == `ALU_NOP)?{overFlowFlag,zeroFlag,negativeFlag,carryFlag,16'd0}:
                (aluSignals == `ALU_NOT)?{overFlowFlag,zeroFlagTemp,negativeFlagTemp,carryFlag,~firstOperand}:
                (aluSignals == `ALU_STD)?{overFlowFlag,zeroFlag,negativeFlag,carryFlag,firstOperand}: // aluOut must be Rdst
                (aluSignals == `ALU_LDD)?{overFlowFlag,zeroFlag,negativeFlag,carryFlag,secondOperand}: // aluOut must be Rsrc
                (aluSignals == `ALU_JZ)?{overFlowFlag,1'b0,negativeFlag,carryFlag,16'd0}: 
                (aluSignals == `ALU_JN)?{overFlowFlag,zeroFlag,1'b0,carryFlag,16'd0}: 
                (aluSignals == `ALU_JC)?{overFlowFlag,zeroFlag,negativeFlag,1'b0,16'd0}:
                (aluSignals == `ALU_JMP)?{overFlowFlag,zeroFlag,negativeFlag,carryFlag,16'd0}:
                (aluSignals == `ALU_INC)?{overFlowFlag,zeroFlagTemp,negativeFlagTemp,firstOperand+1}:
                (aluSignals == `ALU_DEC)?{overFlowFlag,zeroFlagTemp,negativeFlagTemp,firstOperand-1}:
                (aluSignals == `ALU_MOV)?{overFlowFlag,zeroFlag,negativeFlag,carryFlag,secondOperand}:
                (aluSignals == `ALU_ADD)?{overFlowFlagTemp,zeroFlagTemp,negativeFlagTemp,firstOperand+secondOperand}:
                (aluSignals == `ALU_SUB)?{overFlowFlagTemp,zeroFlagTemp,negativeFlagTemp,firstOperand-secondOperand}:   /*rdst= rdst-rsrc*/
                (aluSignals == `ALU_AND)?{overFlowFlag,zeroFlagTemp,negativeFlagTemp,carryFlag,firstOperand&secondOperand}:
                (aluSignals == `ALU_OR)?{overFlowFlag,zeroFlagTemp,negativeFlagTemp,carryFlag,firstOperand|secondOperand}:
                (aluSignals == `ALU_SHL)?(secondOperand == 16'b0 ? {overFlowFlag,zeroFlagTemp,negativeFlagTemp,1'b0, firstOperand} : {overFlowFlag,zeroFlagTemp,negativeFlagTemp,firstOperand[15 - (secondOperand - 1)] , firstOperand << secondOperand}) : 
                (aluSignals == `ALU_SHR)?(secondOperand == 16'b0) ? {overFlowFlag,zeroFlagTemp,negativeFlagTemp,1'b0, firstOperand} : {overFlowFlag,zeroFlagTemp,negativeFlagTemp,firstOperand[secondOperand - 1], firstOperand >> secondOperand} :
                (aluSignals == `ALU_SETC)?{overFlowFlag,zeroFlag,negativeFlag,1'b1, 16'b0}: /// we just raised the setC to 1
                (aluSignals == `ALU_CLRC)?{overFlowFlag,zeroFlag,negativeFlag,1'b0, 16'b0}: /// we just raised the clrC to 1
                17'dx;

endmodule



