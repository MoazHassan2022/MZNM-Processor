module regfile(read_enable,write_enable,read_data,write_data,clk,rst,read_addr,write_addr);
input  read_enable;
input  write_enable;
input  [15:0]write_data;
input  clk;
input  rst;
input  [2:0]write_addr;
output [15:0]read_data;
input  [2:0]read_addr;


reg [15:0] read_data;


wire[7:0]sel;

reg [15:0] registers [7:0];
integer i;

//read from the registers based on the address
always@(negedge clk or rst)
begin
    if(rst)
    begin
        for (i = 0;i<8;i = i+1)
        registers [i] = 16'b0; 
    end
    else
    begin
        if(write_enable) registers[write_addr] = write_data;
    end
end
always@(posedge clk or rst)
begin
    if(rst)
    begin
        for (i = 0;i<8;i = i+1)
        registers [i] = 16'b0; 
    end
    
    if(read_enable)  read_data = registers[read_addr];
end
    
endmodule
