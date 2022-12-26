// the detection hazard unit is responsible for that:
    //1. flush instructions that has been fetched and will not be used in cases of branch
    //2. make bubble signal to control unit to make bubble in load use case[s] 
    //3. determine pc source value in case of branches
`include "defines.v"
`define pcSrcFromReg 2'b01
`define pcSrcDec2 2'b10


//assumption : CCR = {zero,negative,carry,overflow} // [3: NF, 2: OF, 1: CF, 0: ZF]

module hazardDetectionUnit (
    ccr,opcode,src1,src2,dst,ID_EX_MEMRD,pcSrc,bubbleSignal
);
    input [3:0] ccr;
    input [4:0] opcode;
    input [2:0] src1,src2,dst;
    input ID_EX_MEMRD; // MRAfterD2E
    output[1:0] pcSrc;
    output bubbleSignal;  /*bubble signal is connected to nop signal of control unit to handle the pcHazard*/

    /*handling of load use case*/
    assign bubbleSignal = (((opcode == `OP_LDD ) || (opcode == `OP_POP )) & ID_EX_MEMRD & (src1==dst || src2==dst)) ? 1'b1:1'b0;   
    
    /*handling of branches cases*/
    /*branches cases are:
        JZ   --> we detect that we will jump after execution that means we will flush 2 instructions in fetching and decoding
        JN   --> //
        JC   --> //
        JMP  --> we detect that we will jump in decoding phase that means we will flush only one instruction
    */

    assign pcSrc =  (bubbleSignal === 1'b1) ? `pcSrcDec2 : ((opcode == `OP_JZ & ccr[0]) || (opcode == `OP_JN & ccr[3] ) || (opcode == `OP_JC & ccr[1] ) || (opcode == `OP_JMP )) ? `pcSrcFromReg
      :2'b00;


endmodule