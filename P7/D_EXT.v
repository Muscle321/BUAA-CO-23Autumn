`timescale 1ns / 1ps
`include "Define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:57:22 11/08/2023 
// Design Name: 
// Module Name:    D_EXT 
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
module D_EXT(
	input [15:0] imm,
	input [1:0] opEXT,
	output [31:0] Extout
    );
	assign Extout = (opEXT == `Ext_unsigned) ? {{16{1'b0}},imm} : 
						 (opEXT == `Ext_signed) ? {{16{imm[15]}},imm} : 
						 (opEXT == `Ext_sll) ? {imm,{16{1'b0}}} : imm;
	
endmodule
