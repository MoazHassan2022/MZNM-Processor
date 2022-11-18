module Processor (
    /* INTERFACE WITH DATA MEMORY */
    memData, /* READ DATA */
    MR, 
    MW, 
    aluOut, /* READ ADDRESS */ 
    readData2, /* WRITE DATA */
    /* INTERFACE WITH INSTRUCTION MEMORY */
    pc, /* READ ADDRESS */
    instr, 
    clk, 
    reset
);
// DEFINNG INPUTS
input wire clk, reset;
input wire [15:0] memData;
input wire [31:0] instr;

// DEFINING OUTPUTS
output MR, MW;
output [15:0] aluOut, readData2;
output [31:0] pc;

// DEFINING WIRES
wire IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC; // control unit signals
wire pcSrc; // pcSrc is result of anding of (Branch, zeroFlag)
wire [31:0] extendedInstruction, extendedAddress;
wire [3:0] aluSignals; // condition code register
wire [15:0] aluOut, read_data1, read_data2, write_data, aluSecondOperand;
wire [3:0] CCR; // [0: ZF, 1: NF, 2: CF, 3: OF] TODO: I had to make this as wire for (Illegeal output or inout port connection) error, I think this is right and in pipelined processor just put CCR wires in the buffer register

// Assigns
assign pcSrc = Branch & CCR[0];
// shift left and give it to pc
assign extendedAddress = pc + (extendedInstruction<<1);

// Registers, alu output, and alu inputs are all 16 bits
assign aluSecondOperand = ALU_src === 1'b0 ? read_data2 : instr[15:0];


// DEFINING Logic
PC pcCircuit(extendedAddress, pcSrc, pc, reset, clk);

ControlUnit cu(instr[31:27], aluSignals, IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC);
SignExtend se(instr[15:0], extendedInstruction);

// INSTR: [31:27] opcode
// [26:24] Rdest
regfile regFile(RW, read_data1, read_data2, write_data, clk, reset, instr[26:24], instr[23:21], instr[26:24]); 
ALU alu(aluSignals,read_data1,aluSecondOperand,aluOut,CCR[0],CCR[1],CCR[2],CCR[3]);

WriteBack writeBack(memData, aluOut, RW, MTR, write_data);


endmodule