`timescale 1ns / 1ps
`include "Define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:36:47 11/08/2023 
// Design Name: 
// Module Name:    F_IFU 
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
module F_IFU(
	input clk,
	input reset,
	input [31:0] NPC,
	input WE,
	output [31:0] Instr,
	output [31:0] PC
    );
	reg [31:0] IM [0:4095];

	initial begin
        $readmemh("code.txt", IM);
	end

	
	reg [31:0]IM_PC;
	
	assign PC = IM_PC + 32'h0000_3000;
	assign Instr = IM[IM_PC[13:2]];
	
	always@(posedge clk) begin
		if(reset) IM_PC <= 32'h0000_0000;
		else if(WE) IM_PC <= NPC - 32'h0000_3000;
		else IM_PC <= IM_PC;
	end

endmodule
