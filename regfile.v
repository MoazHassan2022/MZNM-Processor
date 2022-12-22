module regfile(write_enable, read_data1, read_data2, write_data, clk, rst, read_addr1, read_addr2, write_addr);
input  write_enable;
input  [15:0]write_data;
input  clk;
input  rst;
input  [2:0]write_addr;
output reg [15:0]read_data1, read_data2;
input  [2:0]read_addr1, read_addr2;

wire[7:0]sel;

reg [15:0] registers [7:0];
integer i;

// Asynchronously read
assign read_data1 = registers[read_addr1];
assign read_data2 = registers[read_addr2];

//read from the registers based on the address
always@(posedge clk)
begin
    if(rst)
    begin
        for (i = 0;i<8;i = i+1)
        registers [i] = 16'b0; 
    end
    else
    begin
        #1; // TODO: try to avoid doing this making M2W buffer makes registersOut = inputs @negedge clk
        if(write_enable) begin
            registers[write_addr] = write_data;
        end
    end
    $display("reg[0] = %d,reg[1] = %d,reg[2] = %d,reg[3] = %d,reg[4] = %d,reg[5] = %d,reg[6] = %d,reg[7] = %d",registers[0],registers[1],registers[2],registers[3],registers[4],registers[5],registers[6],registers[7]);
end
endmodule
