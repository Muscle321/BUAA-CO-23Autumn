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
	input clk,
	input reset
    );
	 
//---------------------------wire_Define---------------------------//
//-----------SU-----------// 	
	 wire stall;

//-----------F-----------//
	 wire [31:0] F_NPC, F_PC, F_Instr;
	 wire F_WE;

//-----------D-----------//
	 wire [31:0] D_Instr, D_PC, D_rs, D_rt, D_pre_rs, D_pre_rt, D_Extout;
	 wire D_WE,D_Bflag;
	 wire [4:0] D_rs_addr, D_rt_addr;
	 wire [2:0] D_opNPC,D_opBranch;
	 wire [1:0] D_opExt;
	 wire [15:0] D_imm;
	 wire [25:0] D_index;

//-----------E-----------//
	 wire E_clr;
	 wire [31:0] E_Instr, E_PC, E_rs, E_rt, E_Extout, E_SrcA, E_SrcB, E_pre_rs, E_pre_rt, E_RegData, E_ALUresult;
	 wire [4:0] E_RegAddr, E_rs_addr, E_rt_addr;
	 wire [3:0] E_opALU;
	 wire [1:0] E_ALUsrcA, E_ALUsrcB, E_RegDataSel;

//-----------M-----------//
	 wire [31:0] M_Instr, M_PC, M_pre_rt, M_rt, M_RegData, M_ALUresult, M_DMout;
	 wire [4:0] M_rt_addr, M_RegAddr;
	 wire [2:0] M_loadType;
	 wire [1:0] M_storeType, M_RegDataSel;
	 wire M_DMWE;

//-----------W-----------//
	 wire [31:0] W_Instr, W_PC, W_RegData, W_ALUresult, W_DMout; 
	 wire [4:0] W_RegAddr; 
	 wire [1:0] W_RegDataSel;
	 wire W_WE;

//-------------------------------SU-------------------------------//
	 SU su(
		.D_Instr(D_Instr),
		.E_Instr(E_Instr),
		.M_Instr(M_Instr),
		.stall(stall)
	 );
	 

	 
//-------------------------------stateF-------------------------------//
	 assign F_WE = !stall;
	 
	 
	 F_IFU F_ifu(
		.clk(clk),
		.reset(reset),
		.WE(F_WE),
		.NPC(F_NPC),
		.PC(F_PC),
		.Instr(F_Instr)
	 );
	 
//-------------------------------stateD-------------------------------//	 
	 assign D_WE = !stall;
//-----------stateD_FU-----------// 
	 assign D_rs = (D_rs_addr != 5'b00000 && D_rs_addr == E_RegAddr) ? E_RegData :
						(D_rs_addr != 5'b00000 && D_rs_addr == M_RegAddr) ? M_RegData : D_pre_rs;
	 assign D_rt = (D_rt_addr != 5'b00000 && D_rt_addr == E_RegAddr) ? E_RegData :
						(D_rt_addr != 5'b00000 && D_rt_addr == M_RegAddr) ? M_RegData : D_pre_rt;
	 
	 
	 D_REG D_reg(
		.clk(clk),
		.reset(reset),
		.WE(D_WE),
		.F_PC(F_PC),
		.F_Instr(F_Instr),
		.D_PC(D_PC),
		.D_Instr(D_Instr)
	 );
	 
	 CU D_cu(
		.Instr(D_Instr),
		.rs(D_rs_addr),
		.rt(D_rt_addr),
		.imm(D_imm),
		.index(D_index),
		.D_opNPC(D_opNPC),
		.D_opBranch(D_opBranch),
		.D_opExt(D_opExt)
	 );
	 
	 D_GRF D_grf(
		.clk(clk),
		.reset(reset),
		.WE(W_WE),
		.A1(D_rs_addr),
		.A2(D_rt_addr),
		.A3(W_RegAddr),
		.WD(W_RegData),
		.PC(W_PC),
		.RD1(D_pre_rs),
		.RD2(D_pre_rt)
	 );
	 
	 D_EXT D_ext(
		.imm(D_imm),
		.opEXT(D_opExt),
		.Extout(D_Extout)
	 );
	 
	 D_NPC D_npc(
		.F_PC(F_PC),
		.D_PC(D_PC),
		.Branch(D_Extout),
		.Index(D_index),
		.rs(D_rs),
		.opNPC(D_opNPC),
		.Bflag(D_Bflag),
		.stall(stall),
		.NPC(F_NPC)
	 );
	 
	 D_CMP D_cmp(
		.rs(D_rs),
		.rt(D_rt),
		.opBranch(D_opBranch),
		.Bflag(D_Bflag)
	 );
	 
//-------------------------------stateE-------------------------------//	 
	 assign E_clr = stall;
	 assign E_RegData = (E_RegDataSel == `Reg_PC8) ? E_PC + 8 : 32'h0000_0000;
	 assign E_SrcA = (E_ALUsrcA == 2'b00) ? E_rs : E_rs;
	 assign E_SrcB = (E_ALUsrcB == `ALUsrcB_rt) ? E_rt :
	 					  (E_ALUsrcB == `ALUsrcB_imm) ? E_Extout : E_rt;
	 
//-----------stateE_FU-----------// 
	 assign E_rs = (E_rs_addr != 5'b00000 && E_rs_addr == M_RegAddr) ? M_RegData :
						(E_rs_addr != 5'b00000 && E_rs_addr == W_RegAddr) ? W_RegData : E_pre_rs;
	 assign E_rt = (E_rt_addr != 5'b00000 && E_rt_addr == M_RegAddr) ? M_RegData :
						(E_rt_addr != 5'b00000 && E_rt_addr == W_RegAddr) ? W_RegData : E_pre_rt;

	 
	 E_REG E_reg(
		.clk(clk),
		.reset(reset),
		.clr(E_clr),
		.D_PC(D_PC),
		.D_Instr(D_Instr),
		.D_rs(D_rs),
		.D_rt(D_rt),
		.D_Extout(D_Extout),
		.E_PC(E_PC),
		.E_Instr(E_Instr),
		.E_rs(E_pre_rs),
		.E_rt(E_pre_rt),
		.E_Extout(E_Extout)
	 );
	 
	 
	 CU E_cu(
		.Instr(E_Instr),
		.rs(E_rs_addr),
		.rt(E_rt_addr),
		.E_opALU(E_opALU),
		.E_ALUsrcA(E_ALUsrcA),
		.E_ALUsrcB(E_ALUsrcB),
		.RegDataSel(E_RegDataSel),
		.RegAddr(E_RegAddr)
	 );
	 
	 E_ALU E_alu(
		.SrcA(E_SrcA),
		.SrcB(E_SrcB),
		.opALU(E_opALU),
		.ALUresult(E_ALUresult)
	 );

	 
//-------------------------------stateM-------------------------------//	 
	 assign M_RegData = (M_RegDataSel == `Reg_PC8) ? M_PC + 8 :
							  (M_RegDataSel == `Reg_alu) ? M_ALUresult : 32'h0000_0000;
							  
//-----------stateM_FU-----------// 
	 assign M_rt = (M_rt_addr != 5'b00000 && M_rt_addr == W_RegAddr) ? W_RegData : M_pre_rt;	 
	 
	 
	 M_REG M_reg(
		.clk(clk),
		.reset(reset),
		.E_PC(E_PC),
		.E_Instr(E_Instr),
		.E_rt(E_rt),
		.E_ALUresult(E_ALUresult),
		.M_PC(M_PC),
		.M_Instr(M_Instr),
		.M_rt(M_pre_rt),
		.M_ALUresult(M_ALUresult)
	 );
	 
	 CU M_cu(
		.Instr(M_Instr),
		.rt(M_rt_addr),
		.RegAddr(M_RegAddr),
		.RegDataSel(M_RegDataSel),
		.M_loadType(M_loadType),
		.M_storeType(M_storeType),
		.M_DMWE(M_DMWE)
	 );
	 
	 M_DM M_dm(
		.clk(clk),
		.reset(reset),
		.WE(M_DMWE),
		.WD(M_rt),
		.addr(M_ALUresult),
		.PC(M_PC),
		.LoadType(M_loadType),
		.StoreType(M_storeType),
		.RD(M_DMout)
	 );
	 
//-------------------------------stateW-------------------------------//	 	 
	 assign W_RegData = (W_RegDataSel == `Reg_PC8) ? W_PC + 8 :
							  (W_RegDataSel == `Reg_alu) ? W_ALUresult :
							  (W_RegDataSel == `Reg_dm) ? W_DMout : 32'h0000_0000;
	 
	 W_REG W_reg(
		.clk(clk),
		.reset(reset),
		.M_PC(M_PC),
		.M_Instr(M_Instr),
		.M_ALUresult(M_ALUresult),
		.M_RD(M_DMout),
		.W_PC(W_PC),
		.W_Instr(W_Instr),
		.W_ALUresult(W_ALUresult),
		.W_RD(W_DMout)
	 );
	 
	 CU W_cu(
		.Instr(W_Instr),
		.W_regWrite(W_WE),
		.RegAddr(W_RegAddr),
		.RegDataSel(W_RegDataSel)
	 );
	 
	 
endmodule
`default_nettype none