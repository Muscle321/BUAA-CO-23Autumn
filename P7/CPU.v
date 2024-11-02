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
module CPU(
	 input clk,
    input reset,
    input [31:0] i_inst_rdata,
    input [31:0] m_data_rdata,
	 input [5:0] HWInt,
    output [31:0] i_inst_addr,
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3 :0] m_data_byteen,
    output [31:0] m_inst_addr,
    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr,
	 output [31:0] macroscopic_pc,
	 output Req
    );
	 
//---------------------------wire_Define---------------------------//
//-----------SU-----------// 	
	 wire stall;

//-----------F-----------//
	 wire [31:0] F_NPC, F_PC, F_Instr, F_pre_PC;
	 wire [4:0] F_ExcCode;
	 wire F_WE, F_BD;

//-----------D-----------//
	 wire [31:0] D_Instr, D_PC, D_rs, D_rt, D_pre_rs, D_pre_rt, D_Extout;
	 wire D_WE,D_Bflag, D_BD, D_eret, D_RI, D_SYSCALL;
	 wire [4:0] D_rs_addr, D_rt_addr, D_ExcCode, D_pre_ExcCode;
	 wire [2:0] D_opNPC,D_opBranch;
	 wire [1:0] D_opExt;
	 wire [15:0] D_imm;
	 wire [25:0] D_index;

//-----------E-----------//
	 wire E_clr, E_HILObusy, E_BD, E_overflow;
	 wire [31:0] E_Instr, E_PC, E_rs, E_rt, E_Extout, E_SrcA, E_SrcB, E_pre_rs, E_pre_rt, E_RegData, E_ALUresult, E_HILOout;
	 wire [4:0] E_RegAddr, E_rs_addr, E_rt_addr, E_ExcCode;
	 wire [3:0] E_opALU, E_opHILO;
	 wire [2:0] E_RegDataSel;
	 wire [1:0] E_ALUsrcA, E_ALUsrcB;

//-----------M-----------//
	 wire [31:0] M_Instr, M_PC, M_pre_rt, M_rt, M_RegData, M_ALUresult, M_DMout, M_HILOout, M_CP0Out, M_CP0In, M_EPCOut;
	 wire [4:0] M_rt_addr, M_RegAddr, M_CP0Add, M_ExcCode, M_pre_ExcCode, M_new_ExcCode;
	 wire [2:0] M_loadType, M_RegDataSel;
	 wire [1:0] M_storeType;
	 wire M_CP0_WE, M_BDIn, M_BD, M_ERET, M_overflow;

//-----------W-----------//
	 wire [31:0] W_Instr, W_PC, W_RegData, W_ALUresult, W_DMout, W_HILOout, W_CP0Out;
	 wire [4:0] W_RegAddr; 
	 wire [2:0] W_RegDataSel;
	 wire W_WE;

//-------------------------------SU-------------------------------//
	 SU su(
		.D_Instr(D_Instr),
		.E_Instr(E_Instr),
		.M_Instr(M_Instr),
		.E_HILObusy(E_HILObusy),
		.stall(stall)
	 );
	 

	 
//-------------------------------stateF-------------------------------//
	 assign F_WE = !stall;
	 assign F_Instr = (F_ExcCode == 5'd4) ? 32'h0000_0000 : i_inst_rdata;
	 assign F_PC = (D_eret) ? M_EPCOut : F_pre_PC;
	 assign i_inst_addr = F_PC;
	 assign F_ExcCode = ((F_PC[1:0] != 2'b00 || !(F_PC >= 32'h0000_3000 && F_PC <= 32'h0000_6fff)) && !D_eret) ? 5'd4 : 5'd0;
	 
	 F_PC F_pc(
		.clk(clk),
		.reset(reset),
		.WE(F_WE),
		.Req(Req),
		.NPC(F_NPC),
		.PC(F_pre_PC)
	 );
	 
	 
//-------------------------------stateD-------------------------------//	 
	 assign D_WE = !stall;
//-----------stateD_FU-----------// 
	 assign D_rs = (D_rs_addr != 5'b00000 && D_rs_addr == E_RegAddr) ? E_RegData :
						(D_rs_addr != 5'b00000 && D_rs_addr == M_RegAddr) ? M_RegData : D_pre_rs;
	 assign D_rt = (D_rt_addr != 5'b00000 && D_rt_addr == E_RegAddr) ? E_RegData :
						(D_rt_addr != 5'b00000 && D_rt_addr == M_RegAddr) ? M_RegData : D_pre_rt;
	 assign D_ExcCode = (D_pre_ExcCode != 5'd0) ? D_pre_ExcCode : 
							  (D_RI) ? 5'd10 :
							  (D_SYSCALL) ? 5'd8 : 5'd0;
	 
	 D_REG D_reg(
		.clk(clk),
		.reset(reset),
		.WE(D_WE),
		.Req(Req),
		.F_PC(F_PC),
		.F_Instr(F_Instr),
		.F_BD(F_BD),
		.F_ExcCode(F_ExcCode),
		.D_ExcCode(D_pre_ExcCode),
		.D_BD(D_BD),
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
		.D_opExt(D_opExt),
		.ERET(D_eret),
		.F_BD(F_BD),
		.RI(D_RI),
		.SYSCALL(D_SYSCALL)
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
	   .eret(D_eret),
		.Req(Req),
		.F_PC(F_PC),
		.D_PC(D_PC),
		.Branch(D_Extout),
		.Index(D_index),
		.rs(D_rs),
		.EPC(M_EPCOut),
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
		.Req(Req),
		.clr(E_clr),
		.D_PC(D_PC),
		.D_Instr(D_Instr),
		.D_rs(D_rs),
		.D_rt(D_rt),
		.D_Extout(D_Extout),
		.D_BD(D_BD),
		.D_ExcCode(D_ExcCode),
		.E_ExcCode(E_ExcCode),
		.E_BD(E_BD),
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
		.E_opHILO(E_opHILO),
		.RegDataSel(E_RegDataSel),
		.RegAddr(E_RegAddr)
	 );
	 
	 E_ALU E_alu(
		.SrcA(E_SrcA),
		.SrcB(E_SrcB),
		.opALU(E_opALU),
		.ALUresult(E_ALUresult),
		.Overflow(E_overflow)
	 );
	 
	 E_HILO E_hilo(
		.clk(clk),
		.reset(reset),
		.Req(Req),
		.rs(E_rs),
		.rt(E_rt),
		.opHILO(E_opHILO),
		.HILObusy(E_HILObusy),
		.result(E_HILOout)
	 );
	 
//-------------------------------stateM-------------------------------//	 
	 assign m_data_addr = M_ALUresult;
	 assign m_data_wdata = (M_storeType == `DM_sw) ? M_rt :
								  (M_storeType == `DM_sh) ? {M_rt[15:0], M_rt[15:0]} :
								  (M_storeType == `DM_sb) ? {M_rt[7:0], M_rt[7:0], M_rt[7:0], M_rt[7:0]} : M_rt;
								  
	 assign m_inst_addr = M_PC;
	 assign macroscopic_pc = M_PC;
	 assign M_RegData = (M_RegDataSel == `Reg_PC8) ? M_PC + 8 :
							  (M_RegDataSel == `Reg_alu) ? M_ALUresult : 
							  (M_RegDataSel == `Reg_hilo) ? M_HILOout : 32'h0000_0000;
	 						  
//-----------stateM_FU-----------// 
	 assign M_rt = (M_rt_addr != 5'b00000 && M_rt_addr == W_RegAddr) ? W_RegData : M_pre_rt;	 
	 assign M_ExcCode = (M_pre_ExcCode != 5'd0) ? M_pre_ExcCode : M_new_ExcCode;
	 assign M_CP0Add = M_Instr[15:11];
	 assign M_CP0In = M_rt;
	 
	 M_REG M_reg(
		.clk(clk),
		.reset(reset),
		.Req(Req),
		.E_PC(E_PC),
		.E_Instr(E_Instr),
		.E_rt(E_rt),
		.E_ALUresult(E_ALUresult),
		.E_HILOout(E_HILOout),
		.E_BD(E_BD),
		.E_ExcCode(E_ExcCode),
		.E_overflow(E_overflow),
		.M_overflow(M_overflow),
		.M_ExcCode(M_pre_ExcCode),
		.M_BD(M_BD),
		.M_PC(M_PC),
		.M_Instr(M_Instr),
		.M_rt(M_pre_rt),
		.M_ALUresult(M_ALUresult),
		.M_HILOout(M_HILOout)
	 );
	 
	 CU M_cu(
		.Instr(M_Instr),
		.overflow(M_overflow),
		.m_data_addr(m_data_addr),
		.rt(M_rt_addr),
		.RegAddr(M_RegAddr),
		.RegDataSel(M_RegDataSel),
		.M_loadType(M_loadType),
		.M_storeType(M_storeType),
		.ERET(M_ERET),
		.ExcCode(M_new_ExcCode),
		.MTC0(M_CP0_WE)
	 );
	 
	 M_LOAD M_load(
		.addr(M_ALUresult[1:0]),
		.DM_RD(m_data_rdata),
		.LoadType(M_loadType),
		.RD(M_DMout)
	 );
	 
	 M_BE M_be(
		.addr(M_ALUresult[1:0]),
		.StoreType(M_storeType),
		.byteen(m_data_byteen)
	 );
	 
	 CP0 M_cp0(
		.clk(clk),
		.reset(reset),
		.en(M_CP0_WE),
		.CP0Add(M_CP0Add),
		.CP0In(M_CP0In),
		.VPC(M_PC),				//����VPC
		.BDIn(M_BD),						//����BD
		.ExcCodeIn(M_ExcCode),		//����ExcCode
		.HWInt(HWInt),			//����IP
		.EXLClr(M_ERET),					//EXL����ź�
		.CP0Out(M_CP0Out),
		.EPCOut(M_EPCOut),
		.Req(Req)
	 );
	 
	 
//-------------------------------stateW-------------------------------//	 	 
	 assign w_grf_we = W_WE;
	 assign w_grf_addr = W_RegAddr;
	 assign w_grf_wdata = W_RegData;
	 assign w_inst_addr = W_PC;
	 
	 assign W_RegData = (W_RegDataSel == `Reg_PC8) ? W_PC + 8 :
							  (W_RegDataSel == `Reg_alu) ? W_ALUresult :
							  (W_RegDataSel == `Reg_dm) ? W_DMout : 
							  (W_RegDataSel == `Reg_hilo) ? W_HILOout : 
							  (W_RegDataSel == `Reg_cp0) ? W_CP0Out : 32'h0000_0000;
	 
	 W_REG W_reg(
		.clk(clk),
		.reset(reset),
		.Req(Req),
		.M_PC(M_PC),
		.M_Instr(M_Instr),
		.M_ALUresult(M_ALUresult),
		.M_RD(M_DMout),
		.M_HILOout(M_HILOout),
		.M_CP0Out(M_CP0Out),
		.W_CP0Out(W_CP0Out),
		.W_PC(W_PC),
		.W_Instr(W_Instr),
		.W_ALUresult(W_ALUresult),
		.W_RD(W_DMout),
		.W_HILOout(W_HILOout)
	 );
	 
	 CU W_cu(
		.Instr(W_Instr),
		.W_regWrite(W_WE),
		.RegAddr(W_RegAddr),
		.RegDataSel(W_RegDataSel)
	 );
	 
	 
endmodule