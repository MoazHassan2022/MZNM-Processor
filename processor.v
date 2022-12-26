`include "defines.v"
module Processor (
    /* INTERFACE WITH DATA MEMORY */
    memData, /* READ DATA */
    MRAfterE2M, 
    MWAfterE2M, 
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
3. HANDLING PC UNIT WITH HAZARD DETECTION UNIT.
4. INTERRUPT & RTI.
                        ******************* WHAT REMAINS **********************

                        ******************* TO BE TESTED **********************
1. LDM
2. data hazard (forwarding)
3. branch
4. load-use case
                        ******************* TO BE TESTED **********************

////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

// DEFINNG INPUTS
input wire clk, reset;
input wire [1:0] interruptSignal;
input wire [15:0] memData, instr, inPortData;

// DEFINING OUTPUTS
output MRAfterE2M, MWAfterE2M;
output [15:0] dataMemAddr, writeMemData;
output [31:0] pc;
output [15:0] outPortData;
output outSignalEn;


// DEFINING WIRES

wire IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC, StIn, SstIn, StAfterD2E, SstAfterD2E, PCHazard, IRAfterD2E, IWAfterD2E, MRAfterD2E, MWAfterD2E, MTRAfterD2E, ALU_srcAfterD2E, RWAfterD2E, BranchAfterD2E, SetCAfterD2E, 
    CLRCAfterD2E, shift, shiftAfterD2E, MRAfterE2M, MWAfterE2M, MTRAfterE2M, RWAfterE2M, MTRAfterM2W, RWAfterM2W; // control unit signals, TODO: use PCHazard
wire [1:0] pcSrc, FlushNumIn, FlushNumAfterD2E, enablePushOrPop, enablePushOrPopAfterD2E, enablePushOrPopAfterE2M, firstTimeCall, firstTimeCallAfterD2E, firstTimeRET, firstTimeRETAfterD2E, firstTimeCallAfterE2M, firstTimeRETAfterE2M, takeALUOrMemForwardedSrc1, takeALUOrMemForwardedSrc2; // pcSrc is result of anding of (Branch, zeroFlag)
wire [4:0] aluSignals, aluSignalsAfterD2E;
wire [15:0] aluOut, read_data1, read_data2, write_data, aluSecondOperand, aluFirstOperand, read_data1AfterD2E, read_data2AfterD2E, read_data2AfterE2M, instrAfterF2D, aluOutAfterE2M, aluOutAfterM2W, memDataAfterM2W;
wire [3:0] CCR, CCRAfterE2M; // [3: NF, 2: OF, 1: CF, 0: ZF]
wire [4:0] smallImmediateAfterD2E;
wire [2:0] SrcAddressAfterD2E, RegDestinationAfterD2E, RegDestinationAfterE2M, RegDestinationAfterM2W;
wire [2:0] regDestAddressToD2E;
wire [15:0] instrAfterD2E;
wire [`inPortWidth - 1 : 0] dataEitherFromInputPortOrSrc; 
wire [31:0] sp;
wire [31:0] pc, pcAfterD2E, pcAfterF2D, pcAfterE2M;

// Assigns
//// APPLYING ALL SELECTIONS 
//////////////////////////////////////////////////
// Registers, alu output, and alu inputs are all 16 bits
assign aluFirstOperand = (takeALUOrMemForwardedSrc1 === 2'b10) ? aluOutAfterE2M : (takeALUOrMemForwardedSrc1 === 2'b01) ? write_data : read_data1AfterD2E;

assign aluSecondOperand = ((StAfterD2E^SstAfterD2E) === 1'b0) ? ( (shiftAfterD2E == 1'b0) ? (takeALUOrMemForwardedSrc2 === 2'b10) ? aluOutAfterE2M : (takeALUOrMemForwardedSrc2 === 2'b01) ? write_data : read_data2AfterD2E : {{11{1'b0}},smallImmediateAfterD2E} ) : instrAfterD2E;

// In Decode stage, pass the register destination of current instruction if it wasn't an instruction that needs immediate (e.g. LDM),
// and pass the previos register destination if it was an instruction that needs immediate
assign regDestAddressToD2E = (StIn^SstIn) === 1'b0 ? instrAfterF2D[10:8] : RegDestinationAfterD2E;

/// selecting the data either from the input port or from Rsrc2(our src register).
assign dataEitherFromInputPortOrSrc = ((IR) == 1'b1 ? inPortData : read_data2);   

/// working on the Out instruction
assign outSignalEn = IWAfterD2E;  /// this is a signal to inform the listener on the outport that it should read this data. 
assign outPortData = aluOut ; // here we attach the aluOut to the outport in case that we have out write signal.
//////////////////////////////////////////////////
/// Working on push and pop instructions
assign dataMemAddr = (enablePushOrPopAfterE2M[0] === 1'b0) ? aluOutAfterE2M : (enablePushOrPopAfterE2M[1] === 1'b0) ? sp[15:0] : (sp[15:0] + 1'b1); // make the data memory address is aluOutAfterE2M for ordinary instructions, but stack pointer for push and pop, if the instruction is push (enablePushOrPopAfterE2M[1] = 0), take old value of stack pointer, if the instruction is pop (enablePushOrPopAfterE2M[1] = 1), take new value after increment of stack pointer.

/// Working on call instruction
assign writeMemData = (firstTimeCallAfterE2M === 2'b11) ? (pcAfterE2M[15:0]+1'b1) : (firstTimeCallAfterE2M === 2'b01) ? (pcAfterE2M[31:16]) : read_data2AfterE2M;

// DEFINING Logic
PC pcCircuit(aluOut, memData, read_data1, pcSrc, pc, reset, clk, interruptSignal, firstTimeCallAfterD2E, firstTimeRETAfterE2M);

FDBuffer fd(clk, pc, instr, pcAfterF2D, instrAfterF2D);

hazardDetectionUnit hdu(CCR,instrAfterF2D[15:11],instrAfterF2D[10:8],instrAfterF2D[7:5],RegDestinationAfterD2E,MRAfterD2E,pcSrc,bubbleSignal);

regfile regFile(RWAfterM2W, read_data1, read_data2, write_data, clk, reset, instrAfterF2D[10:8], instrAfterF2D[7:5], RegDestinationAfterM2W);

ControlUnit cu(
    instrAfterF2D[15:11], aluSignals, IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, 
    CLRC,StAfterD2E,SstAfterD2E,StIn,SstIn,FlushNumAfterD2E,FlushNumIn,shift,enablePushOrPop, firstTimeCallAfterD2E, firstTimeCall, firstTimeRETAfterD2E, firstTimeRET, bubbleSignal
);

DEBuffer de(
     aluSignals, IR, IW, MR, MW, MTR, ALU_src, RW, Branch, SetC, CLRC, StIn, SstIn, /// the input signals. 
     read_data1, /// read data from the register file. -> (destination data). -> the first reg in the reg file.  
     dataEitherFromInputPortOrSrc, /// to decide whether we read from the inport data or the register file. 
     instrAfterF2D[4:0], /// 5 bits which decide the immediate value for shift left or right.
     instrAfterF2D[7:5], /// 3bits which decide the source address. 
     regDestAddressToD2E, /// destination address which act as input for this buffer because we need it later in the write back stage. 
     FlushNumIn, /// this comes from the CU which decides how many flush instructions we need to do.
     instrAfterF2D, /// instruction itself which is used for the LDM before the buffer.
     shift, /// used for shift left or right instructions
     enablePushOrPop, /// used for push or pop instructions, 00 => no push or pop, 01 => push, 11 => pop
     firstTimeCall, // used for call instruction, 11 => first cycle in call, 01 => second cycle in call, 00 => no call
     firstTimeRET, // used for ret instruction
     pcAfterF2D, // used for call instruction
     clk, /// clock signal.
     read_data1AfterD2E, /// this is the destination data but after the buffer. 
     read_data2AfterD2E, /// this is the source data but after the buffer. either (inport data) or (data from the register file). 
     smallImmediateAfterD2E, /// this is the immediate value for shift left or right but after the buffer, which is decided by instrAfterF2D[4:0].
     SrcAddressAfterD2E, /// this is the source address but after the buffer, which is decided by instrAfterF2D[7:5].
     RegDestinationAfterD2E, /// this is the destination address but after the buffer, which is decided regDestAddressToD2E.
     FlushNumAfterD2E, /// this is the output for FlushNumIn, which is decided by the CU.
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
     instrAfterD2E, /// the instruction which is used for the LDM after the buffer.
     shiftAfterD2E, /// used for shift left or right instructions after the buffer.
     enablePushOrPopAfterD2E, /// used for push or pop instructions, after the buffer
     firstTimeCallAfterD2E,
     pcAfterD2E,
     firstTimeRETAfterD2E,
     StAfterD2E, /// state signal after the D2E buffer. 
     SstAfterD2E, /// second state signal after the D2E buffer.
     );

ForwardingUnit fu(RegDestinationAfterD2E,SrcAddressAfterD2E,RegDestinationAfterE2M,RegDestinationAfterM2W,MRAfterE2M,RWAfterE2M,RWAfterM2W,takeALUOrMemForwardedSrc1,takeALUOrMemForwardedSrc2);

ALU alu(aluSignalsAfterD2E,aluFirstOperand,aluSecondOperand,aluOut,CCRAfterE2M[0],CCRAfterE2M[1],CCRAfterE2M[2],CCRAfterE2M[3],CCR[0],CCR[1],CCR[2],CCR[3]);

EMBuffer em(MRAfterD2E, MWAfterD2E, MTRAfterD2E, RWAfterD2E, read_data2AfterD2E, RegDestinationAfterD2E,
    firstTimeCallAfterD2E, enablePushOrPopAfterD2E, pcAfterD2E, firstTimeRETAfterD2E, aluOut, CCR, clk, read_data2AfterE2M, RegDestinationAfterE2M, 
    MRAfterE2M, MWAfterE2M, MTRAfterE2M, RWAfterE2M, enablePushOrPopAfterE2M, firstTimeCallAfterE2M, pcAfterE2M, firstTimeRETAfterE2M, aluOutAfterE2M, CCRAfterE2M
);

stackPointer stackP(enablePushOrPopAfterE2M[0], clk, reset, enablePushOrPopAfterE2M[1], sp);

MWBuffer mw(MTRAfterE2M, RWAfterE2M, RegDestinationAfterE2M, aluOutAfterE2M, memData, clk, MTRAfterM2W, RWAfterM2W, RegDestinationAfterM2W, aluOutAfterM2W, memDataAfterM2W);

WriteBack writeBack(memDataAfterM2W, aluOutAfterM2W, RWAfterM2W, MTRAfterM2W, write_data);


endmodule