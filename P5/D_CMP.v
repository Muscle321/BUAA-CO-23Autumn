`timescale 1ns / 1ps
`include "Define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:05:56 11/08/2023 
// Design Name: 
// Module Name:    D_CMP 
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
module D_CMP(
	input [31:0] rs,
	input [31:0] rt,
	input [2:0] opBranch,
	output Bflag
    );
	assign Bflag = (opBranch == `B_equal && rs == rt) ? 1 : 0;
	
	
endmodule
