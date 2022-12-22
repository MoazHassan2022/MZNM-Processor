/// define width 
`define regWidth 16
`define PCWidth 32
`define SPWidth 16    
`define CCRWidth 4  // condition code register that can be divided to ZERO FLAG, NEGATIVE FLAG, CARRY FLAG, OVERFLOW FLAG
`define inPortWidth 16
`define outPortWidth 16

/// operation codes 
// R type Operations
`define OP_NOP 5'd0
`define OP_NOT 5'd26
`define OP_INC 5'd1
`define OP_DEC 5'd2
`define OP_MOV 5'd3
`define OP_ADD 5'd4
`define OP_SUB 5'd5
`define OP_AND 5'd6
`define OP_OR 5'd7
`define OP_SHL 5'd8
`define OP_SHR 5'd9

// I type operations
`define OP_PUSH 5'd10
`define OP_POP 5'd11
`define OP_LDM 5'd12
`define OP_LDD 5'd13
`define OP_STD 5'd14

// J type operations
`define OP_JZ 5'd15
`define OP_JN 5'd16
`define OP_JC 5'd17
`define OP_JMP 5'd18
`define OP_Call 5'd19
`define OP_Ret 5'd20
`define OP_RTI 5'd21

// other operations
`define OP_Rst 5'd22
`define OP_INT 5'd23
`define OP_OUT 5'd24
`define OP_IN 5'd25
`define OP_SETC 5'd27
`define OP_CLCR 5'd28


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
`define ALU_STD 4'd11
`define ALU_LDD 4'd12

/// defining common signals 
///  [IR, IW, MR, MW, MTR, ALU src, RW, Branch, SetC, CLRC]
`define ALU_SIGNALS 10'b0000001000
`define BRANCH_SIGNALS 10'b0000000001

