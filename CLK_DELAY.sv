`timescale 1ns / 1ps


module CLK_DELAY(
        input logic  clk,
        input logic  rst,
        input logic  en,
        output logic clk_delay
    );
    
    logic [31:0] count;
    
    always_ff @(posedge clk)begin
        if(rst) begin
            count <= 32'b0;
        end
        else begin
            if(en)begin
                count <= count + 32'd1;
            end          
        end
    end
    
    assign clk_delay = count[27];
    
endmodule
