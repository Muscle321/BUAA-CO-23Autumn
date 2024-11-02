`timescale 1ns / 1ps
`include "Define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:31:21 11/14/2023 
// Design Name: 
// Module Name:    M_LOAD 
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
module M_LOAD(
	input [1:0] addr,
	input [31:0] DM_RD,
	input [2:0] LoadType,
	output [31:0] RD
    );
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
	 
endmodule
