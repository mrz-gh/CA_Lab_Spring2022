module Val2_Gen (
	imm,
	MEM_RW_EN,
	shift_operand,
	Val_Rm,
	Val2
);
	input imm;
	input MEM_RW_EN;
	input[11:0] shift_operand;
	input[31:0] Val_Rm;
	output reg[31:0] Val2;
	
	always @(imm, MEM_RW_EN, shift_operand, Val_Rm) 
	begin
		if (MEM_RW_EN == 1)
		begin
			Val2 = {{20{shift_operand[11]}}, shift_operand[11:0]};
		end
		else if (imm == 1) begin
			Val2 = {shift_operand[7:0], 24'b0, shift_operand[7:0]} >> {shift_operand[11:8], 1'b0};
		end
		else if(shift_operand[4] == 1'b0)
		begin
			case(shift_operand[6:5])
				2'b00:  Val2 = Val_Rm 		   << 	shift_operand[11:7];
		        2'b01:	Val2 = Val_Rm 		   >> 	shift_operand[11:7];
		        2'b10:	Val2 = Val_Rm 		   >>> 	shift_operand[11:7];
		        2'b11:	Val2 = {Val_Rm,Val_Rm} >>   shift_operand[11:7];
			endcase
		end
	end
endmodule