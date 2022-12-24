`include "defines.v"

module ControlUnit (
    opcode, aluSignals, IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, 
    CLRC,StIn,SstIn,StOut,SstOut,FlushNumIn,FlushNumOut,PCHazard,NopSignal,
    shift, enablePushOrPop
);

/// defining the inputs 
input [4:0] opcode; 
input  StIn;
input  SstIn;
input  [1:0] FlushNumIn;
input NopSignal; 


/// defining the outputs [IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC] signals
// St,SSt signals to handle the LDM instr
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
output reg StOut;
output reg SstOut;
output reg [1:0] FlushNumOut;
output reg PCHazard;
output reg shift; // this signal inform me if this instruction was shift or not 
output reg [1:0] enablePushOrPop; // 00 => no push or pop, 01 => push, 11 => pop



/*
  hints:
    the Flashing number will work with the RTI and RET to save the number of the bubbles
  Work Flow:
    first : will check the Number of Flashing 
      if(Number of Flashing > 0)
      {
        //will decrement it by one and then put nop operation
        // will return a signal to the hazard detection unit to return the pc to the previous value
      }
    second: if Flashing equal zero
      if(Flashing equal zero)
      {
        //will check the St and Sst to know if the previous instruction was LDM or not
        if(St==1 and Sst==1)
        {
          // it mean that was LDM inst
          // and we should put LDM signals now
          // and make Stout=1(will help me in the Alu to take the second 16bits withou operations) and Sst=0
        }
        else
        {
          //will put St=0 and Sst=0
          // and check the type of the instruction
        }
      }
*/
always @(*) begin
    if(FlushNumIn>0)
    begin
      FlushNumOut=FlushNumIn-1;
      PCHazard=1;
      {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0; 
      aluSignals = `ALU_NOP; 
      enablePushOrPop = 2'b00;
      shift = 1'b0;
    end
    if(NopSignal==1)
    begin
      {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0; 
      aluSignals = `ALU_NOP; 
      enablePushOrPop = 2'b00;
      shift = 1'b0;
    end
    else
      begin
        // it is the second cycle after detecting that it was LDM inst
        if(StIn==1&&SstIn==1)
          begin
            {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0000011000; 
              aluSignals = `ALU_MOV;
              StOut=1;
              SstOut=0;
              enablePushOrPop = 2'b00;
              shift = 1'b0;
          end
        else
          begin
              StOut=0;
              SstOut=0;
            if(opcode == `OP_NOT) begin
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `ALU_SIGNALS; 
              aluSignals = `ALU_NOT;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
          end else if(opcode == `OP_INC) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `ALU_SIGNALS; 
              aluSignals = `ALU_INC;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_DEC) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `ALU_SIGNALS; 
              aluSignals = `ALU_DEC;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_MOV) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `ALU_SIGNALS; 
              aluSignals = `ALU_MOV;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_ADD) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `ALU_SIGNALS; 
              aluSignals = `ALU_ADD;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_SUB) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `ALU_SIGNALS; 
              aluSignals = `ALU_SUB;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_AND) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `ALU_SIGNALS; 
              aluSignals = `ALU_AND;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_OR) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `ALU_SIGNALS; 
              aluSignals = `ALU_OR;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_SHL) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `ALU_SIGNALS; 
              aluSignals = `ALU_SHL;
              shift = 1'b1;
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_SHR) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `ALU_SIGNALS; 
              aluSignals = `ALU_SHR;
              shift = 1'b1;
              enablePushOrPop = 2'b00;
            end
          /// I Operations
          else if(opcode == `OP_PUSH) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0001000000; 
              aluSignals = `ALU_MOV;
              shift = 1'b0;
              enablePushOrPop = 2'b01; 
            end
          else if(opcode == `OP_POP) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0010101000; 
              aluSignals = `ALU_MOV;
              shift = 1'b0; 
              enablePushOrPop = 2'b11;
            end
          else if(opcode == `OP_LDM) begin 
            // in this part will put the St,SSt=1 and put Nop operation 
              StOut=1;
              SstOut=1;
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0; 
              aluSignals = `ALU_NOP;
              shift = 1'b0;  
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_LDD) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0010101000; // ALU_src must be 0
              aluSignals = `ALU_LDD;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_STD) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0001000000; // ALU_src must be 0
              aluSignals = `ALU_STD;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          ///  J operations
          else if(opcode == `OP_JZ) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `BRANCH_SIGNALS; 
              aluSignals = `ALU_JMP;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_JN) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `BRANCH_SIGNALS; 
              aluSignals = `ALU_JMP;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_JC) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `BRANCH_SIGNALS; 
              aluSignals = `ALU_JMP;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_JMP) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `BRANCH_SIGNALS; 
              aluSignals = `ALU_JMP;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_Call) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `BRANCH_SIGNALS; 
              aluSignals = `ALU_NOP;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_Ret) begin 
              FlushNumOut=2'd2;
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `BRANCH_SIGNALS; 
              aluSignals = `ALU_NOP;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_RTI) begin 
              FlushNumOut=2'd3;
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = `BRANCH_SIGNALS; 
              aluSignals = `ALU_NOP;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          /// other operations 
          else if(opcode == `OP_Rst) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0; 
              aluSignals = `ALU_NOP;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_INT) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0001000100; 
              aluSignals = `ALU_NOP;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_OUT) begin 
              // {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0110000000; 
              /// here we just raise the Out write signal and the alu will just move the data which comes to it
              /// which should be value inside the Rdst comes from the instruction itself. 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0100000000; 
              aluSignals = `ALU_MOV;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_IN) begin 
              /// TODO: DON'T FORGET TO DETECT AND SOLVE IF THERE ARE ANY HAZARDS DURING THE IN OPERATIONS.
              // {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b1001000000; /// old 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b1000001000;
              /// IR = 1 -> because I will read from the input port. 
              /// RW = 1 -> because I will write to the register file in the destation. 
              aluSignals = `ALU_MOV;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_NOP) begin // this is repeated. 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0; 
              aluSignals = `ALU_NOP;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_SETC) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0000000010; 
              aluSignals = `ALU_SETC;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_CLRC) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0000000001; 
              aluSignals = `ALU_NOP;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          end
      end
end
endmodule