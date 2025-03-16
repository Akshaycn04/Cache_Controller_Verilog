
module MMM #(parameter ADDR_SIZE = 15)(
    input clk,
    input reset,
    input [ADDR_SIZE-1:0] address_req,
    output reg [31:0] before_outData
);
    integer i;
    reg [31:0] dataArray [0:(1<<ADDR_SIZE)-1];

    // Initializing the dataArray
    initial begin
        for (i = 0; i < (1<<ADDR_SIZE); i = i + 1) begin
            dataArray[i] = i;
        end
    end

    // Update before_outData based on dataArray[address_req]
    always @(posedge clk) begin
        if (reset) begin
            before_outData <= 0;
        end else begin
            before_outData <= dataArray[address_req];
        end
    end
endmodule


