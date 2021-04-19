#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <error.h>
#include <stdint.h>
#include <sys/mman.h>
#include "../hps_0.h"

// The start address and length of the Lightweight bridge
#define HPS_TO_FPGA_LW_BASE 0xFF200000
#define HPS_TO_FPGA_LW_SPAN 0x0020000

int main(int argc, char ** argv)
{
    void * lw_bridge_map = 0;
    uint32_t * pwm_avalon_bridge_map = 0;
    int devmem_fd = 0;
    int result = 0;
    int duty = 0;
    // int max_pwm = 250; // Value that makes a 100% duty cycle in the PWM.
    // int time_steps = 5000; // Time between steps. (in us)

    // Check to make sure they entered a valid input value
    if(argc != 2)
    {
        printf("Please enter only one argument that specifies the number of step for the PWM sweep.\n");
        exit(EXIT_FAILURE);
    }
    // Get the steps from the PWM sweep from the passed in arguments
    duty = atoi(argv[1]);

    // Open up the /dev/mem device (aka, RAM)
    devmem_fd = open("/dev/mem", O_RDWR | O_SYNC);
    if(devmem_fd < 0)
    {
        perror("devmem open");
        exit(EXIT_FAILURE);
    }

    // mmap() the entire address space of the Lightweight bridge so we can access our custom module 
    lw_bridge_map = (uint32_t*)mmap(NULL, HPS_TO_FPGA_LW_SPAN, PROT_READ|PROT_WRITE, MAP_SHARED, devmem_fd, HPS_TO_FPGA_LW_BASE); 
    if(lw_bridge_map == MAP_FAILED)
    {
        perror("devmem mmap");
        close(devmem_fd);
        exit(EXIT_FAILURE);
    }

    // Set the custom_pwm_map to the correct offset within the RAM (CUSTOM_PWM_0_BASE is from "hps_0.h")
    pwm_avalon_bridge_map = (uint32_t*)(lw_bridge_map + PWM_AVALON_BRIDGE_0_BASE);
    printf("The duty cycle selected is: %d\n", duty);
    // Change PWM
    // printf("Changing PWM from 0 to 100 and back to 0...\n");
    
    // *custom_pwm_map = 125;
    // // Wait 2 seconds
    // usleep(20000s00);

    // printf(" Sweep Up...\n");
    // for(int i = 0; i < steps+1; ++i)
    // {
    //     *custom_pwm_0_map = (i*max_pwm)/steps;
    //     *custom_pwm_1_map = (i*max_pwm)/steps;
    //     // *custom_pwm_map = 253;
    //     // Wait time_steps seconds
    //     usleep(time_steps);
    // }
    // usleep(2000000);
    // printf(" Sweep Down...\n");
    // for(int i = steps-1; i > -1; --i)
    // {
    //     *custom_pwm_0_map = (i*max_pwm)/steps;
    //     // *custom_pwm_map = 253;
    //     // Wait time_steps seconds
    //     usleep(time_steps);
    // }
    // printf("Done!\n");

    // *pwm_avalon_bridge_map = duty;

    // Unmap everything and close the /dev/mem file descriptor
    result = munmap(lw_bridge_map, HPS_TO_FPGA_LW_SPAN); 
    if(result < 0)
    {
        perror("devmem munmap");
        close(devmem_fd);
        exit(EXIT_FAILURE);
    }

    close(devmem_fd);
    exit(EXIT_SUCCESS);
}