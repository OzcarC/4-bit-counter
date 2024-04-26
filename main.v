`timescale 1ns/1ps

module counter(
    input reset,clk, count,
    output [3:0] out
);
    wire w1,w2,w3,w4;
    wire [3:0] plusOne;

    dFlipFlop   d1(.D(w1), .clk(clk), .reset(reset), .Q(out[0])),
                d2(.D(w2), .clk(clk), .reset(reset), .Q(out[1])),
                d3(.D(w3), .clk(clk), .reset(reset), .Q(out[2])),
                d4(.D(w4), .clk(clk), .reset(reset), .Q(out[3]));

    mux2_1  mux1(.a(plusOne[0]), .b(out[0]), .sel(count), .out(w1)),
            mux2(.a(plusOne[1]), .b(out[1]), .sel(count), .out(w2)),
            mux3(.a(plusOne[2]), .b(out[2]), .sel(count), .out(w3)),
            mux4(.a(plusOne[3]), .b(out[3]), .sel(count), .out(w4));
    
    fourBitRCA rca(.a(out), .b(4'b1), .cIn(1'b0), .sum(plusOne));

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, counter);
    end
endmodule

module dFlipFlop(
    input D, clk, reset,
    output reg Q
);
    always @(posedge clk) begin
        if(reset == 0)
            Q<= 1'b0;
        else
            Q<=D;
    end
endmodule

module mux2_1(
    input a, b, sel,
    output out
);
    assign out = sel ? a:b;
endmodule

module fullAdder(
    input a, b, cIn,
    output sum, cOut
);
    assign sum = cIn ^ (a ^ b);
    assign cOut = (a & b) | (a & cIn) | (b & cIn);
endmodule

module fourBitRCA(
    input [3:0] a,b,
    input cIn,
    output [3:0] sum,
    output cOut
);
    wire w1,w2,w3;

    fullAdder fA1(.a(a[0]), .b(b[0]), .cIn(cIn), .sum(sum[0]), .cOut(w1));
    fullAdder fA2(.a(a[1]), .b(b[1]), .cIn(w1), .sum(sum[1]), .cOut(w2));
    fullAdder fA3(.a(a[2]), .b(b[2]), .cIn(w2), .sum(sum[2]), .cOut(w3));
    fullAdder fA4(.a(a[3]), .b(b[3]), .cIn(w3), .sum(sum[3]), .cOut(cOut));
endmodule
    