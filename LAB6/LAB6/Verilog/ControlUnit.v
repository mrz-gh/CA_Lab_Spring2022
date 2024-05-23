module ControlUnit(
    mode,
    opcode, 
    S,
	Instruction,
    mem_read,
    mem_write,
    B,
    EXE_CMD, 
	WB_enable, 
    up_status
);
    input [1:0] mode;
    input [3:0] opcode;
    input S;
	input [31:0] Instruction;

    output reg mem_write, mem_read;
    output reg WB_enable, B;
    output reg [3:0] EXE_CMD;
    output reg up_status;


    always @(opcode, S, mode) begin
        {up_status, B, EXE_CMD, mem_write, mem_read, WB_enable} = 0;
        if (mode == 2'b00) begin
            up_status = S;

            case (opcode)
                4'b1101: begin
                    //MOV
                    WB_enable = 1'b1;
                    EXE_CMD = 4'b0001;
                end
                4'b1111: begin
                    //MVN
                    WB_enable = 1'b1;
                    EXE_CMD = 4'b1001;
                end
                4'b0100: begin
                    //ADD
                    WB_enable = 1'b1;
                    EXE_CMD = 4'b0010;
                end
                4'b0101: begin
                    //ADC
                    WB_enable = 1'b1;
                    EXE_CMD = 4'b0011;
                end
                4'b0010: begin
                    //SUB
                    WB_enable = 1'b1;
                    EXE_CMD = 4'b0100;
                end
                4'b0110: begin
                    //SBC
                    WB_enable = 1'b1;
                    EXE_CMD = 4'b0101;
                end
                4'b0000: begin
                    //AND
                    WB_enable = (Instruction == {4'b1110, 28'b0}) ? 1'b0 : 1'b1;
                    // WB_enable = 1'b1;
                    EXE_CMD = 4'b0110;
                end
                4'b1100: begin
                    //ORR
                    WB_enable = 1'b1;
                    EXE_CMD = 4'b0111;
                end
                4'b0001: begin
                    //EOR
                    WB_enable = 1'b1;
                    EXE_CMD = 4'b1000;
                end
                4'b1010: begin //State S = 0 is ignored.
                    //CMP
                    WB_enable = 1'b0;
                    EXE_CMD = 4'b0100;
                end
                4'b1000: begin //State S = 0 is ignored.
                    //TST
                    WB_enable = 1'b0;
                    EXE_CMD = 4'b0110;
                end
            endcase
        end
        else if (mode == 2'b01) begin
            if (opcode == 4'b0100) begin
                if (S == 1'b1) begin
                    //LDR
                    mem_read = 1'b1;
                    EXE_CMD = 4'b0010;
                    WB_enable = 1'b1;
                end
                else begin
                    //STR
                    mem_write = 1'b1;
                    EXE_CMD = 4'b0010;
                end
            end
        end
        else if (mode == 2'b10) begin
            if(Instruction[24] == 0)begin
                B = 1'b1;
            end
        end
        else begin
            {B, EXE_CMD, mem_write, mem_read, WB_enable} = 0;
        end
    end
endmodule