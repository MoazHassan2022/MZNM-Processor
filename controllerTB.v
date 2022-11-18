`include "defines.v"
module controllerTB;
reg [19:0] instrWriteAddress;
reg [15:0] instrWriteData;
reg clk, reset, instrWriteEnable;

Controller controller(clk, reset, instrWriteAddress, instrWriteData, instrWriteEnable);
initial begin
	reset = 1'b1;
	clk = 1'b0;
	#100;
    instrWriteAddress = 20'd32;
    instrWriteEnable = 1'b1;
    instrWriteData = {`OP_LDM, 11'b00000000000}; // LDM R1, 0h
    #100;
    instrWriteAddress = 20'd33;
    instrWriteData = 16'b0000000000000000; // LDM R1, 0h
    #100;
    instrWriteAddress = 20'd34;
    instrWriteData = {`OP_LDM, 11'b00100000000}; // LDM R2, 2h
    #100;
    instrWriteAddress = 20'd35;
    instrWriteData = 16'b0000000000000010; // LDM R2, 2h
    #100;
    instrWriteAddress = 20'd36;
    instrWriteData = {`OP_NOP, 11'b00000000000}; // NOP
    #100;
    instrWriteAddress = 20'd37;
    instrWriteData = 16'b0000000000000000; // NOP
    #100;
    instrWriteAddress = 20'd38;
    instrWriteData = {`OP_ADD, 11'b00000100000}; // ADD R1, R2 (We define first operand as Rdst)
    #100;
    instrWriteAddress = 20'd39;
    instrWriteData = 16'b0000000000000000; // ADD R1, R2
    #100;
    instrWriteAddress = 20'd40;
    instrWriteData = {`OP_NOT, 11'b00000000000}; // NOT R1
    #100;
    instrWriteAddress = 20'd41;
    instrWriteData = 16'b0000000000000000; // NOT R1
    #100;
    instrWriteAddress = 20'd42;
    instrWriteData = {`OP_STD, 11'b00000100000}; // STD R1, R2
    #100;
    instrWriteAddress = 20'd43;
    instrWriteData = 16'b0000000000000000; // STD R1, R2
    #100;
    instrWriteAddress = 20'd44;
    instrWriteData = {`OP_LDD, 11'b10100000000}; // LDD R6, R1
    #100;
    instrWriteAddress = 20'd45;
    instrWriteData = 16'b0000000000000000; // LDD R6, R1
    #100;
    instrWriteEnable = 1'b0;
    clk = 1'b0;
    reset = 1'b0;
    #100;
    #100;
    #100;
    #100;
    #100;
    #100;
    #100;

end
always begin
	#50;
	clk = ~clk;
end
endmodule