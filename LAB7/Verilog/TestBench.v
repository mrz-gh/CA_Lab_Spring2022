`timescale 1ns/1ns
module testbench;

  // Inputs
  reg CLOCK_50 = 0;
  reg [17:0] SW;
  wire [15:0] SRAM_DQ;
  wire [17:0] SRAM_ADDR;
  wire SRAM_UB_N;
  wire SRAM_LB_N;
  wire SRAM_WE_N;
  wire SRAM_CE_N;
  wire SRAM_OE_N;

  // Instantiate ARM module
  ARM dut (
    .CLOCK_50(CLOCK_50),
    .SW(SW),
    .SRAM_DQ(SRAM_DQ),
		.SRAM_ADDR(SRAM_ADDR),
		.SRAM_UB_N(SRAM_UB_N),
		.SRAM_LB_N(SRAM_LB_N),
		.SRAM_WE_N(SRAM_WE_N),
		.SRAM_CE_N(SRAM_CE_N),
		.SRAM_OE_N(SRAM_OE_N)
  );
  SRAM sram(
		.clk(CLOCK_50),
		.rst(SW[17]),
		.SRAM_DQ(SRAM_DQ),
		.SRAM_ADDR(SRAM_ADDR),
		.SRAM_UB_N(SRAM_UB_N),
		.SRAM_LB_N(SRAM_LB_N),
		.SRAM_WE_N(SRAM_WE_N),
		.SRAM_CE_N(SRAM_CE_N),
		.SRAM_OE_N(SRAM_OE_N)
	);

  // Clock generator
  always #5 CLOCK_50 = ~CLOCK_50;
  

  // Reset generator
  initial begin
    SW[17] = 1;
    SW[16] = 1; //Forward
    #10 SW[17] = 0;
  end

  initial begin
    $dumpfile("Waveforms.vcd");
    $dumpvars(0, dut.DS, dut.DR);
  end


  // Test inputs
  initial begin

    #10000 $stop;
  end



endmodule
