module ALU (
    VAL1,
    VAL2,
    EXE_cmd,
    c_in,
    ALU_res,
    status_bits
);
    input[31:0] VAL1;
    input[31:0] VAL2;
    input[3:0] EXE_cmd;
    input c_in;
    output[31:0] ALU_res;
    output[3:0] status_bits;

    wire N, Z, C, V;
    assign status_bits = {N, Z, C, V};
    assign {C, ALU_res}=(EXE_cmd == 4'b0001) ? VAL2:
                        (EXE_cmd == 4'b1001) ? ~VAL2:
                        (EXE_cmd == 4'b0010) ? VAL1 + VAL2:
                        (EXE_cmd == 4'b0011) ? VAL1 + VAL2 + c_in:
                        (EXE_cmd == 4'b0100) ? VAL1 - VAL2:
                        (EXE_cmd == 4'b0101) ? VAL1 - VAL2 - {31'b0, ~c_in}:
                        (EXE_cmd == 4'b0110) ? VAL1 & VAL2:
                        (EXE_cmd == 4'b0111) ? VAL1 | VAL2:
                        (EXE_cmd == 4'b1000) ? VAL1 ^ VAL2:
                        33'b0;
                        
    assign Z = ~(|ALU_res);
    assign N = ALU_res[31];
    assign V =  (EXE_cmd == 4'b0010 || EXE_cmd == 4'b0011) ? 
                ((ALU_res[31] & ~VAL1[31] & ~VAL2[31]) || (~ALU_res[31] & VAL1[31] & VAL2[31])):
                (EXE_cmd == 4'b0100 || EXE_cmd == 4'b0101) ?
                ((ALU_res[31] & ~VAL1[31] & VAL2[31]) || (~ALU_res[31] & VAL1[31] & ~VAL2[31])):
                1'b0;                      
  
endmodule