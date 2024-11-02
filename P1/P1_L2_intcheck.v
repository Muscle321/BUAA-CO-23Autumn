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
		0:从头开始检测i，如果是零或者tab保持此状态；
										  如果检测到i则进入1，先将flag置0，；
										  其他，先将flag置0，就进入终止状态。
		1：检测n，如果n进入2，反之，直接终止。
		2：检测t，如果t进入3，反之，终止。
		3: 检测空格
		3：检测标识符的第一个字母或者下划线，如果为空格保持状态；
												如果数字或其他字符，进入终止；
												如果字母或下划线，进入4；
												如果检测到i，进入	
		4：将普通标识符（首字母不是i）检测完，直到检测到空格或者comma或者semicolon，如果检测到comma，进入3；
																							  如果检测到semicolon，进入1，并且flag置为1；
																							  如果检测到空白字符，进入5再次检测semicolon；
																							  如果检测到字母、数字、下划线，继续该state；
																							  其他，进入终止；
		5：检测comma或者semicolon，如果为空格，继续；
										如果为comma，进入3；
										如果为semicolon，进入0，并且将flag置为1；
										其他，进入终止；
		6：检测下一个标识符是否为n，如果为n，则进入7；
									  如果为空格，进入5；
									  如果为comma，进入3；
									  如果为semicolon，进入0，flag置为1；
									  如果为其他字母、数字、下划线，进入4；
									  其他，终止；
		7：检测下一个标识符是否为t，如果为t，进入8；
									  如果为空格，进入5；
									  如果为comma，进入3；
									  如果为semicolon，进入0，flag置为1；
									  如果为其他字母、数字、下划线，进入4；
									  其他，终止；
		8：检测下一个in，如果为空格、comma，进入终止；
							如果为semicolon，进入0；
							如果为其他字母、数字、下划线，进入4；
							其他，终止；
		11：终止状态，直到检测到semicolon进入0
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
								state <= (char_type == `tab || char_type == `space || char_type == `semicolon) ? 4'b0000 :			//分号
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
										(char_type == `semicolon) ? 4'b0000 : `rubbish;			//letter+i，n，t,			semicolon
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
