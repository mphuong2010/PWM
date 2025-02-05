#include <stdint.h>
#include <stdio.h>
#include "system.h"
#include "io.h"
#include "altera_up_avalon_adc.h"

// PWM register definitions
#define PWM_CONTROL_REG      (*(volatile uint32_t *)(PWM_0_BASE + 0x00))
#define PWM_STATUS_REG       (*(volatile uint32_t *)(PWM_0_BASE + 0x04))
#define PWM_PERIOD_REG       (*(volatile uint32_t *)(PWM_0_BASE + 0x08))
#define PWM_DUTY_CYCLE_REG   (*(volatile uint32_t *)(PWM_0_BASE + 0x0C))
#define PWM_PRESCALER_REG    (*(volatile uint32_t *)(PWM_0_BASE + 0x10))

#define PWM_ENABLE           0x00000001

// Function to initialize PWM
void pwm_config(uint16_t period, uint16_t duty_cycle, uint16_t prescaler) {
    PWM_PERIOD_REG = period;
    PWM_DUTY_CYCLE_REG = duty_cycle;
    PWM_PRESCALER_REG = prescaler;
}

// Function to start PWM
void pwm_start() {
    PWM_CONTROL_REG = PWM_ENABLE;
}

// Function to stop PWM
void pwm_stop() {
    PWM_CONTROL_REG = 0x0;
}

// Delay function
void delay() {
    for (volatile int i = 0; i < 1000000; i++);
}

int main() {
    // Initialize PWM with default values
    pwm_config(100, 0, 50);  // period 100, duty cycle 0%, prescaler 1000
    pwm_start();

    // Create and initialize ADC device
    alt_up_adc_dev *adc;
    adc = alt_up_adc_open_dev(ADC_0_NAME);  // Open ADC device
    if (adc == NULL) {
        printf("Error: Unable to open ADC device.\n");
        return 1;
    }
    printf("ADC device initialized successfully.\n");

    uint16_t adc_value = 0;
    uint16_t duty_cycle = 0;

    while (1) {
        // Read ADC value from channel 0 (assuming potentiometer is connected to channel 0)
        adc_value = alt_up_adc_read(adc, 0);  // Read ADC value from channel 0

        // Scale ADC value to the PWM duty cycle (0-100%)
        duty_cycle = (adc_value * 100) / 4095;  // Scale ADC value to 0-100

        // Update PWM duty cycle based on ADC value
        pwm_config(100, duty_cycle, 50);  // Update PWM duty cycle
        pwm_start();

        // Print ADC value and duty cycle for debugging
        printf("ADC Value: %d, Duty Cycle: %d%%\n", adc_value, duty_cycle);

        // Add delay to slow down updates
        delay();
    }

    return 0;
}
