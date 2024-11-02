`timescale 1ns / 1ps
`include "Define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:09:15 11/09/2023 
// Design Name: 
// Module Name:    E_REG 
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
module E_REG(
	input clk,
	input reset,
	input clr,
	input [31:0] D_PC,
	input [31:0] D_Instr,
	input [31:0] D_rs,
	input [31:0] D_rt,
	input [31:0] D_Extout,
	output reg [31:0] E_PC,
	output reg [31:0] E_Instr,
	output reg [31:0] E_rs,
	output reg [31:0] E_rt,
	output reg [31:0] E_Extout
    );
	
	always@(posedge clk) begin
		if(reset || clr) begin
			E_PC <= 32'h0000_0000;
			E_Instr <= 32'h0000_0000;
			E_rs <= 32'h0000_0000;
			E_rt <= 32'h0000_0000;
			E_Extout <= 32'h0000_0000;
		end
		else begin
			E_PC <= D_PC;
			E_Instr <= D_Instr;
			E_rs <= D_rs;
			E_rt <= D_rt;
			E_Extout <= D_Extout;
		end
	end
	
endmodule