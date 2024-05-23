module ExecuteStage(
    clk,
    EXE_CMD,
    MEM_R_EN,
    MEM_W_EN,
    PC,
    Val_Rn,
    Val_Rm,
    imm,
    Shift_operand,
    Signed_imm_24,
    Status_Reg_in,
    ALU_result,
    Br_addr,
    Status_Reg,
    sel_src1,
    sel_src2,
    ALU_result_ER,
    WB_Value,
    MEM_ADDR
);
  
    input clk;
    input MEM_R_EN;
    input MEM_W_EN;
    input imm;
    input [31:0] PC;
    input [31:0] Val_Rn;
    input [31:0] Val_Rm;
    input [3:0] EXE_CMD;
    input [3:0] Status_Reg_in;
    input [11:0] Shift_operand;
    input [23:0] Signed_imm_24;
    input [1:0] sel_src1, sel_src2;
    input [31:0] ALU_result_ER, WB_Value;
    output [31:0] ALU_result;
    output [31:0] Br_addr;
    output [3:0] Status_Reg;
    output [31:0] MEM_ADDR;
    wire [31:0] VAL2GEN;

    wire [31:0] Val1, Val2;
    
    assign Val1 =   (sel_src1 == 2'b00) ? Val_Rn : 
                    (sel_src1 == 2'b01) ? ALU_result_ER :
                    (sel_src1 == 2'b10) ? WB_Value : 32'bz;
    assign Val2 =   (sel_src2 == 2'b00) ? Val_Rm : 
                    (sel_src2 == 2'b01) ? ALU_result_ER :
                    (sel_src2 == 2'b10) ? WB_Value : 32'bz;
                    
    assign MEM_ADDR = Val2;
    ALU ALU1(
        .VAL1(Val1),
        .VAL2(VAL2GEN),
        .EXE_cmd(EXE_CMD),
        .c_in(Status_Reg_in[1]),
        .ALU_res(ALU_result),
        .status_bits(Status_Reg)
    );

    adder_addr ADDEER_ADDR(
        .PC(PC),
        .sign_24_imm(Signed_imm_24),
        .br_addr(Br_addr)
    );

    Val2_Gen VAL2GENERATOR(
        .imm(imm),
        .MEM_RW_EN(MEM_W_EN | MEM_R_EN),
        .shift_operand(Shift_operand),
        .Val_Rm(Val2),
        .Val2(VAL2GEN)
    );
                  
endmodule