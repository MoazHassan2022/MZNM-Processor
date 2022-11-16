module SignExtend (instrunction, extendedInstruction);
    /// defining the inputs
    input [15:0] instrunction; 

    /// defing the output
    output [31:0] extendedInstruction; 

    /// definning wires 
    wire [15:0] connectors; 

    /// defining the logic 
    assign connectors [15:0] = (instrunction[15] == 1) ? 16'b1111111111111111 : 16'b0; 
    assign extendedInstruction = {connectors, instrunction}; 
endmodule