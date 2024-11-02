`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:08:04 10/10/2023 
// Design Name: 
// Module Name:    P0_L0_EXT 
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
module ext(
	input [15:0] imm,
	input [1:0] EOp,
	output [31:0] ext
    );
	 assign ext = (EOp == 2'b00 && imm[15] == 1) ? {16'hffff,imm} :
					  (EOp == 2'b00 || EOp == 2'b01) ? {16'h0000,imm} :
					  (EOp == 2'b10) ? {imm,16'h0000} :
					  (EOp == 2'b11 && imm[15] == 1) ? {16'hffff,imm} << 2 : {16'h0000,imm} << 2;
	 
	 
endmodule
