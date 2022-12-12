module Processor (
    /* INTERFACE WITH DATA MEMORY */
    memData, /* READ DATA */
    MR, 
    MW, 
    aluOut, /* ADDRESS */ 
    read_data2, /* WRITE DATA */
    /* INTERFACE WITH INSTRUCTION MEMORY */
    pc, /* READ ADDRESS */
    instr, 
    clk, 
    reset,
    interruptSignal
);
// DEFINNG INPUTS
input wire clk, reset;
input wire [1:0] interruptSignal;
input wire [15:0] memData, instr;

// DEFINING OUTPUTS
output MR, MW;
output [15:0] aluOut, read_data2;
output [31:0] pc;

// DEFINING WIRES
wire IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC; // control unit signals
wire [1:0] pcSrc; // pcSrc is result of anding of (Branch, zeroFlag)
wire [31:0] extendedInstruction, extendedAddress;
wire [3:0] aluSignals;
wire [15:0] aluOut, read_data1, read_data2, write_data, aluSecondOperand;
wire [3:0] CCR; // [0: ZF, 1: NF, 2: CF, 3: OF] TODO: I had to make this as wire for (Illegeal output or inout port connection) error, I think this is right and in pipelined processor just put CCR wires in the buffer register

// Assigns
assign pcSrc = 2'b0; // TODO: I had to make this static for now, but please who takes detecion hazard unit must edit it

// BZ + BN + BC
// B(Z+N+C)

// Registers, alu output, and alu inputs are all 16 bits
assign aluSecondOperand = ALU_src === 1'b0 ? read_data2 : instr[15:0];


// DEFINING Logic
PC pcCircuit(aluOut, pcSrc, pc, reset, clk, interruptSignal);

ControlUnit cu(instr[15:11], aluSignals, IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC);

// INSTR: [31:27] opcode
// [26:24] Rdest
regfile regFile(RW, read_data1, read_data2, write_data, clk, reset, instr[10:8], instr[7:5], instr[10:8]); // TODO: Change write_addr to be given from M2W buffer 
ALU alu(aluSignals,read_data1,aluSecondOperand,aluOut,CCR[0],CCR[1],CCR[2],CCR[3]);

WriteBack writeBack(memData, aluOut, RW, MTR, write_data);


endmodule