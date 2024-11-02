`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:07:58 10/31/2023 
// Design Name: 
// Module Name:    DM 
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
module DM(
	input clk,
	input reset,
	input WE,
	input [31:0] WD,
	input [31:0] addr,
	input [31:0] PC,
	input [1:0] ReadType,
	input [1:0] WriteType,
	output [31:0] RD
    );
	 reg [31:0] data [0:3071];
	 wire [12:0] DM_addr;
	 wire [31:0] DM_WD,DM_RD;
	 assign DM_addr = addr[13:2];
	 assign DM_RD = data[DM_addr];
	 assign RD = (ReadType == 2'b00) ? DM_RD :
					 (ReadType == 2'b01 && addr[1:0] == 2'b00) ? {{24{DM_RD[7]}},DM_RD[7:0]} :
					 (ReadType == 2'b01 && addr[1:0] == 2'b01) ? {{24{DM_RD[15]}},DM_RD[15:8]} :
					 (ReadType == 2'b01 && addr[1:0] == 2'b10) ? {{24{DM_RD[23]}},DM_RD[23:16]} :
					 (ReadType == 2'b01 && addr[1:0] == 2'b11) ? {{24{DM_RD[31]}},DM_RD[31:24]} :
					 (ReadType == 2'b10 && addr[1] == 1'b0) ? {{16{DM_RD[15]}},DM_RD[15:0]} :
					 (ReadType == 2'b10 && addr[1] == 1'b1) ? {{16{DM_RD[31]}},DM_RD[31:16]} : DM_RD;
	 
	 assign DM_WD = (WriteType == 2'b00) ? WD :
						 (WriteType == 2'b01 && addr[1:0] == 2'b00) ? {DM_RD[31:8],WD[7:0]} :
						 (WriteType == 2'b01 && addr[1:0] == 2'b01) ? {DM_RD[31:16],WD[7:0],DM_RD[7:0]} :
						 (WriteType == 2'b01 && addr[1:0] == 2'b10) ? {DM_RD[31:24],WD[7:0],DM_RD[15:0]} :
						 (WriteType == 2'b01 && addr[1:0] == 2'b11) ? {WD[7:0],DM_RD[23:0]} :
						 (WriteType == 2'b10 && addr[1] == 1'b0) ? {DM_RD[31:16],WD[15:0]} :
						 (WriteType == 2'b10 && addr[1] == 1'b1) ? {WD[15:0],DM_RD[15:0]} : WD;
	 integer i;
	 
	 always@(posedge clk) begin
		if(reset) begin
			for(i = 0; i <= 12'd3071; i = i + 1) data[i] <= 32'h0000_0000;
		end
		else begin
			if(WE) begin
				data[DM_addr] <= DM_WD;
				$display("@%h: *%h <= %h", PC, addr, DM_WD);
			end
		end
	 end
endmodule
