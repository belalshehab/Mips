module RegisterFile(
	output [31:0] data1, data2,
	input [4:0] read1, read2, writeReg,
	input [31:0] writeData,
	input writeEnable,
	input clk
	);

reg [31:0] rf [0:31];

assign data1 = rf[read1];
assign data2 = rf[read2];

initial
begin
	rf[0] = 0;
end

always@(posedge clk)
begin
if(writeEnable)
	rf[writeReg] <= writeData;
end
endmodule


module RegFileTest;

wire [31:0] data1, data2;
reg[4:0] read1, read2, writeReg;
reg [31:0] writeData;

reg writeEnable;
wire clk;

reg [31:0] i;

Clock clock (clk);

RegisterFile registerFile(data1, data2, read1, read2, writeReg, writeData, writeEnable, clk);



initial
begin
$monitor($time,,, "read1: %d, read2: %d, data1: %d, data2: %d",
read1, read2, data1, data2);
read1 = 0;
read2 = 0;
writeReg = 0;
writeData = 0;
// writeEnable = 1;

i = 0;


repeat(32)@(posedge clk)
begin
	writeEnable = 1;
	writeData <= i;
	writeReg <= i;
	i <= i +1;
	writeEnable = 0;
end

// #5
// writeEnable = 0;



#10
read1 = 2;
read2 = 3;

#10
read1 = 1;
read2 = 2;

#10
read1 = 0;
read2 = 1;

#10
writeData = 5;
writeReg = 0;
writeEnable = 1;

#2
writeData = 6;
writeReg = 1;

#10
writeEnable = 0;

read1 = 31;
read2 = 1;

end



endmodule
