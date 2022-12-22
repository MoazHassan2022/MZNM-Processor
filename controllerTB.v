`include "defines.v"
module controllerTB;
reg clk, reset;
reg [1:0] interruptSignal;

Controller controller(clk, reset, interruptSignal);
initial begin
	reset = 1'b1;
	clk = 1'b0;
	#100;
    clk = 1'b0;
    reset = 1'b0;
    #100; // [NOT R0], [NOT R1], [NOP], [ADD R1, R0], [LDM R5, 6], [LDM R6, 2], [SUB R5, R6]
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