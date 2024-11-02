`timescale 1ns / 1ps
`include "Define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:56:35 11/09/2023 
// Design Name: 
// Module Name:    CU 
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
module CU(
	input [31:0] Instr,
	input check,
//--------decode---------//	
	output [25:0] index,
	output [15:0] imm,
	output [4:0] rs,
	output [4:0] rt,
	output [4:0] rd,
	
//--------TypeInstr---------//
	output [2:0] TypeInstr,
	output TypeJl,
	output TypeJr,
	output TypeJaddr,
	
//--------Control---------//	
	output [2:0] D_opNPC,
	output [1:0] D_opExt,
	output [2:0] D_opBranch,
	output [3:0] E_opALU,
	output [1:0] E_ALUsrcA,
	output [1:0] E_ALUsrcB,
	output [2:0] M_loadType,
	output [1:0] M_storeType,
	output M_DMWE,
	output W_regWrite,
	output [4:0] RegAddr,
	output [1:0] RegDataSel
	
    );
	 wire TypeR, TypeI, TypeB, TypeJ, TypeL, TypeS;
	 assign TypeInstr = (TypeR) ? `typeR :
							  (TypeI) ? `typeI :
							  (TypeB) ? `typeB :
							  (TypeJ) ? `typeJ :
							  (TypeL) ? `typeL :
							  (TypeS) ? `typeS : 3'b000;
//--------decode---------//
	 assign index = Instr[25:0];
	 assign imm = Instr[15:0];
	 assign rs = Instr[25:21];
	 assign rt = Instr[20:16];
	 assign rd = Instr[15:11];
	 
	 wire [5:0] opcode = Instr[31:26];
	 wire [5:0] funct = Instr[5:0];
	 
//--------TypeR---------//
	 wire ADD = (opcode == 6'b00_0000 && funct == `add);
	 wire SUB = (opcode == 6'b00_0000 && funct == `sub);
	 
	 assign TypeR = ADD | SUB;
	 
//--------TypeI---------//	 
	 wire ORI = (opcode == `ori);
	 wire LUI = (opcode == `lui);
	 
	 assign TypeI = ORI | LUI;
	 
//--------TypeB---------//	 	 
	 wire BEQ = (opcode == `beq);
	 
	 
	 assign TypeB = BEQ;
//--------TypeJ---------//	 	 
	 wire JAL = (opcode == `jal);
	 wire JR = (opcode == 6'b00_0000 && funct == `jr);
	 
	 assign TypeJr = JR;
	 assign TypeJl = JAL;
	 assign TypeJ = TypeJr || TypeJl;
//--------TypeL---------//	 	 
	 wire LW = (opcode == `lw);
	 
	 assign TypeL = LW;
//--------TypeS---------//	 	 
	 wire SW = (opcode == `sw);
	 
	 assign TypeS = SW;
	 
	 
//--------Control---------//	 
	 assign D_opNPC = (TypeB) ? `NPC_b :
							(TypeJl) ? `NPC_jt :
							(TypeJr) ? `NPC_jr : `NPC_n;
							
	 assign D_opExt = (TypeB || TypeL || TypeS) ? `Ext_signed :
							(LUI) ? `Ext_sll :
							(ORI) ? `Ext_unsigned : 2'b00;
	 
 	 assign D_opBranch = (BEQ) ? `B_equal : 3'b000;
	 
	 
	 
	 assign E_opALU = (ADD || TypeL || TypeS) ? `ALU_add :
							(SUB) ? `ALU_sub :
							(ORI) ? `ALU_or : 4'b0000;
							
	 assign E_ALUsrcA = 2'b00;
	 assign E_ALUsrcB = (TypeR) ? `ALUsrcB_rt :
							  (TypeI || TypeS || TypeL) ? `ALUsrcB_imm : 2'b00;
							  
							  
	 assign M_loadType = (LW) ? `DM_lw : 3'b000;
	 assign M_storeType = (SW) ? `DM_sw : 2'b00;
	 assign M_DMWE = (TypeS) ? 1 : 0;
	 assign W_regWrite = (TypeI || TypeR || TypeL || TypeJl) ? 1 : 0;
	 assign RegAddr = (!W_regWrite) ? 5'b00000 :
							(TypeI || TypeL) ? rt :
							(TypeR) ? rd :
							(TypeJl) ? 5'd31 : 5'b00000;
	 assign RegDataSel = (TypeR || TypeI) ? `Reg_alu :
								(TypeL) ? `Reg_dm :
								(TypeJl) ? `Reg_PC8 : 2'b00;
	 
endmodule
