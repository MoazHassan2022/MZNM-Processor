module Controller (clk, reset, interruptSignal);

// DEFINING INPUTS
input wire clk, reset;
input wire [1:0] interruptSignal;


// DEFINING WIRES
wire [31:0] pc;
wire [15:0] memData, aluOut, readData2, instr;
wire memRead, memWrite;


// DEFINING BLOCKS
IntructionMemory instrMem(pc, instr);
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
    reset,
    interruptSignal
);


endmodule