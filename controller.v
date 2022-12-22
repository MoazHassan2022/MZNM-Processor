module Controller (clk, reset, interruptSignal, inPortData, outPortData, outSignalEn);

// DEFINING INPUTS
input clk, reset;
input [1:0] interruptSignal;

////////////// IN Port WORK /////////////////
wire [`inPortWidth - 1:0] inPortData; 
/////////////////////////////////////////////

/// Defining the outputs. 
output [`inPortWidth - 1:0] outPortData; 
output outSignalEn;  // this is the enable for the IW (input write). 

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
    interruptSignal,
    inPortData, /// the data which is coming from the in port. 
    outPortData, 
    outSignalEn
);


endmodule