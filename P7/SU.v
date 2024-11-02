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
	input E_HILObusy,
	output stall
    );
	 wire [1:0] T_use_rs, T_use_rt, T_new_E, T_new_M;
	 wire [4:0] D_addr_rs, D_addr_rt;
	 wire [4:0] E_addr, M_addr;
	 wire [2:0] D_typeInstr, E_typeInstr, M_typeInstr;
	 wire D_jr, E_mf, D_md, D_mf, D_mt;
	 wire D_typeM, E_mfc0, M_mfc0, D_eret, E_mtc0, M_mtc0, D_MTC0;
	 
	 CU SU_D_CU(
		.Instr(D_Instr),
		.rs(D_addr_rs),
		.rt(D_addr_rt),
		.TypeInstr(D_typeInstr),
		.TypeJr(D_jr),
		.TypeMd(D_md),
		.TypeMf(D_mf),
		.TypeMt(D_mt),
		.ERET(D_eret),
		.MTC0(D_MTC0)
	 );
	 
	 CU SU_E_CU(
		.Instr(E_Instr),
		.RegAddr(E_addr),
		.TypeMf(E_mf),
		.TypeInstr(E_typeInstr),
		.MFC0(E_mfc0),
		.MTC0(E_mtc0)
	 );
	 
	 CU SU_M_CU(
		.Instr(M_Instr),
		.RegAddr(M_addr),
		.TypeInstr(M_typeInstr),
		.MFC0(M_mfc0),
		.MTC0(M_mtc0)
	 );
	 
	 assign D_typeM = D_md | D_mf | D_mt;
	 
	 assign T_use_rs = (D_typeInstr == `typeR) ? 2'b01 :
							 (D_typeInstr == `typeI) ? 2'b01 :
							 (D_typeInstr == `typeL) ? 2'b01 :
							 (D_typeInstr == `typeS || D_md || D_mt) ? 2'b01 : 
							 (D_typeInstr == `typeB) ? 2'b00 :
							 (D_typeInstr == `typeJ && D_jr) ? 2'b00 : 2'b11;
	 
	 assign T_use_rt = (D_typeInstr == `typeR || D_md) ? 2'b01 :
							 (D_typeInstr == `typeS || D_MTC0) ? 2'b10 : 
							 (D_typeInstr == `typeB) ? 2'b00 : 2'b11;
	 
	 assign T_new_E = (E_typeInstr == `typeR) ? 2'b01 :
							(E_typeInstr == `typeI || E_mf) ? 2'b01 :
							(E_typeInstr == `typeL || E_mfc0) ? 2'b10 : 2'b00;
	 
	 assign T_new_M = (M_typeInstr == `typeL || M_mfc0) ? 2'b01 : 2'b00;
	 
	 wire stall_rs, stall_rt, stall_hilo, stall_cp0;
	 assign stall_rs = (D_addr_rs && D_addr_rs == E_addr && T_new_E > T_use_rs) | (D_addr_rs && D_addr_rs == M_addr && T_new_M > T_use_rs); 
	 assign stall_rt = (D_addr_rt && D_addr_rt == E_addr && T_new_E > T_use_rt) | (D_addr_rt && D_addr_rt == M_addr && T_new_M > T_use_rt);
	 assign stall_hilo = (D_md | D_mf | D_mt) && E_HILObusy;
	 assign stall_cp0 = (M_mtc0 && M_Instr[15:11] == 5'd14 && D_eret) | (E_mtc0 && E_Instr[15:11] == 5'd14 && D_eret);
	 assign stall = stall_rs | stall_rt | stall_hilo | stall_cp0;
	 
endmodule
