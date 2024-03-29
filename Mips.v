
module Mips(
    //Output signals for debugging only
    wire [31:0] mipsAluOut, mipsInstruction, mipsregData1, mipsregData2, PC,
    mipsRegWriteData,
    //End of debugging signals

    input reset, clk
);


//ExtendedPc 
wire [31:0] currentAddress;
wire addressBranchSelect, addressJumpSelect, addressJumpRSelect;

//InstructionMemory
wire [31:0] instruction;

//RegisterFile and regMux
wire [31:0] regData1, regData2;
wire [4:0] writeRegAddress;
wire [31:0] regWriteData;
wire regWriteEnable;


//ControlUnit 
wire branch, memWriteEnable, aluSrcSelector, regWrite;
wire [1:0] writeRegDist, memToReg;
wire [2:0] aluOp;

//ExtendedAlu
wire [31:0] aluOut;
wire aluZeroFlag;
wire [31:0] aluInput2;
wire [31:0] addressPlus4;

//SignExtend
wire [31:0] extendedInstruction; //aka branch steps

//DataMemory
wire [31:0] dataMemoryRead;

//Signal for Debugging only
assign mipsAluOut = aluOut;
assign mipsInstruction = instruction;
assign mipsregData1 = regData1;
assign mipsregData2 = regData2;
assign PC = currentAddress;
assign mipsRegWriteData = regWriteData;
//End of debugging signals


ExtendedPC pc(currentAddress, addressPlus4, extendedInstruction, addressBranchSelect, addressJumpSelect, addressJumpRSelect, instruction, regData1, reset, clk);

and branchAnd(addressBranchSelect, aluZeroFlag, branch);

InstructionMemory instructionMemory(instruction, currentAddress);

MuxThreeToOne5 writeRegMux(writeRegAddress, instruction[20:16], instruction[15:11], 5'b11111, writeRegDist);

RegisterFile registerFile(regData1, regData2, instruction[25:21], instruction[20:16],
                            writeRegAddress, regWriteData, regWriteEnable, clk);

ControlUnit controlUnit(writeRegDist, branch, memToReg, memWriteEnable, aluSrcSelector,
			regWriteEnable, addressJumpSelect, addressJumpRSelect, aluOp, instruction[31:26], instruction[5:0]);


SignExtend signExtend(extendedInstruction, instruction[15:0]);
MuxTwoToOne32 aluInput2Mux(aluInput2, regData2, extendedInstruction, aluSrcSelector);
ExtendedAlu extendedAlu(aluOut, aluZeroFlag, regData1, aluInput2, instruction[5:0], aluOp, instruction[10:6]);


DataMemory dataMemory(dataMemoryRead, aluOut, regData2, memWriteEnable, clk);

MuxThreeToOne32 memToRegMux(regWriteData, aluOut, dataMemoryRead, addressPlus4, memToReg);
endmodule // Mips


module MipsTest;

wire [31:0] aluOut, instruction, regData1, regData2, PC, regWriteData;

wire clk;
reg reset;
Clock clock(clk);

Mips mips(aluOut, instruction, regData1, regData2, PC, regWriteData, reset, clk);

initial
begin
    // $monitor($time,,, "aluOut:%d, regData1:%d, regData2:%d, instruction:%b\nregWriteData : %d",
    //         aluOut, regData1, regData2, instruction, regWriteData);

    $monitor($time,,, "pc : %d", PC);

    reset = 1'b1;

    #10
    reset = 1'b0;
end

always@(posedge clk)
begin
    if(^aluOut[0] === 1'bx && reset == 1'b0)
        $finish;
end

endmodule // MipsTest