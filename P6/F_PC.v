`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:47:53 11/14/2023 
// Design Name: 
// Module Name:    F_PC 
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
module F_PC(
	input clk,
	input reset,
	input [31:0] NPC,
	input WE,
	output [31:0] PC
    );

	reg [31:0]IM_PC;
	
	assign PC = IM_PC + 32'h0000_3000;
	
	always@(posedge clk) begin
		if(reset) IM_PC <= 32'h0000_0000;
		else if(WE) IM_PC <= NPC - 32'h0000_3000;
		else IM_PC <= IM_PC;
	end

endmodule
