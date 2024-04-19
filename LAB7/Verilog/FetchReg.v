module FetchReg (
    clk,
    rst,
    freeze,
    flush,
    PC_in,
    Instruction_in,
    PC,
    Instruction
);
    input wire clk;
    input wire rst;
    input wire freeze;
    input wire flush;
    input [31:0] PC_in;
    input [31:0] Instruction_in;
    output reg [31:0] PC;
    output reg [31:0] Instruction;
    
    //PC_Reg, Instruction
    always @(posedge clk, posedge rst) begin
        if(rst)begin
            Instruction <= 0;
            PC <= 0;
        end
        else if (flush)begin
            Instruction <= {4'b1110, 28'b0};
            PC <= 0;
        end        
        else if(~freeze)begin
            PC <= PC_in;
            Instruction <= Instruction_in;
        end
    end
    

    
endmodule