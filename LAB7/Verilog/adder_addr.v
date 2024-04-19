module adder_addr(
    PC,
    sign_24_imm,
    br_addr
);
    input[31:0] PC;
    input[23:0] sign_24_imm;
    output[31:0] br_addr;
    wire[31:0] branch;

    assign branch = ({{8{sign_24_imm[23]}}, sign_24_imm}) << 2'b10;
    assign br_addr = PC + branch;
endmodule
