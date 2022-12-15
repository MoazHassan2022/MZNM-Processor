module DEBuffer(ST,SST,Reg1,Reg2,Instruction,SrcAddress,RegDestination,Clk, STOut, SSTOut, Reg1Out, Reg2Out, 
InstructionOut, SrcAddressOut, RegDestinationOut,FlashNumIn,FlashNumOut);


// Inputs to the buffer
input Clk;
input ST;
input SST;
input [16:0] Reg1,Reg2;
input [4:0]  Instruction;
input [2:0]  SrcAddress;
input [2:0]  RegDestination;
input [2:0]  FlashNumIn;


// Outputs from the buffer
output reg   STOut;
output reg   SSTOut;
output reg  [16:0] Reg1Out;
output reg  [16:0] Reg2Out;
output reg  [4:0]  InstructionOut;
output reg  [2:0]  SrcAddressOut;
output reg  [2:0]  RegDestinationOut;
output reg  [2:0]  FlashNumOut;


// Regs in the buffer
reg STReg;
reg SSTReg;
reg [2:0] FlashNumReg;
reg [16:0] Reg1Reg,Reg2Reg;
reg [4:0]  InstructionReg;
reg [2:0]  SrcAddressReg;
reg [2:0]  RegDestinationReg;


// will read the St and SST at any time 
assign STOut=STReg;
assign SSTOut=SSTReg;
assign FlashNumOut=FlashNumReg;
always@(posedge Clk)
begin
    STReg=ST;
    SSTReg=SST;
    Reg1Reg=Reg1;
    Reg2Reg=Reg2;
    InstructionReg=Instruction;
    SrcAddressReg=SrcAddress;
    RegDestinationReg=RegDestination;
end

always@(negedge Clk)
begin
    FlashNumReg=FlashNumIn;
    Reg1Out=Reg1Reg;
    Reg2Out=Reg2Reg;
    InstructionOut=InstructionReg;
    SrcAddressOut=SrcAddressReg;
    RegDestinationOut=RegDestinationReg;
end
endmodule
