KDIR ?= /media/franz/Windows8_OS/builder/socfpga-kernel-dev/KERNEL
TARGET = pwm_avalon_bridge
HOST = 192.168.1.108

default:
	$(MAKE) -C $(KDIR) ARCH=arm M=$(CURDIR)

clean:
	$(MAKE) -C $(KDIR) ARCH=arm M=$(CURDIR) clean

help:
	$(MAKE) -C $(KDIR) ARCH=arm M=$(CURDIR) help

install:
	scp $(TARGET).ko root@${HOST}:/root/pwm_avalon_bridge