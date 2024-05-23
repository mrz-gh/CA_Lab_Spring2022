module SRAM_Controller (
    clk,
    rst,
    MEM_W_EN,
    MEM_R_EN,
    Data_address,
    Data_in,
    freeze_signal,
    Data_out,
    SRAM_DQ,
    SRAM_ADDR,
    SRAM_UB_N,
    SRAM_LB_N,
    SRAM_WE_N,
    SRAM_CE_N,
    SRAM_OE_N
);
    input clk, rst;
    input MEM_W_EN;
    input MEM_R_EN;
    input [31:0] Data_address;
    input [31:0] Data_in;
    output freeze_signal;
    output [31:0] Data_out;
    inout [15:0] SRAM_DQ;
    output [17:0] SRAM_ADDR;
    output SRAM_UB_N;
    output SRAM_LB_N;
    output SRAM_WE_N;
    output SRAM_CE_N;
    output SRAM_OE_N;

    assign SRAM_UB_N = 1'b0;
    assign SRAM_LB_N = 1'b0;
    assign SRAM_CE_N = 1'b0;
    assign SRAM_OE_N = 1'b0;

    reg [3:0] counter;
    assign freeze_signal = (MEM_W_EN || MEM_R_EN) & (counter != 3'b101);

    wire [31:0] Memory_address;
    wire [31:0] Decoded_Address;
    assign Decoded_Address = (Data_address - 32'd1024);
    assign Memory_address = {1'b0 , Decoded_Address[31:1]};

    always@(posedge clk, posedge rst)begin
        if(rst == 1'b1)begin
            counter <= 3'b0;
        end
        else if(MEM_W_EN || MEM_R_EN) begin
            if(counter != 3'b101)
                counter <= counter + 3'b001;
            else
                counter <= 3'b0;
        end
        else 
            counter <= 3'b0;
    end
    assign SRAM_DQ =    ((MEM_W_EN == 1'b1) && counter == 3'b000) ? Data_in [31:16] :
                        ((MEM_W_EN == 1'b1) && counter == 3'b001) ? Data_in [15:0] : 16'bz;
    assign SRAM_ADDR =  ((MEM_W_EN == 1'b1) && counter == 3'b000) ? Memory_address [17:0] :
                        ((MEM_W_EN == 1'b1) && counter == 3'b001) ? (Memory_address [17:0] + 1'b1) :
                        ((MEM_R_EN == 1'b1) && counter == 3'b000) ? (Memory_address [17:0]) :
                        ((MEM_R_EN == 1'b1) && counter == 3'b001) ? (Memory_address [17:0] + 1'b1) : SRAM_ADDR;

    assign Data_out[15:0] =     ((MEM_R_EN == 1'b1) && counter == 3'b001) ?
                                SRAM_DQ : Data_out[15:0]; //3'b010 if test with actual SRAM
    assign Data_out[31:16] =    ((MEM_R_EN == 1'b1) && counter == 3'b000) ?
                                SRAM_DQ : Data_out[31:16]; //3'b001 if test with actual SRAM 
    assign SRAM_WE_N = ((MEM_W_EN == 1'b1) && (counter < 3'b010)) ? 1'b0 : 1'b1;

endmodule

  