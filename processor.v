`include "defines.v"
module Processor (
    /* INTERFACE WITH DATA MEMORY */
    memData, /* READ DATA */
    MRAfterD2E, 
    MWAfterD2E, 
    dataMemAddr, /* ADDRESS */ 
    writeMemData, /* WRITE DATA */
    /* INTERFACE WITH INSTRUCTION MEMORY */
    pc, /* READ ADDRESS */
    instr, 
    clk, 
    reset,
    interruptSignal,
    inPortData, /// data coming from the inport. 
    outPortData,
    outSignalEn
);














































/*/////////////////////////////////////////////////////////////////////////////////////////////////////////////

                        ******************* WHAT REMAINS **********************
1. MAKING CCR AS LIKE AS STACK POINTER MODULE.
2. BRANCH INSTRUCTIONS AND HANDLING THEM WITH HAZARD DETECTION UNIT.
3. INTERRUPT & RTI.
4. HANDLING PC UNIT WITH HAZARD DETECTION UNIT.
5. PUTTING REMAINING 4 BUFFERS
6. PUTTING FORWARDING UNIT
7. Handling RET


                        ******************* WHAT REMAINS **********************


////////////////////////////////////////////////////////////////////////////////////////////////////////////*/































// DEFINNG INPUTS
input wire clk, reset;
input wire [1:0] interruptSignal;
input wire [15:0] memData, instr, inPortData;

// DEFINING OUTPUTS
output MRAfterD2E, MWAfterD2E;
output [15:0] dataMemAddr, writeMemData;
output [31:0] pc;
output [15:0] outPortData;
output outSignalEn;


// DEFINING WIRES

wire IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC, StIn, SstIn, StAfterD2E, SstAfterD2E, PCHazard, IRAfterD2E, IWAfterD2E, MTRAfterD2E, ALU_srcAfterD2E, RWAfterD2E, BranchAfterD2E, SetCAfterD2E, 
    CLRCAfterD2E, shift, shiftAfterD2E; // control unit signals, TODO: use PCHazard
wire [1:0] pcSrc, FlushNumIn, FlushNumAfterD2E, enablePushOrPop, enablePushOrPopAfterD2E, firstTimeCall, firstTimeCallAfterD2E; // pcSrc is result of anding of (Branch, zeroFlag)
wire [31:0] extendedInstruction, extendedAddress;
wire [3:0] aluSignals, aluSignalsAfterD2E;
wire [15:0] aluOut, read_data1, read_data2, write_data, aluSecondOperand, read_data1AfterD2E, read_data2AfterD2E;
wire [3:0] CCR; // [3: NF, 2: OF, 1: CF, 0: ZF] TODO: I had to make this as wire for (Illegeal output or inout port connection) error, I think this is right and in pipelined processor just put CCR wires in the buffer register
wire [4:0] smallImmediateAfterD2E;
wire [2:0] SrcAddressAfterD2E, RegDestinationAfterD2E; // TODO: use them for forwarding
wire [2:0] regDestAddressToD2E;
wire [15:0] instrAfterD2E;
wire [`inPortWidth - 1 : 0] dataEitherFromInputPortOrSrc; 
wire [31:0] sp;
wire [31:0] pc, pcAfterD2E;

// Assigns
assign pcSrc = 2'b0; // TODO: I had to make this static for now, but please who takes detecion hazard unit must edit it

// BZ + BN + BC
// B(Z+N+C)


//// APPLYING ALL SELECTIONS 
//////////////////////////////////////////////////
// Registers, alu output, and alu inputs are all 16 bits
assign aluSecondOperand = ((StAfterD2E^SstAfterD2E) === 1'b0) ? ( (shiftAfterD2E == 1'b0) ?  read_data2AfterD2E : {{11{1'b0}},smallImmediateAfterD2E} ) : instrAfterD2E;

// In Decode stage, pass the register destination of current instruction if it wasn't an instruction that needs immediate (e.g. LDM),
// and pass the previos register destination if it was an instruction that needs immediate
assign regDestAddressToD2E = (StIn^SstIn) === 1'b0 ? instr[10:8] : RegDestinationAfterD2E;

/// selecting the data either from the input port or from Rsrc2(our src register).
assign dataEitherFromInputPortOrSrc = ((IR) == 1'b1 ? inPortData : read_data2);   

/// working on the Out instruction
assign outSignalEn = IWAfterD2E;  /// this is a signal to inform the listener on the outport that it should read this data. 
assign outPortData = aluOut ; // here we attach the aluOut to the outport in case that we have out write signal.
//////////////////////////////////////////////////
/// Working on push and pop instructions
assign dataMemAddr = (enablePushOrPopAfterD2E[0] === 1'b0) ? aluOut : (enablePushOrPopAfterD2E[1] === 1'b0) ? sp[15:0] : (sp[15:0] + 1'b1); // make the data memory address is aluOut for ordinary instructions, but stack pointer for push and pop, if the instruction is push (enablePushOrPopAfterD2E[1] = 0), take old value of stack pointer, if the instruction is pop (enablePushOrPopAfterD2E[1] = 1), take new value after increment of stack pointer.

/// Working on call instruction TODO: change firstTimeCallAfterD2E to firstTimeCallAfterE2M, pcAfterD2E to pcAfterE2M, read_data2AfterD2E to read_data2AfterE2M
assign writeMemData = (firstTimeCallAfterD2E === 2'b11) ? (pcAfterD2E[15:0]+1'b1) : (firstTimeCallAfterD2E === 2'b01) ? (pcAfterD2E[31:16]) : read_data2AfterD2E;

// DEFINING Logic
PC pcCircuit(aluOut, pcSrc, pc, reset, clk, interruptSignal, firstTimeCallAfterD2E);

ControlUnit cu(
    instr[15:11], aluSignals, IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, 
    CLRC,StAfterD2E,SstAfterD2E,StIn,SstIn,FlushNumAfterD2E,FlushNumIn,PCHazard,1'b0,shift,enablePushOrPop, firstTimeCallAfterD2E, firstTimeCall
); // NopSignal is the last input here, from detectionHazardUnit, PCHazard will be connected as an output from detectionHazardUnit

// INSTR: [31:27] opcode
// [26:24] Rdest
regfile regFile(RWAfterD2E, read_data1, read_data2, write_data, clk, reset, instr[10:8], instr[7:5], RegDestinationAfterD2E); // TODO: Change write_addr to be given from M2W buffer 

DEBuffer de(
     aluSignals, IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC, StIn, SstIn, /// the input signals. 
     StAfterD2E, /// state signal after the D2E buffer. 
     SstAfterD2E, /// second state signal after the D2E buffer.
     read_data1, /// read data from the register file. -> (destination data). -> the first reg in the reg file.  
     dataEitherFromInputPortOrSrc, /// to decide whether we read from the inport data or the register file. 
     instr[4:0], /// 5 bits which decide the immediate value for shift left or right.
     instr[7:5], /// 3bits which decide the source address. 
     regDestAddressToD2E, /// destination address which act as input for this buffer because we need it later in the write back stage. 
     clk, /// clock signal.
     read_data1AfterD2E, /// this is the destination data but after the buffer. 
     read_data2AfterD2E, /// this is the source data but after the buffer. either (inport data) or (data from the register file). 
     smallImmediateAfterD2E, /// this is the immediate value for shift left or right but after the buffer, which is decided by instr[4:0].
     SrcAddressAfterD2E, /// this is the source address but after the buffer, which is decided by instr[7:5].
     RegDestinationAfterD2E, /// this is the destination address but after the buffer, which is decided regDestAddressToD2E.
     FlushNumAfterD2E, /// this is the output for FlushNumIn, which is decided by the CU.
     FlushNumIn, /// this comes from the CU which decides how many flush instructions we need to do.
     IRAfterD2E, /// IR signal after the buffer.
     IWAfterD2E, /// IW signal after the buffer.
     MRAfterD2E, /// MR signal after the buffer.
     MWAfterD2E, /// MW signal after the buffer.
     MTRAfterD2E,/// MTR signal after the buffer.
     ALU_srcAfterD2E,/// ALU_src signal after the buffer.
     RWAfterD2E,/// RW signal after the buffer.
     BranchAfterD2E, /// Branch signal after the buffer.
     SetCAfterD2E, /// SetC signal after the buffer.
     CLRCAfterD2E, /// CLRC signal after the buffer.
     aluSignalsAfterD2E, /// aluSignals signal after the buffer.
     instr, /// instruction itself which is used for the LDM before the buffer.
     instrAfterD2E, /// the instruction which is used for the LDM after the buffer.
     shift, /// used for shift left or right instructions
     shiftAfterD2E, /// used for shift left or right instructions after the buffer.
     enablePushOrPop, /// used for push or pop instructions, 00 => no push or pop, 01 => push, 11 => pop
     enablePushOrPopAfterD2E, /// used for push or pop instructions, after the buffer
     firstTimeCall, // used for call instruction, 11 => first cycle in call, 01 => second cycle in call, 00 => no call
     firstTimeCallAfterD2E,
     pc, // user for call instruction
     pcAfterD2E
     );

ALU alu(aluSignalsAfterD2E,read_data1AfterD2E,aluSecondOperand,aluOut,CCR[0],CCR[1],CCR[2],CCR[3]);

stackPointer stackP(enablePushOrPopAfterD2E[0], clk, reset, enablePushOrPopAfterD2E[1], sp);

WriteBack writeBack(memData, aluOut, RWAfterD2E, MTRAfterD2E, write_data);


endmodule