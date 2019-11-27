
module MuxTwoToOne32(
    output [31:0] out,
    input [31:0] in0, in1,
    input select
);

assign out = (select == 1'b0)? in0 : in1;

endmodule // MuxTwoToOne



module MuxTwoToOne5(
    output [4:0] out,
    input [4:0] in0, in1,
    input select
);

assign out = (select == 1'b0)? in0 : in1;

endmodule // MuxTwoToOne



module MuxThreeToOne32 (
    output reg [31:0] out,
    input [31:0]in1, in2, in3,
    input  [1:0] sel
);
     
always@(in1, in2, in3, sel)
begin
case(sel)
    2'b00:out<= in1;
    2'b01:out<= in2;
    2'b10:out<= in3;

endcase

end
endmodule

module MuxThreeToOne5 (
    output reg [4:0] out,
    input [4:0]in1, in2, in3,
    input  [1:0] sel    
);
     
always@(in1, in2, in3, sel)
begin
case(sel)
    2'b00:out<= in1;
    2'b01:out<= in2;
    2'b10:out<= in3;

endcase

end
endmodule


module MuxTwoToOneTest;
    reg [31:0] x, y;
    reg sel;
    wire [31:0] o;

    MuxTwoToOne32 mux32(o, x, y, sel);

initial
begin
    $monitor($time,,, "in0: %d, in1: %d, sel: %b, output: %d", x, y, sel, o);

    x = 0;
    y = 0;
    sel = 0;

    #5
    x = 10;
    y = 20;
    sel = 0;

    #5
    x = 10;
    y = 20;
    sel = 1;

end

endmodule