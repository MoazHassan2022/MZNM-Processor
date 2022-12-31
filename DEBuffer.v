module DEBuffer(aluSignals, IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC, ST, SST, isPush, isIN, Reg1, Reg2, smallImmediate, SrcAddress,
    RegDestination, FlashNumIn, instr, shift, enablePushOrPop, firstTimeCall, firstTimeRET, firstTimeINT, pc, clk, Reg1Out, Reg2Out, smallImmediateOut, 
    SrcAddressOut, RegDestinationOut, FlashNumOut, IROut, IWOut, MROut, MWOut, MTROut, ALU_srcOut, RWOut, BranchOut, SetCOut, CLRCOut, 
    aluSignalsOut, instrOut, shiftOut, enablePushOrPopOut, firstTimeCallOut, pcOut, firstTimeRETOut, firstTimeINTOut, STOut, SSTOut, isPushOut, isINOut
);


// Inputs to the buffer
input clk, ST, SST, IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC, shift, isPush, isIN; 
input [15:0] Reg1,Reg2, instr;
input [4:0]  smallImmediate;
input [2:0]  SrcAddress;
input [2:0]  RegDestination;
input [1:0]  FlashNumIn, enablePushOrPop, firstTimeCall, firstTimeRET, firstTimeINT;
input [4:0]  aluSignals;
input [31:0] pc;

// Outputs from the buffer
output reg  [15:0] Reg1Out, Reg2Out, instrOut;
output reg  [4:0]  smallImmediateOut;
output reg  [2:0]  SrcAddressOut;
output reg  [2:0]  RegDestinationOut;
output reg  [1:0]  FlashNumOut, enablePushOrPopOut, firstTimeCallOut, firstTimeRETOut, firstTimeINTOut;
output reg STOut, SSTOut, IROut, IWOut, MROut, MWOut, MTROut, ALU_srcOut, RWOut, BranchOut, SetCOut, CLRCOut, shiftOut, isPushOut, isINOut;
output reg [4:0] aluSignalsOut;
output reg [31:0] pcOut;



always@(posedge clk)
begin
    FlashNumOut=FlashNumIn;
    STOut=ST;
    SSTOut=SST;
    Reg1Out=Reg1;
    Reg2Out=Reg2;
    smallImmediateOut=smallImmediate;
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
    enablePushOrPopOut = enablePushOrPop;
    firstTimeCallOut = firstTimeCall;
    pcOut = pc;
    firstTimeRETOut = firstTimeRET;
    firstTimeINTOut = firstTimeINT;
    isPushOut = isPush;
    isINOut = isIN;
end
endmodule
