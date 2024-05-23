module SRAM_Controller(
	input 			clk           	,
	input 			rst           	,
	input 			MEM_W_EN      	,
	input        	MEM_R_EN      	,
	input [31:0] 	Data_address  	,
	input [31:0] 	Data_in			,
	
	
	output reg [63:0] Data_out		,
	output reg [17:0] SRAM_ADDR		,
	output reg SRAM_UB_N			,
	output reg SRAM_LB_N			,
	output reg SRAM_WE_N			,
	output reg SRAM_CE_N			,
	output reg SRAM_OE_N			,
	
	inout [15:0] SRAM_DQ			,
	
	output freeze_signal
);

	wire 			ready;
	wire 	[31:0] 	s_Data_address;
	reg 	[63:0] 	temp_data;

	reg [2:0] ps, ns;
	always @(posedge clk, posedge rst) begin
	if(rst)
		ps <= 0;
	else
		ps <= ns; 
	end


	always @(MEM_W_EN, MEM_R_EN, ps, s_Data_address) begin
		{Data_out, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N} = 0;
		SRAM_WE_N = 1'b1;
		
		case(ps)
			3'b000: begin
				ns = 0;
				if (MEM_R_EN)begin
					SRAM_ADDR = {s_Data_address[18:3], 2'b00};
					ns = ps + 3'd1;
				end
				else if (MEM_W_EN) begin
					SRAM_ADDR = {s_Data_address[18:2], 1'b0};
					SRAM_WE_N=1'b0;
					ns = ps + 3'd1;
				end
			end
			3'b001: begin
				ns = ps;
				if(MEM_R_EN) begin
					SRAM_ADDR = {s_Data_address[18:3], 2'b01};
					ns = ps + 3'd1;
				end
				if(MEM_W_EN) begin
					SRAM_ADDR = {s_Data_address[18:2], 1'b1};
					SRAM_WE_N=1'b0;
					ns = ps + 3'd1;
				end
			end
			3'b010: begin
				ns = ps + 3'd1;
				if(MEM_R_EN) begin
					SRAM_ADDR = {s_Data_address[18:3], 2'b10};
				end
				
			end
			3'b011: begin
				ns = ps + 3'd1;
				if(MEM_R_EN)begin
					SRAM_ADDR = {s_Data_address[18:3], 2'b11};
				end
			end
			3'b100: begin
				ns = ps + 3'd1;
			end
			3'b101: begin
				Data_out = temp_data;
				ns = 0;
			end
			default: ns = 0;
		endcase
	end


	/* "temp_data" register to store read data */
	always @(posedge clk, posedge rst)begin
		if(rst)
			temp_data <= 0;
		else if (MEM_R_EN & ps == 3'b000)
			temp_data[15:0] <= SRAM_DQ;
		else if (MEM_R_EN & ps == 3'b001)
			temp_data[31:16] <= SRAM_DQ;
		else if (MEM_R_EN & ps == 3'b010)
			temp_data[47:32] <= SRAM_DQ;
		else if (MEM_R_EN & ps == 3'b011)
			temp_data[63:48] <= SRAM_DQ;

	end

	assign SRAM_DQ =    (MEM_W_EN && (ps == 3'b000)) ? Data_in[15:0] : (MEM_W_EN && (ps == 3'b001)) ?
						Data_in[31:16]:16'bzzzzzzzzzzzzzzzz;

	assign ready = ((~MEM_R_EN & ~MEM_W_EN) | (ps == 3'b101)) ? 1'b1 : 1'b0;
	assign freeze_signal = ~ready;
	assign s_Data_address = Data_address - 32'd1024;

endmodule