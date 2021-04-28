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
    uint32_t * count_map = 0;
    // uint32_t * custom_dipsw_map = 0;
    // uint32_t * custom_leds_map = 0;
    // uint32_t * dipsw_value = 0;
    uint32_t * count_value = 0;
    uint32_t * init_value = 0;
    int devmem_fd = 0;
    int result = 0;
    int time_delay = 100000; // Time delay in us.
    // Check to make sure they entered a valid input value
    // if(argc != 2)
    // {
    //     printf("Please enter only one argument that specifies the number of step for the PWM sweep.\n");
    //     exit(EXIT_FAILURE);
    // }
    // Get the steps from the PWM sweep from the passed in arguments
    // steps = atoi(argv[1]);
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
    // Set the custom_dipsw_map to the correct offset within the RAM (DIPSW_PIO_BASE is from "hps_0.h")
    count_map = (uint32_t*)(lw_bridge_map + AVALON_ENCODER_0_BASE);
    // custom_dipsw_map = (uint32_t*)(lw_bridge_map + DIPSW_PIO_BASE);
    // custom_leds_map = (uint32_t*)(lw_bridge_map + CUSTOM_LEDS_0_BASE);
    printf("This program reads continuously the first encoder count. To finish reading use Ctrl+C.\n");
    printf(" Reading...\n");
    init_value = (uint32_t*)count_map;
    // for(int i = 0; i < 10000; ++i)
    while(1)
    {
        count_value = (uint32_t*)count_map;
        printf("\r Value read: %d", count_value-init_value);
        // printf("\r Value read: %d", count_value);
        fflush(stdout);
        // *custom_leds_map = dipsw_value;
        usleep(time_delay);
    }
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