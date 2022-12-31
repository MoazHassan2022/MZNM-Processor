// the detection hazard unit is responsible for that:
    //1. flush instructions that has been fetched and will not be used in cases of branch
    //2. make bubble signal to control unit to make bubble in load use case[s] 
    //3. determine pc source value in case of branches
`include "defines.v"
`define pcSrcFromReg 2'b01
`define pcSrcStay 2'b10


//assumption : CCR = {zero,negative,carry,overflow} // [3: NF, 2: OF, 1: CF, 0: ZF]

module hazardDetectionUnit (
    ccr,opcode,opcodeAfterD2E,opcodeAfterE2M,src1,src2,dst,dstAfterE2M,MRAfterD2E,MRAfterE2M,pcSrc,bubbleSignal
);
    input [3:0] ccr;
    input [4:0] opcode, opcodeAfterD2E, opcodeAfterE2M;
    input [2:0] src1,src2,dst,dstAfterE2M;
    input MRAfterD2E, MRAfterE2M;
    output[1:0] pcSrc;
    output bubbleSignal;  /*bubble signal is connected to nop signal of control unit to handle the pcHazard*/
    wire isBranch, isLDDOrPOPAfterD2E, isLDDOrPOPAfterE2M;

    assign isLDDOrPOPAfterD2E = ((opcodeAfterD2E == `OP_LDD ) || (opcodeAfterD2E == `OP_POP ))  ? 1'b1 : 1'b0;
    assign isLDDOrPOPAfterE2M = ((opcodeAfterE2M == `OP_LDD ) || (opcodeAfterE2M == `OP_POP )) ? 1'b1 : 1'b0;
    assign isBranchTaken = ((opcode == `OP_JZ & ccr[0]) || (opcode == `OP_JN & ccr[3] ) || (opcode == `OP_JC & ccr[1] ) || (opcode == `OP_JMP )) ? 1'b1 : 1'b0;
    assign isBranch = ((opcode == `OP_JZ) || (opcode == `OP_JN) || (opcode == `OP_JC) || (opcode == `OP_JMP )) ? 1'b1 : 1'b0;

    /*handling of load or pop use case*/
    assign bubbleSignal = ((isLDDOrPOPAfterD2E & MRAfterD2E & (src1==dst || src2==dst)) || (isBranch & isLDDOrPOPAfterE2M & MRAfterE2M & (src1==dstAfterE2M || src2==dstAfterE2M))) ? 1'b1:1'b0;   
    
    /*handling of branches cases*/
    /*branches cases are:
        JZ   --> we detect that we will jump after execution that means we will flush 2 instructions in fetching and decoding
        JN   --> //
        JC   --> //
        JMP  --> we detect that we will jump in decoding phase that means we will flush only one instruction
    */

    assign pcSrc =  (bubbleSignal === 1'b1) ? `pcSrcStay : isBranchTaken ? `pcSrcFromReg
      :2'b00;


endmodule