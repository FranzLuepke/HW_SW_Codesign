TARGET = devmem_count

CFLAGS = -static -g -Wall -std=gnu99
LDFLAGS = -g -Wall
CC = $(CROSS_COMPILE)gcc
ARCH = arm
HOST = 192.168.1.108

build: $(TARGET)
$(TARGET): $(TARGET).o
	$(CC) $(LDFLAGS) $^ -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f $(TARGET) *.a *.o *.~

install: $(TARGET)
	scp $(TARGET) root@${HOST}:/root/count