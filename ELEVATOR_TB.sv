`timescale 1ns / 1ps


module ELEVATOR_TB();

logic clk;
logic rst;
logic stop;
logic [1:0] in;
logic [1:0] floor;
logic [3:0] changes_count;

ELEVATOR elevator_tb(
    .clk(clk),         
    .rst(rst),         
    .stop(stop),        
    .in(in),          
    .floor(floor),        
    .changes_count(changes_count)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst = 1'd1;
    stop = 1'd0;
    in = 2'd0;
    
    #10;
    rst = 1'd0;
    
    #10;
    in = 2'd3;
    
    #40;
    in = 2'd1;
    
    #20;
    in = 2'd2;
    stop = 1'd1;
    
    #30;
    stop = 1'd0;
    
    #20;
    in = 2'd3;
    stop = 1'd1;
    
    #20;
    in = 2'd0;
    
    #10;
    stop = 1'd0;
    
    #40;
    $stop;
end

endmodule
