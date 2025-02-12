//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:   
// Design Name: 
// Module Name:    spart 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module spart(
    input clk,
    input rst,
    input [1:0] br_cfg,
    input iocs,
    input iorw,
    output rda,
    output tbr,
    input [1:0] ioaddr,
    inout [7:0] databus,
    output txd,
    input rxd
    );

    // rda: Receive Data Available - Indicates that a byte of data has
//been received and is ready to be read from the SPART to the
//Processor

    logic [7:0] rx_data, tx_data;
    logic clr_rx_rdy, rx_rdy;
    logic trmt;
    logic tx_done;
    logic [7:0] databus_reg;

    logic [11:0] baud_goal;

    logic finish;

    assign baud_goal = br_cfg == 2'b00 ? 12'd5208 :
                                  2'b01 ?  12'd2604:
                                  2'b10 ?  12'd1302 :
                                  2'b11 ?  12'd651 : 12'd5208;

    assign tbr = ioaddr == 2'b00 ? 1'b1 : 1'b0;
    assign rda = rx_rdy;

    assign trmt = tbr;
    assign clr_rx_rdy = 1'b1;

    UART uart_bottom( .clk(clk), .rst_n(~rst), .RX(rxd), .TX(txd), 
    .rx_rdy(rx_rdy) , .clr_rx_rdy(clr_rx_rdy), .rx_data(rx_data), 
    .trmt(trmt), .tx_data(tx_data), .tx_done(tx_done), .baud_goal(baud_goal));

    // from the processor to the spart
    assign tx_data = ~iorw ? databus_reg : 8'b0000_0000;
    assign databus_reg = (iorw & rda) ? rx_data : 8'b0000_0000; 
    
    assign databus = iocs ? databus_reg : 8'bzzzz_zzzz;

 



endmodule
