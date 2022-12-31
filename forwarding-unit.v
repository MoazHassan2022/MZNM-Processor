module ForwardingUnit(src1,src2,EX_MEM_RD,MEM_WB_RD,MTRAfterE2M,RWAfterE2M,RWAfterM2W,RWAfterD2E,MTRAfterD2E,destAddrAfterF2D,isINAfterD2E,src1_signal,src2_signal,forwardedToBranch);

input [2:0] src1;           /*the address of the first src of the ALU                                                                                       */
input [2:0] src2;           /*the address of the second src of the ALU                                                                                      */
input [2:0] EX_MEM_RD;      /*the address of the destination register of EX_MEM phase // RegisterDestinationAfterE2M                                                                      */
input [2:0] MEM_WB_RD;      /*the address of the destination of the register of MEM_WB phase // RegDestinationAfterM2W                                                               */
input RWAfterD2E, MTRAfterD2E, isINAfterD2E;
input [2:0] destAddrAfterF2D;
input MTRAfterE2M;        /*the signal that determines if the register value will be read from memory /* MRAfterE2M   */
input RWAfterE2M;            /*the signal that determines if the register value will be written /* RWAfterE2M                                                     */
input RWAfterM2W;            /*the signal that determines if the value coming from memory will written back to register file or the one that coming from ALU  /* RWAfterM2W */

output [1:0] src1_signal, src2_signal, forwardedToBranch; /*the selecting signals that determine the sources of ALU & pc for jump*/

assign src1_signal = (src1==EX_MEM_RD && !MTRAfterE2M && RWAfterE2M && !isINAfterD2E)? 2'd2: // take aluOutAfterE2M
                     (src1==MEM_WB_RD && RWAfterM2W && !isINAfterD2E)? 2'd1: // memDataAfterM2W
                     2'd0;
assign src2_signal = (src2==EX_MEM_RD && !MTRAfterE2M && RWAfterE2M && !isINAfterD2E)? 2'd2: // take aluOutAfterE2M
                     (src2==MEM_WB_RD && RWAfterM2W && !isINAfterD2E)? 2'd1: // memDataAfterM2W
                     2'd0;
assign forwardedToBranch = (destAddrAfterF2D==src1 && !MTRAfterD2E && RWAfterD2E && !isINAfterD2E)? 2'b01: // take aluOut
                     (destAddrAfterF2D==EX_MEM_RD && !MTRAfterE2M && RWAfterE2M && !isINAfterD2E)? 2'b10: // take aluOutAfterE2M
                     (destAddrAfterF2D==MEM_WB_RD && RWAfterM2W && !isINAfterD2E)? 2'b11: // memDataAfterM2W
                     2'd0;

endmodule