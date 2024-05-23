module status_reg(
	clk,
	rst,
	S,
	status_bit,
	SR
);
	input clk, rst, S;
	input[3:0] status_bit;
	output reg [3:0] SR;

	always@(negedge clk, posedge rst)
	begin
		if(rst)
			SR <= 4'b0;
		else if(S)
			SR <= status_bit;
	end
endmodule