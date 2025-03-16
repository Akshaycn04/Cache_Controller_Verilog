module MainMemory #(parameter addr = 15)(
    input clk,
    input reset, 
    input hit,
    input [14:0] address_req,      // Address input
    output reg [31:0] outData,      // Output data
    output reg hit_delayed,
    output reg [14:0] address_req_delayed
);

    reg [31:0] dataArray [0:(1<<addr)-1];    // Declare data array
    reg [31:0] d0, d1, d2, d3;
    reg h0, h1, h2, h3, h4;
    reg [14:0] a0, a1, a2, a3, a4;    // Intermediate concatenated data
    wire [31:0] before_outData;       // Wire to receive data from DataInitializer

    // Instantiate DataInitializer module to initialize dataArray and update before_outData
    MMM #(addr) data_init(
        .clk(clk),
        .reset(reset),
        .address_req(address_req),
        .before_outData(before_outData)
        //.dataArray(dataArray)
    );

    always @(posedge clk) begin
        if (reset) begin
            d0 <= 0; h0 <= 1; a0 <= 0;
            d1 <= 0; h1 <= 1; a1 <= 0;
            d2 <= 0; h2 <= 1; a2 <= 0;
            d3 <= 0; h3 <= 1; a3 <= 0;
            outData <= 0; h4 <= 1; a4 <= 0;
            hit_delayed <= 1; address_req_delayed <= 0;
        end else begin      
            d0 <= before_outData; h0 <= hit; a0 <= address_req;
            d1 <= d0; h1 <= h0; a1 <= a0;
            d2 <= d1; h2 <= h1; a2 <= a1;
            d3 <= d2; h3 <= h2; a3 <= a2;
            outData <= d3; h4 <= h3; a4 <= a3;
            hit_delayed <= h4; address_req_delayed <= a4;
        end
    end
endmodule // MainMemory
