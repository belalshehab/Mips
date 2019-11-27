module AluControl(
	output reg[2:0] aluControl,
	input[5:0] funct,
	input [2:0] aluOp
);
always @(aluOp, funct) 
if(aluOp == 3'b000)
	aluControl <= 3'b010;  	//(Add) addi, lw, sw
else if (aluOp == 3'b001)
	aluControl <= 3'b110;	//(Sub) beq, bne	

else if (aluOp == 3'b011) 	//ori
	aluControl = 3'b001;
	
else if (aluOp == 3'b010)	//R-type
	begin
		if(funct == 36)
			aluControl <= 3'b000;	//And 0
		else if(funct == 37)
			aluControl <=3'b001;	//Or 1
		else if(funct == 32)
			aluControl <= 3'b010;	//Add 2
		else if (funct == 0)
			aluControl <= 3'b011;	//Sll 3
		else if(funct == 34)		
			aluControl <= 3'b110;	//Sub 6
		else if(funct == 42)
			aluControl <= 3'b111;	//Slt 7
	end
// else
// 	aluControl <= 3'b000;
	
endmodule

module tb_alu();
reg[5:0] funct;
reg[2:0]aluOp;
wire[2:0] aluControl;
reg [31:0] instructions[0:5];
reg [31:0] instruction;

integer file;
integer i;
AluControl A (aluControl, funct, aluOp);
initial begin
	i = 0;
	$monitor("%b, %b, %b, %b", funct, aluOp, aluControl, instruction);
	$readmemb("binaryCode.txt", instructions);
	aluOp = 3'b010;
	for(i = 0; i < 6; i = i + 1)
		begin
		#10
		instruction = 32'b00000010010100111000100000100010;
		funct  = instruction[5:0];
			
		end	
	
	//Decalre Control unit here
	//aluOp value =  output of control unit
	end

endmodule
