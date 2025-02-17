//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    
// Design Name: 
// Module Name:    driver 
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
module driver(
    input clk,
    input rst,
    // input [1:0] br_cfg,
    output iocs,
    output iorw,
    input rda,
    input tbr,
    output [1:0] ioaddr,
    inout [7:0] databus
    );

	logic start, finish;
	logic trmt;
	logic rx_rdy;
	logic [8:0] databus_driver;
	logic rst_n;
	logic iorw_reg;

	assign iorw = iorw_reg;

	logic clr_rx_rdy;

	assign rst_n = ~rst;

    typedef enum logic[1:0] {IDLE, TRANS, DONE} state_t;
	state_t state, nxt_state;

    // State machine for data reception
	always_ff @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		state<=IDLE;
	else
		state<= nxt_state;
    end

	assign ioaddr =	trmt ? 2'b00 : 
	finish ? 2'b10 : 2'b11;

	always_ff @(posedge clk, negedge rst_n) begin
		if(!rst_n)
			databus_driver <= 8'b0000_0000;
		else if(finish == 1'b1)
			databus_driver <= databus;

	end

	assign iocs = 1'b1;
// TODO: iorw set to 1 when driver receives data, vice versa
       always_comb begin
       		//default state
		trmt = 1'b0;
		clr_rx_rdy = 1'b0;
        finish = 1'b0;
		start = 1'b0;
		iorw_reg = 1'b0;

		case(state)
			TRANS: begin
				iorw_reg = 1;
				if(rda) begin
					trmt = 1'b1;
					clr_rx_rdy = 1'b1;
				end
				nxt_state = TRANS;
			end
			DONE: begin
				finish =1;
				nxt_state = TRANS;
			end
			default: begin
				start = 1;
				iorw_reg = 1;
				nxt_state = TRANS;
			end
		endcase
    
       end


endmodule
