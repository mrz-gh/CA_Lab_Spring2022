module DecodeReg (
    clk,
    rst,
    flush,
    PC_in,
    B_in,
    EXE_CMD_in,
    S_in,
    MEM_R_EN_in,
    MEM_W_EN_in,
    Status_Reg_in,
    WB_EN_in,
    Signed_imm_24_in,
    Dest_in,
    Val_Rn_in,
    Val_Rm_in,
    imm_in,
    Shift_operand_in,
    PC,
    B,
    EXE_CMD,
    S,
    MEM_R_EN,
    MEM_W_EN,
    WB_EN,
    Signed_imm_24,
    Dest,
    Val_Rn,
    Val_Rm,
    imm,
    Shift_operand,
    Status_Reg,
    src1_in,
    src2_in,
    src1,
    src2,
    freeze
);
    input wire clk;
    input wire rst;
    input wire flush;
    input wire [31:0] PC_in, Val_Rn_in, Val_Rm_in;
    input B_in, S_in, MEM_R_EN_in, MEM_W_EN_in, WB_EN_in, imm_in;
    input [23:0] Signed_imm_24_in;
    input [3:0] Dest_in, EXE_CMD_in, Status_Reg_in;
    input [11:0] Shift_operand_in;
    input [3:0] src1_in, src2_in;
    input freeze;

    output reg [31:0] PC;
    
    output reg [23:0] Signed_imm_24;
    output reg [3:0] Dest;
    output reg B, S, MEM_W_EN, MEM_R_EN, WB_EN, imm;
    output reg [3:0] EXE_CMD, Status_Reg;
    output reg [31:0] Val_Rm, Val_Rn;
    output reg [11:0] Shift_operand;
    output reg [3:0] src1, src2;

    //PC
    always @(posedge clk, posedge rst) begin
        if(rst)begin
            {PC, Signed_imm_24, Dest, B, S, MEM_W_EN, MEM_R_EN, WB_EN, EXE_CMD, Val_Rm, Val_Rn, imm, Shift_operand, Status_Reg, src1, src2} <= 0;
        end
        else if(flush)begin
            {PC, Signed_imm_24, Dest, B, S, MEM_W_EN, MEM_R_EN, WB_EN, EXE_CMD, Val_Rm, Val_Rn, imm, Shift_operand, Status_Reg, src1, src2} <= 0;
        end
        else if (~freeze) begin
            {PC, Signed_imm_24, Dest, B, S, MEM_W_EN, MEM_R_EN, WB_EN, EXE_CMD, Val_Rm, Val_Rn, imm, Shift_operand, Status_Reg, src1, src2} <=
            {PC_in, Signed_imm_24_in, Dest_in, B_in, S_in, MEM_W_EN_in, MEM_R_EN_in, WB_EN_in, EXE_CMD_in, Val_Rm_in, Val_Rn_in, imm_in, Shift_operand_in, Status_Reg_in, src1_in, src2_in};
        end
    end
    
endmodule