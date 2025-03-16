module Cache(
    input clk,                     // Clock input
    input rst,                     // Reset signal
    input [14:0] address,          // Address input
    input [31:0] inData,
    input [14:0] address_req_delayed,
    input hit_delayed,
    output reg [14:0] address_req, // Input data
    output reg hit,                // Hit signal
    output [31:0] outData          // Output data
);

    // Separate wires for each memory section output
    wire [31:0] CDMOut0, CDMOut1, CDMOut2, CDMOut3;
    wire [2:0] tagOut0, tagOut1, tagOut2, tagOut3;
    wire isValid0, isValid1, isValid2, isValid3;

    // Signals for selected section
    reg isValid_selected;
    reg [2:0] tagOut_selected;
    reg [31:0] CDMOut_selected;

    // Write enable signals for each cache memory section
    reg [3:0] wrEna;
    always @(*) begin
        case (address_req_delayed[11:10])
            2'b00: wrEna = 4'b0001 & {4{~hit_delayed}};
            2'b01: wrEna = 4'b0010 & {4{~hit_delayed}};
            2'b10: wrEna = 4'b0100 & {4{~hit_delayed}};
            2'b11: wrEna = 4'b1000 & {4{~hit_delayed}};
        endcase
    end

    // Instantiate the CacheMemory module
    CMM cacheMemory (
        .clk(clk),
        .wrEna(wrEna),
        .waddress(address[9:0]),
        .raddress(address_req_delayed[9:0]),
        .inData({1'b1, address[14:12], inData}),
        .isValid0(isValid0),
        .isValid1(isValid1),
        .isValid2(isValid2),
        .isValid3(isValid3),
        .tagOut0(tagOut0),
        .tagOut1(tagOut1),
        .tagOut2(tagOut2),
        .tagOut3(tagOut3),
        .CDMOut0(CDMOut0),
        .CDMOut1(CDMOut1),
        .CDMOut2(CDMOut2),
        .CDMOut3(CDMOut3)
    );

    // Select the appropriate cache memory section based on the address
    always @(*) begin
        case (address[11:10])
            2'b00: {isValid_selected, tagOut_selected, CDMOut_selected} = {isValid0, tagOut0, CDMOut0};
            2'b01: {isValid_selected, tagOut_selected, CDMOut_selected} = {isValid1, tagOut1, CDMOut1};
            2'b10: {isValid_selected, tagOut_selected, CDMOut_selected} = {isValid2, tagOut2, CDMOut2};
            2'b11: {isValid_selected, tagOut_selected, CDMOut_selected} = {isValid3, tagOut3, CDMOut3};
        endcase
    end

    // Hit logic
    always @(*) begin
        hit = isValid_selected & (tagOut_selected == address[14:12]);
    end

    // Register the address_req on the positive edge of the clock
    always @(posedge clk) begin
        if (rst) begin
            address_req <= 0;
        end 
        else begin 
            address_req <= address;
        end
    end

    // Output data based on hit or delayed hit
    assign outData = ((address == address_req_delayed) & ~hit_delayed) ? inData : CDMOut_selected;

endmodule
