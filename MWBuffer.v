module MWBuffer(MTRAfterE2M, RWAfterE2M, RegDestinationAfterE2M, aluOutAfterE2M, memData, clk, MTROut, RWOut, RegDestinationOut, aluOutOut, memDataOut);


// Inputs to the buffer
input clk, MTRAfterE2M, RWAfterE2M; 
input [2:0]  RegDestinationAfterE2M;
input [15:0] aluOutAfterE2M, memData;

// Outputs from the buffer
output reg MTROut, RWOut; 
output reg [2:0]  RegDestinationOut;
output reg [15:0] aluOutOut, memDataOut;

always@(posedge clk)
begin
    RegDestinationOut=RegDestinationAfterE2M;
    MTROut = MTRAfterE2M;
    RWOut = RWAfterE2M;
    aluOutOut = aluOutAfterE2M;
    memDataOut = memData;
end
endmodule
