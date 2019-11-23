
module Mips(
    //Output signals for debugging only
    wire [31:0] mipsAluOut, mipsInstruction, mipsregData1, mipsregData2, PC,
    mipsRegWriteData,
    //End of debugging signals

    input reset, clk
);


//ExtendedPc 
wire [31:0] currentAddress;
// wire [31:0] jumbSteps;

wire addressSrcSelect;

//InstructionMemory
wire [31:0] instruction;

//RegisterFile and regMux
wire [31:0] regData1, regData2;
wire [4:0] writeRegAddress;
wire [31:0] regWriteData;
wire regWriteEnable;


//ControlUnit 
wire writeRegDist, branch, memToReg, memWriteEnable, aluSrcSelector, regWrite;
wire [1:0] aluOp;

//ExtendedAlu
wire [31:0] aluOut;
wire aluZeroFlag;
wire [31:0] aluInput2;

//SignExtend
wire [31:0] extendedInstruction; //aka jump steps

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


ExtendedPC pc(currentAddress, extendedInstruction , addressSrcSelect, reset, clk);

and branchAnd(addressSrcSelect, aluZeroFlag, branch);

InstructionMemory instructionMemory(instruction, currentAddress);

MuxTwoToOne5 writeRegMux(writeRegAddress, instruction[20:16], instruction[15:11], writeRegDist);

RegisterFile registerFile(regData1, regData2, instruction[25:21], instruction[20:16],
                            writeRegAddress, regWriteData, regWriteEnable, clk);

ControlUnit controlUnit(writeRegDist, branch, memToReg, memWriteEnable, aluSrcSelector,
			regWriteEnable, aluOp, instruction[31:26], instruction[5:0]);


SignExtend signExtend(extendedInstruction, instruction[15:0]);
MuxTwoToOne32 aluInput2Mux(aluInput2, regData2, extendedInstruction, aluSrcSelector);
ExtendedAlu extendedAlu(aluOut, aluZeroFlag, regData1, aluInput2, instruction[5:0], aluOp);


DataMemory dataMemory(dataMemoryRead, aluOut, regData2, memWriteEnable, clk);

MuxTwoToOne32 memToRegMux(regWriteData, aluOut, dataMemoryRead, memToReg);
endmodule // Mips


module MipsTest;

wire [31:0] aluOut, instruction, regData1, regData2, PC, regWriteData;

wire clk;
reg reset;
Clock clock(clk);

Mips mips(aluOut, instruction, regData1, regData2, PC, regWriteData, reset, clk);

initial
begin
    $monitor($time,,, "aluOut:%d, regData1:%d, regData2:%d, instruction:%b\nregWriteData : %d",
            aluOut, regData1, regData2, instruction, regWriteData);
    reset = 1'b1;
    #10
    reset = 1'b0;

    #200
    reset = 1'b0;

// 001000_00000_10000_0000000000001010 addi $s0, $0, 10
// 001000_10000_10001_0000000000001010 addi $s1, $s0, 10
// 101011_10000_10001_0000000000010100 sw $s2, 20($s2)
end

endmodule // MipsTest