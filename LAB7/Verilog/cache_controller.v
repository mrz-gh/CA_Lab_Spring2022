module cache_controller (
    clk,
    rst,
    address,
    wdata,
    MEM_R_EN,
    MEM_W_EN,
    rdata,
    ready,
    sram_address,
    sram_wdata,
    sram_write,
    sram_read,
    sram_rdata,
    sram_ready
);

    input clk;
    input rst;
    input [31:0] address;
    input [31:0] wdata;
    input MEM_R_EN;
    input MEM_W_EN;
    output [31:0] rdata;
    output ready;
    output [31:0] sram_address;
    output [31:0] sram_wdata;
    output sram_write, sram_read;
    input [63:0] sram_rdata;
    input sram_ready;

    wire hit;
    assign ready = sram_ready;

    wire offset;
    wire [5:0] index;
    wire [9:0] tag;
    assign offset = address[2];
    assign index = address[8:3];
    assign tag = address[18:9];

    // Cache
    reg [31:0] mem_way0_data0 [63:0];
    reg [31:0] mem_way0_data1 [63:0];
    reg [31:0] mem_way1_data0 [63:0];
    reg [31:0] mem_way1_data1 [63:0];

    reg mem_way0_valid [63:0];
    reg mem_way1_valid [63:0];

    reg [9:0] mem_way0_tag [63:0];
    reg [9:0] mem_way1_tag [63:0];

    reg LRU [63:0];



    // hit
    wire hit_way0, hit_way1;
    assign hit_way0 = (mem_way0_valid[index]) & (mem_way0_tag[index] == tag);
    assign hit_way1 = (mem_way1_valid[index]) & (mem_way1_tag[index] == tag);
    assign hit = hit_way0 | hit_way1;
    assign sram_read = MEM_R_EN & ~hit;

    // read data
    wire [31:0] rdata_temp;
    assign rdata_temp = hit ?
                   (hit_way0 ? (offset ? mem_way0_data1[index] : mem_way0_data0[index]) :
                   hit_way1 ? (offset ? mem_way1_data1[index] : mem_way1_data0[index]) : 32'bz) :
                   sram_ready ? (offset ? sram_rdata[63:32] : sram_rdata[31:0]) : 32'bz;

    assign rdata = MEM_R_EN ? rdata_temp : 32'bz;


    // LRU
    integer i;
    always @(posedge rst, posedge clk) begin
        if (rst)
            for(i = 0; i < 64; i = i + 1)
                LRU[i] <= 0;

        else if(MEM_R_EN & hit_way0)
            LRU[index] <= 0;
        else if (MEM_R_EN & hit_way1) 
            LRU[index] <= 1;
        else if (~hit & sram_ready)begin
            if((mem_way0_valid[index] == 1'b1) & (LRU[index] == 1'b1))
                LRU[index] <= 1'b0;
            else if((mem_way1_valid[index] == 1'b1) & (LRU[index] == 1'b0))
                LRU[index] <= 1'b1;
        end
    end

    // Cache Data & tag & Valid
    always @(posedge rst, posedge clk) begin
        if (rst)begin
            for(i = 0; i < 64; i = i + 1)begin
                {mem_way0_data1[i], mem_way0_data0[i],mem_way1_data1[i], mem_way1_data0[i]} <= 0;
                mem_way0_valid[i] <= 0;
                mem_way1_valid[i] <= 0;
                mem_way0_tag[i] <= 0;
                mem_way1_tag[i] <= 0;
            end
        end
                
        else if(MEM_R_EN & ~hit & sram_ready & (LRU[index] == 1))begin
            {mem_way0_data1[index], mem_way0_data0[index]} <= sram_rdata;
            mem_way0_valid[index] <= 1;
            mem_way0_tag[index] <= tag;
        end
        else if (MEM_R_EN & ~hit & sram_ready & (LRU[index] == 0)) begin
            {mem_way1_data1[index], mem_way1_data0[index]} <= sram_rdata;
            mem_way1_valid[index] <= 1;
            mem_way1_tag[index] <= tag;
        end
        else if(MEM_W_EN & hit_way0)begin
            mem_way0_valid[index] <= 0;
        end
        else if(MEM_W_EN & hit_way1)begin
            mem_way1_valid[index] <= 0;
        end

    end


    
    assign sram_address = address;
    assign sram_wdata = wdata;
    assign sram_write = MEM_W_EN;

    
endmodule