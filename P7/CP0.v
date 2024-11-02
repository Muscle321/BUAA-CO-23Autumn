`timescale 1ns / 1ps
`include "Define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:27:48 12/01/2023 
// Design Name: 
// Module Name:    CP0 
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
module CP0(
	input clk,
	input reset,
	input en,
	input [4:0] CP0Add,
	input [31:0] CP0In,
	output [31:0] CP0Out,
	input [31:0] VPC,				//输入VPC
	input BDIn,						//输入BD
	input [4:0] ExcCodeIn,		//输入ExcCode
	input [5:0] HWInt,			//输入IP
	input EXLClr,					//EXL清除信号
	output [31:0] EPCOut,
	output Req
    );
	 reg [31:0] SR, Cause, EPC;
	 wire [31:0] temp_EPC = (Req) ? (BDIn ? VPC - 32'h4 : VPC) : EPC;
	 wire IntReq, ExcReq;
	 assign CP0Out = (CP0Add == 5'd12) ? SR :
						  (CP0Add == 5'd13) ? Cause :
						  (CP0Add == 5'd14) ? EPCOut : 32'h0000_0000;
	 assign IntReq = (`IE & !`EXL & (|(`IM & HWInt)));
	 assign ExcReq = (!`EXL & (|ExcCodeIn));
	 assign Req = IntReq | ExcReq;
	 
	 assign EPCOut = temp_EPC;
	 
	 always@(posedge clk) begin
		if(reset) begin
			SR <= 32'h0000_0000;
			Cause <= 32'h0000_0000;
			EPC <= 32'h0000_0000;
		end else begin
			`IP <= HWInt;
			if(Req) begin
				`EXL <= 1'b1;
				`BD <= BDIn;
				EPC <= temp_EPC;
				`ExcCode <= IntReq ? 5'd0 : ExcCodeIn;
			end else if (EXLClr) begin
				`EXL <= 1'b0;
			end else if(en) begin
				if(CP0Add == 5'd12) SR <= CP0In;
				else if(CP0Add == 5'd14) EPC <= CP0In;
			end
		end
	 end
endmodule
