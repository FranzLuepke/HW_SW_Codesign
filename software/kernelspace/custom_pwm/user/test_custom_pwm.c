/**
 * @file   test_custom_pwm.c
 * @author Franz Luepke
 * @date   14 March 2021
 * @version 0.1
 * @brief  A Linux user space program that communicates with the test_custom_pwm.c LKM. It passes a
 * string to the LKM and duty cycle of the PWM output changes. For this example to work the device
 * must be called /dev/custom_pwm.
*/
#include<stdio.h>
#include<stdlib.h>
#include<errno.h>
#include<fcntl.h>
#include<string.h>
#include<unistd.h>
// Variables
#define BUFFER_LENGTH 256 // The buffer length.
// main function
int main()
{
	int ret;
	int fd_1;
	int fd_2;
	char stringToSend[BUFFER_LENGTH];
	printf("Starting PWM device test code example...\n");
	fd_1 = open("/dev/custom_pwm", O_RDWR); // Open the device with read/write access
	if (fd_1 < 0)
	{
		perror("Failed to open pwm_1 device...");
		return errno;
	}

	// // PWM 2 ope
	// fd_2 = open("/dev/custom_pwm_2", O_RDWR); // Open the device with read/write access
	// if (fd_2 < 0)
	// {
	// 	perror("Failed to open pwm_2 device...");
	// 	return errno;
	// }

	printf("PWM devices test.\n");
	// PWM 1 write
	printf(" Type in a string to send its hex value pwm_1:\n");
	scanf("%[^\n]%*c", stringToSend);                // Read in a string (with spaces)
	printf("  Writing message to the device [%s].\n", stringToSend);
	ret = write(fd_1, stringToSend, strlen(stringToSend)); // Send the string to the LKM
	if(ret < 0)
	{
		perror("  Failed to write the message to the device.");
		return errno;
	}

	// // PWM 2 write
	// printf(" Type in a string to send its hex value pwm_2:\n");
	// scanf("%[^\n]%*c", stringToSend);                // Read in a string (with spaces)
	// printf("  Writing message to the device [%s].\n", stringToSend);
	// ret = write(fd_2, stringToSend, strlen(stringToSend)); // Send the string to the LKM
	// if(ret < 0)
	// {
	// 	perror("  Failed to write the message to the device.");
	// 	return errno;
	// }

	printf("End of the program\n");
	return 0;
}