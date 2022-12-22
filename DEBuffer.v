module DEBuffer(aluSignals, IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC,
ST,SST,STOut, SSTOut, Reg1,Reg2,Instruction,SrcAddress,RegDestination,Clk, Reg1Out, Reg2Out, 
InstructionOut, SrcAddressOut, RegDestinationOut,FlashNumOut,FlashNumIn, IROut, IWOut, MROut, MWOut, MTROut, ALU_srcOut, RWOut, BranchOut, SetCOut, 
    CLRCOut, aluSignalsOut, instr, instrOut,  
    shift, 
    shiftOut
    );


// Inputs to the buffer
input Clk;
input ST;
input SST;
input IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC;
input [15:0] Reg1,Reg2, instr;
input [4:0]  Instruction;
input [2:0]  SrcAddress;
input [2:0]  RegDestination;
input [1:0]  FlashNumIn;
input [3:0]  aluSignals;
input shift;

// Outputs from the buffer
output reg   STOut;
output reg   SSTOut;
output reg  [15:0] Reg1Out;
output reg  [15:0] Reg2Out;
output reg  [15:0] instrOut;
output reg  [4:0]  InstructionOut;
output reg  [2:0]  SrcAddressOut;
output reg  [2:0]  RegDestinationOut;
output reg  [1:0]  FlashNumOut;
output reg IROut, IWOut, MROut, MWOut, MTROut, ALU_srcOut, RWOut, BranchOut, SetCOut, CLRCOut;
output reg [3:0] aluSignalsOut;
output reg shiftOut;



always@(negedge Clk)
begin
    FlashNumOut=FlashNumIn;
    STOut=ST;
    SSTOut=SST;
    Reg1Out=Reg1;
    Reg2Out=Reg2;
    InstructionOut=Instruction;
    SrcAddressOut=SrcAddress;
    RegDestinationOut=RegDestination;
    IROut = IR;
    IWOut = IW;
    MROut = MR;
    MWOut = MW;
    MTROut = MTR;
    ALU_srcOut = ALU_src;
    RWOut = RW;
    BranchOut = Branch;
    SetCOut = SetC;
    CLRCOut = CLRC;
    aluSignalsOut = aluSignals;
    instrOut = instr;
    shiftOut = shift;
end
endmodule
