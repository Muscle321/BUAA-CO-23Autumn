`timescale 1ns / 1ps
`include "Define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:27:00 12/01/2023 
// Design Name: 
// Module Name:    Bridge 
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
module Bridge(
	input [31:0] pre_m_data_addr,
	input [31:0] pre_m_data_wdata,
	input [3:0] pre_m_data_byteen,
	input [31:0] pre_m_data_rdata,
	input Req,
	input [31:0] TC0_Dout,
	input [31:0] TC1_Dout,
	
	output [31:0] m_data_addr,
	output [31:0] m_data_wdata,
	output [3:0] m_data_byteen,
	output [31:0] m_data_rdata,
	
	output [31:0] m_int_addr,     
   output [3:0] m_int_byteen,   
	
	output TC0_WE,
	output [31:0] TC0_Din,
	output [31:2] TC0_Addr,
	output TC1_WE,
	output [31:0] TC1_Din,
	output [31:2] TC1_Addr
    );
	 wire TC_WE = &pre_m_data_byteen;
	 assign TC0_WE = !Req && TC_WE && (pre_m_data_addr >= 32'h0000_7f00 && pre_m_data_addr <= 32'h0000_7f07);
	 assign TC1_WE = !Req && TC_WE && (pre_m_data_addr >= 32'h0000_7f10 && pre_m_data_addr <= 32'h0000_7f17);
	 assign TC0_Din = pre_m_data_wdata;
	 assign TC1_Din = pre_m_data_wdata;
	 assign TC0_Addr = pre_m_data_addr[31:2];
	 assign TC1_Addr = pre_m_data_addr[31:2];
	 
	 assign m_data_addr = pre_m_data_addr;
	 assign m_data_wdata = pre_m_data_wdata;
	 assign m_data_byteen = (pre_m_data_addr >= 32'h0000_0000 && pre_m_data_addr <= 32'h0000_2fff && !Req) ? pre_m_data_byteen : 4'b0000;
	 
	 assign m_int_addr = pre_m_data_addr;
	 assign m_int_byteen = (pre_m_data_addr >= 32'h0000_7f20 && pre_m_data_addr <= 32'h0000_7f23 && !Req) ? pre_m_data_byteen : 4'b0000;
	 
	 assign m_data_rdata = (pre_m_data_addr >= 32'h0000_0000 && pre_m_data_addr <= 32'h0000_2fff) ? pre_m_data_rdata :
								  (pre_m_data_addr >= 32'h0000_7f00 && pre_m_data_addr <= 32'h0000_7f0b) ? TC0_Dout : 
								  (pre_m_data_addr >= 32'h0000_7f10 && pre_m_data_addr <= 32'h0000_7f1b) ? TC1_Dout :
								  (pre_m_data_addr >= 32'h0000_7f20 && pre_m_data_addr <= 32'h0000_7f23) ? 32'h0000_0000 : 32'h0000_0000;
	 
endmodule
