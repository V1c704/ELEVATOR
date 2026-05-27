`timescale 1ns / 1ps


module COUNTER #(parameter WIDTH = 4)(
        input logic              clk,
        input logic              rst,
        input logic              en,
        output logic [WIDTH-1:0] changes_count
    );
    
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            changes_count <= 4'd0;
        end
        else begin
            if(en) 
                changes_count <= changes_count + 4'd1;
        end
    end
    
endmodule
