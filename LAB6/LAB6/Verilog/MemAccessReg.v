module MemAccessReg(
    clk,
    rst,
    WB_EN_in,
    MEM_R_EN_in,
	Dest_in,
	ALU_Res,
	Data_mem_res_in,
	ALU_Result,
	WB_EN,MEM_R_EN,
	Dest,
	Data_mem_res,
	freeze
);
	input clk, rst, WB_EN_in, MEM_R_EN_in;
	input [3:0] Dest_in;
	input [31:0] ALU_Res;
	input [31:0] Data_mem_res_in;
    input freeze;
	output reg [31:0] ALU_Result;
	output reg WB_EN, MEM_R_EN;
	output reg [3:0] Dest;
	output reg [31:0] Data_mem_res;

	always @(posedge clk, posedge rst) begin
		if (rst == 1) begin
			ALU_Result      <= 32'b0;
			WB_EN           <= 0;
			MEM_R_EN        <= 0;
			Dest            <= 4'b0;
			Data_mem_res    <= 32'b0;
		end
		else if (~freeze) begin
			ALU_Result      <= ALU_Res;
			WB_EN           <= WB_EN_in;
			MEM_R_EN        <= MEM_R_EN_in;
			Dest            <= Dest_in;
			Data_mem_res    <= Data_mem_res_in;
		end
	end
endmodule