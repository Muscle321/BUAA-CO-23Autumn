`timescale 1ns / 1ps
`include "Define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:55:49 11/09/2023 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,                    // ʱ���ź�
    input reset,                  // ͬ����λ�ź�
    input interrupt,              // �ⲿ�ж��ź�
    output [31:0] macroscopic_pc, // ��� PC

    output [31:0] i_inst_addr,    // IM ��ȡ��ַ��ȡָ PC��
    input  [31:0] i_inst_rdata,   // IM ��ȡ����

    output [31:0] m_data_addr,    // DM ��д��ַ
    input  [31:0] m_data_rdata,   // DM ��ȡ����
    output [31:0] m_data_wdata,   // DM ��д������
    output [3 :0] m_data_byteen,  // DM �ֽ�ʹ���ź�

    output [31:0] m_int_addr,     // �жϷ�������д���ַ
    output [3 :0] m_int_byteen,   // �жϷ������ֽ�ʹ���ź�

    output [31:0] m_inst_addr,    // M �� PC

    output w_grf_we,              // GRF дʹ���ź�
    output [4 :0] w_grf_addr,     // GRF ��д��Ĵ������
    output [31:0] w_grf_wdata,    // GRF ��д������

    output [31:0] w_inst_addr     // W �� PC
);
//---------------Bridge----------------//
	 wire [31:0] pre_m_data_addr, pre_m_data_wdata, new_m_data_rdata;
	 wire [3:0] pre_m_data_byteen;
	
	 wire TC1_WE, TC0_WE, Req;
	 wire TC1_IRQ, TC0_IRQ;
	 wire [31:0] TC1_out, TC0_out, TC0_Din, TC1_Din;
	 wire [31:2] TC0_Addr, TC1_Addr;
	 wire [5:0] HWInt = {3'b0, interrupt, TC1_IRQ, TC0_IRQ};
	 
	 
	Bridge bridge(
		.pre_m_data_addr(pre_m_data_addr),
		.pre_m_data_wdata(pre_m_data_wdata),
		.pre_m_data_byteen(pre_m_data_byteen),
		.pre_m_data_rdata(m_data_rdata),
		.Req(Req),
		.TC0_Dout(TC0_Dout),
		.TC1_Dout(TC1_Dout),	
		.m_data_addr(m_data_addr),
		.m_data_wdata(m_data_wdata),
		.m_data_byteen(m_data_byteen),
		.m_data_rdata(new_m_data_rdata),
		.m_int_addr(m_int_addr),     
		.m_int_byteen(m_int_byteen),   
		.TC0_WE(TC0_WE),
		.TC0_Din(TC0_Din),
		.TC0_Addr(TC0_Addr),
		.TC1_WE(TC1_WE),
		.TC1_Din(TC1_Din),
		.TC1_Addr(TC1_Addr)
	);
	
//---------------Timer----------------//
	 
	 TC TC0(
		.clk(clk),
		.reset(reset),
		.Addr(TC0_Addr),
		.WE(TC0_WE),
		.Din(TC0_Din),
		.Dout(TC0_out),
		.IRQ(TC0_IRQ)
	 );
	 
	 TC TC1(
		.clk(clk),
		.reset(reset),
		.Addr(TC1_Addr),
		.WE(TC1_WE),
		.Din(TC1_Din),
		.Dout(TC1_out),
		.IRQ(TC1_IRQ)
	 );
	 
//---------------CPU----------------//

	 
	 CPU cpu(
		.clk(clk),
		.reset(reset),
		.i_inst_rdata(i_inst_rdata),
		.m_data_rdata(new_m_data_rdata),
		.HWInt(HWInt),
		.i_inst_addr(i_inst_addr),
		.m_data_addr(pre_m_data_addr),
		.m_data_wdata(pre_m_data_wdata),
		.m_inst_addr(m_inst_addr),
		.m_data_byteen(pre_m_data_byteen),
		.w_grf_we(w_grf_we),
		.w_grf_addr(w_grf_addr),
		.w_grf_wdata(w_grf_wdata),
		.w_inst_addr(w_inst_addr),
		.macroscopic_pc(macroscopic_pc),
		.Req(Req)
	 );
	 
	 
endmodule
