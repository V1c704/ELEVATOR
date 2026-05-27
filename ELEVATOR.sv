`timescale 1ns / 1ps


module ELEVATOR(
        input logic        clk,
        input logic        rst,
        input logic        stop,
        input logic [1:0]  in,
        output logic [1:0] floor,
        output logic [3:0] changes_count
    );
    
    logic count_enable;
    
    ELEVATOR_FSM elevator_fsm0(
        .clk(clk), 
        .rst(rst), 
        .in(in),  
        .stop(stop),
        .floor(floor)
    );
    
    CHANGE_DETECTOR change_detector0(
        .clk(clk),  
        .rst(rst),  
        .in(in),   
        .change(count_enable)
    );
    
    COUNTER counter0(
        .clk(clk),         
        .rst(rst),         
        .en(count_enable),          
        .changes_count(changes_count)
    );
    
endmodule
