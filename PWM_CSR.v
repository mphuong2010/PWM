module PWM_CSR(
    //clock, reset
    input           clk,
    input           reset,
    //avalon interface
    input           chipselect,
    input           write,
    input           read,
    input   [2:0]   address,
    input   [31:0]  writedata,
    output  [31:0]  readdata,
    //control signals
    output          enable,
    output  [15:0]  period,
    output  [15:0]  duty_cycle,
    output  [15:0]  prescaler,
    //status signals
    input           pwm_running
);

parameter   ADDR_CONTROL=3'd0,
            ADDR_STATUS=3'd1,
            ADDR_PERIOD=3'd2,
            ADDR_DUTY_CYCLE=3'd3,
            ADDR_DIVISOR=3'd4;

reg [31:0]  data_reg;

// Internal registers
reg [31:0]  control_reg;
reg [31:0]  status_reg;
reg [15:0]  period_reg;
reg [15:0]  duty_cycle_reg;
reg [15:0]  divisor_reg;

assign enable = control_reg[0];
assign period = period_reg;
assign duty_cycle = duty_cycle_reg;
assign prescaler = divisor_reg;

assign readdata = data_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        control_reg <= 32'h0;
        period_reg <= 16'h0;
        duty_cycle_reg <= 16'h0;
        divisor_reg <= 16'h0;
    end else if (chipselect & write) begin
        case (address)
            ADDR_CONTROL:    control_reg        <= writedata;
            ADDR_PERIOD:     period_reg         <= writedata[15:0];
            ADDR_DUTY_CYCLE: duty_cycle_reg     <= writedata[15:0];
            ADDR_DIVISOR:    divisor_reg        <= writedata[15:0];
        endcase
    end else begin
        control_reg     <= control_reg;
        period_reg      <= period_reg;
        duty_cycle_reg  <= duty_cycle_reg;
        divisor_reg     <= divisor_reg;
    end
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_reg <= 32'h0;
    end else if (chipselect & read) begin
        case (address)
            ADDR_CONTROL:   data_reg <= control_reg;
            ADDR_STATUS:    data_reg <= {31'h0, pwm_running};
            ADDR_PERIOD:    data_reg <= {16'h0, period_reg};
            ADDR_DUTY_CYCLE:data_reg <= {16'h0, duty_cycle_reg};
            ADDR_DIVISOR:   data_reg <= {16'h0, divisor_reg};
            default:        data_reg <= 32'h0;
        endcase
    end else begin
        data_reg <= data_reg;
    end
end

endmodule