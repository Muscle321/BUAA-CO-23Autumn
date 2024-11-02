`timescale 1ns / 1ps
`include "Define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:42:14 11/08/2023 
// Design Name: 
// Module Name:    D_GRF 
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
module D_GRF(
	input clk,
	input reset,
	input WE,
	input [4:0] A1,
	input [4:0] A2,
	input [4:0] A3,
	input [31:0] WD,
	input [31:0] PC,
	output [31:0] RD1,
	output [31:0] RD2
    );
	 
	 integer i;
	 reg [31:0] Register [0:31];
	 assign RD1 = (A1 == 5'd0) ? 32'h0000_0000 : 
					  (A1 == A3) ? WD : Register[A1];
					  
	 assign RD2 = (A2 == 5'd0) ? 32'h0000_0000 : 
					  (A2 == A3) ? WD : Register[A2];
	 
	 
	 always@(posedge clk) begin
		if(reset) begin
			for(i = 0; i <= 5'd31; i = i + 1) Register[i] <= 32'h0000_0000;
		end
		else begin
			if(WE == 1 && A3 != 5'd0) Register[A3] <= WD;
		end
	 end
	 
endmodule
