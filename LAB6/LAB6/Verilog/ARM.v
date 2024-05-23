// ============================================================================
// Copyright (c) 2012 by Terasic Technologies Inc.
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//  Terasic Technologies Inc
//  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
//
//
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// ============================================================================
//
// Major Functions:	DE2 TOP LEVEL
//
// ============================================================================
//
// Revision History :
// ============================================================================
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| Johnny Chen       :| 05/08/19  :|      Initial Revision
//   V1.1 :| Johnny Chen       :| 05/11/16  :|      Added FLASH Address FL_ADDR[21:20]
//   V1.2 :| Johnny Chen       :| 05/11/16  :|		Fixed ISP1362 INT/DREQ Pin Direction.   
//   V1.3 :| Johnny Chen       :| 06/11/16  :|		Added the Dedicated TV Decoder Line-Locked-Clock Input
//													            for DE2 v2.X PCB.
//   V1.5 :| Eko    Yan        :| 12/01/30  :|      Update to version 11.1 sp1.
// ============================================================================

module ARM
	(
		////////////////////	Clock Input	 	////////////////////	 
		CLOCK_27,						//	27 MHz
		CLOCK_50,						//	50 MHz
		EXT_CLOCK,						//	External Clock
		////////////////////	Push Button		////////////////////
		KEY,							//	Pushbutton[3:0]
		////////////////////	DPDT Switch		////////////////////
		SW,								//	Toggle Switch[17:0]
		////////////////////	7-SEG Dispaly	////////////////////
		HEX0,							//	Seven Segment Digit 0
		HEX1,							//	Seven Segment Digit 1
		HEX2,							//	Seven Segment Digit 2
		HEX3,							//	Seven Segment Digit 3
		HEX4,							//	Seven Segment Digit 4
		HEX5,							//	Seven Segment Digit 5
		HEX6,							//	Seven Segment Digit 6
		HEX7,							//	Seven Segment Digit 7
		////////////////////////	LED		////////////////////////
		LEDG,							//	LED Green[8:0]
		LEDR,							//	LED Red[17:0]
		////////////////////////	UART	////////////////////////
		//UART_TXD,						//	UART Transmitter
		//UART_RXD,						//	UART Receiver
		////////////////////////	IRDA	////////////////////////
		//IRDA_TXD,						//	IRDA Transmitter
		//IRDA_RXD,						//	IRDA Receiver
		/////////////////////	SDRAM Interface		////////////////
		DRAM_DQ,						//	SDRAM Data bus 16 Bits
		DRAM_ADDR,						//	SDRAM Address bus 12 Bits
		DRAM_LDQM,						//	SDRAM Low-byte Data Mask 
		DRAM_UDQM,						//	SDRAM High-byte Data Mask
		DRAM_WE_N,						//	SDRAM Write Enable
		DRAM_CAS_N,						//	SDRAM Column Address Strobe
		DRAM_RAS_N,						//	SDRAM Row Address Strobe
		DRAM_CS_N,						//	SDRAM Chip Select
		DRAM_BA_0,						//	SDRAM Bank Address 0
		DRAM_BA_1,						//	SDRAM Bank Address 0
		DRAM_CLK,						//	SDRAM Clock
		DRAM_CKE,						//	SDRAM Clock Enable
		////////////////////	Flash Interface		////////////////
		FL_DQ,							//	FLASH Data bus 8 Bits
		FL_ADDR,						//	FLASH Address bus 22 Bits
		FL_WE_N,						//	FLASH Write Enable
		FL_RST_N,						//	FLASH Reset
		FL_OE_N,						//	FLASH Output Enable
		FL_CE_N,						//	FLASH Chip Enable
		////////////////////	SRAM Interface		////////////////
		SRAM_DQ,						//	SRAM Data bus 16 Bits
		SRAM_ADDR,						//	SRAM Address bus 18 Bits
		SRAM_UB_N,						//	SRAM High-byte Data Mask 
		SRAM_LB_N,						//	SRAM Low-byte Data Mask 
		SRAM_WE_N,						//	SRAM Write Enable
		SRAM_CE_N,						//	SRAM Chip Enable
		SRAM_OE_N,						//	SRAM Output Enable
		////////////////////	ISP1362 Interface	////////////////
		OTG_DATA,						//	ISP1362 Data bus 16 Bits
		OTG_ADDR,						//	ISP1362 Address 2 Bits
		OTG_CS_N,						//	ISP1362 Chip Select
		OTG_RD_N,						//	ISP1362 Write
		OTG_WR_N,						//	ISP1362 Read
		OTG_RST_N,						//	ISP1362 Reset
		OTG_FSPEED,						//	USB Full Speed,	0 = Enable, Z = Disable
		OTG_LSPEED,						//	USB Low Speed, 	0 = Enable, Z = Disable
		OTG_INT0,						//	ISP1362 Interrupt 0
		OTG_INT1,						//	ISP1362 Interrupt 1
		OTG_DREQ0,						//	ISP1362 DMA Request 0
		OTG_DREQ1,						//	ISP1362 DMA Request 1
		OTG_DACK0_N,					//	ISP1362 DMA Acknowledge 0
		OTG_DACK1_N,					//	ISP1362 DMA Acknowledge 1
		////////////////////	LCD Module 16X2		////////////////
		LCD_ON,							//	LCD Power ON/OFF
		LCD_BLON,						//	LCD Back Light ON/OFF
		LCD_RW,							//	LCD Read/Write Select, 0 = Write, 1 = Read
		LCD_EN,							//	LCD Enable
		LCD_RS,							//	LCD Command/Data Select, 0 = Command, 1 = Data
		LCD_DATA,						//	LCD Data bus 8 bits
		////////////////////	SD_Card Interface	////////////////
		//SD_DAT,							//	SD Card Data
		//SD_WP_N,						   //	SD Write protect 
		//SD_CMD,							//	SD Card Command Signal
		//SD_CLK,							//	SD Card Clock
		////////////////////	USB JTAG link	////////////////////
		TDI,  							// CPLD -> FPGA (data in)
		TCK,  							// CPLD -> FPGA (clk)
		TCS,  							// CPLD -> FPGA (CS)
	   TDO,  							// FPGA -> CPLD (data out)
		////////////////////	I2C		////////////////////////////
		I2C_SDAT,						//	I2C Data
		I2C_SCLK,						//	I2C Clock
		////////////////////	PS2		////////////////////////////
		PS2_DAT,						//	PS2 Data
		PS2_CLK,						//	PS2 Clock
		////////////////////	VGA		////////////////////////////
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK,						//	VGA BLANK
		VGA_SYNC,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,  						//	VGA Blue[9:0]
		////////////	Ethernet Interface	////////////////////////
		ENET_DATA,						//	DM9000A DATA bus 16Bits
		ENET_CMD,						//	DM9000A Command/Data Select, 0 = Command, 1 = Data
		ENET_CS_N,						//	DM9000A Chip Select
		ENET_WR_N,						//	DM9000A Write
		ENET_RD_N,						//	DM9000A Read
		ENET_RST_N,						//	DM9000A Reset
		ENET_INT,						//	DM9000A Interrupt
		ENET_CLK,						//	DM9000A Clock 25 MHz
		////////////////	Audio CODEC		////////////////////////
		AUD_ADCLRCK,					//	Audio CODEC ADC LR Clock
		AUD_ADCDAT,						//	Audio CODEC ADC Data
		AUD_DACLRCK,					//	Audio CODEC DAC LR Clock
		AUD_DACDAT,						//	Audio CODEC DAC Data
		AUD_BCLK,						//	Audio CODEC Bit-Stream Clock
		AUD_XCK,						//	Audio CODEC Chip Clock
		////////////////	TV Decoder		////////////////////////
		TD_DATA,    					//	TV Decoder Data bus 8 bits
		TD_HS,							//	TV Decoder H_SYNC
		TD_VS,							//	TV Decoder V_SYNC
		TD_RESET,						//	TV Decoder Reset
		TD_CLK27,                  //	TV Decoder 27MHz CLK
		////////////////////	GPIO	////////////////////////////
		GPIO_0,							//	GPIO Connection 0
		GPIO_1						//	GPIO Connection 1

//		S, B, MEM_R_EN, MEM_W_EN, WB_EN,
//		S_DR, B_DR, MEM_R_EN_DR, MEM_W_EN_DR, WB_EN_DR,
//		EXE_CMD, EXE_CMD_DR


	);

////////////////////////	Clock Input	 	////////////////////////
input		   	CLOCK_27;				//	27 MHz
input		   	CLOCK_50;				//	50 MHz
input			   EXT_CLOCK;				//	External Clock
////////////////////////	Push Button		////////////////////////
input	   [3:0]	KEY;					//	Pushbutton[3:0]
////////////////////////	DPDT Switch		////////////////////////
input	  [17:0]	SW;						//	Toggle Switch[17:0]
////////////////////////	7-SEG Dispaly	////////////////////////
output	[6:0]	HEX0;					//	Seven Segment Digit 0
output	[6:0]	HEX1;					//	Seven Segment Digit 1
output	[6:0]	HEX2;					//	Seven Segment Digit 2
output	[6:0]	HEX3;					//	Seven Segment Digit 3
output	[6:0]	HEX4;					//	Seven Segment Digit 4
output	[6:0]	HEX5;					//	Seven Segment Digit 5
output	[6:0]	HEX6;					//	Seven Segment Digit 6
output	[6:0]	HEX7;					//	Seven Segment Digit 7
////////////////////////////	LED		////////////////////////////
output	[8:0]	LEDG;					//	LED Green[8:0]
output  [17:0]	LEDR;					//	LED Red[17:0]
////////////////////////////	UART	////////////////////////////
//output			UART_TXD;				//	UART Transmitter
//input			   UART_RXD;				//	UART Receiver
////////////////////////////	IRDA	////////////////////////////
//output			IRDA_TXD;				//	IRDA Transmitter
//input			   IRDA_RXD;				//	IRDA Receiver
///////////////////////		SDRAM Interface	////////////////////////
inout	  [15:0]	DRAM_DQ;				//	SDRAM Data bus 16 Bits
output  [11:0]	DRAM_ADDR;				//	SDRAM Address bus 12 Bits
output			DRAM_LDQM;				//	SDRAM Low-byte Data Mask 
output			DRAM_UDQM;				//	SDRAM High-byte Data Mask
output			DRAM_WE_N;				//	SDRAM Write Enable
output			DRAM_CAS_N;				//	SDRAM Column Address Strobe
output			DRAM_RAS_N;				//	SDRAM Row Address Strobe
output			DRAM_CS_N;				//	SDRAM Chip Select
output			DRAM_BA_0;				//	SDRAM Bank Address 0
output			DRAM_BA_1;				//	SDRAM Bank Address 0
output			DRAM_CLK;				//	SDRAM Clock
output			DRAM_CKE;				//	SDRAM Clock Enable
////////////////////////	Flash Interface	////////////////////////
inout	  [7:0]	FL_DQ;					//	FLASH Data bus 8 Bits
output [21:0]	FL_ADDR;				//	FLASH Address bus 22 Bits
output			FL_WE_N;				//	FLASH Write Enable
output			FL_RST_N;				//	FLASH Reset
output			FL_OE_N;				//	FLASH Output Enable
output			FL_CE_N;				//	FLASH Chip Enable
////////////////////////	SRAM Interface	////////////////////////
inout	 [15:0]	SRAM_DQ;				//	SRAM Data bus 16 Bits
output [17:0]	SRAM_ADDR;				//	SRAM Address bus 18 Bits
output			SRAM_UB_N;				//	SRAM High-byte Data Mask 
output			SRAM_LB_N;				//	SRAM Low-byte Data Mask 
output			SRAM_WE_N;				//	SRAM Write Enable
output			SRAM_CE_N;				//	SRAM Chip Enable
output			SRAM_OE_N;				//	SRAM Output Enable
////////////////////	ISP1362 Interface	////////////////////////
inout	 [15:0]	OTG_DATA;				//	ISP1362 Data bus 16 Bits
output  [1:0]	OTG_ADDR;				//	ISP1362 Address 2 Bits
output			OTG_CS_N;				//	ISP1362 Chip Select
output			OTG_RD_N;				//	ISP1362 Write
output			OTG_WR_N;				//	ISP1362 Read
output			OTG_RST_N;				//	ISP1362 Reset
output			OTG_FSPEED;				//	USB Full Speed,	0 = Enable, Z = Disable
output			OTG_LSPEED;				//	USB Low Speed, 	0 = Enable, Z = Disable
input			   OTG_INT0;				//	ISP1362 Interrupt 0
input			   OTG_INT1;				//	ISP1362 Interrupt 1
input			   OTG_DREQ0;				//	ISP1362 DMA Request 0
input			   OTG_DREQ1;				//	ISP1362 DMA Request 1
output			OTG_DACK0_N;			//	ISP1362 DMA Acknowledge 0
output			OTG_DACK1_N;			//	ISP1362 DMA Acknowledge 1
////////////////////	LCD Module 16X2	////////////////////////////
inout	  [7:0]	LCD_DATA;				//	LCD Data bus 8 bits
output			LCD_ON;					//	LCD Power ON/OFF
output			LCD_BLON;				//	LCD Back Light ON/OFF
output			LCD_RW;					//	LCD Read/Write Select, 0 = Write, 1 = Read
output			LCD_EN;					//	LCD Enable
output			LCD_RS;					//	LCD Command/Data Select, 0 = Command, 1 = Data
////////////////////	SD Card Interface	////////////////////////
//inout	 [3:0]	SD_DAT;					//	SD Card Data
//input			   SD_WP_N;				   //	SD write protect
//inout			   SD_CMD;					//	SD Card Command Signal
//output			SD_CLK;					//	SD Card Clock
////////////////////////	I2C		////////////////////////////////
inout			   I2C_SDAT;				//	I2C Data
output			I2C_SCLK;				//	I2C Clock
////////////////////////	PS2		////////////////////////////////
input		 	   PS2_DAT;				//	PS2 Data
input			   PS2_CLK;				//	PS2 Clock
////////////////////	USB JTAG link	////////////////////////////
input  			TDI;					// CPLD -> FPGA (data in)
input  			TCK;					// CPLD -> FPGA (clk)
input  			TCS;					// CPLD -> FPGA (CS)
output 			TDO;					// FPGA -> CPLD (data out)
////////////////////////	VGA			////////////////////////////
output			VGA_CLK;   				//	VGA Clock
output			VGA_HS;					//	VGA H_SYNC
output			VGA_VS;					//	VGA V_SYNC
output			VGA_BLANK;				//	VGA BLANK
output			VGA_SYNC;				//	VGA SYNC
output	[9:0]	VGA_R;   				//	VGA Red[9:0]
output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
////////////////	Ethernet Interface	////////////////////////////
inout	[15:0]	ENET_DATA;				//	DM9000A DATA bus 16Bits
output			ENET_CMD;				//	DM9000A Command/Data Select, 0 = Command, 1 = Data
output			ENET_CS_N;				//	DM9000A Chip Select
output			ENET_WR_N;				//	DM9000A Write
output			ENET_RD_N;				//	DM9000A Read
output			ENET_RST_N;				//	DM9000A Reset
input			   ENET_INT;				//	DM9000A Interrupt
output			ENET_CLK;				//	DM9000A Clock 25 MHz
////////////////////	Audio CODEC		////////////////////////////
inout			   AUD_ADCLRCK;			//	Audio CODEC ADC LR Clock
input			   AUD_ADCDAT;				//	Audio CODEC ADC Data
inout			   AUD_DACLRCK;			//	Audio CODEC DAC LR Clock
output			AUD_DACDAT;				//	Audio CODEC DAC Data
inout			   AUD_BCLK;				//	Audio CODEC Bit-Stream Clock
output			AUD_XCK;				//	Audio CODEC Chip Clock
////////////////////	TV Devoder		////////////////////////////
input	 [7:0]	TD_DATA;    			//	TV Decoder Data bus 8 bits
input			   TD_HS;					//	TV Decoder H_SYNC
input			   TD_VS;					//	TV Decoder V_SYNC
output			TD_RESET;				//	TV Decoder Reset
input          TD_CLK27;            //	TV Decoder 27MHz CLK
////////////////////////	GPIO	////////////////////////////////
inout	[35:0]	GPIO_0;					//	GPIO Connection 0
inout	[35:0]	GPIO_1;					//	GPIO Connection 1

	

	wire [31:0] PC, PC_FR, PC_DR;
	wire [31:0] Instruction, Instruction_FR;
	wire flush, rst;
	wire hazard, freeze;
	
	assign rst = SW[17];
	assign F_or_nH = SW[16]; //Forward or notHazard
	assign LEDG = SW[8:0];
	assign LEDR = PC[17:0];

	wire B_DR;
	wire [31:0] BranchAddr;
	wire CLOCK_25;
	FreqDivider FD(
		.in(CLOCK_50),
		.out(CLOCK_25),
		.rst(rst)
	);
	FetchStage FS (
		.clk(CLOCK_25),
		.rst(rst),
		.freeze(hazard | freeze),
		.Branch_taken(B_DR),
		.BranchAddr(BranchAddr),
		.PC(PC),
		.Instruction(Instruction)
	);

	FetchReg FR (
		.clk(CLOCK_25),
		.rst(rst),
		.freeze(hazard | freeze),
		.flush(flush),
		.PC_in(PC),
		.Instruction_in(Instruction),
		.PC(PC_FR),
		.Instruction(Instruction_FR)
	);
	
	wire [23:0] Signed_imm_24, Signed_imm_24_DR;
	wire S, B, MEM_R_EN, MEM_W_EN, WB_EN;
	wire S_DR, MEM_R_EN_DR, MEM_W_EN_DR, WB_EN_DR;
	wire MEM_R_EN_ER, MEM_W_EN_ER, WB_EN_ER, WB_EN_MR, MEM_R_EN_MR;

	wire [3:0] Dest, Dest_DR, Dest_ER, Dest_MR;

	wire [3:0] EXE_CMD, EXE_CMD_DR;

	wire [31:0] Val_Rn, Val_Rm, Val_Rn_DR, Val_Rm_DR, Val_Rm_ER;
	wire [31:0] WB_Value;
	wire imm, imm_DR;
	wire [11:0] Shift_operand, Shift_operand_DR;

	wire [3:0] Status_Reg, Status_Reg_DR, Status_Reg_ER;
	wire [3:0] Rn, src2, src1_DR, src2_DR;
	wire Two_src;
	wire [1:0] sel_src1, sel_src2, sel_src1_FU, sel_src2_FU;
	
	DecodeStage DS (
		.clk(CLOCK_25), 
		.rst(rst),
		.WB_WB_EN(WB_EN_MR),
		.Instruction(Instruction_FR),
		.Status_Reg(Status_Reg_ER),
		.hazard(hazard),
		.Dest_wb(Dest_MR),
		.Result_Wb(WB_Value),
		.Signed_imm_24(Signed_imm_24),
		.Dest(Dest),
		.S(S),
		.B(B),
		.MEM_W_EN(MEM_W_EN),
		.MEM_R_EN(MEM_R_EN),
		.WB_EN(WB_EN),
		.EXE_CMD(EXE_CMD),
    	.Val_Rn(Val_Rn),
    	.Val_Rm(Val_Rm),
		.imm(imm),
		.Shift_operand(Shift_operand),
		.src1(Rn),
		.src2(src2),
		.Two_src(Two_src)
	);

	assign flush = B_DR;
	DecodeReg DR (
		.clk(CLOCK_25),
		.rst(rst),
		.flush(flush),
		.imm_in(imm),
		.Shift_operand_in(Shift_operand),
		.PC_in(PC_FR),
		.PC(PC_DR),
		.B_in(B),
		.EXE_CMD_in(EXE_CMD),
		.S_in(S), 
		.MEM_R_EN_in(MEM_R_EN),
		.MEM_W_EN_in(MEM_W_EN),
    	.Status_Reg_in(Status_Reg_ER),
		.WB_EN_in(WB_EN),
		.Signed_imm_24_in(Signed_imm_24),
		.Dest_in(Dest),
		.B(B_DR),
		.EXE_CMD(EXE_CMD_DR),
		.S(S_DR),
		.MEM_R_EN(MEM_R_EN_DR),
		.MEM_W_EN(MEM_W_EN_DR),
		.WB_EN(WB_EN_DR),
		.Signed_imm_24(Signed_imm_24_DR),
		.Dest(Dest_DR),
		.Val_Rn_in(Val_Rn),
		.Val_Rm_in(Val_Rm),
		.Val_Rn(Val_Rn_DR),
		.Val_Rm(Val_Rm_DR),
		.imm(imm_DR),
		.Shift_operand(Shift_operand_DR),
		.Status_Reg(Status_Reg_DR),
    	.src1_in(Rn),
    	.src2_in(src2),
    	.src1(src1_DR),
    	.src2(src2_DR),
		.freeze(freeze)
	);

	status_reg sr(
		.clk(CLOCK_25),
		.rst(rst),
		.S(S_DR),
		.status_bit(Status_Reg),
		.SR(Status_Reg_ER)
	);

	wire [31:0] ALU_result, ALU_result_ER, ALU_result_MR, MEM_ADDR;
	ExecuteStage ES(
		.clk(CLOCK_25),
		.EXE_CMD(EXE_CMD_DR),
		.MEM_R_EN(MEM_R_EN_DR),
		.MEM_W_EN(MEM_W_EN_DR),
		.PC(PC_DR),
		.Val_Rn(Val_Rn_DR),
		.Val_Rm(Val_Rm_DR),
		.imm(imm_DR),
		.Shift_operand(Shift_operand_DR),
		.Signed_imm_24(Signed_imm_24_DR),
		.Status_Reg_in(Status_Reg_DR),
		.ALU_result(ALU_result),
		.Br_addr(BranchAddr),
		.Status_Reg(Status_Reg),
		.sel_src1(sel_src1),
		.sel_src2(sel_src2),
		.ALU_result_ER(ALU_result_ER),
		.WB_Value(WB_Value),
		.MEM_ADDR(MEM_ADDR)
	);

	ExecuteReg ER (
		.clk(CLOCK_25),
		.rst(rst),
		.WB_en_in(WB_EN_DR),
		.MEM_R_EN_in(MEM_R_EN_DR),
		.MEM_W_EN_in(MEM_W_EN_DR),
		.ALU_result_in(ALU_result),
		.ST_val_in(MEM_ADDR),
		.Dest_in(Dest_DR),
		.WB_en(WB_EN_ER),
		.MEM_R_EN(MEM_R_EN_ER),
		.MEM_W_EN(MEM_W_EN_ER),
		.ALU_result(ALU_result_ER),
		.ST_val(Val_Rm_ER),
		.Dest(Dest_ER),
		.freeze(freeze)
	);

	wire [31:0] Data_mem_res, Data_mem_res_MR;

	// MemAccessStage MAS (
	// 	.clk(CLOCK_25),
	// 	.rst(rst),
	// 	.MEMread(MEM_R_EN_ER),
	// 	.MEMwrite(MEM_W_EN_ER),
	// 	.address(ALU_result_ER),
	// 	.data(Val_Rm_ER),
	// 	.MEM_result(Data_mem_res)
	// );

	MemAccessReg MAR(
		.clk(CLOCK_25),
		.rst(rst),
		.WB_EN_in(WB_EN_ER),
		.MEM_R_EN_in(MEM_R_EN_ER),
		.Dest_in(Dest_ER),
		.ALU_Res(ALU_result_ER),
		.Data_mem_res_in(Data_mem_res),
		.ALU_Result(ALU_result_MR),
		.WB_EN(WB_EN_MR),
		.MEM_R_EN(MEM_R_EN_MR),
		.Dest(Dest_MR),
		.Data_mem_res(Data_mem_res_MR),
		.freeze(freeze)
	);

	WriteBackStage WBS(
		.ALU_result(ALU_result_MR),
		.MEM_result(Data_mem_res_MR),
		.MEM_R_en(MEM_R_EN_MR),
		.out(WB_Value)
	);

	HazardDetectionUnit HDU(
		.EXE_MEM_R_EN(MEM_R_EN_DR),
		.F_or_nH(F_or_nH),
		.opcode(Instruction_FR[24:21]),
		.src1(Rn),
		.src2(src2),
		.two_src(Two_src),
		.Exe_Dest(Dest_DR),
		.Exe_WB_EN(WB_EN_DR),
		.Mem_Dest(Dest_ER),
		.Mem_WB_EN(WB_EN_ER),
		.hazard_detect(hazard)
	);

	ForwardingUnit FU(
    	.src1(src1_DR),
		.src2(src2_DR),
		.Dest_ER(Dest_ER),
		.Dest_MR(Dest_MR),
		.WB_EN_MR(WB_EN_MR),
		.WB_EN_ER(WB_EN_ER),
		.sel_src1(sel_src1_FU),
		.sel_src2(sel_src2_FU)
	);
	
	assign sel_src1 = F_or_nH ? sel_src1_FU : 2'b0;
	assign sel_src2 = F_or_nH ? sel_src2_FU : 2'b0;

	SRAM_Controller SC(
		.clk(CLOCK_25),
		.rst(rst),
		.MEM_W_EN(MEM_W_EN_ER),
		.MEM_R_EN(MEM_R_EN_ER),
		.Data_address(ALU_result_ER),
		.Data_in(Val_Rm_ER),
		.freeze_signal(freeze),
		.Data_out(Data_mem_res),
		.SRAM_DQ(SRAM_DQ),
		.SRAM_ADDR(SRAM_ADDR),
		.SRAM_UB_N(SRAM_UB_N),
		.SRAM_LB_N(SRAM_LB_N),
		.SRAM_WE_N(SRAM_WE_N),
		.SRAM_CE_N(SRAM_CE_N),
		.SRAM_OE_N(SRAM_OE_N)
	);

	
endmodule