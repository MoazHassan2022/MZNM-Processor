`include "defines.v"
module controllerTB;
reg clk, reset, interruptSignal;
reg [15:0] inPortData;
wire [15:0] outPortData;
wire outSignalEn;

Controller controller(clk, reset, interruptSignal, inPortData, outPortData, outSignalEn);
initial begin
	reset = 1'b1;
	clk = 1'b0;
    inPortData = 16'h0;
    interruptSignal = 1'b0;
	@(posedge clk); 
    reset = 1'b0;
    inPortData = 16'h5; 
    @(posedge clk);
    inPortData = 16'h19;
    @(posedge clk);
    inPortData = 16'hFFFF;
    @(posedge clk);
    interruptSignal = 1'b1;
    inPortData = 16'hF320;
    @(posedge clk);
    interruptSignal = 1'b0;
    @(posedge clk);
    @(posedge clk); 
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
end
always begin
	#50;
	clk = ~clk;
end
endmodule