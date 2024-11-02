`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:41:41 10/31/2023 
// Design Name: 
// Module Name:    ALU 
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
`define ADD 3'b000
`define SUB 3'b001
`define oor 3'b010
`define sll16 3'b011

module ALU(
	input [31:0] SrcA,
	input [31:0] SrcB,
	input [2:0] opALU,
	output [31:0] ALUresult,
	output Zero
    );
	 
	assign ALUresult = (opALU == `ADD) ? SrcA + SrcB :
							 (opALU == `SUB) ? SrcA - SrcB :
							 (opALU == `oor) ? SrcA | SrcB :
							 (opALU == `sll16) ? SrcB<<16 : 32'h0000_0000;
	assign Zero = (ALUresult == 32'h0000_0000) ? 1 : 0;
	
endmodule
