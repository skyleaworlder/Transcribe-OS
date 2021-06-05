# Makefile variables
ASM			=	nasm
DD 			= 	dd
BXIMAGE		=	/opt/bochs/bin/bximage
BOCHS		= 	/opt/bochs/bin/bochs
ASMBFLAGS	=	-I boot/include/

# about build / clean
ASMMBR		= 	boot/MBR.S
ASMLOADER	= 	boot/loader.S
ASMFILES	=	$(ASMMBR) $(ASMLOADER)
BINMBR		=	boot/MBR.bin
BINLOADER	= 	boot/loader.bin
BINFILES	= 	$(BINMBR) $(BINLOADER)

.PHONY: everything, build, buildimg, run, clean

everything:	$(BINFILES)

build: everything buildimg

buildimg:
	$(BXIMAGE) -mode=create -hd=10 -sectsize=512 -q hd10M-20-16-63.img
	$(DD) if=./boot/MBR.bin of=./hd10M-20-16-63.img bs=512 count=1 conv=notrunc
	$(DD) if=./boot/loader.bin of=./hd10M-20-16-63.img bs=512 count=1 seek=2 conv=notrunc

run:
	$(BOCHS)

clean:
	rm -f boot/*.bin *.img

$(BINMBR) $(BINLOADER): $(ASMMBR) $(ASMLOADER) boot/include/boot.inc
	$(ASM) -o $(BINMBR) $(ASMBFLAGS) $(ASMMBR)	 
	$(ASM) -o $(BINLOADER) $(ASMBFLAGS) $(ASMLOADER)
