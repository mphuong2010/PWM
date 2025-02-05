module PWM_CORE(
    input           clk,
    input           reset,
    input   [15:0]  period,
    input   [15:0]  duty_cycle,
    input   [15:0]  prescaler,
    input           enable,
    output          pwm_running,
    output          pwm_out
);

////////////////////down clocking for pwm/timer///////////////////
wire    even_clk, odd_clk;
down_clocking_even down_clocking_even_0(
    clk,
    (!reset),
    {1'b0, prescaler[15:1]},
    even_clk
);
down_clocking_odd down_clocking_odd_0(
    clk,
    (!reset),
    {1'b0, prescaler[15:1]},
    odd_clk
);
wire    clk_div;
assign  clk_div = prescaler[0] ? odd_clk : even_clk;
///////////////////////////////////////////////////////

/////////////////main counter //////////////////////////
reg [15:0] counter;
wire [15:0] period_minus_1;

assign period_minus_1 = (period == 0) ? 0 : (period - 1);

assign pwm_running = enable;

assign pwm_out = (counter < duty_cycle) && enable;

always@(posedge clk_div or posedge reset)
    if(reset) begin
        counter <= 0;
    end
    else begin
        if(enable) begin
            if(counter >= period_minus_1) 
                counter <= 0;
            else 
                counter <= counter + 1;
        end
    end

//////////////////////////////////////////////////////////

endmodule