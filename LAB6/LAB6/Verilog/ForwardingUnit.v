module ForwardingUnit (
    src1, 
    src2,
    Dest_ER,
    Dest_MR, 

    WB_EN_MR,
    WB_EN_ER,
    sel_src1,
    sel_src2
);

    input [3:0] src1; 
    input [3:0] src2;
    input [3:0] Dest_ER, Dest_MR;
    input WB_EN_ER, WB_EN_MR;
    output [1:0] sel_src1;
    output [1:0] sel_src2;


    assign sel_src1 =   ((src1 == Dest_ER) && (WB_EN_ER == 1'b1)) ? 2'b01 :
                        ((src1 == Dest_MR) && (WB_EN_MR == 1'b1)) ? 2'b10 : 2'b00;

                        
    assign sel_src2 =   ((src2 == Dest_ER) && (WB_EN_ER == 1'b1)) ? 2'b01 :
                        ((src2 == Dest_MR) && (WB_EN_MR == 1'b1)) ? 2'b10 : 2'b00;
    
    
endmodule