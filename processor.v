module Processor (
    /* INTERFACE WITH DATA MEMORY */
    memData, /* READ DATA */
    MRAfterD2E, 
    MWAfterD2E, 
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
output MRAfterD2E, MWAfterD2E;
output [15:0] aluOut, read_data2;
output [31:0] pc;

// DEFINING WIRES
wire IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC, StIn, SstIn, StAfterD2E, SstAfterD2E, PCHazard, IRAfterD2E, IWAfterD2E, MTRAfterD2E, ALU_srcAfterD2E, RWAfterD2E, BranchAfterD2E, SetCAfterD2E, 
    CLRCAfterD2E; // control unit signals, TODO: use PCHazard
wire [1:0] pcSrc, FlushNumIn, FlushNumAfterD2E; // pcSrc is result of anding of (Branch, zeroFlag)
wire [31:0] extendedInstruction, extendedAddress;
wire [3:0] aluSignals, aluSignalsAfterD2E;
wire [15:0] aluOut, read_data1, read_data2, write_data, aluSecondOperand, Reg1AfterD2E, Reg2AfterD2E;
wire [3:0] CCR; // [0: ZF, 1: NF, 2: CF, 3: OF] TODO: I had to make this as wire for (Illegeal output or inout port connection) error, I think this is right and in pipelined processor just put CCR wires in the buffer register
wire [4:0] InstructionAfterD2E; // TODO: use it, instr[4:0] for SHL, SHR
wire [2:0] SrcAddressAfterD2E, RegDestinationAfterD2E; // TODO: use them for forwarding
wire [2:0] regDestAddressToD2E;
wire [15:0] instrAfterD2E;

// Assigns
assign pcSrc = 2'b0; // TODO: I had to make this static for now, but please who takes detecion hazard unit must edit it

// BZ + BN + BC
// B(Z+N+C)

// Registers, alu output, and alu inputs are all 16 bits
//assign aluSecondOperand = ALU_src === 1'b0 ? Reg2AfterD2E : instr[15:0];
assign aluSecondOperand = (StAfterD2E^SstAfterD2E) === 1'b0 ? Reg2AfterD2E : instrAfterD2E;
// In Decode stage, pass the register destination of current instruction if it wasn't an instruction that needs immediate (e.g. LDM),
// and pass the previos register destination if it was an instruction that needs immediate
assign regDestAddressToD2E = (StIn^SstIn) === 1'b0 ? instr[10:8] : RegDestinationAfterD2E;


// DEFINING Logic
PC pcCircuit(aluOut, pcSrc, pc, reset, clk, interruptSignal);

// ControlUnit cu(instr[15:11], aluSignals, IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC);

ControlUnit cu(
    instr[15:11], aluSignals, IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, 
    CLRC,StAfterD2E,SstAfterD2E,StIn,SstIn,FlushNumAfterD2E,FlushNumIn,PCHazard,1'b0
); // NopSignal is the last input here, from detectionHazardUnit, PCHazard will be connected as an output from detectionHazardUnit

// INSTR: [31:27] opcode
// [26:24] Rdest
regfile regFile(RWAfterD2E, read_data1, read_data2, write_data, clk, reset, instr[10:8], instr[7:5], RegDestinationAfterD2E); // TODO: Change write_addr to be given from M2W buffer 

DEBuffer de(aluSignals, IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, 
    CLRC, StIn, SstIn,StAfterD2E,SstAfterD2E, read_data1,read_data2,instr[4:0],instr[7:5],regDestAddressToD2E,clk, Reg1AfterD2E, Reg2AfterD2E, 
InstructionAfterD2E, SrcAddressAfterD2E, RegDestinationAfterD2E,FlushNumAfterD2E,FlushNumIn, IRAfterD2E, IWAfterD2E, MRAfterD2E, MWAfterD2E, MTRAfterD2E, ALU_srcAfterD2E, RWAfterD2E, BranchAfterD2E, SetCAfterD2E, 
    CLRCAfterD2E, aluSignalsAfterD2E, instr, instrAfterD2E);

ALU alu(aluSignalsAfterD2E,Reg1AfterD2E,aluSecondOperand,aluOut,CCR[0],CCR[1],CCR[2],CCR[3]);

WriteBack writeBack(memData, aluOut, RWAfterD2E, MTRAfterD2E, write_data);


endmodule