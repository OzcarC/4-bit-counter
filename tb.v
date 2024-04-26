`timescale 1ns/1ps

module test;
    reg reset,count,clk;
    wire [3:0] out;
    integer i;

    counter dat(.reset(reset), .count(count), .clk(clk), .out(out));
    initial begin
        clk = 1;
        reset = 0;
        count = 1;
        for(i=0; i<100;i=i+1) begin
            #10 clk = ~clk;
        end
    end
    initial begin
        #20 reset = 1;
        #200 reset = 0;
        #50 reset = 1;
        #180 count = 0;
        #60 count = 1;
        #180 count = 0; reset = 0;
        #70 count = 1; reset = 1;
    end

    always @(out)
        $monitor("num = %d",out);
endmodule
    
