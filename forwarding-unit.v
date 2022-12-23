module ForwardingUnit(src1,src2,EX_MEM_RD,MEM_WB_RD,EX_MEM_readEN,MEM_WB_EN,src1_signal,src2_signal);

input [5:0] src1;           /*the address of the first src of the ALU                                                                                       */
input [5:0] src2;           /*the address of the second src of the ALU                                                                                      */
input [5:0] EX_MEM_RD;      /*the address of the destination refister of EX_MEM phase                                                                       */
input [5:0] MEM_WB_RD;      /*the address of the destination of the register of MEM_WB phase                                                                */

input EX_MEM_readEN;        /*the signal that determines if the register value will be read from memory                                                     */
input MEM_WB_EN;            /*the signal that determines if the value coming from memory will written back to register file or the one that coming from ALU */

output [1:0] src1_signal ,src2_signal; /*the selecting signals that determine the sources of ALU*/

assign src1_signal = (src1==EX_MEM_RD && !EX_MEM_readEN)? 2'd2:
                     (src1==MEM_WB_RD && !MEM_WB_EN)? 2'd1:
                     2'd0;
assign src2_signal = (src2 == EX_MEM_RD && !EX_MEM_readEN)?2'd2:
                     (src2 == MEM_WB_RD && !MEM_WB_EN)?2'd1:
                     2'd0;
endmodule