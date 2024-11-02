`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:03:34 10/13/2023 
// Design Name: 
// Module Name:    P1_L2_intcheck 
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
`define other 4'b0000
`define num 4'b0001
`define letter 4'b0010
`define underline 4'b0011
`define semicolon 4'b0100
`define chari 4'b0101
`define charn 4'b0110
`define chart 4'b0111
`define space 4'b1000
`define tab 4'b1001
`define comma 4'b1010
`define rubbish 4'b1011


module intcheck(
	input clk,
	input reset,
	input [7:0] in,
	output reg [3:0] state,
	output [3:0] char_type,
	output out
    );
	 
	assign char_type = (in >= 8'd48 && in <= 8'd57) ? `num :
							 (in == 8'd105) ? `chari :
							 (in == 8'd110) ? `charn :
							 (in == 8'd116) ? `chart :
							 ((in >= 8'd65 && in <= 8'd90)||(in >= 8'd97 && in <= 8'd122)) ? `letter :
							 (in == 8'd95) ? `underline :
							 (in == 8'd59) ? `semicolon :
							 (in == 8'd32) ? `space : 
							 (in == 8'd9) ? `tab : 
							 (in == 8'd44) ? `comma : `other;
	reg flag;
	assign out = (flag == 1) ? 1 : 0;
	/*
		0:��ͷ��ʼ���i������������tab���ִ�״̬��
										  �����⵽i�����1���Ƚ�flag��0����
										  �������Ƚ�flag��0���ͽ�����ֹ״̬��
		1�����n�����n����2����֮��ֱ����ֹ��
		2�����t�����t����3����֮����ֹ��
		3: ���ո�
		3������ʶ���ĵ�һ����ĸ�����»��ߣ����Ϊ�ո񱣳�״̬��
												������ֻ������ַ���������ֹ��
												�����ĸ���»��ߣ�����4��
												�����⵽i������	
		4������ͨ��ʶ��������ĸ����i������ֱ꣬����⵽�ո����comma����semicolon�������⵽comma������3��
																							  �����⵽semicolon������1������flag��Ϊ1��
																							  �����⵽�հ��ַ�������5�ٴμ��semicolon��
																							  �����⵽��ĸ�����֡��»��ߣ�������state��
																							  ������������ֹ��
		5�����comma����semicolon�����Ϊ�ո񣬼�����
										���Ϊcomma������3��
										���Ϊsemicolon������0�����ҽ�flag��Ϊ1��
										������������ֹ��
		6�������һ����ʶ���Ƿ�Ϊn�����Ϊn�������7��
									  ���Ϊ�ո񣬽���5��
									  ���Ϊcomma������3��
									  ���Ϊsemicolon������0��flag��Ϊ1��
									  ���Ϊ������ĸ�����֡��»��ߣ�����4��
									  ��������ֹ��
		7�������һ����ʶ���Ƿ�Ϊt�����Ϊt������8��
									  ���Ϊ�ո񣬽���5��
									  ���Ϊcomma������3��
									  ���Ϊsemicolon������0��flag��Ϊ1��
									  ���Ϊ������ĸ�����֡��»��ߣ�����4��
									  ��������ֹ��
		8�������һ��in�����Ϊ�ո�comma��������ֹ��
							���Ϊsemicolon������0��
							���Ϊ������ĸ�����֡��»��ߣ�����4��
							��������ֹ��
		11����ֹ״̬��ֱ����⵽semicolon����0
	*/
	always@(posedge clk) begin
		if(reset) begin
			flag <= 0;
			state <= 0;
		end
		else begin
			case(state)
				4'b0000: begin
								flag <= 0;
								state <= (char_type == `tab || char_type == `space || char_type == `semicolon) ? 4'b0000 :			//�ֺ�
											(char_type == `chari) ? 4'b0001 : `rubbish;
							end
				4'b0001: state <= (char_type == `charn) ? 4'b0010 : 
										(char_type == `semicolon) ? 4'b0000 : `rubbish;
				4'b0010: state <= (char_type == `chart) ? 4'b0011 : 
										(char_type == `semicolon) ? 4'b0000 : `rubbish;
				4'b0011: state <= (char_type == `tab || char_type == `space) ? 4'b0100 : 
										(char_type == `semicolon) ? 4'b0000 : `rubbish;
				4'b0100: state <= (char_type == `tab || char_type == `space) ? 4'b0100 : 
										(char_type == `chari) ? 4'b0111 :
										(char_type == `letter || char_type == `underline || char_type == `charn || char_type == `chart) ? 4'b0101 : 
										(char_type == `semicolon) ? 4'b0000 : `rubbish;			//letter+i��n��t,			semicolon
				4'b0101: begin
								state <= (char_type == `comma) ? 4'b0100 :
											(char_type == `semicolon) ? 4'b0000 :
											(char_type == `tab || char_type == `space) ? 4'b0110 :
											(char_type == `letter || char_type == `num || char_type == `underline || char_type == `chari || char_type == `charn || char_type == `chart) ? 4'b0101 : `rubbish;
								flag <= (char_type == `semicolon) ? 1 : 0;
							end
				4'b0110: begin
								state <= (char_type == `comma) ? 4'b0100 :
											(char_type == `semicolon) ? 4'b0000 :
											(char_type == `tab || char_type == `space) ? 4'b0110 : `rubbish;
								flag <= (char_type == `semicolon) ? 1 : 0;
							end
				4'b0111: begin
								state <= (char_type == `charn) ? 4'b1000 :
											(char_type == `comma) ? 4'b0100 :
											(char_type == `semicolon) ? 4'b0000 :
											(char_type == `tab || char_type == `space) ? 4'b0110 :
											(char_type == `letter || char_type == `num || char_type == `underline || char_type == `chari || char_type == `chart) ? 4'b0101 : 4'b1011;
								flag <= (char_type == `semicolon) ? 1 : 0;
							end
				4'b1000: begin
								state <= (char_type == `chart) ? 4'b1001 :
											(char_type == `comma) ? 4'b0100 :
											(char_type == `semicolon) ? 4'b0000 :
											(char_type == `tab || char_type == `space) ? 4'b0110 :
											(char_type == `letter || char_type == `num || char_type == `underline || char_type == `chari || char_type == `charn) ? 4'b0101 : `rubbish;
								flag <= (char_type == `semicolon) ? 1 : 0;
							end
				4'b1001: state <= (char_type == `semicolon) ? 4'b0000 :
										(char_type == `letter || char_type == `num || char_type == `underline || char_type == `chari || char_type == `charn || char_type == `chart) ? 4'b0101 : `rubbish;
				4'b1011: state <= (char_type == `semicolon) ? 4'b0000 : 4'b1011;
			endcase
		end	
	end
endmodule
