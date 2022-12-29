`include "defines.v"

module ControlUnit (
    opcode, aluSignals, IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, 
    CLRC,StIn,SstIn,interruptSignal,StOut,SstOut,FlushNumIn,FlushNumOut, shift,
    enablePushOrPop, firstTimeCallIn, firstTimeCallOut, firstTimeRETIn, firstTimeRETOut,
    firstTimeINTIn, firstTimeINTOut, bubbleSignal, isPush
);

/// defining the inputs 
input [4:0] opcode; 
input  StIn;
input  SstIn;
input  [1:0] FlushNumIn, firstTimeCallIn, firstTimeRETIn, firstTimeINTIn;
input bubbleSignal, interruptSignal; 


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
output reg [4:0] aluSignals;
output reg StOut;
output reg SstOut;
output reg [1:0] FlushNumOut;
output reg shift; // this signal inform me if this instruction was shift or not 
output reg [1:0] enablePushOrPop; // 00 => no push or pop, 01 => push, 11 => pop
output reg [1:0] firstTimeCallOut; // Please see the call algorithm down at handling OP_CALL instruction
output reg [1:0] firstTimeRETOut; // Please see the ret algorithm down at handling OP_RET instruction
output reg [1:0] firstTimeINTOut; // Please see the interrupt algorithm down at handling interrupt signal
output reg isPush;


always @(*) begin
    if(firstTimeINTIn === 2'b11)
    begin
      // it is the second cycle in INT
      {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0001000000; 
        aluSignals = `ALU_NOP;
        firstTimeINTOut = 2'b01;
        enablePushOrPop = 2'b01;
        shift = 1'b0;
        isPush = 1'b0;
        firstTimeCallOut = 2'b00;
        firstTimeRETOut = 2'b00;
    end
    else if(interruptSignal === 1'b1) begin 
        /*
          first cycle found interrupt = 1{
            firstTimeINT = 11, ALU_NOP, handled as a call instr, but at memory mux take the current inst PC[15:0] as it is, and at second cycle when firstTimeINT = 01, take (current instr PC - 1)[31:16]
            at pc, it takes zero when firstTimeINTAfterD2E = 11, at E2M buffer, it puts the CCR in freezedCCR when it sees firstTimeINTAfterD2E = 11
            alu takes the freezedCCRAfterE2M when RTI
          }
        */
        {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0001000000; 
        aluSignals = `ALU_NOP;
        shift = 1'b0; 
        enablePushOrPop = 2'b01; // push
        firstTimeINTOut = 2'b11; // first cycle in INT(push lower PC as it is)
        isPush = 1'b0;
        firstTimeCallOut = 2'b00;
        firstTimeRETOut = 2'b00;
      end
    else if(FlushNumIn>0)
    begin
      FlushNumOut=FlushNumIn-1;
      {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0; 
      aluSignals = `ALU_NOP; 
      enablePushOrPop = 2'b00;
      shift = 1'b0;
      isPush = 1'b0;
      firstTimeCallOut = 2'b00;
      firstTimeRETOut = 2'b00;
    end
    else if(bubbleSignal==1)
    begin
      {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0; 
      aluSignals = `ALU_NOP; 
      enablePushOrPop = 2'b00;
      shift = 1'b0;
      isPush = 1'b0;
      firstTimeCallOut = 2'b00;
      firstTimeRETOut = 2'b00;
    end
    else
      begin
        if(StIn==1&&SstIn==1)
          begin
            // it is the second cycle after detecting that it was LDM inst
            {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0000011000; 
              aluSignals = `ALU_MOV;
              StOut=1;
              SstOut=0;
              enablePushOrPop = 2'b00;
              shift = 1'b0;
              isPush = 1'b0;
          end
        else if(firstTimeCallIn === 2'b11)
          begin
            // it is the second cycle in call
            {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0001000000; 
              aluSignals = `ALU_NOP;
              firstTimeCallOut = 2'b01;
              enablePushOrPop = 2'b01;
              shift = 1'b0;
              isPush = 1'b0;
          end
          else if(firstTimeRETIn === 2'b11)
          begin
            // it is the second cycle in ret
              FlushNumOut = 2'b10;
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0010000000; 
              aluSignals = `ALU_MOV;
              shift = 1'b0; 
              enablePushOrPop = 2'b11;
              firstTimeRETOut = 2'b01;
              isPush = 1'b0;
          end
        else
          begin
              firstTimeCallOut = 2'b00;
              firstTimeRETOut = 2'b00;
              StOut=0;
              SstOut=0;
              isPush = 1'b0;
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
              isPush = 1'b1; // for selecting aluOutAfterE2M in memory stage
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
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0; 
              aluSignals = `ALU_JZ;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_JN) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0; 
              aluSignals = `ALU_JN;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_JC) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0; 
              aluSignals = `ALU_JC;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_JMP) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0; 
              aluSignals = `ALU_JMP;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          else if(opcode == `OP_Call) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0001000000; 
              aluSignals = `ALU_STD; // to make aluOut = Rdst
              shift = 1'b0; 
              enablePushOrPop = 2'b01; // push
              firstTimeCallOut = 2'b11; // first cycle in call(push lower PC + 1)
              /*
                ******* CALL ALGORITHM *******
                there are 2 bits register in the D2E buffer like st, sst, called firstTimeCall[1:0]
                If it was a call, make enablePushOrPop = 01, make firstTimeCall = 11, first 1 tells data memory that it is the first cycle in call, then it will push lower part of PC + 1, second bit tells that it is a call instr, pass ALU_JMP
                If we find here in next cycle that firstTimeCall = 11, then make enablePushOrPop = 01, make firstTimeCall = 01, pass NOP, in order to prevent writing previos instr result back, data memory will find firstTimeCall = 01, then will write the higher part of the PC as it is(it is already incremented)
                We need to pass PC in all buffers
                firstTimeCallAfterD2E must be a selector in pc mux to select aluOut as a pc new value
              */
            end
          else if(opcode == `OP_Ret) begin
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0010000000; 
              aluSignals = `ALU_MOV;
              shift = 1'b0; 
              enablePushOrPop = 2'b11;
              firstTimeRETOut = 2'b11;
              /*
                ******* RET ALGORITHM *******
                there are 2 bits register in the D2E buffer like st, sst, called firstTimeRET[1:0]
                If it was a call, make enablePushOrPop = 11, make firstTimeRET = 11, first 1 tells PC that it is the first cycle in ret, then it will take the popped into higher part of PC, second bit tells that it is a call instr
                If we find here in next cycle that firstTimeRET = 11, then make enablePushOrPop = 11, make firstTimeRET = 01, PC will find firstTimeRET = 01, then will write the popped into the lower part of the PC
              */
            end
          else if(opcode == `OP_RTI) begin 
              {IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC} = 10'b0010000000; 
              aluSignals = `ALU_RTI;
              shift = 1'b0; 
              enablePushOrPop = 2'b11;
              firstTimeRETOut = 2'b11;
              /*
                ******* RTI ALGORITHM *******
                Same as RET instruction, but the difference is that we need the alu to take the freezedCCRAfterE2M
              */
            end
          /// other operations 
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
              aluSignals = `ALU_CLRC;
              shift = 1'b0; 
              enablePushOrPop = 2'b00;
            end
          end
      end
end
endmodule