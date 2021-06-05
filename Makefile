# Makefile variables
ASM			=	nasm
DD 			= 	dd
BXIMAGE		=	/opt/bochs/bin/bximage
BOCHS		= 	/opt/bochs/bin/bochs
ASMBFLAGS	=	-I boot/include/

# about build / clean
.PHONY: everything, build, buildimg, run, clean

everything:	boot/MBR.bin

build: everything buildimg

buildimg:
	$(BXIMAGE) -mode=create -hd=10 -sectsize=512 -q hd10M-20-16-63.img
	$(DD) if=./boot/MBR.bin of=./hd10M-20-16-63.img bs=512 count=1 conv=notrunc

run:
	$(BOCHS)

clean:
	rm -f boot/*.bin *.img

boot/MBR.bin: boot/MBR.S boot/include/boot.inc
	$(ASM) -o $@ $(ASMBFLAGS) $<
