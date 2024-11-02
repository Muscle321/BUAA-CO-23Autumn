`timescale 1ns / 1ps
`include "Define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:11:49 11/14/2023 
// Design Name: 
// Module Name:    E_HILO 
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
module E_HILO(
	input clk,
	input reset,
	input Req,
	input [31:0] rs,
	input [31:0] rt,
	input [3:0] opHILO,
	output HILObusy,
	output [31:0] result
    );
	 reg [31:0] HI, LO, temp_hi, temp_lo;
	 reg [3:0] count;
	 reg busy;
	 wire start;
	 
	 
	 wire [63:0] Mout, Muout;
	 wire [31:0] Div, Divu, Mod, Modu;
	 
	 assign Div = $signed(rs) / $signed(rt);
	 assign Divu = rs / rt;
	 assign Mod = $signed(rs) % $signed(rt);
	 assign Modu = rs % rt;
	 assign Muout = {{32{1'b0}}, rs} * {{32{1'b0}}, rt};
	 assign Mout = {{32{rs[31]}}, rs} * {{32{rt[31]}}, rt};
	 
	 assign start = (opHILO == `HILO_mult || opHILO == `HILO_multu || opHILO == `HILO_div || opHILO == `HILO_divu) ? 1 : 0;
	 assign result = (opHILO == `HILO_mfhi) ? HI :
						  (opHILO == `HILO_mflo) ? LO : 32'h0000_0000;
	 assign HILObusy = start | busy;
	 
	 
	 always@(posedge clk) begin
		if(reset) begin
			temp_hi <= 32'h0000_0000;
			temp_lo <= 32'h0000_0000;
			HI <= 32'h0000_0000;
			LO <= 32'h0000_0000;
			count <= 4'd0;
			busy <= 0;
		end 
		else if(!Req) begin
			if(count == 0) begin
				if(opHILO == `HILO_mthi) HI <= rs;
				else if(opHILO == `HILO_mtlo) LO <= rs;
				else if(opHILO == `HILO_mult) begin
					busy <= 1;
					count <= 4'd5;
					temp_hi <= Mout[63:32];
					temp_lo <= Mout[31:0];
				end
				else if(opHILO == `HILO_multu) begin
					busy <= 1;
					count <= 4'd5;
					temp_hi <= Muout[63:32];
					temp_lo <= Muout[31:0];
				end
				else if(opHILO == `HILO_div) begin
					busy <= 1;
					count <= 4'd10;
					temp_lo <= Div;
					temp_hi <= Mod;
				end
				else if(opHILO == `HILO_divu) begin
					busy <= 1;
					count <= 4'd10;
					temp_lo <= Divu;
					temp_hi <= Modu;
				end
			end
			else if(count == 1) begin
				count <= 4'd0;
				busy <= 0;
				HI <= temp_hi;
				LO <= temp_lo;
			end
			else  count <= count - 1;
		end
	 end
endmodule
