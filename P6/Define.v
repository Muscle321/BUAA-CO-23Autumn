//---------CU-define---------//
//---------TypeR-fucnt--------opcode == 00_0000//
`define add 6'b10_0000
`define sub 6'b10_0010
`define And 6'b10_0100
`define Or 6'b10_0101
`define slt 6'b10_1010
`define sltu 6'b10_1011

//---------TypeI-opcode-------//
`define ori 6'b00_1101
`define lui 6'b00_1111
`define addi 6'b00_1000
`define andi 6'b00_1100


//---------TypeB-opcode-------//
`define beq 6'b00_0100
`define bne 6'b00_0101

//---------TypeJ-opcode-------//
`define jal 6'b00_0011


//---------TypeJ-fucnt--------opcode == 00_0000//
`define jr 6'b00_1000


//---------TypeL-opcode-------//
`define lw 6'b10_0011
`define lb 6'b10_0000
`define lh 6'b10_0001

//---------TypeS-opcode-------//
`define sw 6'b10_1011
`define sb 6'b10_1000
`define sh 6'b10_1001

//---------TypeM-fucnt--------opcode == 00_0000//
`define mfhi 6'b01_0000
`define mflo 6'b01_0010
`define mthi 6'b01_0001
`define mtlo 6'b01_0011
`define mult 6'b01_1000
`define multu 6'b01_1001
`define div 6'b01_1010
`define divu 6'b01_1011

//---------TypeInstr-------//
`define typeR 3'b001
`define typeI 3'b010
`define typeB 3'b011
`define typeJ 3'b100
`define typeL 3'b101
`define typeS 3'b110

//---------GRF-define---------//
`define Reg_alu 3'b000
`define Reg_dm 3'b001
`define Reg_PC8 3'b010
`define Reg_hilo 3'b011

//---------FUsel-define---------//
`define selN 2'b00
`define selE 2'b01
`define selM 2'b10
`define selW 2'b11

//---------EXT-define---------//
`define Ext_signed 2'b01
`define Ext_unsigned 2'b00
`define Ext_sll 2'b10

//---------NPC-define---------//
`define NPC_n 3'b000
`define NPC_b 3'b001
`define NPC_jt 3'b010
`define NPC_jr 3'b011

//---------Branch-define---------//
`define B_beq 3'b001
`define B_bne 3'b010

//---------ALU-define---------//
`define ALU_add 4'b0000
`define ALU_sub 4'b0001
`define ALU_or 4'b0010
`define ALU_and 4'b0011
`define ALU_slt 4'b0100
`define ALU_sltu 4'b0101

`define ALUsrcB_rt 2'b00
`define ALUsrcB_imm 2'b01

//---------DM-define---------//
`define DM_lw 3'b000
`define DM_lb 3'b001
`define DM_lbu 3'b010
`define DM_lh 3'b011
`define DM_lhu 3'b100

`define DM_sw 2'b01
`define DM_sb 2'b10
`define DM_sh 2'b11

//---------HILO-define---------//
`define HILO_mult 4'b0001
`define HILO_multu 4'b0010
`define HILO_div 4'b0011
`define HILO_divu 4'b0100
`define HILO_mfhi 4'b0101
`define HILO_mflo 4'b0110
`define HILO_mthi 4'b0111
`define HILO_mtlo 4'b1000


