module Datapath_tb;

  // Inputs to the Datapath module
  reg clk;
  reg rst;
  reg [14:0] address;

  // Outputs from the Datapath module
  wire hit;
  wire [31:0] outData;

  // Instantiate the Datapath module
  Datapath uut (
    .clk(clk),
    .rst(rst),
    .address(address),
    .hit(hit),
    .outData(outData)
  );

  // Clock generation (50 MHz clock, 20 ns period)
  initial clk = 1;
  always #10 clk = ~clk;

  // Toggle Coverage Enhancement Initialization
  initial begin
    integer i;
    // VCD Dump Configuration
    //$dumpfile("Datapath_tb.vcd");
    //$dumpvars(0, Datapath_tb);

    // Initial reset and address initialization
    rst = 1;
    address = 15'h0000;
    #20;
    rst = 0; // Release reset
    #20;

    // Toggle Reset Multiple Times
    for (i = 0; i < 3; i = i + 1) begin
      rst = 1; #10;
      rst = 0; #10;
    end

    // Sequential Addressing to Maximize Cache Behavior
    for (address = 15'h0000; address < 15'h0020; address = address + 1) begin
      #20;
      $display("Sequential Access - Address: %h, Output Data: %h, Hit: %b", address, outData, hit);
    end

    // Alternating High and Low Addresses to Ensure Toggle Coverage
    address = 15'h0000; #20;
    address = 15'h7FFF; #20;
    address = 15'h0001; #20;
    address = 15'h7FFE; #20;
    address = 15'h3FFF; #20;

    // Extended Strided Access with Boundary Variations
    for (address = 15'h0010; address < 15'h0030; address = address + 2) begin
      #20;
      $display("Extended Stride - Address: %h, Output Data: %h, Hit: %b", address, outData, hit);
    end

    // Random Address Access for Toggle Coverage
    address = 15'h0123; #20;
    address = 15'h0456; #20;
    address = 15'h0789; #20;
    address = 15'h0101; #20;
    address = 15'h0321; #20;
    address = 15'h0654; #20;

    // Strided Access Pattern to Test Cache Thrashing with Repeats
    for (address = 15'h1000; address < 15'h1020; address = address + 4) begin
      #20;
      $display("Thrashing Stride - Address: %h, Output Data: %h, Hit: %b", address, outData, hit);
    end

    // Sequential Reset with Cache Access to Increase Reset Toggle Coverage
    rst = 1; #10; rst = 0; #20;
    address = 15'h2000; #20;
    rst = 1; #10; rst = 0; #20;
    address = 15'h2001; #20;
    rst = 1; #10; rst = 0; #20;
    address = 15'h2002; #20;

    // Repeated Access Pattern for Cache Hits
    address = 15'h3001; #20;
    address = 15'h3001; #20;
    address = 15'h3001; #20;
    $display("Repeated Access for Hit - Address: %h, Output Data: %h, Hit: %b", address, outData, hit);

    // Access Range of Addresses Covering Different Cache Sets
    for (address = 15'h4000; address < 15'h4010; address = address + 2) begin
      #20;
      $display("Cache Set Coverage - Address: %h, Output Data: %h, Hit: %b", address, outData, hit);
    end

    // Edge Wrapping and Boundaries with Mixed Patterns
    address = 15'h7FFE; #20;
    address = 15'h0002; #20;
    address = 15'h3FFF; #20;
    address = 15'h7FFF; #20;
    address = 15'h0001; #20;

    // Extended Random Pattern to Increase Toggle Variability
    address = 15'h1ACE; #20;
    address = 15'h1ABC; #20;
    address = 15'h1234; #20;
    address = 15'h4321; #20;

    // End simulation after enhanced toggle coverage tests
    $stop;
  end
endmodule
