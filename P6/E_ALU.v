`timescale 1ns / 1ps
`include "Define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:16:55 11/09/2023 
// Design Name: 
// Module Name:    E_ALU 
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
module E_ALU(
	input [31:0] SrcA,
	input [31:0] SrcB,
	input [3:0] opALU,
	output [31:0] ALUresult
    );
	wire [31:0] res_slt;
	wire less;
	assign less = $signed(SrcA) < $signed(SrcB);
	assign res_slt = (less) ? 32'h0000_0001 : 32'h0000_0000;
	
	assign ALUresult = (opALU == `ALU_add) ? SrcA + SrcB :
							 (opALU == `ALU_sub) ? SrcA - SrcB :
							 (opALU == `ALU_or) ? SrcA | SrcB : 
							 (opALU == `ALU_and) ? SrcA & SrcB : 
							 (opALU == `ALU_slt) ? res_slt : 
							 (opALU == `ALU_sltu) ? ((SrcA < SrcB) ? 32'h0000_0001 : 32'h0000_0000) : 32'h0000_0000;
	
endmodule
