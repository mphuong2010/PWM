module PWM_WRAPPER(
    input           clk,
    input           reset,
    input           chipselect,
    input           write,
    input           read,
    input   [2:0]   address,
    input   [31:0]  writedata,
    output  [31:0]  readdata,
    output          pwm_out
);

wire        enable;
wire [15:0] period;
wire [15:0] duty_cycle;
wire [15:0] prescaler;
wire        pwm_running;

PWM_CSR csr_inst (
    .clk            (clk),
    .reset          (reset),
    .chipselect     (chipselect),
    .write          (write),
    .read           (read),
    .address        (address),
    .writedata      (writedata),
    .readdata       (readdata),
    .enable         (enable),
    .period         (period),
    .duty_cycle     (duty_cycle),
    .prescaler      (prescaler),
    .pwm_running    (pwm_running)
);

PWM_CORE core_inst (
    .clk            (clk),
    .reset          (reset),
    .period         (period),
    .duty_cycle     (duty_cycle),
    .prescaler      (prescaler),
    .enable         (enable),
    .pwm_running    (pwm_running),
    .pwm_out        (pwm_out)
);

endmodule