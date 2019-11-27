module PC(
    output reg [31:0] currentAddress,
    input [31:0] nextAddress,
    input reset, clk
);

always @(posedge clk)
begin
if(reset == 0'b1)
    currentAddress = 0;
else
    currentAddress = nextAddress;
end
endmodule // PC


module ExtendedPC(
    output [31:0] currentAddress,
    input [31:0] jumpSteps,
    input selectBranch, selectJump, selectJumpR,
    input [31:0] instruction,
    input [31:0] jumpRAddress,
    input reset, clk
);

wire [31:0] nextAddress, branchMuxOut, jumpMuxOut;
wire [31:0] addressPlus4, branchOffset, branchAddress, jumpAddress;

FullAdder add4(addressPlus4, currentAddress, 4);

ShiftLeftRegister shiftLeftBranch(branchOffset, jumpSteps, 5'b00010);
FullAdder addJump(branchAddress, addressPlus4, branchOffset);

MuxTwoToOne32 branchMux(branchMuxOut, addressPlus4, branchAddress, selectBranch);

assign jumpAddress = {addressPlus4[31:28], instruction[25:0] << 2};
MuxTwoToOne32 jumpMux(jumpMuxOut, branchMuxOut, jumpAddress, selectJump);

MuxTwoToOne32 jumpRMux(nextAddress, jumpMuxOut, jumpRAddress, selectJumpR);

PC pc(currentAddress, nextAddress, reset, clk);

// assign nextAddress = (selectBranch == 1'b0) ? currentAddress +4 : (branchAddress << 2) + currentAddress +4;

endmodule // ExtendedPC


module PCTest;
    
    wire clk;
    wire [31:0] currentAddress;

    reg [31:0] branchAddress;
    reg reset, selectBranch;


    Clock clock(clk);
    ExtendedPC pc(currentAddress, branchAddress, selectBranch, reset, clk);

    initial
    begin
    $monitor($time,,, "current: %d, jump: %d, selectBranch: %b, reset:%b", currentAddress, branchAddress, selectBranch, reset);
        
        branchAddress = 100;
        
        selectBranch = 0;
        reset = 1;
        #2
        reset = 0;
        #20
        selectBranch = 1;
        #2
        selectBranch = 0;
        #10

        branchAddress = 10;
        selectBranch = 1;
        #2
        selectBranch = 0;
        #20

        reset = 1;
        // #10
        // reset = 0;
    end


endmodule // PCTest