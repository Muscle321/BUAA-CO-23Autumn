`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:35:49 10/31/2023 
// Design Name: 
// Module Name:    NPC 
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
`define Normal 3'b000
`define JImm 3'b001
`define JIndex 3'b010
`define JReg 3'b011


module NPC(
	input [31:0] PC,
	input [31:0] Branch,
	input [2:0] opNPC,
	input zero,
	output [31:0] NPC
    );
	
	assign NPC = (opNPC == `Normal) ? PC + 4 :
					 (opNPC == `JImm && zero == 1) ? PC + 4 + (Branch << 2) :
					 (opNPC == `JImm) ? PC + 4 : 
					 (opNPC == `JIndex) ? {PC[31:28], Branch[25:0], 2'b00} :
					 (opNPC == `JReg) ? Branch : 32'h0000_3000;
	
endmodule
