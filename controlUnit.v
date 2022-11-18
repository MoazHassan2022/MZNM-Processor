`include "defines.v"

module ControlUnit (
    opcode, aluSignals, IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC
);

/// defining the inputs 
input [4:0] opcode; 


/// defining the outputs [IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC] signals
output reg IR; 
output reg IW;
output reg MR;
output reg MW;
output reg MTR;
output reg ALU_src; 
output reg RW; 
output reg Branch; 
output reg SetC; 
output reg CLRC; 
output reg [3:0] aluSignals; 


always @(*) begin
    /// R Operations
    if(opcode == `OP_NOT) begin
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `ALU_SIGNALS; 
        aluSignals = `ALU_NOT; 
    end else if(opcode == `OP_INC) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `ALU_SIGNALS; 
        aluSignals = `ALU_INC; 
      end
    else if(opcode == `OP_DEC) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `ALU_SIGNALS; 
        aluSignals = `ALU_DEC; 
      end
    else if(opcode == `OP_MOV) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `ALU_SIGNALS; 
        aluSignals = `ALU_MOV; 
      end
    else if(opcode == `OP_ADD) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `ALU_SIGNALS; 
        aluSignals = `ALU_ADD; 
      end
    else if(opcode == `OP_SUB) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `ALU_SIGNALS; 
        aluSignals = `ALU_SUB; 
      end
    else if(opcode == `OP_AND) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `ALU_SIGNALS; 
        aluSignals = `ALU_AND; 
      end
    else if(opcode == `OP_OR) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `ALU_SIGNALS; 
        aluSignals = `ALU_OR; 
      end
    else if(opcode == `OP_SHL) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `ALU_SIGNALS; 
        aluSignals = `ALU_SHL; 
      end
    else if(opcode == `OP_SHR) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `ALU_SIGNALS; 
        aluSignals = `ALU_SHR; 
      end

    /// I Operations
    else if(opcode == `OP_PUSH) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0001000000; 
        aluSignals = `ALU_NOP; 
      end
    else if(opcode == `OP_POP) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0010101000; 
        aluSignals = `ALU_NOP; 
      end
    else if(opcode == `OP_LDM) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0000011000; 
        aluSignals = `ALU_MOV; // LDM is an instruction in which we move immediate value to Rdst  
      end
    else if(opcode == `OP_LDD) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0010101000; // ALU_src must be 0
        aluSignals = `ALU_LDD; 
      end
    else if(opcode == `OP_STD) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0001000000; // ALU_src must be 0
        aluSignals = `ALU_STD; 
      end
    ///  J operations
    else if(opcode == `OP_JZ) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `BRANCH_SIGNALS; 
        aluSignals = `ALU_NOP; 
      end
    else if(opcode == `OP_JN) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `BRANCH_SIGNALS; 
        aluSignals = `ALU_NOP; 
      end
    else if(opcode == `OP_JC) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `BRANCH_SIGNALS; 
        aluSignals = `ALU_NOP; 
      end
    else if(opcode == `OP_JMP) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `BRANCH_SIGNALS; 
        aluSignals = `ALU_NOP; 
      end
    else if(opcode == `OP_Call) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `BRANCH_SIGNALS; 
        aluSignals = `ALU_NOP; 
      end
    else if(opcode == `OP_Ret) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `BRANCH_SIGNALS; 
        aluSignals = `ALU_NOP; 
      end
    else if(opcode == `OP_RTI) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `BRANCH_SIGNALS; 
        aluSignals = `ALU_NOP; 
      end
    /// other operations 
    else if(opcode == `OP_Rst) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0; 
        aluSignals = `ALU_NOP; 
      end
    else if(opcode == `OP_INT) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0001000100; 
        aluSignals = `ALU_NOP; 
      end
    else if(opcode == `OP_OUT) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0110000000; 
        aluSignals = `ALU_NOP; 
      end
    else if(opcode == `OP_IN) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b1001000000; 
        aluSignals = `ALU_NOP; 
      end
    else if(opcode == `OP_NOP) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0; 
        aluSignals = `ALU_NOP; 
      end
    else if(opcode == `OP_SETC) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0000000010; 
        aluSignals = `ALU_NOP; 
      end
    else if(opcode == `OP_CLCR) begin 
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0000000001; 
        aluSignals = `ALU_NOP; 
      end
end
   
endmodule