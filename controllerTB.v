`include "defines.v"
module controllerTB;
reg clk, reset;
reg [1:0] interruptSignal;
reg [15:0] inPortData;
wire [15:0] outPortData;
wire outSignalEn;

Controller controller(clk, reset, interruptSignal, inPortData, outPortData, outSignalEn);
initial begin
	reset = 1'b1;
	clk = 1'b0;
	#100;
    clk = 1'b0;
    reset = 1'b0;
    #100; // [NOT R0], [NOT R1], [NOP], [ADD R1, R0], [LDM R5, 6], [LDM R6, 2], [SUB R5, R6], [IN R3], [SUB R3, R5], [OUT R5], [SHL R3, 2], [SHR R3, 4]
    #100;
    #100;
    #100;
    #100;
    #100;
    #100;
    inPortData = 16'd10;
    #100;
    #100;
    #100;
end
always begin
	#50;
	clk = ~clk;
end
endmodule