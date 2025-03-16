module Datapath(
    input clk,                     // Clock input
    input rst,                    // Write enable signal
    input [14:0] address,          // Address input
    output hit,                    // Hit output
    output [31:0] outData          // Output data
);

    wire [31:0] memOut; 
    wire[14:0] address_req,address_req_delayed; 
    wire hit_delayed;
              // Intermediate memory output

    // Instantiate Cache
    Cache uut (
    clk,rst,address,memOut,address_req_delayed,hit_delayed,address_req,hit,outData
    );

    // Instantiate MainMemory
    MainMemory MM (
    clk,rst,hit,address_req,memOut,hit_delayed,address_req_delayed
    );

endmodule // Datapath
