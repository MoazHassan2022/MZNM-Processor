module EMBuffer(MRAfterD2E, MWAfterD2E, MTRAfterD2E, RWAfterD2E, read_data2AfterD2E, RegDestinationAfterD2E,
    firstTimeCallAfterD2E, enablePushOrPopAfterD2E, pcAfterD2E, firstTimeRETAfterD2E, firstTimeINTAfterD2E, isPushAfterD2E, aluOut, CCR, clk, read_data2Out, RegDestinationOut, 
    MROut, MWOut, MTROut, RWOut, enablePushOrPopOut, firstTimeCallOut, pcOut, firstTimeRETOut, firstTimeINTOut, isPushOut, aluOutOut, CCROut, freezedCCROut
);


// Inputs to the buffer
input clk, MRAfterD2E, MWAfterD2E, MTRAfterD2E, RWAfterD2E, isPushAfterD2E; 
input [15:0] read_data2AfterD2E, aluOut;
input [2:0]  RegDestinationAfterD2E;
input [1:0]  enablePushOrPopAfterD2E, firstTimeCallAfterD2E, firstTimeRETAfterD2E, firstTimeINTAfterD2E;
input [31:0] pcAfterD2E;
input [3:0] CCR;

// Outputs from the buffer
output reg  [15:0] read_data2Out, aluOutOut;
output reg  [2:0]  RegDestinationOut;
output reg  [1:0]  enablePushOrPopOut, firstTimeCallOut, firstTimeRETOut, firstTimeINTOut;
output reg MROut, MWOut, MTROut, RWOut, isPushOut;
output reg [31:0] pcOut;
output reg [3:0] CCROut;
output reg [3:0] freezedCCROut;

always@(posedge clk)
begin
    RegDestinationOut=RegDestinationAfterD2E;
    MROut = MRAfterD2E;
    MWOut = MWAfterD2E;
    MTROut = MTRAfterD2E;
    RWOut = RWAfterD2E;
    enablePushOrPopOut = enablePushOrPopAfterD2E;
    firstTimeCallOut = firstTimeCallAfterD2E;
    pcOut = pcAfterD2E;
    firstTimeRETOut = firstTimeRETAfterD2E;
    firstTimeINTOut = firstTimeINTAfterD2E;
    read_data2Out = read_data2AfterD2E;
    aluOutOut = aluOut;
    CCROut = CCR;
    isPushOut = isPushAfterD2E;
    if(firstTimeINTAfterD2E === 2'b11)
        freezedCCROut = CCR; // freeze the flags until ALU takes them back when RTI
end
endmodule
