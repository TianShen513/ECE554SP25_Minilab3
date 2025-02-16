//////////////////////////////////////////////////////////////////////////////////
// Company: UW-Madison
// Engineer: Tianqi Shen
// 
// Create Date:   
// Design Name: 
// Module Name:    spart 
// Project Name: ECE 554
// Target Devices: Altera DE1
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

    logic [13:0] baud_goal;

    logic finish;

    logic rst_n;

    assign rst_n = ~rst;

 assign baud_goal = (br_cfg == 2'b00) ? 14'd10416 :
                   (br_cfg == 2'b01) ? 14'd5208  :
                   (br_cfg == 2'b10) ? 14'd2604  :
                   (br_cfg == 2'b11) ? 14'd1302  : 14'd10416;

    assign tbr = ioaddr == 2'b00 ? 1'b1 : 1'b0;
    assign rda = rx_rdy;

    assign trmt = tbr;
    assign clr_rx_rdy = ioaddr == 2'b00;

    UART uart_bottom( .clk(clk), .rst_n(rst_n), .RX(rxd), .TX(txd), 
    .rx_rdy(rx_rdy) , .clr_rx_rdy(clr_rx_rdy), .rx_data(rx_data), 
    .trmt(trmt), .tx_data(tx_data), .tx_done(tx_done), .baud_goal(baud_goal));

    // from the processor to the spart
    //assign tx_data = (ioaddr == 2'b00)? databus_reg : 8'b0000_0000;

   always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        tx_data <= 8'b0000_0000; // Reset value
    end else if (iorw)begin
        tx_data <=  rx_data;
    end
    end

//     always_comb begin
//     databus_reg = 8'b0000_0000;  // Default value
//     if (rda) begin
//         databus_reg = rx_data;   // Override if rda is asserted
//     end
// end

    always_ff @(posedge clk or negedge rst_n) begin

    if (!rst_n) begin
        databus_reg <= 8'b0000_0000; // Reset value
    end else if (rda) begin
        databus_reg <=  rx_data;
    end
    end
    
    assign databus = iocs ? databus_reg : 8'bzzzz_zzzz;

 



endmodule
