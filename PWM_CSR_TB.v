`timescale 1ns / 1ps

module PWM_CSR_tb;

    // Inputs
    reg clk;
    reg reset;
    reg chipselect;
    reg write;
    reg read;
    reg [2:0] address;
    reg [31:0] writedata;
    reg pwm_running;

    // Outputs
    wire [31:0] readdata;
    wire enable;
    wire [15:0] period;
    wire [15:0] duty_cycle;
    wire [15:0] divisor;

    // Instantiate the Unit Under Test (UUT)
    PWM_CSR uut (
        .clk(clk), 
        .reset(reset), 
        .chipselect(chipselect), 
        .write(write), 
        .read(read), 
        .address(address), 
        .writedata(writedata), 
        .readdata(readdata), 
        .enable(enable), 
        .period(period), 
        .duty_cycle(duty_cycle), 
        .divisor(divisor), 
        .pwm_running(pwm_running)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        chipselect = 0;
        write = 0;
        read = 0;
        address = 0;
        writedata = 0;
        pwm_running = 0;

        // Wait for global reset to finish
        #15;
        reset = 0;

        // Test Case 1: Write to control register
        #10;
        chipselect = 1;
        write = 1;
        address = 3'd0;
        writedata = 32'h00000001; // Enable PWM
        #10;
        write = 0;
        chipselect = 0;

        // Test Case 2: Write to period register
        #10;
        chipselect = 1;
        write = 1;
        address = 3'd2;
        writedata = 32'h00000100; // Set period to 256
        #10;
        write = 0;
        chipselect = 0;

        // Test Case 3: Write to duty cycle register
        #10;
        chipselect = 1;
        write = 1;
        address = 3'd3;
        writedata = 32'h00000080; // Set duty cycle to 128
        #10;
        write = 0;
        chipselect = 0;

        // Test Case 4: Write to divisor register
        #10;
        chipselect = 1;
        write = 1;
        address = 3'd4;
        writedata = 32'h00000010; // Set divisor to 16
        #10;
        write = 0;
        chipselect = 0;

        // Test Case 5: Read from control register
        #10;
        chipselect = 1;
        read = 1;
        address = 3'd0;
        #10;
        read = 0;
        chipselect = 0;

        // Test Case 6: Read from status register
        #10;
        chipselect = 1;
        read = 1;
        address = 3'd1;
        pwm_running = 1; // Set PWM running status
        #10;
        read = 0;
        chipselect = 0;

        // Test Case 7: Read from period register
        #10;
        chipselect = 1;
        read = 1;
        address = 3'd2;
        #10;
        read = 0;
        chipselect = 0;

        // Test Case 8: Read from duty cycle register
        #10;
        chipselect = 1;
        read = 1;
        address = 3'd3;
        #10;
        read = 0;
        chipselect = 0;

        // Test Case 9: Read from divisor register
        #10;
        chipselect = 1;
        read = 1;
        address = 3'd4;
        #10;
        read = 0;
        chipselect = 0;

        // Finish simulation
        #100;
        $finish;
    end

    // Clock generation
    always #5 clk = ~clk;

endmodule