module WriteBackStage(
    ALU_result,
    MEM_result,
    MEM_R_en,
    out
);

	input  [31:0]ALU_result;
	input  [31:0]MEM_result;
	input  MEM_R_en;
	output [31:0]out;
	reg	   [31:0]out;
	
	always @(MEM_R_en, ALU_result, MEM_result) 
		case (MEM_R_en)
			1'b0  : out = ALU_result;
			1'b1  : out = MEM_result;			
		endcase
			
endmodule