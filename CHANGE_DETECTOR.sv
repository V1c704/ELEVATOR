`timescale 1ns / 1ps


module CHANGE_DETECTOR(
        input  logic      clk,
        input  logic      rst,
        input logic [1:0] in,
        output logic      change
    );
    
    logic [1:0] register;
    
    always_ff @(posedge clk) begin
        if(rst) begin
           change <= 1'b0;
           register <= 2'd0; 
        end
        else begin
           if(in != register) begin
                change <= 1'b1;
           end
           else change <= 1'b0;     
        end
        register <= in;
    end
    
endmodule
