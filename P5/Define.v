//---------CU-define---------//
//---------TypeR-fucnt--------opcode == 00_0000//
`define add 6'b10_0000
`define sub 6'b10_0010

//---------TypeI-opcode-------//
`define ori 6'b00_1101
`define lui 6'b00_1111

//---------TypeB-opcode-------//
`define beq 6'b00_0100

//---------TypeJ-opcode-------//
`define jal 6'b00_0011


//---------TypeJ-fucnt--------opcode == 00_0000//
`define jr 6'b00_1000



//---------TypeL-opcode-------//
`define lw 6'b10_0011


//---------TypeS-opcode-------//
`define sw 6'b10_1011


//---------TypeInstr-------//
`define typeR 3'b001
`define typeI 3'b010
`define typeB 3'b011
`define typeJ 3'b100
`define typeL 3'b101
`define typeS 3'b110

//---------GRF-define---------//
`define Reg_alu 2'b00
`define Reg_dm 2'b01
`define Reg_PC8 2'b10

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
`define B_equal 3'b001



//---------ALU-define---------//
`define ALU_add 4'b0000
`define ALU_sub 4'b0001
`define ALU_or 4'b0010


`define ALUsrcB_rt 2'b00
`define ALUsrcB_imm 2'b01

//---------DM-define---------//
`define DM_lw 3'b000
`define DM_lb 3'b001
`define DM_lbu 3'b010
`define DM_lh 3'b011
`define DM_lhu 3'b100

`define DM_sw 2'b00
`define DM_sb 2'b01
`define DM_sh 2'b10



