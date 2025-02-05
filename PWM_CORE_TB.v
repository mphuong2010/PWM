`timescale 1ns / 1ps

module PWM_CORE_tb;

    // Inputs
    reg clk;
    reg reset;
    reg [15:0] period;
    reg [15:0] duty_cycle;
    reg [15:0] prescaler;
    reg enable;

    // Outputs
    wire pwm_out;

    wire clk_div;
    // wire even_clk;
    // wire odd_clk;
    wire [15:0] period_minus_1;
    wire [15:0] counter;



    // Instantiate the Unit Under Test (UUT)
    PWM_CORE uut (
        .clk(clk), 
        .reset(reset), 
        .period(period), 
        .duty_cycle(duty_cycle), 
        .prescaler(prescaler), 
        .enable(enable), 
        .pwm_out(pwm_out)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        period = 16'd100;
        duty_cycle = 16'd50;
        prescaler = 16'd1;
        enable = 0;

        // Wait for global reset to finish
        #100;
        reset = 0;

        // Test Case 1: Basic PWM operation
        enable = 1; // Start PWM
        // Test Case 2: Change duty cycle
        #20000;
        duty_cycle = 16'd75;

        // Test Case 3: Change period
        #20000;
        period = 16'd200;

        // Test Case 4: change prescaler
        #20000;
        prescaler = 16'd2;

        // Test Case 5: change prescaler
        #20000;
        prescaler = 16'd3;
        // Test Case 6: Reset
        #100;
        reset = 1;
        #100;
        reset = 0;
        // Test Case 7: Disable PWM
        #20000;
        enable = 0;

        // Finish simulation
        #2000;
        $finish;
    end

    // Clock generation
    always #5 clk = ~clk;

    assign clk_div = uut.clk_div;
    // assign even_clk = uut.even_clk;
    // assign odd_clk = uut.odd_clk;
    assign period_minus_1 = uut.period_minus_1;
    assign counter = uut.counter;

endmodule