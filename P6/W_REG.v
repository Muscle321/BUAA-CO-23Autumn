`timescale 1ns / 1ps
`include "Define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:38:02 11/09/2023 
// Design Name: 
// Module Name:    W_REG 
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
module W_REG(
	input clk,
	input reset,
	input [31:0] M_PC,
	input [31:0] M_Instr,
	input [31:0] M_ALUresult,
	input [31:0] M_RD,
	input [31:0] M_HILOout,
	output reg [31:0] W_PC,
	output reg [31:0] W_Instr,
	output reg [31:0] W_ALUresult,
	output reg [31:0] W_RD,
	output reg [31:0] W_HILOout
    );
	
	always@(posedge clk) begin
		if(reset) begin
			W_PC <= 32'h0000_0000;
			W_Instr <= 32'h0000_0000;
			W_ALUresult <= 32'h0000_0000;
			W_RD <= 32'h0000_0000;
			W_HILOout <= 32'h0000_0000;
		end
		else begin
			W_PC <= M_PC;
			W_Instr <= M_Instr;
			W_ALUresult <= M_ALUresult;
			W_RD <= M_RD;
			W_HILOout <= M_HILOout;
		end
	end
	
endmodule
