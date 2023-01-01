module stackPointer(enable, clk, rst, pushOrPop, sp);
input  enable, clk, rst, pushOrPop;
output reg [31:0] sp;

always@(negedge clk)
begin
	if(rst)
    begin
        sp = 2047;
    end
end
always@(posedge clk)
begin
    if(rst)
    begin
        sp = 2047;
    end
    else
    begin
        if(enable) begin
            if(pushOrPop === 1'b0) begin // push
                sp = sp - 1;
                $display("PUSH SP = %d", sp);
            end
            else begin // pop
                sp = sp + 1;
                $display("POP SP = %d", sp);
            end
        end
    end
end
endmodule
