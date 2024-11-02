`timescale 1ns / 1ps
`include "Define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:21:49 11/14/2023 
// Design Name: 
// Module Name:    M_BE 
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
module M_BE(
	input [1:0] addr,
	input [1:0] StoreType,
	output [3:0] byteen
    );
	assign byteen = (StoreType == `DM_sw) ? 4'b1111 :
						 (StoreType == `DM_sb && addr[1:0] == 2'b00) ? 4'b0001 :
						 (StoreType == `DM_sb && addr[1:0] == 2'b01) ? 4'b0010 :
						 (StoreType == `DM_sb && addr[1:0] == 2'b10) ? 4'b0100 :
						 (StoreType == `DM_sb && addr[1:0] == 2'b11) ? 4'b1000 :
						 (StoreType == `DM_sh && addr[1] == 1'b0) ? 4'b0011 :
						 (StoreType == `DM_sh && addr[1] == 1'b1) ? 4'b1100 : 4'b0000;
endmodule
