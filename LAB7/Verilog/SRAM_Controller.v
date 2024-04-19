/*module SRAM_Controller (
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
    reg [31:0] Data_out_reg;
    reg [17:0] SRAM_ADDR_reg;
    reg [3:0] counter;
    assign freeze_signal = (MEM_W_EN || MEM_R_EN) & (counter != 3'b101);

    wire [31:0] Memory_address;
    wire [31:0] Decoded_Address;
    assign Memory_address = {1'b0 , Decoded_Address[31:1]};
    assign Decoded_Address = (Data_address - 32'd1024);

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
    assign SRAM_ADDR =  ((MEM_W_EN == 1'b1) && counter == 3'b000) ? SRAM_ADDR_reg :
                        ((MEM_W_EN == 1'b1) && counter == 3'b001) ? (SRAM_ADDR_reg + 1'b1) :
                        ((MEM_R_EN == 1'b1) && counter == 3'b000) ? (SRAM_ADDR_reg) :
                        ((MEM_R_EN == 1'b1) && counter == 3'b001) ? (SRAM_ADDR_reg + 1'b1) : 18'bz;

    // assign Data_out[15:0] =     ((MEM_R_EN == 1'b1) && counter == 3'b001) ?
    //                             SRAM_DQ : Data_out[15:0]; //3'b010 if test with actual SRAM
    // assign Data_out[31:16] =    ((MEM_R_EN == 1'b1) && counter == 3'b000) ?
    //                             SRAM_DQ : Data_out[31:16]; //3'b001 if test with actual SRAM 
    assign SRAM_WE_N = ((MEM_W_EN == 1'b1) && (counter < 3'b010)) ? 1'b0 : 1'b1;


    always @(posedge clk, posedge rst) begin
        if (rst) begin
            Data_out_reg <= 0;
        end
        else if ((MEM_R_EN == 1'b1) && counter == 3'b001) begin
            Data_out_reg[15:0] <= SRAM_DQ;
        end
        else if ((MEM_R_EN == 1'b1) && counter == 3'b000) begin
            Data_out_reg[31:16] <= SRAM_DQ;
        end
    end
    assign Data_out = Data_out_reg;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            SRAM_ADDR_reg <= 0;
        end
        else begin
            SRAM_ADDR_reg <= Memory_address [17:0];
        end
    end
endmodule

  */


module SRAM_Controller(
    clk,
    rst,
    MEM_W_EN,
    MEM_R_EN,
    Data_address,
    Data_in,
    Data_out,
    freeze_signal,
    SRAM_DQ,
    SRAM_ADDR,
    SRAM_UB_N,
    SRAM_LB_N,
    SRAM_WE_N,
    SRAM_CE_N,
    SRAM_OE_N
);
    input clk, rst, MEM_W_EN, MEM_R_EN;
    input [31:0] Data_address, Data_in;

    output reg SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N;
    output reg [63:0] Data_out;
    output reg [17:0] SRAM_ADDR;
    output freeze_signal;
    inout [15:0] SRAM_DQ;

    wire ready;
    wire [31:0] s_Data_address;
    reg [63:0] temp_data;

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
    /*
    assign SRAM_ADDR =  (ps == 3'b000) ? {s_Data_address[18:3], 2'b00} :
                        (ps == 3'b001) ? {s_Data_address[18:3], 2'b01} :
                        (ps == 3'b010) ? {s_Data_address[18:3], 2'b10} :
                        (ps == 3'b011) ? {s_Data_address[18:3], 2'b11} : 0;
                        */

endmodule