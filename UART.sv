module UART(clk,rst_n,RX,TX,rx_rdy,clr_rx_rdy,rx_data,trmt,tx_data,tx_done, baud_goal);

	input clk,rst_n;			// clock and active low reset
	input RX,trmt;
	input [13 :0] baud_goal;				// strt_tx tells TX section to transmit tx_data
	input clr_rx_rdy;			// rx_rdy can be cleared by this or new start bit
	input [7:0] tx_data;		// byte to transmit
	output TX,rx_rdy,tx_done;	// rx_rdy asserted when byte received,
								// tx_done asserted when tranmission complete
	output [7:0] rx_data;		// byte received

	//////////////////////////////
	// Instantiate Transmitter //
	////////////////////////////
	UART_tx iTX(.clk(clk), .rst_n(rst_n), .TX(TX), .trmt(trmt),
			.tx_data(tx_data), .tx_done(tx_done), .baud_goal(baud_goal));
			

	///////////////////////////
	// Instantiate Receiver //
	/////////////////////////
	UART_rx iRX(.clk(clk), .rst_n(rst_n), .RX(RX), .rdy(rx_rdy),
				.clr_rdy(clr_rx_rdy), .rx_data(rx_data), .baud_goal(baud_goal));

endmodule