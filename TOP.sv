`timescale 1ns / 1ps


module TOP(
        input logic        clk,
        input logic        rst,
        input logic        en,
        input logic        stop,
        input logic [1:0]  in,
        output logic       clk_delay,
        output logic [6:0] floor_display,
        output logic [3:0] changes_count
    );
    
    logic [1:0] floor;
    
    CLK_DELAY clk_delay0(
        .clk(clk),     
        .rst(rst),     
        .en(en),      
        .clk_delay(clk_delay)
    );
    
    ELEVATOR elevator_dut(
        .clk(clk),          
        .rst(rst),          
        .stop(stop),         
        .in(in),           
        .floor(floor),         
        .changes_count(changes_count) 
    );
    
    FLOOR_TRANSCODER(
        .in(floor),
        .out(floor_display)
    );
    
endmodule
