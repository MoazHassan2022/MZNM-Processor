`include "defines.v"
module controllerTB;
reg clk, reset, interruptSignal;
reg [15:0] inPortData;
wire [15:0] outPortData;
wire outSignalEn;

Controller controller(clk, reset, interruptSignal, inPortData, outPortData, outSignalEn);
initial begin
	reset = 1'b1;
	clk = 1'b1;
	#100; 
    clk = 1'b0;
    reset = 1'b0; // interrupt handling routing is : [AND R4, R3], [ADD R4, R1], [OUT R4], [RTI]
    #100; // [LDM R4, 36], [MOV R3, R4], [SHR R4, 1], [INC R1], [SUB R5, R5], (interrupt), [INC R4]
    #100;
    //reset = 1'b1;
    #100;
    //reset = 1'b0;
    #100;
    #100;
    #100;
    interruptSignal = 1'b1;
    #100;
    interruptSignal = 1'b0;
    //inPortData = 16'd10;
    #100;
    #100;
    #100;
end
always begin
	#50;
	clk = ~clk;
end
endmodule

// [NOT R0], [NOT R1], [PUSH R1], [NOP], [ADD R1, R0], [LDM R5, 6], [LDM R6, 2], [SUB R5, R6], [ADD R3, R5], [POP R7], [STD R5, R0], [LDD R2, R5], [LDM R4, 52], [CALL R4](will go to last NOP), [NOT R0](to be executed after RET), [NOP], [NOP], [NOP], [ADD R7, R4], [RET](return to near NOT R0)
/*

1101000000000000
1101000100000000
0101000000100000
0000000000000000
0010000100000000
0110010100000000
0000000000000110
0110011000000000
0000000000000010
0010110111000000
0010001110100000
0101111100000000
0111010100000000
0110101010100000
0110010000000000
0000000000110100
1001110000000000
1101000000000000
0000000000000000
0000000000000000
0000000000000000
0010011110000000
1010000000000000

*/