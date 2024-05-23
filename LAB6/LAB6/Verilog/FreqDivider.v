module FreqDivider (
    in,
    out,
    rst
);
    input in, rst;
    output out;
    reg counter;
    assign out = counter;
    always @(posedge in) begin
        if(rst)
            counter <= 1'b0;
        else
            counter <= counter + 1;
    end
endmodule