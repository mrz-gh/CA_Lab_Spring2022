module Data_Memory (
	clk,
	rst,
	MEM_W_EN,
	MEM_R_EN,
	Data_addr,
	Data_in,
	Data_out
);
	input clk, rst;
	input MEM_W_EN;
	input MEM_R_EN;
	input [31:0] Data_addr;
	input [31:0] Data_in;
	output [31:0] Data_out;
	
	integer i;
	reg [31:0] memory [0:63];
	wire [31:0] Decoded_Addr;
	wire [31:0] Memory_addr;
	
	assign Decoded_Addr = (Data_addr - 32'd1024);
	assign Memory_addr = {2'b0 , Decoded_Addr[31:2]};
	assign Data_out =  MEM_R_EN ? memory[Memory_addr] : 32'bz;


	always @(posedge clk, posedge rst) begin
		if (rst) 
			for(i = 0; i <= 63; i = i + 1) begin
				memory[i] = 32'b0;
			end
		else if(MEM_W_EN)
			memory[Memory_addr] = Data_in; 
	end

	

endmodule