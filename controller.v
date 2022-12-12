module Controller (clk, reset, instrWriteAddress, instrWriteData, instrWriteEnable);

// DEFINING INPUTS
input wire clk, reset, instrWriteEnable;
input wire [19:0] instrWriteAddress;
input wire [15:0] instrWriteData;


// DEFINING OUTPUTS
wire [31:0] pc, instr;
wire [15:0] memData, aluOut, readData2;
wire memRead, memWrite;


// DEFINING BLOCKS
IntructionMemory instrMem(pc, instr, clk, instrWriteAddress, instrWriteData, instrWriteEnable);
DataMemory dataMem(clk,memWrite,memRead,readData2,memData,aluOut[10:0]);
Processor processor(
    /* INTERFACE WITH DATA MEMORY */
    memData, /* READ DATA */
    memRead, 
    memWrite, 
    aluOut, /* ADDRESS */ 
    readData2, /* WRITE DATA */
    /* INTERFACE WITH INSTRUCTION MEMORY */
    pc, /* READ ADDRESS */
    instr, 
    clk, 
    reset
);


endmodule