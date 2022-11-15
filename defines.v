/// define width 
`define regWidth 16
`define PCWidth 32
`define SPWidth     
`define CCRWidth 4  // condition code register that can be divided to ZERO FLAG, NEGATIVE FLAG, CARRY FLAG, OVERFLOW FLAG
`define inPortWidth 16
`define outPortWidth 16

/// operation codes 
// R type Operations
`define OP_NOT 6'd0
`define OP_INC 6'd1
`define OP_DEC 6'd2
`define OP_MOV 6'd3
`define OP_ADD 6'd4
`define OP_SUB 6'd5
`define OP_AND 6'd6
`define OP_OR 6'd7
`define OP_SHL 6'd8
`define OP_SHR 6'd9

// I type operations
`define OP_PUSH 6'd10
`define OP_POP 6'd11
`define OP_LDM 6'd12
`define OP_LDD 6'd13
`define OP_STD 6'd14

// J type operations
`define OP_JZ 6'd15
`define OP_JN 6'd16
`define OP_JC 6'd17
`define OP_JMP 6'd18
`define OP_Call 6'd19
`define OP_Ret 6'd20
`define OP_RTI 6'd21

// other operations
`define OP_Rst 6'd22
`define OP_INT 6'd23
`define OP_OUT 6'd24
`define OP_IN 6'd25
`define OP_NOP 6'd26
`define OP_SETC 6'd27
`define OP_CLCR 6'd28


/// define the memory size
`define DATA_MEM_SIZE 12'd4096
`define INSTRUCTION_MEM_SIZE 21'd2097152



/// defining the operations for the ALU
`define ALU_NOP 4'b0
`define ALU_NOT 4'd1
`define ALU_INC 4'd2
`define ALU_DEC 4'd3
`define ALU_MOV 4'd4
`define ALU_ADD 4'd5
`define ALU_SUB 4'd6
`define ALU_AND 4'd7
`define ALU_OR 4'd8
`define ALU_SHL 4'd9
`define ALU_SHR 4'd10

/// defining common signals 
///  [IR, IW, MR, MW, MTR, ALU src, RW, Branch, SetC, CLRC]
`define ALU_SIGNALS 10'b0000001000
`define BRANCH_SIGNALS 10'b0000000001

