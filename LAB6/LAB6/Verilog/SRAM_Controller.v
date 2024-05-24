module SRAM_Controller (
    input clk,
    input rst,

    // From Memory Stage
    input MEM_W_EN,
    input MEM_R_EN,
    input [31:0] Data_address, // address
    input [31:0] Data_in, // writeData

    // To Next Stage
    output [31:0] Data_out, // readData

    // For freeze other Stage
    output freeze_signal,

    inout [15:0] SRAM_DQ, // SRAM Data bus 16 Bits
    output [17:0] SRAM_ADDR, // SRAM Address bus 18 Bits
    output SRAM_UB_N, // SRAM High-byte Data Mask
    output SRAM_LB_N, // SRAM Low-byte Data Mask
    output SRAM_WE_N, // SRAM Write Enable
    output SRAM_CE_N, // SRAM Chip Enable
    output SRAM_OE_N // SRAM Output Enable
);

//////////////////////////////////// Counter
    reg [3:0] counter;
    always@(posedge clk, posedge rst)begin
        if(rst == 1'b1)begin
            counter <= 3'b0;
        end
        else if((MEM_W_EN == 1'b1) || (MEM_R_EN == 1'b1)) begin
            if(counter != 3'b101)
                counter <= counter + 3'b001;
            else
                counter <= 3'b0;
        end
        else 
            counter <= 3'b0;
    end


//////////////////////////////////// 1 bit output signals
    // assign zero to some output signals
    assign SRAM_UB_N = 1'b0;
    assign SRAM_LB_N = 1'b0;
    assign SRAM_CE_N = 1'b0;
    assign SRAM_OE_N = 1'b0;
    
    // Write Enable signal of SRAM
    assign SRAM_WE_N = ((MEM_W_EN == 1'b1) && (counter < 3'b010)) ? 1'b0 : 1'b1;

    // Freeze signal for other stages
    assign freeze_signal = (MEM_W_EN || MEM_R_EN) & (counter != 3'b101);
    //*********** assign ready = ? (freeze_signal = ~ready)


//////////////////////////////////// Address
    // Memory Address
    wire [31:0] Decoded_Address;
    assign Decoded_Address = (Data_address - 32'd1024);
    wire [31:0] Memory_address;
    assign Memory_address = {1'b0 , Decoded_Address[31:1]};

    // Assign to SRAM Address bus which has 18 bits
    assign SRAM_ADDR =  ((MEM_W_EN == 1'b1) && counter == 3'b000) ? (Memory_address [17:0]) : // // Decoded_Address[18:1]
                        ((MEM_W_EN == 1'b1) && counter == 3'b001) ? (Memory_address [17:0] + 1'b1) :
                        ((MEM_R_EN == 1'b1) && counter == 3'b000) ? (Memory_address [17:0]) :
                        ((MEM_R_EN == 1'b1) && counter == 3'b001) ? (Memory_address [17:0] + 1'b1) : 18'bz;


//////////////////////////////////// Data
    // Assign to SRAM Data bus which has 16 bits
    assign SRAM_DQ =    ((MEM_W_EN == 1'b1) && counter == 3'b000) ? Data_in [15:0] :
                        ((MEM_W_EN == 1'b1) && counter == 3'b001) ? Data_in [31:16] : 16'bz;

    // Write data in memory stage (readData signal in the view of memory stage)
    reg [31:0] Data_out_reg;
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            Data_out_reg <= 0;
        end
        else if ((MEM_R_EN == 1'b1) && counter == 3'b000) begin
            Data_out_reg[15:0] <= SRAM_DQ;
        end
        else if ((MEM_R_EN == 1'b1) && counter == 3'b001) begin
            Data_out_reg[31:16] <= SRAM_DQ;
        end
    end
    assign Data_out = Data_out_reg;


endmodule

