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
    #100;
    #100;
    #100;

end
always begin
	#50;
	clk = ~clk;
end
endmodule