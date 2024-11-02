`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:41:20 10/10/2023 
// Design Name: 
// Module Name:    P1_L1_BlockChecker 
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
`define charb 8'd98
`define charB 8'd66
`define chard 8'd100
`define charD 8'd68
`define chare 8'd101
`define charE 8'd69
`define charg 8'd103
`define charG 8'd71
`define chari 8'd105
`define charI 8'd73
`define charn 8'd110
`define charN 8'd78



module BlockChecker(
	input clk,
	input reset,
	input [7:0] in,
	output result
    );
	 reg [31:0] stack;
	 wire [2:0] char_type;
	 reg flag;
	 reg [4:0] state;			//00000,一共五位，第五位表示是否多出单词，第四位表示begin或end，前三位为state
	 reg Flag;
	 
	 assign char_type = (in == `charb || in == `charB) ? 3'b001 :
							  (in == `chard || in == `charD) ? 3'b010 :
							  (in == `chare || in == `charE) ? 3'b011 :
							  (in == `charg || in == `charG) ? 3'b100 :
							  (in == `chari || in == `charI) ? 3'b101 :
							  (in == `charn || in == `charN) ? 3'b110 : 
							  (in == 8'd32) ? 3'b111 : 3'b000;
	 assign  result = (stack == 32'b0 && flag == 0) ? 1 : 0;
	 
	 always@(posedge clk or posedge reset) begin
		if(reset) begin
			state <= 0;
			stack <= 0;
			flag <= 0;
			Flag <= 0;
		end
		else if(!Flag || !flag) begin
			Flag <= flag;
			case(state) 
				5'b00000: state<= (char_type == 3'b001) ? 5'b00001 :		//检测b
										(char_type == 3'b011) ? 5'b01001 : 			//检测e
										(char_type == 3'b111) ? 5'b00000 : 5'b01111;	//检测空格
				5'b00001: state<= (char_type == 3'b011) ? 5'b00010 : 				//检测e
										(char_type == 3'b111) ? 5'b00000 : 5'b01111;		//检测空格
				5'b00010: state<= (char_type == 3'b100) ? 5'b00011 : 						//检测g
										(char_type == 3'b111) ? 5'b00000 : 5'b01111;		//检测空格	
				5'b00011: state<= (char_type == 3'b101) ? 5'b00100 : 
										(char_type == 3'b111) ? 5'b00000 : 5'b01111;		//检测i
				5'b00100: begin
								state <= (char_type == 3'b110) ? 5'b00111 : 
											(char_type == 3'b111) ? 5'b00000 : 5'b01111;		//检测n,如果有进入5’b00111检测单词合法性	
								stack <= (char_type == 3'b110) ? stack + 1 : stack;		//检测n,如果有stack+1
							 end
				5'b00111: begin
								if(char_type == 3'b111) state <= 5'b00000;
								else begin
									stack <= stack -1;
									state <= 5'b01111;
								end
							 end
				5'b01001: state <= (char_type == 3'b110) ? 5'b01010 : 
										 (char_type == 3'b111) ? 5'b00000 : 5'b01111;	//检测n		
				5'b01010: begin
								state <= (char_type == 3'b010) ? 5'b01011 : 
											(char_type == 3'b111) ? 5'b00000 : 5'b01111;		//检测d,如果有进入5'b01011检测单词合法性	
								stack <= (char_type == 3'b010) ? stack - 1 : stack;
								if(char_type == 3'b010 && stack == 32'b0) flag <= 1;
							 end
				5'b01011: begin
								if(char_type == 3'b111) state <= 5'b00000;
								else begin
									state <= 5'b01111;
									stack <= stack + 1;
									if(stack == 32'hffffffff) flag <= 0;
								end
							 end
				5'b01111: state <= (char_type == 3'b111) ? 5'b00000 : 5'b01111;
			endcase
		end
	 end
	 
endmodule



/*case(state_begin)
								3'b000: state_begin <= (char_type == 3'b001) ? 3'b001 : 3'b100;
								3'b001: state_begin <= (char_type == 3'b011) ? 3'b010 : 3'b100;
								3'b010: state_begin <= (char_type == 3'b100) ? 3'b011 : 3'b100;
								3'b011: begin
												state_begin <= 3'b100;
												if(char_type == 3'b101) stack <= stack + 1;
												else stack <= stack;
										  end
								3'b100: begin
											  if(char_type == 3'b111) begin
													flag_minus[1] <= 0;
													state_begin <= 3'b000;
												end
											  else if(char_type != 3'b111 && flag_minus[1] == 0) begin
													flag_minus[1] <= 1;
													state_begin <= 3'b100;
													stack <= stack - 1;
											  end
											  else state_begin <= 3'b100;
											end
							endcase
							case(state_end)
								2'b00: state_end <= (char_type == 3'b011) ? 2'b01 : 2'b11;
								2'b01: state_end <= (char_type == 3'b110) ? 2'b10 : 2'b11;
								2'b10: begin
												state_end <= 2'b11;
												if(char_type == 3'b010 && stack >= 32'b1) stack <= stack - 1;
												else if(char_type == 3'b010 && stack == 32'b0) flag <= 1;
												else stack <= stack;
										  end
								2'b11: begin
												if(char_type == 3'b111) begin
													flag_minus[0] <= 0;
													state_end <= 2'b00;
												end
											  else if(char_type != 3'b111 && flag_minus[0] == 0) begin
													flag_minus[0] <= 1;
													state_end <= 2'b11;
													if(stack == 0) flag <= 0;
													stack <= stack + 1;
											  end
											  else state_end <= 2'b11;
										 end
							endcase
							*/
