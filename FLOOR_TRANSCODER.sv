`timescale 1ns / 1ps


module FLOOR_TRANSCODER(
        input logic [1:0]  in,
        output logic [6:0] out
    );
    
    always_comb begin
        case(in)
            2'd0:   out = 7'b000_1100;
            2'd1:   out = 7'b111_1001;
            2'd2:   out = 7'b010_0100;
            2'd3:   out = 7'b011_0000;
            default: out = 7'b111_1111;
        endcase    
    end
    
endmodule
