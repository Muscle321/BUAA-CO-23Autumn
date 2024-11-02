`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:04:42 10/10/2023 
// Design Name: 
// Module Name:    P1_L0_expr 
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
module expr(
   input clk,
	input clr,
	input [7:0] in,
	output out
    );		
	 wire [1:0] char_type;
	 reg [1:0] state = 2'b00;
	 assign out = (state == 2'b10) ? 1 : 0;
	 assign char_type = (in >= 8'd48 && in <= 8'd57) ? 2'b01 : 
							  (in == 8'd42 || in == 8'd43) ? 2'b10 : 2'b00;
	 
	 always@(posedge clk or posedge clr) begin
		if(clr == 1) begin
			state <= 2'b00;
		end
		else begin
			case(state)
				2'b00: begin
							state <= (char_type == 2'b01) ? 2'b10 : 2'b11;
						end
				2'b10: begin
							state <= (char_type == 2'b10) ? 2'b01 : 2'b11;
						end
				2'b01: begin
							state <= (char_type == 2'b01) ? 2'b10 : 2'b11;
						end
				2'b11: begin
							state <= 2'b11;
						end
			endcase
		end
	 end
endmodule
