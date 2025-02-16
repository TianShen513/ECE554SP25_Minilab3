// Test bench for UART Receiver
module lab1_spart_tb;
    logic clk;
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    logic [3:0]  KEY;
    logic [9:0]  LEDR;
    logic [9:0]  SW;
    logic [35:0] GPIO;

    reg [7:0] tx_data;  // Changed from 'byte' (reserved keyword)

    // Instantiate DUT - changed module name (should match your actual design module)
    lab1_spart iDut(
        //////////// CLOCK //////////
        .CLOCK_50(clk),
        .CLOCK2_50(),
        .CLOCK3_50(),
        .CLOCK4_50(),

        //////////// SEG7 //////////
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5),

        //////////// KEY //////////
        .KEY(KEY),

        //////////// LED //////////
        .LEDR(LEDR),

        //////////// SW //////////
        .SW(SW),

        //////////// GPIO //////////
        .GPIO(GPIO)
    );

    // Task declaration moved outside initial block
    task transmit_byte(input [7:0] bytes);
        integer j;
        begin
            // Simulate start bit (low) on GPIO[5]
            GPIO[5] = 0;          // Assuming RX is connected to GPIO[5]
             #26042; // 26041.67 ns for 38400 baud rate            // 4800 baud period (1/4800 * 1e9 = 208333.33ns)

            // Simulate data bits
            for (j = 0; j < 8; j = j + 1) begin
                GPIO[5] = bytes[j];
                #26042; // 26041.67 ns for 38400 baud rate
            end

            // Simulate stop bit (high)
            GPIO[5] = 1;
          #26042; // 26041.67 ns for 38400 baud rate
        end
    endtask

    initial begin
        // Initialize inputs
        SW = 10'b0;               // Fixed syntax (was 0')
        SW[9:8] = 2'b11;
        clk = 1'b0;
        KEY = 4'b0;               // Fixed syntax (was 0')
        KEY[0] = 0;               // rst_n
        GPIO[5] = 1'b1;           // Idle state

        // Reset sequence
        @(negedge clk);
        @(negedge clk);
        KEY[0] = 1;               // Assert reset
        @(negedge clk);
        @(negedge clk);
        KEY[0] = 0;               // Release reset
        @(negedge clk);
        KEY[0] = 1;   
        // Transmit test data
        tx_data = 8'b1111_0000;   // Changed variable name
        transmit_byte(tx_data);

        // Add more test cases if needed
        // ...

        // End simulation
        #1000000 $finish;
    end

    // Clock generation
    always #10 clk = ~clk;         // 100MHz clock (10ns period)
endmodule