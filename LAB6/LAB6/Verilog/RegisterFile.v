module RegisterFile (
    clk,
    rst,
    src1,
    src2, 
    Dest_wb,
    Result_wb,
    writeBackEn,
    reg1,
    reg2
);

    input wire clk, rst;
    input wire [3:0] src1, src2, Dest_wb;
    input wire [31:0] Result_wb; 
    input wire writeBackEn;
    output wire [31:0] reg1, reg2;

    reg [31:0] Reg_File [14:0];

    integer i;

    //Reg_File
    always @(negedge clk, posedge rst) begin
        if (rst) begin
            for (i = 0; i < 15; i = i + 1) begin
                Reg_File[i] <= i;
            end
        end
        else if(writeBackEn) begin
            Reg_File[Dest_wb] <= Result_wb;
        end
    end
    assign reg1 = Reg_File[src1];
    assign reg2 = Reg_File[src2];
endmodule