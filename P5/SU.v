`timescale 1ns / 1ps
`include "Define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:50:18 11/09/2023 
// Design Name: 
// Module Name:    SU 
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
module SU(
	input [31:0] D_Instr,
	input [31:0] E_Instr,
	input [31:0] M_Instr,
	output stall
    );
	 wire [1:0] T_use_rs, T_use_rt, T_new_E, T_new_M;
	 wire [4:0] D_addr_rs, D_addr_rt;
	 wire [4:0] E_addr, M_addr;
	 wire [2:0] D_typeInstr, E_typeInstr, M_typeInstr;
	 wire D_jr;
	 
	 CU SU_D_CU(
		.Instr(D_Instr),
		.rs(D_addr_rs),
		.rt(D_addr_rt),
		.TypeInstr(D_typeInstr),
		.TypeJr(D_jr)
	 );
	 
	 CU SU_E_CU(
		.Instr(E_Instr),
		.RegAddr(E_addr),
		.TypeInstr(E_typeInstr)
	 );
	 
	 CU SU_M_CU(
		.Instr(M_Instr),
		.RegAddr(M_addr),
		.TypeInstr(M_typeInstr)
	 );
	 assign T_use_rs = (D_typeInstr == `typeR) ? 2'b01 :
							 (D_typeInstr == `typeI) ? 2'b01 :
							 (D_typeInstr == `typeL) ? 2'b01 :
							 (D_typeInstr == `typeS) ? 2'b01 : 
							 (D_typeInstr == `typeB) ? 2'b00 :
							 (D_typeInstr == `typeJ && D_jr) ? 2'b00 : 2'b11;
	 
	 assign T_use_rt = (D_typeInstr == `typeR) ? 2'b01 :
							 (D_typeInstr == `typeS) ? 2'b10 : 
							 (D_typeInstr == `typeB) ? 2'b00 : 2'b11;
	 
	 assign T_new_E = (E_typeInstr == `typeR) ? 2'b01 :
							(E_typeInstr == `typeI) ? 2'b01 :
							(E_typeInstr == `typeL) ? 2'b10 : 2'b00;
	 
	 assign T_new_M = (M_typeInstr == `typeL) ? 2'b01 : 2'b00;
	 
	 wire stall_rs,stall_rt;
	 assign stall_rs = (D_addr_rs && D_addr_rs == E_addr && T_new_E > T_use_rs) | (D_addr_rs && D_addr_rs == M_addr && T_new_M > T_use_rs); 
	 assign stall_rt = (D_addr_rt && D_addr_rt == E_addr && T_new_E > T_use_rt) | (D_addr_rt && D_addr_rt == M_addr && T_new_M > T_use_rt);
	 assign stall = stall_rs | stall_rt;
	 
endmodule
