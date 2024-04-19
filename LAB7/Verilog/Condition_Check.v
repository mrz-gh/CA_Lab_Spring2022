module Condition_Check (
    cond, Status_Reg, 
    cond_check
);
    input [3:0] cond, Status_Reg;
    output reg cond_check;


    wire Z_SR, C, N, V;

    assign N = Status_Reg[3];
    assign Z_SR = Status_Reg[2];
    assign C = Status_Reg[1];
    assign V = Status_Reg[0];
    
    
    always @(cond, Status_Reg) begin
        cond_check = 0;
        case (cond)
            4'd0:
                cond_check = Z_SR;
            4'd1:
                cond_check = ~Z_SR;
            4'd2:
                cond_check = C;
            4'd3:
                cond_check = ~C;
            4'd4:
                cond_check = N;
            4'd5:
                cond_check = ~N;
            4'd6:
                cond_check = V;
            4'd7:
                cond_check = ~V;
            4'd8:
                cond_check = C & ~Z_SR;
            4'd9:
                cond_check = ~C & Z_SR;
            4'd10:
                cond_check = N == V;
            4'd11:
                cond_check = N != V;
            4'd12:
                cond_check = Z_SR == 0 & N == V;
            4'd13:
                cond_check = Z_SR == 1 | N != V;
            4'd14:
                cond_check = 1;
            default:
                cond_check = 1;
        endcase
    end


endmodule