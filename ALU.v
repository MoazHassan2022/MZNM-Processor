module ALU(opCode,firstOperand,secondOperand,result,zeroFlag,carryFlag,overFlowFlag,negativeFlag);
input [3:0] opCode;
input [15:0] firstOperand,secondOperand;
output [15:0] result;
output zeroFlag,carryFlag,overFlowFlag,negativeFlag;



assign zeroFlag = (result==16'd0);
assign overFlowFlag = (firstOperand[15] ^ result[15]) & (secondOperand[15] ^ result[15]);
assign negativeFlag = result[15];
assign {carryFlag,result} = (opCode == `ALU_NOP)?17'd0:
                (opCode == `ALU_NOT)?!{0,firstOperand}:
                (opCode == `ALU_INC)?firstOperand+1:
                (opCode == `ALU_DEC)?firstOperand-1:
                (opCode == `ALU_MOV)?{0,firstOperand}:
                (opCode == `ALU_ADD)?firstOperand+secondOperand:
                (opCode == `ALU_SUB)?firstOperand-secondOperand:
                (opCode == `ALU_AND)?{0,firstOperand&secondOperand}:
                (opCode == `ALU_OR)? {0,firstOperand|secondOperand}:
                (opCode == `ALU_SHL)?{0,firstOperand<<secondOperand}:
                (opCode == `ALU_SHR)?{0,firstOperand>>secondOperand}:
                17'dx;


endmodule
