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
	input Req,
	input [31:0] F_PC,
	input [31:0] F_Instr,
	input F_BD,
	input [4:0] F_ExcCode,
	output reg [4:0] D_ExcCode,
	output reg D_BD,
	output reg [31:0] D_PC,
	output reg [31:0] D_Instr
    );
	
	always@(posedge clk) begin
		if(reset || Req) begin
			D_PC <= (Req) ? 32'h0000_4180 : 32'h0000_0000;
			D_Instr <= 32'h0000_0000;
			D_BD <= 0;
			D_ExcCode <= 5'd0;
		end
		else if(WE) begin
			D_PC <= F_PC;
			D_Instr <= F_Instr;
			D_BD <= F_BD;
			D_ExcCode <= F_ExcCode;
		end
		else begin
			D_PC <= D_PC;
			D_Instr <= D_Instr;
			D_BD <= D_BD;
			D_ExcCode <= D_ExcCode;
		end
	end
	
endmodule
