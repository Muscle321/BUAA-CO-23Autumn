`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:54:30 10/31/2023 
// Design Name: 
// Module Name:    IFU 
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
module IFU(
	input clk,
	input reset,
	input [31:0] NPC,
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
		else IM_PC <= NPC - 32'h0000_3000;
	end

endmodule
