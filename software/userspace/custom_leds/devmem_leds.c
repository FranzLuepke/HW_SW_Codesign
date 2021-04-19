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
    uint32_t * custom_led_map = 0;
    int devmem_fd = 0;
    int result = 0;
    int blink_times = 0;

    // Check to make sure they entered a valid input value
    if(argc != 2)
    {
        printf("Please enter only one argument that specifies the number of times to blink the LEDs\n");
        exit(EXIT_FAILURE);
    }

    // Get the number of times to blink the LEDS from the passed in arguments
    blink_times = atoi(argv[1]);

    // Open up the /dev/mem device (aka, RAM)
    devmem_fd = open("/dev/mem", O_RDWR | O_SYNC);
    if(devmem_fd < 0) {
        perror("devmem open");
        exit(EXIT_FAILURE);
    }

    // mmap() the entire address space of the Lightweight bridge so we can access our custom module 
    lw_bridge_map = (uint32_t*)mmap(NULL, HPS_TO_FPGA_LW_SPAN, PROT_READ|PROT_WRITE, MAP_SHARED, devmem_fd, HPS_TO_FPGA_LW_BASE); 
    if(lw_bridge_map == MAP_FAILED) {
        perror("devmem mmap");
        close(devmem_fd);
        exit(EXIT_FAILURE);
    }

    // Set the custom_led_map to the correct offset within the RAM (CUSTOM_LEDS_0_BASE is from "hps_0.h")
    custom_led_map = (uint32_t*)(lw_bridge_map + CUSTOM_LEDS_0_BASE);
    // Blink the LED ten times
    printf("Blinking LEDs %d times...\n", blink_times);
    for(int i = 0; i < blink_times; ++i)
    {
        // Turn all LEDs on
        *custom_led_map = 0xFF;

        // Wait half a second
        usleep(500000);

        // Turn all the LEDS off
        *custom_led_map = 0x00;

        // Wait half a second
        usleep(500000); 
    }

    printf("Done!\n");

    // Unmap everything and close the /dev/mem file descriptor
    result = munmap(lw_bridge_map, HPS_TO_FPGA_LW_SPAN); 
    if(result < 0) {
        perror("devmem munmap");
        close(devmem_fd);
        exit(EXIT_FAILURE);
    }

    close(devmem_fd);
    exit(EXIT_SUCCESS);
}