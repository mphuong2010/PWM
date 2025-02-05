`timescale 1ns / 1ps

module PWM_WRAPPER_tb;

    // Inputs
    reg clk;
    reg reset;
    reg chipselect;
    reg write;
    reg read;
    reg [2:0] address;
    reg [31:0] writedata;

    // Outputs
    wire [31:0] readdata;
    wire pwm_out;

    wire [15:0] pwm_core_counter;
    wire pwm_core_clk_div;
    wire pwm_core_even_clk;
    wire pwm_core_odd_clk;
    wire [15:0] pwm_core_period_minus_1;
    wire [15:0] pwm_core_duty_cycle;
    wire [15:0] pwm_core_prescaler;
    wire [15:0] pwm_core_period;
    wire pwm_core_enable;   
    wire pwm_core_pwm_running;
    wire pwm_core_pwm_out;



    // Instantiate the Unit Under Test (UUT)
    PWM_WRAPPER uut (
        .clk(clk), 
        .reset(reset), 
        .chipselect(chipselect), 
        .write(write), 
        .read(read), 
        .address(address), 
        .writedata(writedata), 
        .readdata(readdata), 
        .pwm_out(pwm_out)
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

        // Wait for global reset to finish
        #100;
        reset = 0;

        // Test Case 1: Write to period register
        #10;
        chipselect = 1;
        write = 1;
        address = 3'd2;
        writedata = 32'd100; // Set period to 256
        #10;
        write = 0;
        chipselect = 0;

        // Test Case 2: Write to duty cycle register
        #10;
        chipselect = 1;
        write = 1;
        address = 3'd3;
        writedata = 32'd75; // Set duty cycle to 75
        #10;
        write = 0;
        chipselect = 0;

        // Test Case 3: Write to divisor register
        #10;
        chipselect = 1;
        write = 1;
        address = 3'd4;
        writedata = 32'd1; // Set divisor to 16
        #10;
        write = 0;
        chipselect = 0;

        // Test Case 4: Write to control register to enable PWM
        #10;
        chipselect = 1;
        write = 1;
        address = 3'd0;
        writedata = 32'h00000001; // Enable PWM
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
        #20000;
        $finish;

        
    end

    // Clock generation
    always #5 clk = ~clk;


    assign pwm_core_counter = uut.core_inst.counter;
    assign pwm_core_clk_div = uut.core_inst.clk_div;
    assign pwm_core_even_clk = uut.core_inst.even_clk;
    assign pwm_core_odd_clk = uut.core_inst.odd_clk;
    assign pwm_core_period_minus_1 = uut.core_inst.period_minus_1;
    assign pwm_core_duty_cycle = uut.core_inst.duty_cycle;
    assign pwm_core_prescaler = uut.core_inst.prescaler;
    assign pwm_core_period = uut.csr_inst.period_reg;
    assign pwm_core_enable = uut.csr_inst.control_reg[0];
    assign pwm_core_pwm_running = uut.core_inst.pwm_running;

endmodule