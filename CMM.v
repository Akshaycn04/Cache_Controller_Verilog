module CMM(
    input clk,
    input [3:0] wrEna,                  // Write enable for each memory section
    input [9:0] waddress,               // Write address
    input [9:0] raddress,               // Read address
    input [35:0] inData,                // Input data (1 valid bit + 3 tag bits + 32 data bits)
    output isValid0, isValid1, isValid2, isValid3,
    output [2:0] tagOut0, tagOut1, tagOut2, tagOut3,
    output [31:0] CDMOut0, CDMOut1, CDMOut2, CDMOut3
);

    // Instantiate each memory section
    Memory #(.DATA_WIDTH(32+3+1), .DEPTH(1024)) CDM00 (
        .clk(clk), 
        .wrEn(wrEna[0]), 
        .waddress(waddress), 
        .raddress(raddress),
        .inData(inData), 
        .outData({isValid0, tagOut0, CDMOut0})
    );

    Memory #(.DATA_WIDTH(32+3+1), .DEPTH(1024)) CDM01 (
        .clk(clk), 
        .wrEn(wrEna[1]), 
        .waddress(waddress), 
        .raddress(raddress),
        .inData(inData), 
        .outData({isValid1, tagOut1, CDMOut1})
    );

    Memory #(.DATA_WIDTH(32+3+1), .DEPTH(1024)) CDM10 (
        .clk(clk), 
        .wrEn(wrEna[2]), 
        .waddress(waddress), 
        .raddress(raddress),
        .inData(inData), 
        .outData({isValid2, tagOut2, CDMOut2})
    );

    Memory #(.DATA_WIDTH(32+3+1), .DEPTH(1024)) CDM11 (
        .clk(clk), 
        .wrEn(wrEna[3]), 
        .waddress(waddress), 
        .raddress(raddress),
        .inData(inData), 
        .outData({isValid3, tagOut3, CDMOut3})
    );

endmodule
