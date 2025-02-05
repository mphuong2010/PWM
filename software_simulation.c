#include <stdint.h>
#include <stdio.h>
#include "system.h"
#include "io.h"

#define PWM_CONTROL_REG      (*(volatile uint32_t *)(PWM_0_BASE + 0x00))
#define PWM_STATUS_REG       (*(volatile uint32_t *)(PWM_0_BASE + 0x04))
#define PWM_PERIOD_REG       (*(volatile uint32_t *)(PWM_0_BASE + 0x08))
#define PWM_DUTY_CYCLE_REG   (*(volatile uint32_t *)(PWM_0_BASE + 0x0C))
#define PWM_PRESCALER_REG    (*(volatile uint32_t *)(PWM_0_BASE + 0x10))

#define PWM_ENABLE           0x00000001

void pwm_config(uint16_t period, uint16_t duty_cycle, uint16_t prescaler) {
    PWM_PERIOD_REG = period;
    PWM_DUTY_CYCLE_REG = duty_cycle;
    PWM_PRESCALER_REG = prescaler;
}

void pwm_start() {
    PWM_CONTROL_REG = PWM_ENABLE;
}

void pwm_stop() {
    PWM_CONTROL_REG = 0x0;
}

uint32_t pwm_get_status() {
    return PWM_STATUS_REG;
}

int main() {
    pwm_config(100, 75, 1);
    pwm_start();
    pwm_stop();
    pwm_config(100, 50, 1);
    pwm_start();
    return 0;
}
