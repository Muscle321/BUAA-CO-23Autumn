`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:57:50 10/10/2023 
// Design Name: 
// Module Name:    P1_L0_ALU 
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
module alu(
	input [31:0] A,
	input [31:0] B,
	input [2:0] ALUOp,
	output [31:0] C
    );
	 wire [31:0] D;
	 assign D = $signed(A) >>> B;
	 assign C = (ALUOp == 3'b000) ? A + B :
					(ALUOp == 3'b001) ? A - B :
					(ALUOp == 3'b010) ? A & B :
					(ALUOp == 3'b011) ? A | B :
					(ALUOp == 3'b100) ? A >> B :
					(ALUOp == 3'b101) ? D : 0;

					
endmodule
