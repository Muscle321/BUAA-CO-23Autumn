`timescale 1ns / 1ps
`include "Define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:29:14 11/09/2023 
// Design Name: 
// Module Name:    M_DM 
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
module M_DM(
	input clk,
	input reset,
	input WE,
	input [31:0] WD,
	input [31:0] addr,
	input [31:0] PC,
	input [2:0] LoadType,
	input [1:0] StoreType,
	output [31:0] RD
    );
	 reg [31:0] data [0:3071];
	 wire [12:0] DM_addr;
	 wire [31:0] DM_WD,DM_RD;
	 assign DM_addr = addr[13:2];
	 assign DM_RD = data[DM_addr];
	 assign RD = (LoadType == `DM_lw) ? DM_RD :
					 (LoadType == `DM_lb && addr[1:0] == 2'b00) ? {{24{DM_RD[7]}},DM_RD[7:0]} :
					 (LoadType == `DM_lb && addr[1:0] == 2'b01) ? {{24{DM_RD[15]}},DM_RD[15:8]} :
					 (LoadType == `DM_lb && addr[1:0] == 2'b10) ? {{24{DM_RD[23]}},DM_RD[23:16]} :
					 (LoadType == `DM_lb && addr[1:0] == 2'b11) ? {{24{DM_RD[31]}},DM_RD[31:24]} :
					 (LoadType == `DM_lbu && addr[1:0] == 2'b00) ? {{24{1'b0}},DM_RD[7:0]} :
					 (LoadType == `DM_lbu && addr[1:0] == 2'b01) ? {{24{1'b0}},DM_RD[15:8]} :
					 (LoadType == `DM_lbu && addr[1:0] == 2'b10) ? {{24{1'b0}},DM_RD[23:16]} :
					 (LoadType == `DM_lbu && addr[1:0] == 2'b11) ? {{24{1'b0}},DM_RD[31:24]} :
					 (LoadType == `DM_lh && addr[1] == 1'b0) ? {{16{DM_RD[15]}},DM_RD[15:0]} :
					 (LoadType == `DM_lh && addr[1] == 1'b1) ? {{16{DM_RD[31]}},DM_RD[31:16]} : 
					 (LoadType == `DM_lhu && addr[1] == 1'b0) ? {{16{1'b0}},DM_RD[15:0]} :
					 (LoadType == `DM_lhu && addr[1] == 1'b1) ? {{16{1'b0}},DM_RD[31:16]} : DM_RD;
	 
	 assign DM_WD = (StoreType == `DM_sw) ? WD :
						 (StoreType == `DM_sb && addr[1:0] == 2'b00) ? {DM_RD[31:8],WD[7:0]} :
						 (StoreType == `DM_sb && addr[1:0] == 2'b01) ? {DM_RD[31:16],WD[7:0],DM_RD[7:0]} :
						 (StoreType == `DM_sb && addr[1:0] == 2'b10) ? {DM_RD[31:24],WD[7:0],DM_RD[15:0]} :
						 (StoreType == `DM_sb && addr[1:0] == 2'b11) ? {WD[7:0],DM_RD[23:0]} :
						 (StoreType == `DM_sh && addr[1] == 1'b0) ? {DM_RD[31:16],WD[15:0]} :
						 (StoreType == `DM_sh && addr[1] == 1'b1) ? {WD[15:0],DM_RD[15:0]} : WD;
	 integer i;
	 
	 always@(posedge clk) begin
		if(reset) begin
			for(i = 0; i <= 12'd3071; i = i + 1) data[i] <= 32'h0000_0000;
		end
		else begin
			if(WE) begin
				data[DM_addr] <= DM_WD;
				$display("%d@%h: *%h <= %h", $time, PC, {addr[31:2],2'b00}, DM_WD);
			end
		end
	 end
endmodule
