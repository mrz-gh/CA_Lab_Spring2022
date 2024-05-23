module MemAccessStage (
    clk,
    rst,
    MEMread,
    MEMwrite,
    address,
    data,
    MEM_result
);
    input clk, rst;
    input MEMread, MEMwrite;
    input [31:0] address, data;
    output [31:0] MEM_result;

    Data_Memory DM (
        .clk(clk),
        .rst(rst),
        .MEM_W_EN(MEMwrite),
        .MEM_R_EN(MEMread),
        .Data_addr(address),
        .Data_in(data),
        .Data_out(MEM_result)
    );
endmodule