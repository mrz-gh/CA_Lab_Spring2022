module DecodeStage (
    clk,
    rst,
    WB_WB_EN,
    Instruction,
    Status_Reg,
    hazard,
    Dest_wb,
    Result_Wb,
    Signed_imm_24,
    Dest,
    S,
    B,
    MEM_W_EN,
    MEM_R_EN,
    WB_EN,
    EXE_CMD,
    Val_Rn,
    Val_Rm,
    imm,
    Shift_operand,
    src1,
    src2,
    Two_src
);

    input clk;
    input rst;
    input [31:0] Instruction, Result_Wb;
    input [3:0] Status_Reg;
    input [3:0] Dest_wb;
    input hazard, WB_WB_EN;
 
    
    output [23:0] Signed_imm_24;
    output [3:0] Dest;
    output wire B, S, MEM_W_EN, MEM_R_EN, WB_EN;
    output wire [3:0] EXE_CMD;
    output wire [31:0] Val_Rn, Val_Rm;
	output imm;
	output[11:0] Shift_operand;
    output [3:0] src1, src2;
    output Two_src;

    assign imm = Instruction[25];
    assign Shift_operand = Instruction[11:0];
    wire [3:0] Rm, Rn, Rd;
    assign Rm = Instruction[3:0];
    assign Rd = Instruction[15:12];
    assign Rn = Instruction[19:16];
    wire [3:0] opcode;
    assign opcode = Instruction[24:21];
    wire S_in;
    assign S_in = Instruction[20];
    wire [1:0] mode;
    assign mode = Instruction[27:26];
    wire [3:0] cond;
    assign cond = Instruction[31:28];

    assign Dest = Rd;

    wire [3:0] in1_Addr, in2_Addr;
    wire cond_check;
    wire CU_B, CU_MEM_W_EN, CU_MEM_R_EN, CU_WB_EN, CU_up_status;
    wire [3:0] CU_EXE_CMD;

    assign in1_Addr = Rn;
    assign in2_Addr = MEM_W_EN ? Rd : Rm;


    RegisterFile RF (
        .clk(clk),
        .rst(rst),
        .src1(in1_Addr), 
        .src2(in2_Addr), 
        .Dest_wb(Dest_wb),
        .Result_wb(Result_Wb),
        .writeBackEn(WB_WB_EN),
        .reg1(Val_Rn), 
		.reg2(Val_Rm)
    );


    ControlUnit CU (
        .mode(mode), 
        .opcode(opcode),
        .S(S),
		.Instruction(Instruction),
        .mem_read(CU_MEM_R_EN), 
        .mem_write(CU_MEM_W_EN),
        .B(CU_B),
        .EXE_CMD(CU_EXE_CMD),
		.WB_enable(CU_WB_EN), 
        .up_status(CU_up_status)
    );

    Condition_Check CC (
        .cond(cond), 
		.Status_Reg(Status_Reg),
        .cond_check(cond_check)
    );

    assign Signed_imm_24 = {{16{Instruction[7]}}, Instruction[7:0]};
    
    
    assign {S, B, MEM_W_EN, MEM_R_EN, WB_EN, EXE_CMD} = (~cond_check | hazard) ? 0 :
           {S_in, CU_B, CU_MEM_W_EN, CU_MEM_R_EN, CU_WB_EN, CU_EXE_CMD};

    assign Two_src = ~imm | MEM_W_EN;
    assign src1 = in1_Addr;
    assign src2 = in2_Addr;
endmodule