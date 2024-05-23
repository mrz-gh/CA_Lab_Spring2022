module HazardDetectionUnit (
    EXE_MEM_R_EN,
    F_or_nH,
    opcode,
    src1,
    src2,
    two_src,
    Exe_Dest,
    Exe_WB_EN,
    Mem_Dest,
    Mem_WB_EN,
    hazard_detect
);
    
    input[3:0] src1, src2, Mem_Dest, Exe_Dest, opcode;
    input Exe_WB_EN, Mem_WB_EN, two_src;
    input EXE_MEM_R_EN, F_or_nH;

    output hazard_detect;
    assign hazard_detect =  (EXE_MEM_R_EN == 1'b1 && F_or_nH && (Exe_Dest == src1 || (Exe_Dest == src2 && two_src == 1'b1))) ? 1'b1 :
                            F_or_nH ? 1'b0 : ~(opcode == 4'b1101 || opcode == 4'b1111) ?
                            ((src1 == Exe_Dest)&&(Exe_WB_EN == 1'b1)) ? 1'b1 :
                            ((src1 == Mem_Dest)&&(Mem_WB_EN == 1'b1)) ? 1'b1 :
                            ((src2 == Exe_Dest)&&(Exe_WB_EN == 1'b1)&&(two_src == 1'b1)) ? 1'b1 :
                            ((src2 == Mem_Dest)&&(Mem_WB_EN == 1'b1)&&(two_src == 1'b1)) : 1'b0;

    endmodule