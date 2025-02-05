module top_pwm
( 
input CLOCK_50, 
input [0:0] KEY,

input ADC_DOUT, // Digital data input
output ADC_CONVST, // Conversion Start
output ADC_DIN, // Digital data output
output ADC_SCLK, // Digital clock input

output [0:0] LEDR // output signal for PWM
);   

system nios_system( 

.clk_clk (CLOCK_50), 
.reset_reset_n (KEY[0]), 
.adc_0_external_interface_sclk(ADC_SCLK), // adc_0_external_interface.sclk
.adc_0_external_interface_cs_n(ADC_CONVST), //                         .cs_n
.adc_0_external_interface_dout(ADC_DOUT), //                         .dout
.adc_0_external_interface_din(ADC_DIN),  //   
.pwm_0_conduit_end_export (LEDR) 
); 
endmodule 