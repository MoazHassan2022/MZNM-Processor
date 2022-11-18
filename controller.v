module Controller (clk, reset);

// DEFINING INPUTS
input wire clk, reset;

// DEFINING OUTPUTS
wire [31:0] pc, instr;
wire [15:0] memData, aluOut, readData2;
wire memRead, memWrite;

// DEFINING BLOCKS
IntructionMemory instrMem(pc, instr);
DataMemory dataMem(clk,memWrite,memRead,readData2,memData,aluOut[10:0]);
Processor processor(
    /* INTERFACE WITH DATA MEMORY */
    memData, /* READ DATA */
    memRead, 
    memWrite, 
    aluOut, /* READ ADDRESS */ 
    readData2, /* WRITE DATA */
    /* INTERFACE WITH INSTRUCTION MEMORY */
    pc, /* READ ADDRESS */
    instr, 
    clk, 
    reset
);


endmodule