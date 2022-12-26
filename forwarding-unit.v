module ForwardingUnit(src1,src2,EX_MEM_RD,MEM_WB_RD,EX_MEM_readEN,EX_MEM_EN,MEM_WB_EN,src1_signal,src2_signal);

input [2:0] src1;           /*the address of the first src of the ALU                                                                                       */
input [2:0] src2;           /*the address of the second src of the ALU                                                                                      */
input [2:0] EX_MEM_RD;      /*the address of the destination register of EX_MEM phase // RegisterDestinationAfterE2M                                                                      */
input [2:0] MEM_WB_RD;      /*the address of the destination of the register of MEM_WB phase // RegDestinationAfterM2W                                                               */

input EX_MEM_readEN;        /*the signal that determines if the register value will be read from memory /* MRAfterE2M   */
input EX_MEM_EN;            /*the signal that determines if the register value will be written /* RWAfterE2M                                                     */
input MEM_WB_EN;            /*the signal that determines if the value coming from memory will written back to register file or the one that coming from ALU  /* RWAfterM2W */

output [1:0] src1_signal ,src2_signal; /*the selecting signals that determine the sources of ALU*/

assign src1_signal = (src1==EX_MEM_RD && !EX_MEM_readEN && EX_MEM_EN)? 2'd2: // take aluOutAfterE2M
                     (src1==MEM_WB_RD && MEM_WB_EN)? 2'd1: // memDataAfterM2W
                     2'd0;
assign src2_signal = (src2==EX_MEM_RD && !EX_MEM_readEN && EX_MEM_EN)? 2'd2: // take aluOutAfterE2M
                     (src2==MEM_WB_RD && MEM_WB_EN)? 2'd1: // memDataAfterM2W
                     2'd0;

endmodule