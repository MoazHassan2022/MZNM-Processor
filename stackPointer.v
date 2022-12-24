module stackPointer(enable, clk, rst, pushOrPop, sp);
input  enable, clk, rst, pushOrPop;
output reg [31:0] sp;

always@(posedge clk)
begin
    if(rst)
    begin
        sp = 2047;
    end
    else
    begin
        if(enable) begin
            if(pushOrPop === 1'b0) // push
                sp = sp - 1;
            else // pop
                sp = sp + 1;
        end
    end
end
endmodule
