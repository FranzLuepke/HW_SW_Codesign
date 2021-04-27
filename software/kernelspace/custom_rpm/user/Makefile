TARGET = test_custom_leds

CROSS_COMPILE = arm-linux-gnueabihf-
CFLAGS = -g -Wall  -I${SOCEDS_DEST_ROOT}/ip/altera/hps/altera_hps/hwlib/include
LDFLAGS =  -g -Wall  
CC = $(CROSS_COMPILE)gcc
ARCH= arm
HOST = 192.168.1.108

build: $(TARGET)
$(TARGET): $(TARGET).o
	$(CC) $(LDFLAGS)   $^ -o $@  
%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f $(TARGET) *.a *.o *~ 
install:$(TARGET)
	scp testebbchar root@${HOST}:/root