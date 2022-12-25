// the detection hazard unit is responsible for that:
    //1. flush instructions that has been fetched and will not be used in cases of branch
    //2. make bubble signal to control unit to make bubble in load use case[s] 
    //3. determine pc source value in case of branches and ret and rti
`include "defines.v"
`define pcSrcFromReg 2'b01
`define pcSrcFromMem 2'b10


//assumption : CCR = {zero,negative,carry,overflow}

module hazardDetectionUnit (
    ccr,instruction,src1,src2,dst,ID_EX_MEMRD,pcSrc,IF_ID_Flush,controlSignalsSource,bubbleSignal,flushNum
);
    input [3:0] ccr;
    input [4:0] instruction;
    input [2:0] src1,src2,dst;
    input ID_EX_MEMRD;
    output[1:0] pcSrc;
    output IF_ID_Flush;
    output controlSignalsSource; /*this is the selector of mux of signlas of control unit that would be zero in case of flush*/
    output bubbleSignal;  /*bubble signal is connected to nop signal of control unit to handle the pcHazard*/
    output [1:0] flushNum;

    /*handling of load use case*/
    assign {bubbleSignal,controlSignalsSource} = (ID_EX_MEMRD & (src1==dst || src2==dst)) ? 2'b11:2'b00;   
    
    /*handling of branches cases*/
    /*branches cases are:
        JZ   --> we detect that we will jump after execution that means we will flush 2 instructions in fetching and decoding
        JN   --> //
        JC   --> //
        JMP  --> we detect that we will jump in decoding phase that means we will flush only one instruction
        CALL --> we detect that we will jump in decoding but we need to store the the pc then we will flush two instructions
        RET  --> we detect that we will jump in decoding and we will restore the pc only so we will flush two instructions
        RTI  --> we detect that we will jump in decoding and we will restore the pc and flags so we will flush three instructions
    */


    //make sure that the hazard detection unit will flush the IF_ID not the control unit
    assign {flushNum,IF_ID_Flush,pcSrc} =  (instruction == `OP_JZ & ccr[3] ) ? {2'b10,1'b1,`pcSrcFromReg}
      :(instruction == `OP_JN & ccr[2] ) ? {2'b10,1'b1,`pcSrcFromReg}
      :(instruction == `OP_JC & ccr[1] ) ? {2'b10,1'b1,`pcSrcFromReg}
      :(instruction == `OP_JMP ) ? {2'b01,1'b1,`pcSrcFromReg}
      :(instruction == `OP_Call ) ? {2'b10,1'b1,`pcSrcFromReg}
      :(instruction == `OP_Ret ) ? {2'b10,1'b1,`pcSrcFromMem}
      :(instruction == `OP_RTI ) ? {2'b11,1'b1,`pcSrcFromMem}:{2'b0,1'b0,2'b00};


endmodule