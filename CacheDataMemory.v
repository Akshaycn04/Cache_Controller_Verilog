module Memory #(
    parameter DATA_WIDTH = 32,
    parameter DEPTH = 1024,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input clk,                           // Clock input
    input wrEn,                          // Write enable signal
    input [ADDR_WIDTH-1:0] waddress,      // Address input
    input [ADDR_WIDTH-1:0] raddress,      // Address input
    input [DATA_WIDTH-1:0] inData,       // Input data
    output reg [DATA_WIDTH-1:0] outData  // Output data
);

    // Declare data array
    reg [DATA_WIDTH-1:0] dataArray [0:DEPTH-1]; 
    
    // Initialize memory to zero
    integer i; 
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            dataArray[i] = 0;
        end
    end

    always @(posedge clk) begin
        if (wrEn)
            dataArray[waddress] <= inData;
    end
    
    always @(posedge clk) begin
        outData <= dataArray[raddress];
    end
    
endmodule // Memory
