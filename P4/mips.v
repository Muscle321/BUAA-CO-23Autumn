`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:10:16 10/31/2023 
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
	input reset,
	output [31:0] PC
    );
	 //NPC and IFU: opNPC == opNPC
	wire [31:0] NPC,Instr,Branch;
	
	//Instr
	wire [5:0] opcode,funct;
	wire [4:0] rs, rt, rd;
	wire [15:0] Imm;
	wire [25:0] target;
	
	//Controller
	wire NumRead,NumWrite,ALUsrc,opEXT,RegSel,RegWrite,isJAL;
	wire [2:0] opNPC,opALU,BranchSel;
	
	
	//GRF:	WE == RegWrite
	wire [4:0] A1,A2,A3;
	wire [31:0] GRF_WD,GRF_RD1,GRF_RD2;
	
	//ALU:	opALU == opALU
	wire [31:0] SrcA, SrcB, ALUresult;
	wire zero;
	
	//EXT:	op == op; imm == imm;
	wire [31:0] ExtImm;
	
	//DM£º		WE == NumWrite
	wire [31:0] addr,DM_WD,DM_RD;
	
	//link
	assign opcode = Instr[31:26];
	assign funct = Instr[5:0];
	assign rs = Instr[25:21];
	assign rt = Instr[20:16];
	assign rd = Instr[15:11];
	assign Imm = Instr[15:0];
	assign target = Instr[25:0];
	
	assign A1 = rs;
	assign A2 = rt;
	assign A3 = (isJAL == 1) ? 5'd31 :
					(RegSel == 1) ? rd : rt;
					
	assign SrcA = GRF_RD1;
	assign SrcB = (ALUsrc == 1) ? ExtImm : GRF_RD2;
	assign addr = ALUresult;
	
	assign GRF_WD = (isJAL == 1) ? PC + 4 :
						 (NumRead == 1) ? DM_RD : ALUresult;
	assign DM_WD = GRF_RD2;
	
	assign Branch = (BranchSel == 3'b001) ? ExtImm :
						 (BranchSel == 3'b010) ? target :
						 (BranchSel == 3'b011) ? GRF_RD1 : 32'h0000_0000;
	
	
	//instantiation
	NPC sys_NPC(
		.PC(PC),
		.Branch(Branch),
		.opNPC(opNPC),
		.zero(zero),
		.NPC(NPC)
	);
	
	IFU IFU(
		.clk(clk),
		.reset(reset),
		.NPC(NPC),
		.Instr(Instr),
		.PC(PC)
	);

	GRF GRF(
		.clk(clk),
		.reset(reset),
		.WE(RegWrite),
		.A1(A1),
		.A2(A2),
		.A3(A3),
		.WD(GRF_WD),
		.PC(PC),
		.RD1(GRF_RD1),
		.RD2(GRF_RD2)
	);
	
	EXT sys_EXT(
		.imm(Imm),
		.opEXT(opEXT),
		.EXT(ExtImm)
	);
	
	DM DM(
		.clk(clk),
		.reset(reset),
		.WE(NumWrite),
		.WD(DM_WD),
		.addr(addr),
		.PC(PC),
		.ReadType(2'b00),
		.WriteType(2'b00),
		.RD(DM_RD)
	);
	
	ALU ALU(
		.SrcA(SrcA),
		.SrcB(SrcB),
		.opALU(opALU),
		.ALUresult(ALUresult),
		.Zero(zero)
	);
	
	Controller CU(
			.Instr(Instr),
			.NumRead(NumRead),
			.NumWrite(NumWrite),
			.opNPC(opNPC),
			.opALU(opALU),
			.ALUsrc(ALUsrc),
			.opEXT(opEXT),
			.RegWrite(RegWrite),
			.RegSel(RegSel),
			.isJAL(isJAL),
			.BranchSel(BranchSel)
	);
	
endmodule
