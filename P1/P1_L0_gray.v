`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:33:10 10/10/2023 
// Design Name: 
// Module Name:    P1_L0_gray 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module gray(
	input Clk,
	input Reset,
	input En,
	output reg [2:0] Output,
	output reg Overflow
    );
	always@(posedge Clk) begin
		if(Reset) begin
			Output <= 3'b0;
			Overflow <= 0;
		end
		else if(En) begin
			case(Output)
				3'b000: 	begin
								Output <=3'b001;
								Overflow <= Overflow;
							end
				3'b001: 	begin
								Output <=3'b011;
								Overflow <= Overflow;
							end
				3'b011: 	begin
								Output <=3'b010;
								Overflow <= Overflow;
							end
				3'b010: 	begin
								Output <=3'b110;
								Overflow <= Overflow;
							end
				3'b110: 	begin
								Output <=3'b111;
								Overflow <= Overflow;
							end
				3'b111: 	begin
								Output <=3'b101;
								Overflow <= Overflow;
							end
				3'b101: 	begin
								Output <=3'b100;
								Overflow <= Overflow;
							end
				3'b100: 	begin
								Output <=3'b000;
								Overflow <= 1;
							end
			endcase
		end
	end
endmodule
