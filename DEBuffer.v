module DEBuffer(aluSignals, IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC,
ST,SST,STOut, SSTOut, Reg1,Reg2,Instruction,SrcAddress,RegDestination,Clk, Reg1Out, Reg2Out, 
InstructionOut, SrcAddressOut, RegDestinationOut,FlashNumOut,FlashNumIn, IROut, IWOut, MROut, MWOut, MTROut, ALU_srcOut, RWOut, BranchOut, SetCOut, 
    CLRCOut, aluSignalsOut, instr, instrOut);


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


// Regs in the buffer
reg STReg;
reg SSTReg;
reg IRReg, IWReg, MRReg, MWReg, MTRReg, ALU_srcReg, RWReg, BranchReg, SetCReg, CLRCReg;
reg [1:0] FlashNumReg;
reg [15:0] Reg1Reg,Reg2Reg, instrReg;
reg [4:0]  InstructionReg;
reg [2:0]  SrcAddressReg;
reg [2:0]  RegDestinationReg;
reg [3:0]  aluSignalsReg;



always@(negedge Clk)
begin
    FlashNumReg=FlashNumIn;
    STReg=ST;
    SSTReg=SST;
    Reg1Reg=Reg1;
    Reg2Reg=Reg2;
    InstructionReg=Instruction;
    SrcAddressReg=SrcAddress;
    RegDestinationReg=RegDestination;
    IRReg = IR;
    IWReg = IW;
    MRReg = MR;
    MWReg = MW;
    MTRReg = MTR;
    ALU_srcReg = ALU_src;
    RWReg = RW;
    BranchReg = Branch;
    SetCReg = SetC;
    CLRCReg = CLRC;
    aluSignalsReg = aluSignals;
    instrReg = instr;
end

always@(posedge Clk)
begin
    FlashNumOut=FlashNumReg;
    STOut=STReg;
    SSTOut=SSTReg;
    Reg1Out=Reg1Reg;
    Reg2Out=Reg2Reg;
    InstructionOut=InstructionReg;
    SrcAddressOut=SrcAddressReg;
    RegDestinationOut=RegDestinationReg;
    IROut = IRReg;
    IWOut = IWReg;
    MROut = MRReg;
    MWOut = MWReg;
    MTROut = MTRReg;
    ALU_srcOut = ALU_srcReg;
    RWOut = RWReg;
    BranchOut = BranchReg;
    SetCOut = SetCReg;
    CLRCOut = CLRCReg;
    aluSignalsOut = aluSignalsReg;
    instrOut = instrReg;
end
endmodule
