`timescale 1ns / 1ps
`include "Define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:05:40 11/08/2023 
// Design Name: 
// Module Name:    D_NPC 
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
module D_NPC(
	input Req,
	input eret,
	input [31:0] D_PC,
	input [31:0] F_PC,
	input [31:0] Branch,
	input [31:0] EPC,
	input [25:0] Index,
	input [31:0] rs,
	input [2:0] opNPC,
	input Bflag,
	input stall,
	output [31:0] NPC
    );
	
	assign NPC = (Req) ? 32'h0000_4180 : 
					 (eret) ? EPC + 4 : 
					 (stall) ? F_PC :
					 (opNPC == `NPC_n) ? F_PC + 4 :
					 (opNPC == `NPC_b) ? (Bflag ? D_PC + 4 + (Branch<<2) : F_PC + 4) : 
					 (opNPC == `NPC_jt) ? {D_PC[31:28], Index, 2'b00} :
					 (opNPC == `NPC_jr) ? rs : 32'h0000_3000;
	
endmodule
