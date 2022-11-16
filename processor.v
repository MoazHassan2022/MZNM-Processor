module Processor (instrMem, memData, clk, reset, memRead, memWrite, aluOut, readData2);
// DEFINNG INPUTS
input wire clk, reset; // reset is an input?
// instrMem OUT!
input wire [0:16777216] instrMem; // 2*20 * 2 * 8  (must be flattened)
input wire [15:0] memData;

// DEFINING OUTPUTS
output memRead, memWrite;
output [15:0] aluOut, readData2;

// DEFINING WIRES
wire IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC; // control unit signals
wire pcSrc; // pcSrc is result of anding of (Branch, zeroFlag)
wire [31:0] pc, instr, extendedInstruction, extendedAddress;
wire [3:0] aluSignals; // condition code register
wire [15:0] read_data1, read_data2, write_data, aluSecondOperand;

// DEFINING REGS
wire [3:0] CCR; // [0: ZF, 1: NF, 2: CF, 3: OF] TODO: I had to make this as wire for (Illegeal output or inout port connection) error, I think this is right and in pipelined processor just put CCR wires in the buffer register

// Assigns
assign pcSrc = Branch & CCR[0];
// shift left and give it to pc
assign extendedAddress = pc + (extendedInstruction<<1);

// Registers, alu output, and alu inputs are all 16 bits
assign aluSecondOperand = ALU_src === 1'b0 ? read_data2 : instr[15:0];

// TODO: CLK SYNCHRONIZATION


// DEFINING Logic
PC pcCircuit(extendedAddress, pcSrc, pc, reset, clk);
Fetch fetch(pc, instr, instrMem);

ControlUnit cu(instr[31:27], aluSignals, IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC);
SignExtend se(instr[15:0], extendedInstruction);

// INSTR: [31:27] opcode
// [26:24] Rdest
regfile regFile(RW, read_data1, read_data2, write_data, clk, reset, instr[26:24], instr[23:21], instr[26:24]); 
ALU alu(aluSignals,read_data1,aluSecondOperand,aluOut,CCR[0],CCR[1],CCR[2],CCR[3]);


endmodule