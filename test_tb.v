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

  // Testbench initialization
  initial begin
    // VCD Dump Configuration
    $dumpfile("Datapath_tb.vcd"); // Specify the VCD file name
    $dumpvars(0, Datapath_tb); // Dump all variables in Datapath_tb
    
    // Initialize inputs
    rst = 1;
    address = 15'h0000;

    // Apply reset
    #20;
    rst = 0; // Release reset
    #20;

    // Test Case 1: Write operation
    
    address = 15'h0001; // Test with specific address
    #20;
     // Disable write after write operation
    #20;
    
    // Test Case 2: Read operation to check for hit
    address = 15'h0001; // Access the same address to check hit
    #20;
    $display("Address: %h, Output Data: %h, Hit: %b", address, outData, hit); // Expecting a hit

    // Test Case 3: Access different address for miss
    address = 15'h0800; // New address to check for miss
    #20;
    $display("Address: %h, Output Data: %h, Hit: %b", address, outData, hit); // Expecting a miss

    // Test Case 4: Random address
    address = 15'h1234;
    #20;
    $display("Address: %h, Output Data: %h, Hit: %b", address, outData, hit);

    // End simulation
    $stop;
  end

endmodule