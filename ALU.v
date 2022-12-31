`include "defines.v"

module ALU(aluSignals,firstOperand,secondOperand,result,zeroFlag,carryFlag,overFlowFlag,negativeFlag,zeroFlagOut,carryFlagOut,overFlowFlagOut,negativeFlagOut, freezedCCR);
input [4:0] aluSignals;
input [15:0] firstOperand,secondOperand;
input zeroFlag,carryFlag,overFlowFlag,negativeFlag;
input [3:0] freezedCCR; // [3: NF, 2: OF, 1: CF, 0: ZF]

output [15:0] result;
output zeroFlagOut,carryFlagOut,overFlowFlagOut,negativeFlagOut;

wire zeroFlagTemp,negativeFlagTemp,overFlowFlagTemp,expectedZeroFlagOut,expectedOverFlowFlagOut,expectedNegativeFlagOut;
wire [16:0] resultWithCarry, resultOfInc, resultOfDec, resultOfAdd, resultOfSub;

assign resultOfInc = firstOperand+1;
assign resultOfDec = firstOperand-1;
assign resultOfAdd = firstOperand+secondOperand;
assign resultOfSub = secondOperand-firstOperand;

assign result = resultWithCarry[15:0];
assign zeroFlagTemp = (result==16'd0);
assign overFlowFlagTemp = (firstOperand[15] ^ result[15]) & (secondOperand[15] ^ result[15]);
assign negativeFlagTemp = result[15];
assign zeroFlagOut = (expectedZeroFlagOut === 1'b1) ? 1'b1 : 1'b0;
assign carryFlagOut = (resultWithCarry[16] === 1'b1) ? 1'b1 : 1'b0;
assign overFlowFlagOut = (expectedOverFlowFlagOut === 1'b1) ? 1'b1 : 1'b0;
assign negativeFlagOut = (expectedNegativeFlagOut === 1'b1) ? 1'b1 : 1'b0;
assign {expectedOverFlowFlagOut,expectedZeroFlagOut,expectedNegativeFlagOut,resultWithCarry} = 
                (aluSignals == `ALU_RTI)?{freezedCCR[2],freezedCCR[0],freezedCCR[3],freezedCCR[1],16'd0}: // restore flags
		(aluSignals == `ALU_NOP)?{overFlowFlag,zeroFlag,negativeFlag,carryFlag,16'd0}:
                (aluSignals == `ALU_NOT)?{overFlowFlag,zeroFlagTemp,negativeFlagTemp,carryFlag,~firstOperand}:
                (aluSignals == `ALU_STD)?{overFlowFlag,zeroFlag,negativeFlag,carryFlag,firstOperand}: // aluOut must be Rdst
                (aluSignals == `ALU_LDD)?{overFlowFlag,zeroFlag,negativeFlag,carryFlag,secondOperand}: // aluOut must be Rsrc
                (aluSignals == `ALU_JZ)?{overFlowFlag,1'b0,negativeFlag,carryFlag,16'd0}: 
                (aluSignals == `ALU_JN)?{overFlowFlag,zeroFlag,1'b0,carryFlag,16'd0}: 
                (aluSignals == `ALU_JC)?{overFlowFlag,zeroFlag,negativeFlag,1'b0,16'd0}:
                (aluSignals == `ALU_JMP)?{overFlowFlag,zeroFlag,negativeFlag,carryFlag,16'd0}:
                (aluSignals == `ALU_INC)?{overFlowFlag,zeroFlagTemp,negativeFlagTemp,resultOfInc}:
                (aluSignals == `ALU_DEC)?{overFlowFlag,zeroFlagTemp,negativeFlagTemp,resultOfDec}:
                (aluSignals == `ALU_MOV)?{overFlowFlag,zeroFlag,negativeFlag,carryFlag,secondOperand}:
                (aluSignals == `ALU_ADD)?{overFlowFlagTemp,zeroFlagTemp,negativeFlagTemp,resultOfAdd}:
                (aluSignals == `ALU_SUB)?{overFlowFlagTemp,zeroFlagTemp,negativeFlagTemp,resultOfSub}:   /*rdst= rdst-rsrc*/
                (aluSignals == `ALU_AND)?{overFlowFlag,zeroFlagTemp,negativeFlagTemp,carryFlag,firstOperand&secondOperand}:
                (aluSignals == `ALU_OR)?{overFlowFlag,zeroFlagTemp,negativeFlagTemp,carryFlag,firstOperand|secondOperand}:
                (aluSignals == `ALU_SHL)?(secondOperand == 16'b0 ? {overFlowFlag,zeroFlagTemp,negativeFlagTemp,1'b0, firstOperand} : {overFlowFlag,zeroFlagTemp,negativeFlagTemp,firstOperand[15 - (secondOperand - 1)] , firstOperand << secondOperand}) : 
                (aluSignals == `ALU_SHR)?(secondOperand == 16'b0) ? {overFlowFlag,zeroFlagTemp,negativeFlagTemp,1'b0, firstOperand} : {overFlowFlag,zeroFlagTemp,negativeFlagTemp,firstOperand[secondOperand - 1], firstOperand >> secondOperand} :
                (aluSignals == `ALU_SETC)?{overFlowFlag,zeroFlag,negativeFlag,1'b1, 16'b0}: /// we just raised the setC to 1
                (aluSignals == `ALU_CLRC)?{overFlowFlag,zeroFlag,negativeFlag,1'b0, 16'b0}: /// we just raised the clrC to 1
                20'd0;

endmodule



