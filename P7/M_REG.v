`timescale 1ns / 1ps
`include "Define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:29:51 11/09/2023 
// Design Name: 
// Module Name:    M_REG 
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
module M_REG(
	input clk,
	input reset,
	input Req,
	input [31:0] E_PC,
	input [31:0] E_Instr,
	input [31:0] E_ALUresult,
	input [31:0] E_rt,
	input [31:0] E_HILOout,
	input E_BD,
	input [4:0] E_ExcCode,
	input E_overflow,
	output reg M_overflow,
	output reg [4:0] M_ExcCode,
	output reg M_BD,
	output reg [31:0] M_PC,
	output reg [31:0] M_Instr,
	output reg [31:0] M_ALUresult,
	output reg [31:0] M_HILOout,
	output reg [31:0] M_rt
    );
	
	always@(posedge clk) begin
		if(reset | Req) begin
			M_PC <= (Req) ? 32'h0000_4180 : 32'h0000_0000;
			M_Instr <= 32'h0000_0000;
			M_ALUresult <= 32'h0000_0000;
			M_rt <= 32'h0000_0000;
			M_HILOout <= 32'h0000_0000;
			M_BD <= 0;
			M_ExcCode <= 5'd0;
			M_overflow <= 0;
		end
		else begin
			M_PC <= E_PC;
			M_Instr <= E_Instr;
			M_ALUresult <= E_ALUresult;
			M_rt <= E_rt;
			M_HILOout <= E_HILOout;
			M_BD <= E_BD;
			M_ExcCode <= E_ExcCode;
			M_overflow <= E_overflow;
		end
	end
	
endmodule
