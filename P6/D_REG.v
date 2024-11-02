`timescale 1ns / 1ps
`include "Define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:06:05 11/08/2023 
// Design Name: 
// Module Name:    D_REG 
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
module D_REG(
	input clk,
	input reset,
	input WE,
	input [31:0] F_PC,
	input [31:0] F_Instr,
	output reg [31:0] D_PC,
	output reg [31:0] D_Instr
    );
	
	always@(posedge clk) begin
		if(reset) begin
			D_PC <= 32'h0000_0000;
			D_Instr <= 32'h0000_0000;
		end
		else if(WE) begin
			D_PC <= F_PC;
			D_Instr <= F_Instr;
		end
		else begin
			D_PC <= D_PC;
			D_Instr <= D_Instr;
		end
	end
	
endmodule
