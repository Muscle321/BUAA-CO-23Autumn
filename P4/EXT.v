`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:57:29 10/31/2023 
// Design Name: 
// Module Name:    EXT 
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
module EXT(
	input [15:0] imm,
	input opEXT,
	output [31:0] EXT
    );
	wire [31:0] num;
	assign num = $signed(imm);
	assign EXT = (opEXT == 1'b0) ? imm : num;
	
endmodule
