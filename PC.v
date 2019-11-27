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
    input [31:0] jumbSteps,
    input select,
    input reset, clk
);

wire [31:0] nextAddress;
wire [31:0] addressPlus4, jumbOffset, jumbAddress;

FullAdder add4(addressPlus4, currentAddress, 4);

ShiftLeftRegister shiftLeft(jumbOffset, jumbSteps, 5'b00010);
FullAdder addJumb(jumbAddress, addressPlus4, jumbOffset);

MuxTwoToOne32 mux(nextAddress, addressPlus4, jumbAddress, select);
PC pc(currentAddress, nextAddress, reset, clk);

// assign nextAddress = (select == 1'b0) ? currentAddress +4 : (jumbAddress << 2) + currentAddress +4;

endmodule // ExtendedPC


module PCTest;
    
    wire clk;
    wire [31:0] currentAddress;

    reg [31:0] jumbAddress;
    reg reset, select;


    Clock clock(clk);
    ExtendedPC pc(currentAddress, jumbAddress, select, reset, clk);

    initial
    begin
    $monitor($time,,, "current: %d, jumb: %d, select: %b, reset:%b", currentAddress, jumbAddress, select, reset);
        
        jumbAddress = 100;
        
        select = 0;
        reset = 1;
        #2
        reset = 0;
        #20
        select = 1;
        #2
        select = 0;
        #10

        jumbAddress = 10;
        select = 1;
        #2
        select = 0;
        #20

        reset = 1;
        // #10
        // reset = 0;
    end


endmodule // PCTest