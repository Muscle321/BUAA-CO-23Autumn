`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:30:11 10/31/2023 
// Design Name: 
// Module Name:    Controller 
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

// define opcode
`define typeR 6'b00_0000
`define ori 6'b00_1101
`define lw 6'b10_0011
`define sw 6'b10_1011
`define beq 6'b00_0100
`define lui 6'b00_1111
`define jal 6'b00_0011

//opcode is 00_0000 and define funct
`define jr 6'b00_1000
`define add 6'b10_0000
`define sub 6'b10_0010


module Controller(
	input [31:0] Instr,
	output NumRead,
	output NumWrite,
	output [2:0] opNPC,
	output [2:0] opALU,
	output ALUsrc,
	output opEXT,
	output RegWrite,
	output RegSel,
	output isJAL,
	output [2:0] BranchSel
    );
	 wire [5:0] opcode;
	 wire [5:0] funct;
	 assign opcode = Instr[31:26];
	 assign funct = Instr[5:0];
	 
	 
	 assign NumRead = (opcode == `lw) ? 1 : 0;
	 assign NumWrite = (opcode == `sw) ? 1 : 0;
	 assign opEXT = (opcode == `beq) ? 1 : 
						 (opcode == `lw) ? 1 : 
						 (opcode == `sw) ? 1 : 0;
	 assign isJAL = (opcode == `jal) ? 1 : 0;
	 
	 
	 assign ALUsrc = (opcode == `ori) ? 1 :
						  (opcode == `lw) ? 1 :
						  (opcode == `sw) ? 1 :
						  (opcode == `lui) ? 1 : 0;
						  
	 assign RegWrite = (opcode == `ori) ? 1 :
							 (opcode == `lw) ? 1 :
							 (opcode == `jal) ? 1 :
						    (opcode == `lui) ? 1 : 
							 (opcode == `typeR && funct == `add) ? 1 : 
							 (opcode == `typeR && funct == `sub) ? 1 : 0;
							 
	 assign RegSel = (opcode == `typeR && funct == `add) ? 1 : 
						  (opcode == `typeR && funct == `sub) ? 1 : 0;
	 
	 assign opNPC = (opcode == `beq) ? 3'b001 :
						 (opcode == `jal) ? 3'b010 :
						 (opcode == `typeR && funct == `jr) ? 3'b011 : 3'b000;

	 assign opALU = (opcode == `beq) ? 3'b001 :
						 (opcode == `ori) ? 3'b010 :
						 (opcode == `lui) ? 3'b011 :
						 (opcode == `typeR && funct == `sub) ? 3'b001 : 3'b000;
	 
	 assign BranchSel = (opcode == `beq) ? 3'b001 :
							  (opcode == `jal) ? 3'b010 :
							  (opcode == `typeR && funct == `jr) ? 3'b011 : 3'b000;
	 
	 
endmodule
